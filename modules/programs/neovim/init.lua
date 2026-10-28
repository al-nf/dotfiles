vim.cmd("set modelines=0")
vim.cmd("set backspace=indent,eol,start")
vim.cmd("au BufWrite /private/tmp/crontab.* set nowritebackup nobackup")
vim.cmd("au BufWrite /private/etc/pw.* set nowritebackup nobackup")
vim.cmd("let skip_defaults_vim=1")
vim.cmd("filetype on")
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
vim.cmd("syntax on")
vim.cmd("set nu")
vim.cmd("set rnu")
vim.cmd("set tabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("set expandtab")
vim.cmd("set softtabstop=-1")
vim.cmd("set incsearch")
vim.cmd("set cindent")
vim.cmd("set guicursor=n-v-c:block,i-ci-ve-r-cr:hor20")

require("config.lazy")
-- BEGIN MARKDOWN PREVIEW SETTINGS --
vim.g.mkdp_auto_start = 1
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_command_for_global = 0
vim.g.mkdp_open_to_the_world = 0
vim.g.mkdp_open_ip = ''
vim.g.mkdp_browser = 'firefox'
vim.g.mkdp_echo_preview_url = 0
vim.g.mkdp_browserfunc = ''
vim.g.mkdp_preview_options = {
    mkit = {},
    katex = {},
    uml = {},
    maid = {},
    disable_sync_scroll = 0,
    sync_scroll_type = 'middle',
    hide_yaml_meta = 1,
    sequence_diagrams = {},
    flowchart_diagrams = {},
    content_editable = false,
    disable_filename = 0,
    toc = {}
}
vim.g.mkdp_markdown_css = ''
vim.g.mkdp_highlight_css = ''
vim.g.mkdp_port = '3333'
vim.g.mkdp_page_title = '「${name}.md」'
vim.g.mkdp_images_path = '/home/user/.markdown_images'
vim.g.mkdp_filetypes = {'markdown'}
vim.g.mkdp_theme = 'dark'
vim.g.mkdp_combine_preview = 0
vim.g.mkdp_combine_preview_auto_refresh = 1

-- END MARKDOWN PREVIEW SETTINGS --

vim.cmd([[
  augroup NixSettings
    autocmd!
    autocmd FileType nix setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
  augroup END
]])

vim.cmd([[
  augroup VerilogSettings
    autocmd!
    autocmd FileType verilog setlocal tabstop=2 shiftwidth=2 expandtab softtabstop=2
    autocmd FileType verilog setlocal indentexpr= indentkeys= nocindent nosmartindent autoindent
  augroup END
]])


-- BEGIN LUALINE --

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
 
-- END LUALINE --
vim.cmd.colorscheme "catppuccin"
vim.opt.termguicolors = true

require('nvim-highlight-colors').setup({})
