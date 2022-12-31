-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use 'github/copilot.vim'
  use 'mbill/undotree'
  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- Editor friendly plugins
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

----------------------------
-----Configure Telescope----
----------------------------
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
      },
      n = {
        ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
        ["<C-a>"] = require("telescope.actions").select_all,
        ["<C-s>"] = require("telescope.actions").toggle_selection,
        ["<C-d>"] = require("telescope.actions").drop_all,
      }
    },
  },
}
-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

----------------------------
-----Treesitter Configs----
----------------------------
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'scala' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-----------------------
------- Remaps --------
-----------------------
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = '[D]iagnostic [P]revious', noremap = true })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = '[D]iagnostic [N]ext', noremap = true })
vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, { desc = '[D]iagnostic [F]loat window', noremap = true })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = '[D]iagnostic [Q]uickfix list', noremap = true })
-- Telescope remaps
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles,
  { desc = '[?] Find recently opened files', noremap = true })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers,
  { desc = '[ ] Find existing buffers', noremap = true })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<c-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles', noremap = true })
vim.keymap.set('n', '<leader>H', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp', noremap = true })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string,
  { desc = '[S]earch current [W]ord', noremap = true })
vim.keymap.set('n', '<leader>lg', require('telescope.builtin').live_grep, { desc = '[L]ive [G]rep', noremap = true })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics,
  { desc = '[F]ind in [D]iagnostics', noremap = true })
-- Quickfix Remaps
vim.keymap.set('n', '<leader>qf', ':copen<CR>', { desc = 'ne[X]t in Quickfix', noremap = true })
vim.keymap.set('n', '<leader>x', ':cnext<CR>', { desc = ' in Quickfix', noremap = true })
vim.keymap.set('n', '<leader>z', ':cprev<CR>', { desc = 'Previous in Quickfix', noremap = true })
-- List marks
vim.keymap.set('n', '<leader>lm', ':cprev<CR>', { desc = '[L]ist [M]arks', noremap = true })
-- Save current buffer
vim.keymap.set('n', '<leader>w', ':w!<CR>', { desc = 'Save File', noremap = true })
-- Refresh neovim config
vim.keymap.set('n', '<leader>rnc',
  ":w! C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua <bar> :source C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua<CR>"
  , { desc = '[R]efresh [N]vim [C]onfig', noremap = true })
-- Edit powershell config
vim.keymap.set('n', '<leader>epcp',
  ":wincmd v <bar>:e E:\\OneDrive\\OneDrive - Microsoft\\Documents\\PowerShell\\Microsoft.PowerShell_profile.ps1<bar> :wincmd =<CR>"
  , { desc = '[E]dit [P]owershell [C]onfig [P]rofile', noremap = true })
-- Convert tsv to csv
vim.keymap.set('n', '<leader>tc', ':%s/\t/,/g<CR>', { desc = 'Covert [T]SV to [C]SV', noremap = true })
vim.keymap.set('n', '<leader>u', ':UndotreeShow', { desc = '[U]ndo tree pane', noremap = true })
-- Formatting helpers
-- Fix Windows Exception Carriage Returns
vim.keymap.set('n', '<leader>fcr',
  ":%s/\\r\\n/\\r/g <bar> :%s/\\\\\"/\"/g <bar> :%s/\\r\\\\n/\\r/g <bar> :%s/\\\\/\\//g <bar> %s/\\/\\//\\//g <bar> :noh <bar> :w <CR>"
  ,
  { desc = '[F]ix [C]arriage [R]eturns', noremap = true })
-- Fix quote escapes
vim.keymap.set('n', '<leader>feq', ":%s/\\\\\" / \\\"/g<bar> :noh <CR>", { desc = '[U]ndo tree pane', noremap = true })
-- Expand python one liner list to line separated values
vim.keymap.set('n', '<leader>flp',
  ":%s/\\[//g <bar> :%s/\\]//g <bar> :%s/\\,/\r/g <bar> :%s/\\\\/\\//g <bar> :StripWhitespace <bar> :noh <CR>",
  { desc = '[F]ormat [L]ist in [P]ython format to newline separated values', noremap = true })
