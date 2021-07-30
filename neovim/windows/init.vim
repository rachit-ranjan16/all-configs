call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'iCyMind/NeoSolarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'https://github.com/PProvost/vim-ps1.git'
Plug 'sheerun/vim-polyglot'
Plug 'davidhalter/jedi-vim'
Plug 'vuciv/vim-bujo'
Plug 'jremmen/vim-ripgrep'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'ThePrimeagen/harpoon'
 "TODO Figure this out
Plug 'neovim/nvim-lspconfig'
"Plug 'hrsh7th/nvim-compe'
"Plug 'glepnir/lspsaga.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdcommenter'
call plug#end()

" -----------------
" -----------------
" Configs
" -----------------
" -----------------

" -----------------
" Telescope configs
" -----------------
lua <<EOF
require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  }
}
EOF

" -----------------
" Treesitter Configs
" -----------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust" ,"python", "c_sharp", "comment", "java", "lua", "json",}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = {},  -- list of languages that will be disabled
  },
}
EOF

" -----------------
" Harpoon Configs
" -----------------
lua <<EOF
require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
    },
})
EOF

lua <<EOF
local function harpoon_status()
    local status = require("harpoon.mark").status()
    if status == "" then
        status = "N"
    end
    return string.format("H:%s", status)
end
EOF

" -----------------
" AutoComplete Configs
" -----------------
"set completeopt=menuone,noselect
"lua <<EOF
"require'compe'.setup {
  "enabled = true;
  "autocomplete = true;
  "debug = false;
  "min_length = 1;
  "preselect = 'enable';
  "throttle_time = 80;
  "source_timeout = 200;
  "resolve_timeout = 800;
  "incomplete_delay = 400;
  "max_abbr_width = 100;
  "max_kind_width = 100;
  "max_menu_width = 100;
  "documentation = {
    "border = "none", -- the border option is the same as `|help nvim_open_win|`
    "winhighlight = "CompeDocumentation", -- highlight group used for the documentation window
    "max_width = 120,
    "min_width = 40,
    "max_height = math.floor(vim.o.lines * 0.3),
    "min_height = 1,
  "};

  "source = {
    "path = true;
    "buffer = true;
    "calc = true;
    "nvim_lsp = true;
    "nvim_lua = true;
    "vsnip = true;
    "ultisnips = true;
    "luasnip = true;
  "};
"}
"EOF

" -----------------
" Syntastic Configs
" -----------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%F
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" -----------------
" Quickscope Configs
" -----------------
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#e64343' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#afff5f' gui=underline ctermfg=81 cterm=underline

" -----------------
" Cheat.sh Configs
" -----------------
let g:syntastic_javascript_checkers = [ 'jshint' ]
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_shell_checkers = ['shellcheck']


" -----------------
" Coc Configs
" -----------------
"Add `:Format` command to format current buffer.
let g:coc_global_extensions=[ 'coc-powershell', 'coc-json', 'coc-jedi', 'coc-xml', 'coc-omnisharp']
command! -nargs=0 Format :call CocAction('format')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" -----------------
"  Vim Stuff
" -----------------
let g:qs_max_chars=150
" set encoding to utf8
set encoding=utf-8
"Avoid Swap file exists warning
set shortmess+=A
" enable syntax highlighting
let python_highlight_all=1
" set vimairline theme to simple
let g:airline_theme = 'simple'
" Enable powerline fonts
let g:airline_powerline_fonts = 1
" Enable tab line
let g:airline#extensions#tabline#enabled = 1
" set tree style view for netrw
let g:netrw_liststyle=3
" Enable syntax
syntax enable
" show line numbers
set number
" remove whitespaces in diff
set diffopt+=iwhite
"  show file stats
set ruler
" match paren
let loaded_matchparen = 1
" map leader to space.
let mapleader = " "
" Enable auto reload
set autoread
"Set Smart Case
set ignorecase
set smartcase
" Change to the current file's directory
" set autochdir
" set tab to 4 spaces
set ts=4 sw=4
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab
set autoindent
set noerrorbells
"Undo stack over swap files
set noswapfile
set nobackup
set undodir=~/.vim/undodir2
set undofile
" incremental search match as the regex is being typed
set incsearch
set termguicolors
" extra lines while scrolling
set scrolloff=8
" additional column on the left
set signcolumn=yes
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Enable folding
set foldmethod=indent
set foldlevel=99
" Python Pep8 Styling
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
" Indentation for web files
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2
" Turn on Relative Numbers
set relativenumber
set nu
" Netrw open in vertical split
let g:netrw_altv=1
" set colorschene to onedark
colorscheme gruvbox
set background=dark


" -----------------
" -----------------
" Remaps
" -----------------
" -----------------

