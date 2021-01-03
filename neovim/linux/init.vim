call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'iCyMind/NeoSolarized'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-scripts/indentpython.vim'
Plug 'vim-syntastic/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'vim-airline/vim-airline'
Plug 'othree/xml.vim'
Plug 'https://github.com/PProvost/vim-ps1.git'
Plug 'sheerun/vim-polyglot'
Plug 'davidhalter/jedi-vim'
Plug 'vuciv/vim-bujo'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'ntpeters/vim-better-whitespace'
Plug 'xavierchow/vim-swagger-preview'
Plug 'unblevable/quick-scope'
call plug#end()

" -----------------
" -----------------
" Configs
" -----------------
" -----------------

" -----------------
" Fzf config
" -----------------
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8} }
let $FZF_DEFAULT_OPTS = '--reverse'
let $FZF_DEFAULT_COMMAND='rg --files'
" Fuzzy Finder Settings
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*\\packages\\*,*\\obj\\*,*\\objd\\*,*\\out\\*,*\\bin\\*

" -----------------
" Telescope configs
" -----------------
"lua require('telescope').setup({defaults = {file_sorter = require('telescope.sorters').get_fzy_sorter}})

" -----------------
" Syntastic Configs
" -----------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
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
" Vim stuff
" -----------------
" Experimenting leader remap. TODO Decide to keep or ditch
let mapleader = "\<Space>"
let g:qs_max_chars=150
" set encoding to utf8
set encoding=utf-8
"Avoid Swap file exists warning
set shortmess+=A
" enable syntax highlighting
let python_highlight_all=1
" set vimairline theme to simple
let g:airline_theme = 'simple'
" set tree style view for netrw
let g:netrw_liststyle=3
syntax enable
" show line numbers
set number
"  show file stats
set ruler
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
" set colorschene to onedark
colorscheme gruvbox
set background=dark

" -----------------
" -----------------
" Remaps
" -----------------
" -----------------


" Fuzzy find files
nnoremap <c-p> :Files<CR>
"nnoremap <leader>F :Files<CR>
" Refresh nvim config
nnoremap <leader>rnc :source ~/.config/nvim/init.vim<CR>
" Edit nvim config
nnoremap <leader>enc :wincmd v<bar> :edit ~/.config/nvim/init.vim<bar> :wincmd =<CR>
" Format Json File
nnoremap <leader>fj :%!python -m json.tool <CR>
" Format XML File
nnoremap <leader>fx :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>
" Delete all lines in the current file.
nnoremap <leader>dL :1,$d <CR>
" File Explorer View
nnoremap <leader>pv :Lex <bar> :vertical resize -50<CR>
" Window Stuff
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>o :wincmd q<CR>
" Vertical resizes
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
" Copy to system clipboard
nnoremap <leader>c "+y
" Paste from system clipboard
nnoremap <leader>v "+p
vnoremap <leader>p "+y
" Cleanup file and paste from system clipboard
nnoremap <leader>V gg"+yG
" Delete selected visual block and paste content from _ register above it.
vnoremap <leader>p "_dP
"Save and Quit short remaps
nnoremap <leader>w :w <CR>
nnoremap <leader>wa :wa <CR>
nnoremap <leader>wq :wq <CR>
" Open terminal in horizontal split
nnoremap <leader>t :wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal /bin/bash <CR>
" Clear search highlight.
nnoremap <leader><space> :noh<CR>
" Git Stuff
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :G log<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gd :Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>
nnoremap <leader>gc :G commit <bar> :wincmd = <CR>
nnoremap <leader>gp :G push <CR>
nnoremap <leader>gP :G pull <CR>
nnoremap <leader>gS :G stash<CR>
nnoremap <leader>gSa :G stash apply<CR>
nnoremap <leader>gSl :G stash list<CR>
nnoremap <leader>gb :GBranches <CR>
nnoremap <leader>gpom :G pull origin master<CR>
nnoremap <leader>gcm :G reset --hard <bar> :G checkout master <bar> :G pull origin master<CR>
"Syntax Check
nnoremap <leader>sc :SyntasticCheck<CR>
"Whitespace Fixes"
nnoremap <leader>rw :StripWhitespace<CR>
