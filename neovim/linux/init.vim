
call plug#begin(expand('~/.config/nvim/plugged'))
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-vinegar'
Plug 'sheerun/vim-polyglot'
"Plug 'davidhalter/jedi-vim'
Plug 'vuciv/vim-bujo'
Plug 'jremmen/vim-ripgrep'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'gruvbox-community/gruvbox'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'shaunsingh/nord.nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'unblevable/quick-scope'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdcommenter'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'neomake/neomake'
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
        file_sorter = require("telescope.sorters").get_fzy_sorter,
        prompt_prefix = " >",
        color_devicons = true,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        layout_strategy = 'horizontal',
        mappings = {
            i = {
                ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
            },
            n = {
                ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
                ["<C-a>"] = require("telescope.actions").select_all,
                ["<C-s>"] = require("telescope.actions").toggle_selection,
                ["<C-d>"] = require("telescope.actions").drop_all,
            },
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
      },
    },
}
require("telescope").load_extension("git_worktree")
EOF

" -----------------
" Treesitter Configs
" -----------------
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust" ,"python", "c_sharp", "comment", "java", "lua", "json","scala"},
  -- one of "all", "maintained" (parsers with maintainers), or a list of languages
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
"require("telescope").load_extension("harpoon")
" -----------------
" Git Worktree configs
" -----------------
lua <<EOF
require("git-worktree").setup({
    change_directory_command = "cd", -- default: "cd",
    update_on_change = true,-- default: true,
    update_on_change_command = "e .", -- default: "e .",
    clearjumps_on_change = true, -- default: true,
    autopush = false, -- default: false,
})
EOF


" -----------------
" Syntastic Configs
" -----------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%F
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0


"-----------------
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
let g:coc_global_extensions=[ 'coc-powershell', 'coc-json', 'coc-pyright', 'coc-xml', 'coc-metals', 'coc-sql', 'coc-prettier',  'coc-docker', 'coc-yaml']
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
" Vim Stuff
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
" Colorscheme Settings
" Nord configs
let g:nord_contrast = v:true
let g:nord_borders = v:false
let g:nord_disable_background = v:false
let g:nord_italic = v:false
"colorscheme nord

" tokyonight configs
let g:tokyonight_style = "night"
let g:tokyonight_italic_functions = 1
let g:tokyonight_sidebars = [ "qf", "vista_kind", "terminal", "packer" ]

" Change the "hint" color to the "orange" color, and make the "error" color bright red
let g:tokyonight_colors = {
  \ 'hint': 'orange',
  \ 'error': '#ff0000'
\ }

