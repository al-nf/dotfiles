return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter")
        -- Prefer current parsers and queries over binaries left in the legacy plugin directory.
        treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })
        vim.treesitter.language.register("systemverilog", { "verilog", "systemverilog" })
        treesitter.install({ "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "systemverilog" })

        local function attach(buf, lang)
            if not vim.api.nvim_buf_is_valid(buf) then
                return
            end

            local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
            if not stats or stats.size <= 100 * 1024 then
                vim.treesitter.start(buf, lang)
            end
            if lang ~= "systemverilog" then
                vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
            callback = function(event)
                local lang = vim.treesitter.language.get_lang(event.match)
                if not lang then
                    return
                end

                local available = require("nvim-treesitter.parsers")[lang]
                local ignored = lang == "javascript" or lang == "latex"
                if available and not ignored then
                    treesitter.install({ lang }):await(vim.schedule_wrap(function(err, installed)
                        if not err and installed then
                            attach(event.buf, lang)
                        end
                    end))
                else
                    local success, loaded = pcall(vim.treesitter.language.add, lang)
                    if success and loaded then
                        attach(event.buf, lang)
                    end
                end
            end,
        })
    end,
}
