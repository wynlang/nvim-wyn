-- nvim-wyn: Neovim support for the Wyn language.
--
-- Syntax highlighting and filetype detection are provided by the plugin's
-- syntax/, ftdetect/, and ftplugin/ files (loaded automatically). This module
-- wires up the LSP client (`wyn lsp`). Calling setup() is OPTIONAL — the plugin
-- highlights .wyn files out of the box; setup() adds language-server features
-- (diagnostics, hover, completion, go-to-definition, references, rename).
--
-- Usage:
--   require('wyn').setup()                       -- defaults: cmd = "wyn"
--   require('wyn').setup({ cmd = "/path/to/wyn",  -- custom binary
--                          auto_start = true,      -- start LSP on FileType wyn (default true)
--                          on_attach = fn, capabilities = caps })

local M = {}

local function root_dir(fname)
  local found = vim.fs.find({ "wyn.toml", ".git" }, { upward = true, path = vim.fs.dirname(fname) })[1]
  if found then
    return vim.fs.dirname(found)
  end
  return vim.fn.getcwd()
end

-- Start the Wyn LSP for the current buffer using Neovim's built-in client.
-- Works without nvim-lspconfig. Idempotent per buffer/root.
local function start_builtin(opts, bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  vim.lsp.start({
    name = "wyn",
    cmd = { opts.cmd, "lsp" },
    -- The server shells out to `<cmd> check` for diagnostics; tell it exactly
    -- which binary via WYN_LSP_BIN so it doesn't fall back to `./wyn` relative
    -- to the (unrelated) project root and silently produce no diagnostics.
    cmd_env = { WYN_LSP_BIN = opts.cmd },
    root_dir = root_dir(fname),
    on_attach = opts.on_attach,
    capabilities = opts.capabilities,
  }, { bufnr = bufnr })
end

-- Register with nvim-lspconfig if the user has it (so :LspInfo etc. work),
-- otherwise fall back to the built-in client. Returns true if lspconfig handled it.
local function try_lspconfig(opts)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    return false
  end
  local configs = require("lspconfig.configs")
  if not configs.wyn then
    configs.wyn = {
      default_config = {
        cmd = { opts.cmd, "lsp" },
        filetypes = { "wyn" },
        root_dir = function(fname)
          return root_dir(fname)
        end,
        settings = {},
      },
    }
  end
  lspconfig.wyn.setup({
    cmd = { opts.cmd, "lsp" },
    cmd_env = { WYN_LSP_BIN = opts.cmd },
    on_attach = opts.on_attach,
    capabilities = opts.capabilities,
  })
  return true
end

function M.setup(opts)
  opts = opts or {}
  opts.cmd = opts.cmd or "wyn"
  if opts.auto_start == nil then
    opts.auto_start = true
  end

  -- Ensure .wyn / .🐉 are detected as filetype "wyn" even if ftdetect didn't run.
  vim.filetype.add({
    extension = { wyn = "wyn", ["🐉"] = "wyn" },
  })

  if vim.fn.executable(opts.cmd) ~= 1 then
    vim.notify(
      ("nvim-wyn: '%s' not found in PATH — LSP features disabled. Install with `wyn install`.")
        :format(opts.cmd),
      vim.log.levels.WARN
    )
    return
  end

  local used_lspconfig = try_lspconfig(opts)

  if opts.auto_start and not used_lspconfig then
    -- Built-in fallback: start the server when a wyn buffer opens.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "wyn",
      group = vim.api.nvim_create_augroup("NvimWynLsp", { clear = true }),
      callback = function(args)
        start_builtin(opts, args.buf)
      end,
    })
  end
end

return M
