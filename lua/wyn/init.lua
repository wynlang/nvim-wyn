local M = {}

function M.setup(opts)
    opts = opts or {}
    
    -- Set up filetype detection
    vim.filetype.add({
        extension = {
            wyn = 'wyn',
        },
    })
    
    -- Set up syntax highlighting
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "wyn",
        callback = function()
            -- Keywords
            vim.cmd([[syntax keyword wynKeyword fn var const if else for while return break continue match struct enum import export type spawn channel]])
            vim.cmd([[syntax keyword wynType int float string bool void]])
            
            -- Comments
            vim.cmd([[syntax match wynComment "//.*$"]])
            vim.cmd([[syntax region wynBlockComment start="/\*" end="\*/"]])
            
            -- Strings
            vim.cmd([[syntax region wynString start='"' end='"' skip='\\"']])
            
            -- Numbers
            vim.cmd([[syntax match wynNumber "\<\d\+\(\.\d\+\)\?"]])
            
            -- Highlighting
            vim.cmd([[highlight link wynKeyword Keyword]])
            vim.cmd([[highlight link wynType Type]])
            vim.cmd([[highlight link wynComment Comment]])
            vim.cmd([[highlight link wynBlockComment Comment]])
            vim.cmd([[highlight link wynString String]])
            vim.cmd([[highlight link wynNumber Number]])
        end,
    })
    
    -- Set up LSP
    local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
    if not lspconfig_ok then
        vim.notify('nvim-lspconfig not found. LSP features disabled.', vim.log.levels.WARN)
        return
    end
    
    local configs = require('lspconfig.configs')
    
    if not configs.wyn then
        configs.wyn = {
            default_config = {
                cmd = { opts.cmd or 'wyn', 'lsp' },
                filetypes = { 'wyn' },
                root_dir = function(fname)
                    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
                end,
                settings = {},
            },
        }
    end
    
    lspconfig.wyn.setup({
        on_attach = opts.on_attach,
        capabilities = opts.capabilities,
    })
end

return M