" Load the colorscheme
colorscheme tokyonight
"colorscheme gruvbox
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
" Find all references to word under the cursor
nnoremap <leader>fw :lua require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>")})<CR>
" Find In curr directory
nnoremap <leader>fi :lua require('telescope.builtin').find_files{ search_dirs = { vim.fn.expand("%:p:h") ..  "/" .. vim.fn.expand("<cword>") } }<CR>
" Find in file from visual mode
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
" Help
nnoremap <leader>H :lua require("telescope.builtin").help_tags()<CR>
" Syntastic Errors
nnoremap <leader>sn :lnext<CR>
nnoremap <leader>sp :lprev<CR>
" Quick Fix List
nnoremap <leader>qf :copen<CR>
nnoremap <leader>x :cnext<CR>
nnoremap <leader>z :cprev<CR>
" List marks
nnoremap <leader>lm :lua require("telescope.builtin").marks()<CR>
" Refresh nvim config
nnoremap <leader>rnc :w! ~/.config/nvim/init.vim<bar> :source ~/.config/nvim/init.vim<CR>
" Edit nvim config
nnoremap <leader>enc :wincmd v<bar> :edit ~/.config/nvim/init.vim<bar> :wincmd =<CR>
" Edit Powershell Core Profile
nnoremap <leader>epcp :wincmd v<bar> :edit E:\OneDrive\OneDrive - Microsoft\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 <bar> :wincmd =<CR>
" Convert tsv to csv
nnoremap <leader>tc :%s/\t/,/g<CR>
" Buffers
nnoremap <leader>B :Telescope buffers<CR>
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bd :bd<CR>
" Show undo tree
nnoremap <leader>u :UndotreeShow<CR>
" --------------------------------------
" Formatting
" --------------------------------------
" Format Json File
nnoremap <leader>fj :%!python -m json.tool <CR>
" Fix Windows Exception Carriage Returns
nnoremap <leader>fcr :%s/\\r\\n/\r/g <bar> :%s/\\"/"/g <bar> :%s/\\r\\\\n/\r/g <bar> :%s/\\\\/\//g <bar> %s/\/\//\//g <bar> :noh <bar> :w <CR>
" Fix quote escapes
nnoremap <leader>feq :%s/\\"/"/g<bar> :noh <CR>
" Expand one liner list to line separated values
nnoremap <leader>FL :%s/\[//g <bar> :%s/\]//g <bar> :%s/\,/\r/g <bar> :%s/\\\\/\//g <bar> :StripWhitespace <bar> :noh <CR>
" Format single line list to separate lines
nnoremap <leader>CL :%s/\,/\,\r/g<bar> :%s/\ //g <bar>:StripWhitespace <bar> :noh <CR>
" Format file using language server
nnoremap <leader>ff :Format<CR>
" --------------------------------------
" Open Notes
" --------------------------------------
nnoremap <leader>no :wincmd v <bar> :wincmd l <bar> :e ~/Notes.txt<CR>
" Force reload file
nnoremap <leader>re :e!<CR>
" Bat File
nnoremap <leader>cat :!bat %<CR>
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
" Open Definition in a parallel window
nmap <silent> gv :vsp<CR><Plug>(coc-definition)<C-W>L <CR>
" Vertical resizes
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>
" File Explorer View
nnoremap <leader>pv :Lex <bar> :exe "vertical resize " . (winwidth(0) * 2/3)<CR>
" Paste from system clipboard w/o formatting, copy back to system cipboard
nnoremap <leader>cf "+p0"+yydd
" Paste last yanked word
nnoremap <leader>vw "0P
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
nnoremap <leader>V gg"+yG<CR>
" Copy all lines in the current file to system clipboard
nnoremap <leader>ya gg0"+yG<CR>
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
nnoremap <leader>t :wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal fish <CR>
" Clear search highlight
nnoremap <leader><space> :noh<CR>
" Harpoon settings
nnoremap <leader>m :lua require("harpoon.mark").add_file()<CR>
nnoremap <leader>n :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>1 :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <leader>2 :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <leader>3 :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <leader>4 :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <leader>5 :lua require("harpoon.ui").nav_file(5)<CR>
"Git Stuff
nnoremap <leader>gs :G<CR>
nnoremap <leader>gl :G log<CR>
nnoremap <leader>gj :diffget //3<CR>
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gd :Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>
nnoremap <leader>gc :G commit <bar> :wincmd = <CR>
nnoremap <leader>gp :G -c push.default=current push <CR>
nnoremap <leader>gP :G pull <CR>
nnoremap <leader>gwp :wq<bar>:G -c push.default=current push<CR>
nnoremap <leader>gS :G stash<CR>
nnoremap <leader>gSl :lua require("telescope.builtin").git_stash()<CR>
nnoremap <leader>gb :lua require("telescope.builtin").git_branches()<CR>
nnoremap <leader>gCl :lua require("telescope.builtin").git_commits()<CR>
nnoremap <leader>gpom :G pull origin master<CR>
nnoremap <leader>gcm :G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>
nnoremap <leader>gpom :G pull origin master<CR>
nnoremap <leader>gw :lua require('telescope').extensions.git_worktree.git_worktrees()<CR>
"Syntax Check
nnoremap <leader>sc :SyntasticCheck<CR>
"Whitespace Fixes
nnoremap <leader>rw :StripWhitespace<CR>
" Coc stuff
nmap <silent>gd <Plug>(coc-definition)
nmap <silent>gy <Plug>(coc-type-definition)
nmap <silent>gi <Plug>(coc-implementation)
nmap <silent>gr <Plug>(coc-references)
" Config json file with comments
autocmd FileType json syntax match Comment +\/\/.\+$+
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
