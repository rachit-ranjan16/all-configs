call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'
Plug 'davidhalter/jedi-vim'
Plug 'vuciv/vim-bujo'
Plug 'jremmen/vim-ripgrep'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'mbbill/undotree'
" TODO Check whether still required with lsp integration
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
require('telescope').setup{
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
    layout_strategy = "horizontal",
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
" Coc Configs
" -----------------
" Add `:Format` command to format current buffer.
let g:coc_global_extensions=[ 'coc-powershell', 'coc-json', 'coc-jedi', 'coc-xml', 'coc-rls' ]
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
" Vim stuff
" -----------------
" map leader to space.
let mapleader = " "
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
" remove whitespaces in diff
set diffopt+=iwhite
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
set tabstop=4 softtabstop=4
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
" Turn on relative numbers with the current line number
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
nnoremap <leader>lg :lua require("telescope.builtin").live_grep()<CR>
" Find Strings
nnoremap <leader>f :lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" Find In curr dir
nnoremap <leader>fi :lua require('telescope.builtin').find_files{ search_dirs = { vim.fn.expand("%:p:h") ..  "/" .. vim.fn.expand("<cword>") } }<CR>
" Help
nnoremap <leader>H :lua require("telescope.builtin").help_tags()<CR>
" List marks
nnoremap <leader>lm :lua require("telescope.builtin").marks()<CR>
" Refresh nvim config
nnoremap <leader>rnc :w ~/.config/nvim/init.vim <bar>:source ~/.config/nvim/init.vim<CR>
" Edit nvim config
nnoremap <leader>enc :wincmd v<bar> :edit ~/.config/nvim/init.vim<bar> :wincmd =<CR>
" show undo tree
nnoremap <leader>u :UndotreeShow<CR>
" Format XML File
nnoremap <leader>fx :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"<CR>
" Delete all lines in the current file.
nnoremap <leader>dL :1,$d <CR>
" File Explorer View
nnoremap <leader>pv :Lex <bar> :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" Buffer Stuff
nnoremap <leader>b <cmd>Telescope buffers<CR>
" Window Stuff
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>q :wincmd q<CR>
nnoremap <leader>o :wincmd o<CR>
" Vertical resizes
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
" Copy to system clipboard
vnoremap <leader>c "+y
" Paste from system clipboard
nnoremap <leader>v "+p
vnoremap <leader>p "+y
" Cleanup file and paste from system clipboard
nnoremap <leader>V gg"+yG
" Delete selected visual block and paste content from _ register above it.
vnoremap <leader>p "_dP
nnoremap <leader>w :w <CR>
"Save and Quit short remaps
nnoremap <leader>w :w! <CR>
nnoremap <leader>wa :wa! <CR>
nnoremap <leader>wq :wq <CR>
nnoremap <leader>Q :qa <CR>
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
nnoremap <leader>gSl :lua require("telescope.builtin").git_stash()<CR>
nnoremap <leader>gb :lua require("telescope.builtin").git_branches()<CR>
nnoremap <leader>gpom :G pull origin master<CR>
nnoremap <leader>gcm :G reset --hard <bar> :G checkout master <bar> :G pull origin master<CR>
"Syntax check
nnoremap <leader>sc :SyntasticCheck<CR>
" Help Tags
nnoremap <leader>th <cmd>Telescope help_tags<cr>
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
nmap <leader>rn <Plug>(coc-rename)
" Coc format file
nnoremap <leader>ff :Format <CR>
" Coc list all diagnostic errors
nnoremap <leader>ae :CocList diagnostics<CR>
