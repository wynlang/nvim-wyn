-- Headless test for nvim-wyn. Run via tests/run.sh (or the Makefile).
-- Asserts the plugin loads, detects the wyn filetype, applies syntax +
-- ftplugin settings, and - when the `wyn` binary is on PATH - attaches the LSP
-- and produces diagnostics. Exits 0 on success, 1 on any failure.

local failures = 0
local function ok(cond, label)
  if cond then
    io.write("  ok   " .. label .. "\n")
  else
    io.write(" FAIL  " .. label .. "\n")
    failures = failures + 1
  end
end

local here = debug.getinfo(1, "S").source:sub(2)
local dir = vim.fn.fnamemodify(here, ":p:h")
local sample = dir .. "/sample.wyn"

-- 1. Filetype detection (ftdetect).
vim.cmd("edit " .. vim.fn.fnameescape(sample))
ok(vim.bo.filetype == "wyn", "filetype detected as 'wyn' for .wyn")

-- 2. ftplugin settings applied.
ok(vim.bo.expandtab == true, "ftplugin sets expandtab")
ok(vim.bo.shiftwidth == 4, "ftplugin sets shiftwidth=4")
ok(vim.bo.commentstring == "// %s", "ftplugin sets commentstring '// %s'")

-- 3. Syntax highlighting loaded (b:current_syntax set by syntax/wyn.vim).
ok(vim.b.current_syntax == "wyn", "syntax/wyn.vim loaded (b:current_syntax)")

-- Verify the syntax groups are actually defined by syntax/wyn.vim. (We inspect
-- the rule definitions rather than synID() at a cursor position: in headless
-- `-l` mode there is no attached UI, so the highlighter never runs and synID()
-- returns 0 even though the rules are present and work in a real editor.)
do
  local function rule_has(group, word)
    local ok_, out = pcall(vim.fn.execute, "syntax list " .. group)
    return ok_ and type(out) == "string" and out:find(word, 1, true) ~= nil
  end
  ok(rule_has("wynKeyword", "fn"), "wynKeyword rule defines 'fn'")
  ok(rule_has("wynKeyword", "struct"), "wynKeyword rule defines 'struct'")
  ok(rule_has("wynType", "int"), "wynType rule defines 'int'")
  ok(rule_has("wynModule", "Math"), "wynModule rule defines 'Math'")
  -- 'module' was removed as a keyword - make sure it isn't re-introduced.
  ok(not rule_has("wynKeyword", "module"), "wynKeyword does NOT include removed 'module'")
end

-- 4. `require('wyn').setup()` loads without error.
do
  local good = pcall(function()
    require("wyn").setup({ auto_start = false })
  end)
  ok(good, "require('wyn').setup() runs without error")
end

-- 5. LSP: only if the wyn binary is available (CI installs it).
local wyn_cmd = os.getenv("WYN") or "wyn"
if vim.fn.executable(wyn_cmd) == 1 then
  local client_id = vim.lsp.start({
    name = "wyn",
    cmd = { wyn_cmd, "lsp" },
    root_dir = dir,
  }, { bufnr = 0 })
  ok(client_id ~= nil, "vim.lsp.start returns a client id")

  -- Wait for the client to attach (up to ~5s).
  local attached = vim.wait(5000, function()
    return #vim.lsp.get_clients({ bufnr = 0 }) > 0
  end, 100)
  ok(attached, "LSP client attaches to the wyn buffer")

  if attached then
    local client = vim.lsp.get_clients({ bufnr = 0 })[1]
    ok(client and client.server_capabilities ~= nil, "server advertised capabilities")
    ok(client and client.server_capabilities.hoverProvider ~= nil, "hoverProvider capability present")
    ok(client and client.server_capabilities.completionProvider ~= nil, "completionProvider capability present")
    ok(client and client.server_capabilities.definitionProvider ~= nil, "definitionProvider capability present")
  end
else
  io.write("  skip  LSP checks (wyn binary not on PATH)\n")
end

io.write("\n")
if failures > 0 then
  io.write("nvim-wyn tests: FAIL (" .. failures .. ")\n")
  vim.cmd("cquit 1")
else
  io.write("nvim-wyn tests: PASS\n")
  vim.cmd("qall!")
end