" Fuzzy find files
nnoremap <c-p> :lua require("telescope.builtin").find_files()<CR>
" Live Grep for strings
nnoremap <leader>gre :lua require("telescope.builtin").live_grep()<CR>
" Find Strings
nnoremap <leader>f :lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" Find In curr di
nnoremap <leader>fi :lua require('telescope.builtin').find_files{ search_dirs = { vim.fn.expand("%:p:h") ..  "/" .. vim.fn.expand("<cword>") } }<CR>
" Help
nnoremap <leader>H :lua require("telescope.builtin").help_tags()<CR>
" List marks
nnoremap <leader>lm :lua require("telescope.builtin").marks()<CR>
" Fix Windows Exception Carriage Returns
nnoremap <leader>Fcr :%s/\\r\\n/\r/g <bar> :%s/\\"/"/g <bar> :%s/\\r\\\\n/\r/g <bar> :%s/\\\\/\//g <bar> %s/\/\//\//g <bar> :w <CR>
" Refresh nvim config
nnoremap <leader>rnc :w! C:\Users\raranjan\AppData\Local\nvim\init.vim <bar> :source C:\Users\raranjan\AppData\Local\nvim\init.vim<CR>
" Edit nvim config
nnoremap <leader>enc :wincmd v<bar> :edit C:\Users\raranjan\AppData\Local\nvim\init.vim <bar> :wincmd =<CR>
" Edit Powershell Core Profile
nnoremap <leader>epcp :wincmd v<bar> :edit C:\Users\raranjan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 <bar> :wincmd =<CR>
" Buffers
nnoremap <leader>b :Telescope Buffers<CR>
" Show undo tree
nnoremap <leader>u :UndotreeShow<CR>
" Format Json File
nnoremap <leader>fj :%!python -m json.tool <CR>
" Open Notes
nnoremap <leader>no :wincmd v <bar> :wincmd l <bar> :e ~/Notes.txt<CR>
" Force reload file
nnoremap <leader>re :e!<CR>
" Cat File
nnoremap <leader>cat :!type %<CR>
" Create log json file
nnoremap <leader>logj :wincmd v <bar> :wincmd l <bar> :e E:\Logs\someLog.json <bar> :1,$d <CR>
" Delete all lines in the current file.
nnoremap <leader>dL :1,$d <CR>
" Buffer Stuff
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprev<CR>
" Window Stuff
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>o :wincmd o<CR>
" Vertical resizes
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>
" File Explorer View
nnoremap <leader>pv :Lex <bar> :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" Copy to system clipboard
vnoremap <leader>c "+y
" Paste from system clipboard
nnoremap <leader>v "+p
" Yank to end of line
nnoremap Y y$
" Keep the cursor centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
" Move lines around in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Cleanup file and paste from system clipboard
nnoremap <leader>V gg"+yG
" Copy all lines in the current file to system clipboard
nnoremap <leader>ya :1,$y
" Delete selected visual block and paste content from _ register above it.
vnoremap <leader>p d"_P
"Save and Quit short remaps
nnoremap <leader>w :w! <CR>
nnoremap <leader>wa :wa! <CR>
nnoremap <leader>wq :wq <CR>
nnoremap <leader>wa :wa <CR>
nnoremap <leader>Q :qa! <CR>
nnoremap <leader>qa :qa! <CR>
" Open powershell core terminal in horizontal split
nnoremap <leader>t :wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal pwsh <CR>
" Clear search highlight
nnoremap <leader><space> :noh<CR>
" Harpoon settings
nnoremap <leader>m :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>n :lua require("harpoon.ui").toggle_quick_menu()<CR>
"Git Stuff
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :G log<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gd :Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>
nnoremap <leader>gc :G commit <bar> :wincmd = <CR>
nnoremap <leader>gp :G -c push.default=current push <CR>
nnoremap <leader>gP :G pull <CR>
nnoremap <leader>gS :G stash<CR>
nnoremap <leader>gSl :lua require("telescope.builtin").git_stash()<CR>
nnoremap <leader>gb :lua require("telescope.builtin").git_branches()<CR>
nnoremap <leader>gCl :lua require("telescope.builtin").git_commits()<CR>
nnoremap <leader>gpom :G pull origin master<CR>
nnoremap <leader>gcm :G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>
"Syntax Check
nnoremap <leader>sc :SyntasticCheck<CR>
"Whitespace Fixes
nnoremap <leader>rw :StripWhitespace<CR>
" AutoComplete things
"inoremap <silent><expr> <TAB> compe#complete()
"inoremap <silent><expr> <CR>      compe#confirm('<CR>')
"inoremap <silent><expr> <C-e>     compe#close('<C-e>')
"inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
"inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
" Coc stuff
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
nnoremap <silent>K :call <SID>show_documentation()<CR>
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif
" Rename
nmap <leader>rn <Plug>(coc-rename)
" Coc list all diagnostic errors
nnoremap <leader>ae :CocList diagnostics<CR>
" Format file
nnoremap <leader>ff :Format <CR>
