--Helper functions to keep remaps clear
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

function vmap(shortcut, command)
  map('v', shortcut, command)
end

function cmap(shortcut, command)
  map('c', shortcut, command)
end

function tmap(shortcut, command)
  map('t', shortcut, command)
end


-- Fuzzy find files
nmap('<c-p>', ":lua require('telescope.builtin').find_files()<CR>")
-- Live Grep for strings
nmap('<leader>gre', ":lua require('telescope.builtin').live_grep()<CR>")
-- Find Strings
nmap('<leader>f', ":lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep For > ')})<CR>")
-- Find all references to word under the cursor
nmap('<leader>fw', ":lua require('telescope.builtin').grep_string({ search = vim.fn.expand('<cword>')})<CR>")
-- Find In curr directory
nmap('<leader>fi', ":lua require('telescope.builtin').find_files{ search_dirs = { vim.fn.expand('%:p:h') ..  '/'.. vim.fn.expand('<cword>') } }<CR>")
-- TODO Remove if this doesn't work
-- Find in file from visual mode
--vmap('//', "y/\V<C-R>=escape(@','/\')<CR><CR>")
-- Help
nmap('<leader>H', ":lua require('telescope.builtin').help_tags()<CR>")
-- Quick Fix List
nmap('<leader>qf',':copen<CR>')
nmap('<leader>x', ':cnext<CR>')
nmap('<leader>z', ':cprev<CR>')
-- List marks
nmap('<leader>lm', ':lua require('telescope.builtin').marks()<CR>')
-- Refresh nvim config
nmap('<leader>rnc', ':w! ~/.config/nvim/init.vim<bar> :source ~/.config/nvim/init.vim<CR>')
-- Edit nvim config
nmap('<leader>enc', ':wincmd v<bar> :edit ~/.config/nvim/init.vim<bar> :wincmd =<CR>')
-- Edit Powershell Core Profile
nmap('<leader>epcp', ':wincmd v<bar> :edit E:\OneDrive\OneDrive - Microsoft\Documents\PowerShell\Microsoft.PowerShell_profile.ps1 <bar> :wincmd =<CR>')
-- Convert tsv to csv
nmap('<leader>tc', ':%s/\t/,/g<CR>')
-- Buffers
nmap('<leader>B', ':Telescope buffers<CR>')
nmap('<leader>bn', ':bn<CR>')
nmap('<leader>bp', ':bp<CR>')
nmap('<leader>bd', ':bd<CR>')
-- Show undo tree
nmap('<leader>u', ':UndotreeShow<CR>')
-- --------------------------------------
-- Formatting
-- --------------------------------------
-- Format Json File
nmap('<leader>fj', ':%!python -m json.tool <CR>')
-- Fix Windows Exception Carriage Returns
nmap('<leader>fcr', ':%s/\\r\\n/\r/g <bar> :%s/\\'/'/g <bar> :%s/\\r\\\\n/\r/g <bar> :%s/\\\\/\//g <bar> %s/\/\//\//g <bar> :noh <bar> :w <CR>')
-- Fix quote escapes
nmap('<leader>feq', ":%s/\\'/'/g<bar> :noh <CR>")
-- Expand one liner list to line separated values
nmap('<leader>FL', ":%s/\[//g <bar> :%s/\]//g <bar> :%s/\,/\r/g <bar> :%s/\\\\/\//g <bar> :StripWhitespace <bar> :noh <CR>")
-- Format single line list to separate lines
nmap('<leader>CL', ':%s/\,/\,\r/g<bar> :%s/\ //g <bar>:StripWhitespace <bar> :noh <CR>')
-- Format file using language server
nmap('<leader>ff', ':Format<CR>')
-- --------------------------------------
-- Open Notes
-- --------------------------------------
nmap('<leader>no', ':wincmd v <bar> :wincmd l <bar> :e ~/Notes.txt<CR>')
-- Force reload file
nmap('<leader>re', ':e!<CR>')
-- Bat File
nmap('<leader>cat', ':!bat %<CR>')
-- Create log json file
nmap('<leader>logj', ':wincmd v <bar> :wincmd l <bar> :e E:\Logs\someLog.json <bar> :1,$d <CR>')
-- Delete all lines in the current file.
nmap('<leader>dL', ':1,$d <CR>')
-- Window Stuff
nmap('<leader>h', ':wincmd h<CR>')
nmap('<leader>j', ':wincmd j<CR>')
nmap('<leader>k', ':wincmd k<CR>')
nmap('<leader>l', ':wincmd l<CR>')
nmap('<leader>q', ':wincmd q<CR>')
nmap('<leader>o', ':wincmd o<CR>')
-- Open Definition in a parallel window
nmap('gv', ':vsp<CR><Plug>(coc-definition)<C-W>L <CR>')
-- Vertical resizes
nmap('<leader>+', ':vertical resize +10<CR>')
nmap('<leader>-', ':vertical resize -10<CR>')
-- File Explorer View
nmap('<leader>pv', ":Lex <bar> :exe 'vertical resize '. (winwidth(0) * 2/3)<CR>")
-- Paste from system clipboard w/o formatting, copy back to system cipboard
--nmap('<leader>cf "+p0"+yydd
---- Paste last yanked word
--nmap('<leader>vw '0P
---- Copy to system clipboard
--vmap('<leader>c '+y
---- Paste from system clipboard
--nmap('<leader>v '+p
---- Yank to end of line
--nmap('Y y$
---- Keep the cursor centered
--nmap('n nzzzv
--nmap('N Nzzzv
--nmap('J mzJ`z
---- Move lines around in visual mode
--vmap('J :m '>+1<CR>gv=gv
--vmap('K :m '<-2<CR>gv=gv
---- Cleanup file and paste from system clipboard
--nmap('<leader>V gg'+yG<CR>
---- Copy all lines in the current file to system clipboard
--nmap('<leader>ya gg0'+yG<CR>
---- Delete selected visual block and paste content from _ register above it.
--vmap('<leader>p d'_P
--'Save and Quit short remaps
--nmap('<leader>w :w! <CR>
--nmap('<leader>wa :wa! <CR>
--nmap('<leader>wq :wq <CR>
--nmap('<leader>wa :wa <CR>
--nmap('<leader>Q :qa! <CR>
--nmap('<leader>qa :qa! <CR>
---- Open powershell core terminal in horizontal split
--nmap('<leader>t :wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal fish <CR>
--nmap('<leader>vt :wincmd v <bar> :wincmd l <bar> :vertical resize -10<bar> :terminal fish <CR>
---- Clear search highlight
--nmap('<leader><space> :noh<CR>
---- Harpoon settings
--nmap('<leader>m :lua require('harpoon.mark').add_file()<CR>
--nmap('<leader>n :lua require('harpoon.ui').toggle_quick_menu()<CR>
--nmap('<leader>1 :lua require('harpoon.ui').nav_file(1)<CR>
--nmap('<leader>2 :lua require('harpoon.ui').nav_file(2)<CR>
--nmap('<leader>3 :lua require('harpoon.ui').nav_file(3)<CR>
--nmap('<leader>4 :lua require('harpoon.ui').nav_file(4)<CR>
--nmap('<leader>5 :lua require('harpoon.ui').nav_file(5)<CR>
--'Git Stuff
--nmap('<leader>gs :G<CR>
--nmap('<leader>gl :G log<CR>
--nmap('<leader>gj :diffget //3<CR>
--nmap('<leader>gf :diffget //2<CR>
--nmap('<leader>gd :Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>
--nmap('<leader>gc :G commit <bar> :wincmd = <CR>
--nmap('<leader>gp :G -c push.default=current push <CR>
--nmap('<leader>gP :G pull <CR>
--nmap('<leader>gwp :wq<bar>:G -c push.default=current push<CR>
--nmap('<leader>gS :G stash<CR>
--nmap('<leader>gSl :lua require('telescope.builtin').git_stash()<CR>
--nmap('<leader>gb :lua require('telescope.builtin').git_branches()<CR>
--nmap('<leader>gCl :lua require('telescope.builtin').git_commits()<CR>
--nmap('<leader>gpom :G pull origin master<CR>
--nmap('<leader>gcm :G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>
--nmap('<leader>gpom :G pull origin master<CR>
--nmap('<leader>gw :lua require('telescope').extensions.git_worktree.git_worktrees()<CR>
--'Syntax Check
--nmap('<leader>sc :SyntasticCheck<CR>
--'Whitespace Fixes
--nmap('<leader>rw :StripWhitespace<CR>
