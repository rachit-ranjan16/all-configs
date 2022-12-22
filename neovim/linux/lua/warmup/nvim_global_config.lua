-- -----------------
-- Vim Global Configs
-- -----------------
-- TODO Do this in remaps.lua
-- map leader to space.
--let mapleader = -- --
vim.g.qs_max_chars=150
-- vim.o.encoding to utf8
vim.o.encoding='utf-8'
--Avoid Swap file exists warning
vim.o.shortmess = vim.o.shortmess .. 'A'
-- Don't pass messages to |ins-completion-menu|.
vim.o.shortmess = vim.o.shortmess .. 'c'
-- TODO Remove this for lualine
-- vim.o.vimairline theme to simple
--vim.g.airline_theme = 'simple'
-- Enable powerline fonts
vim.g.airline_powerline_fonts = 1
-- TODO replace with lualine
-- Enable tab line
-- vim.g.airline#extensions#tabline#enabled = 1
-- vim.o.tree style view for netrw
vim.g.netrw_liststyle=3
-- show line numbers
vim.o.number = true
-- TODO is this needed? 
-- remove whitespaces in diff
-- vim.o.diffopt = vim.o.diffopt .. 'iwhite'
--  show file stats
vim.o.ruler = true
-- match paren
vim.g.loaded_matchparen = 1
-- Enable auto reload
vim.o.autoread = true
--vim.o.Smart Case
vim.o.ignorecase = true
vim.o.smartcase = true
-- Change to the current file's directory
-- vim.o.autochdir
-- vim.o.tab to 4 spaces
vim.o.tabstop=4       -- number of visual spaces per TAB
vim.o.softtabstop=4   -- number of spaces in tab when editing
vim.o.shiftwidth=4    -- number of spaces to use for autoindent
vim.o.expandtab = true
vim.o.autoindent = true

-- TODO Move this to the undo dir plugin file
--Undo stack over swap files
-- vim.o.noswapfile = true
-- vim.o.nobackup = true
-- vim.o.undodir=~/.vim/undodir2
-- vim.o.undofile = true
-- incremental search match as the regex is being typed
vim.o.incsearch = true
vim.o.termguicolors = true
-- extra lines while scrolling
vim.o.scrolloff=8
-- additional column on the left
vim.o.signcolumn='yes'
-- Give more space for displaying messages.
vim.o.cmdheight=2
-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.o.updatetime=50
-- Enable folding
vim.o.foldmethod='indent'
vim.o.foldlevel=99
-- Turn on Relative Numbers
vim.o.relativenumber = true
vim.o.nu = true
-- Netrw open in vertical split
vim.g.netrw_altv=1
-- Colorscheme Settings
-- TODO move this to theme.lua
-- Nord configs
-- vim.g.nord_contrast = v:true
-- vim.g.nord_borders = v:false
-- vim.g.nord_disable_background = v:false
-- vim.g.nord_italic = v:false
--colorscheme nord

-- move this to theme.lua
-- -- tokyonight configs
-- vim.g.tokyonight_style = 'night'
-- vim.g.tokyonight_italic_functions = 1
-- vim.g.tokyonight_sidebars = { 'qf', 'vista_kind', 'terminal', 'packer' }
-- 
-- -- Change the --hint-- color to the --orange-- color, and make the --error-- color bright red
-- vim.g.tokyonight_colors = {
--   \ 'hint': 'orange',
--   \ 'error': '#ff0000'
-- \ }

-- Load the colorscheme
-- colorscheme tokyonight
--colorscheme gruvbox
-- vim.o.background=dark
-- ]])