-- Format single line list to separate lines
vim.keymap.set('n', '<leader>flc', ":%s/\\,/\\,\\r/g<bar> :%s/\\ /\\ /g <CR>",
  { desc = '[F]ormat [L]ist in csv to newline separated values', noremap = true })
-- Open notes
vim.keymap.set('n', '<leader>no', ' :wincmd v <bar> :wincmd l <bar> :e ~/Notes.txt<CR>',
  { desc = '[O]pen [N]otes', noremap = true })
-- Force reload file
vim.keymap.set('n', '<leader>re', ' :e!<CR>', { desc = '[R]eload file', noremap = true })
-- Create log json file
vim.keymap.set('n', '<leader>logj', ":wincmd v <bar> :wincmd l <bar> :e E:\\Logs\\someLog.json <bar> :1,$d <CR>",
  { desc = 'Create [LogJ]son file', noremap = true })
-- Delete all lines in the current file.
vim.keymap.set('n', '<leader>dL', ':1,$d <CR>', { desc = '[D]elete all [L]ines in the current file', noremap = true })
-- Window Stuff
vim.keymap.set('n', '<leader>h', ' :wincmd h<CR>', { desc = 'Move right', noremap = true })
vim.keymap.set('n', '<leader>j', ' :wincmd j<CR>', { desc = 'Move down', noremap = true })
vim.keymap.set('n', '<leader>k', ' :wincmd k<CR>', { desc = 'Move up', noremap = true })
vim.keymap.set('n', '<leader>l', ' :wincmd l<CR>', { desc = 'Move left', noremap = true })
vim.keymap.set('n', '<leader>q', ' :wincmd q<CR>', { desc = 'Quit current pane', noremap = true })
vim.keymap.set('n', '<leader>o', ' :wincmd o<CR>', { desc = 'Close other panes', noremap = true })
-- Vertical resizes
vim.keymap.set('n', '<leader>+', ' :vertical resize +10<CR>', { desc = 'Vertical resize ++', noremap = true })
vim.keymap.set('n', '<leader>-', ' :vertical resize -10<CR>', { desc = 'Vertical resize --', noremap = true })
-- Paste from system clipboard w/o formatting, copy back to system cipboard
vim.keymap.set('n', '<leader>crf', ' "+p0"+yydd', { desc = '[C]opy [R]emove [F]ormatting', noremap = true })
-- Yank word from anywhere
vim.keymap.set('n', '<leader>yw', ' yiw', { desc = '[Y]ank [W]ord', noremap = true })
-- Paste last yanked word
vim.keymap.set('n', '<leader>vw', ' "0P', { desc = 'Paste yanked [Word]', noremap = true })
-- Copy to system clipboard
vim.keymap.set('n', '<leader>c', ' "+y', { desc = '[C]opy to system clipboard', noremap = true })
-- Paste from system clipboard
vim.keymap.set('n', '<leader>v', ' "+p', { desc = 'Paste from system clipboard', noremap = true })
-- Move line above
vim.keymap.set('n', 'J', ' mzJ`z', { desc = 'Move line above', noremap = true })
-- Move lines around in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move highlighted line down', noremap = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move highlighted line up', noremap = true })
-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local lsp_nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  lsp_nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  lsp_nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  lsp_nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  lsp_nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  lsp_nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  lsp_nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  lsp_nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  lsp_nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  lsp_nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  -- Lesser used LSP functionality
  lsp_nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lsp_nmap('<leader>waf', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  lsp_nmap('<leader>wrf', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  lsp_nmap('<leader>wlf', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  lsp_nmap('<leader>ff', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, 'Format current buffer with LSP')

  -- TODO Remove this
  -- -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   if vim.lsp.buf.format then
  --     vim.lsp.buf.format()
  --   elseif vim.lsp.buf.formatting then
  --     vim.lsp.buf.formatting()
  --   end
  -- end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver', 'sumneko_lua', 'gopls', 'omnisharp' }

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Turn on lsp status information
require('fidget').setup()

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
