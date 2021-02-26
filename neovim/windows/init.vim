call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'
Plug 'davidhalter/jedi-vim'
Plug 'vuciv/vim-bujo'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', {'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
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
" Fzf config
" -----------------
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8} }
let $FZF_DEFAULT_OPTS = '--reverse'
let $FZF_DEFAULT_COMMAND='rg --files'
" Fuzzy Finder Settings
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*\\packages\\*,*\\obj\\*,*\\objd\\*,*\\out\\*,*\\bin\\*

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
" Add `:Format` command to format current buffer.
let g:coc_global_extensions=[ 'coc-powershell', 'coc-json', 'coc-jedi', 'coc-xml' ]
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
" set tree style view for netrw
let g:netrw_liststyle=3
" Enable syntax
syntax enable
" show line numbers
set number
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
set undodir=~/.vim/undodir
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
    \ set fileformat=dos
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
nnoremap <c-p> :Files<CR>
"nnoremap <leader>F :Files<CR>
" Refresh nvim config
nnoremap <leader>rnc :w! C:\Users\raranjan\AppData\Local\nvim\init.vim <bar> :source C:\Users\raranjan\AppData\Local\nvim\init.vim<CR>
" Edit nvim config
nnoremap <leader>enc :wincmd v<bar> :edit C:\Users\raranjan\AppData\Local\nvim\init.vim <bar> :wincmd =<CR>
" Edit Powershell Core Profile
nnoremap <leader>epcp :wincmd v<bar> :edit C:\Users\raranjan\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 <bar> :wincmd =<CR>
" show undo tree
nnoremap <leader>u :UndotreeShow<CR>
" Cat File
nnoremap <leader>cat :!type %<CR>
" Create log json file
nnoremap <leader>logj :wincmd v <bar> :wincmd l <bar> :e E:\Logs\someLog.json <bar> :1,$d <CR>
" Delete all lines in the current file.
nnoremap <leader>dL :1,$d <CR>
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
nnoremap <leader>c "+y
" Paste from system clipboard
nnoremap <leader>v "+p
vnoremap <leader>c "+y
" Cleanup file and paste from system clipboard
nnoremap <leader>V gg"+yG
" Delete selected visual block and paste content from _ register above it.
vnoremap <leader>p "_dP
"Save and Quit short remaps
nnoremap <leader>w :w! <CR>
nnoremap <leader>wa :wa! <CR>
nnoremap <leader>wq :wq <CR>
nnoremap <leader>Q :qa! <CR>
" Open powershell terminal in horizontal split
nnoremap <leader>t :wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal powershell <CR>
" Clear search highlight
nnoremap <leader><space> :noh<CR>
"Git Stuff
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
nnoremap <leader>gcm :G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>
"Syntax Check
nnoremap <leader>sc :SyntasticCheck<CR>
"Whitespace Fixes
nnoremap <leader>rw :StripWhitespace<CR>
" Coc stuff
nnoremap <silent> K :call <SID>show_documentation()<CR>
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
" Coc format file
nnoremap <leader>ff :Format <CR>
" Coc list all diagnostic errors
nnoremap <leader>ae :CocList diagnostics<CR>
