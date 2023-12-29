-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
-- if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
--   is_bootstrap = true
--   vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
--   vim.cmd [[packadd packer.nvim]]
-- end
--
require('packer').startup(function(use)
    -- Package manager
    use 'wbthomason/packer.nvim'
    use { 'j-hui/fidget.nvim', tag = 'legacy' }

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

    use {
        "github/copilot.vim"
    }

    use 'mbbill/undotree'
    -- Git related plugins
    use 'tpope/vim-fugitive'
    use 'tpope/vim-rhubarb'
    use 'lewis6991/gitsigns.nvim'

    -- Editor friendly plugins
    use 'navarasu/onedark.nvim'            -- Theme inspired by Atom
    use 'nvim-lualine/lualine.nvim'        -- Fancier statusline
    use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
    use 'numToStr/Comment.nvim'            -- "gc" to comment visual regions/lines
    use 'ThePrimeagen/harpoon'
    use 'rinx/nvim-ripgrep'
    -- Syntax highlighting for graphQL
    use 'jparise/vim-graphql'
    -- Fuzzy Finder (files, lsp, etc)
    use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

    -- Nvim Metals for Scala
    -- use({'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" }})
    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    -- use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
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
vim.o.hlsearch = true

-- Ensure there are some lines before the cursor hits the bottom while scrolling
vim.o.scrolloff = 15

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- [Windows] Set shell to powershell
-- vim.opt.shell = 'powershell'
-- Set shortmess options
vim.o.shortmess = vim.o.shortmess .. 'A'

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

-- Set relative numbers
vim.o.relativenumber = true
vim.o.nu = true

-- Tab settings
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

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
require('ibl').setup()
----------------------------
-----Configure GitSigns----
----------------------------
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
-----Configure Copilot----
----------------------------
-- Enable autocomplete
vim.g["copilot#enable_autocomplete"] = 1

-- Enable hover
vim.g["copilot#enable_hover"] = 1

-- Enable signature help
vim.g["copilot#enable_signature_help"] = 1
vim.g["copilot#signature_help_delay"] = 500
vim.g["copilot#signature_help_highlight"] = 1
vim.g["copilot#signature_help_virtual_text"] = 1
vim.g["copilot#signature_help_styling"] = {
    parameter = "italic",
    parameter_current = "italic,bold",
    parameter_inactive = "italic",
}
vim.g["copilot#signature_help_severity_limit"] = "hint"

-- Enable diagnostics
vim.g["copilot#enable_diagnostics"] = 1
vim.g["copilot#diagnostics_delay"] = 500
vim.g["copilot#diagnostics_highlight"] = 1
vim.g["copilot#diagnostics_virtual_text"] = 1
vim.g["copilot#diagnostics_underline"] = 1
vim.g["copilot#diagnostics_styling"] = {
    error = "underline",
    warning = "underline",
    information = "underline",
    hint = "underline",
}
vim.g["copilot#diagnostics_severity_limit"] = "hint"

-- Define your keymaps
vim.g["copilot#keymaps"] = {
    hover = '<leader>h',
    signature_help = '<leader>s',
    diagnostics = '<leader>d',
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
-- Configure Harpoon
----------------------------
require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
    },
})
----------------------------
-----Treesitter Configs----
----------------------------
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'scala' },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        disable = { "txt" },
    },
    indent = {
        enable = true,
        disable = { 'python' }
    },
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

----------------------------
-----RipGrep Configs ----
----------------------------
require('nvim-ripgrep').setup {
}

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

    lsp_nmap('Gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    lsp_nmap('Gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    lsp_nmap('Gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    lsp_nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    lsp_nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    lsp_nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    lsp_nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    lsp_nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
    -- Lesser used LSP functionality
    lsp_nmap('GD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
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
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'clangd', 'tsserver', 'lua_ls', 'omnisharp', 'marksman', 'jsonls', 'pylsp', 'ruff_lsp' }

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

require('lspconfig').lua_ls.setup {
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
        ['<C-l>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<C-j>'] = cmp.mapping(function(fallback)
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
vim.cmd("setlocal ts=4 sw=4 sts=4 et")
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
vim.keymap.set('n', '<leader>/',
    function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 10,
            previewer = false,
        })
    end,
    { desc = '[/] Fuzzily search in current buffer]' })
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
vim.keymap.set('n', '<leader>lm', ':marks<CR>', { desc = '[L]ist [M]arks', noremap = true })
-- Save current buffer
vim.keymap.set('n', '<leader>w', ':w!<CR>', { desc = 'Save File', noremap = true })
-- edit neovim config
-- vim.keymap.set('n', '<leader>enc',
--	":wincmd v <bar>:e C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua<bar> :wincmd =<CR>"
--	, { desc = '[E]dit [N]eovim [C]onfig', noremap = true })
-- [Windows] Edit neovim config
vim.keymap.set('n', '<leader>enc',
    ":wincmd v <bar>:e C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua<bar> :wincmd =<CR>"
    , { desc = '[E]dit [N]eovim [C]onfig', noremap = true })
-- [Linux] Refresh neovim config
-- vim.keymap.set('n', '<leader>rnc', ":w! ~/.config/nvim/init.lua <bar> :source ~/.config/nvim/init.lua<CR>",
-- 	{ desc = '[R]efresh [N]vim [C]onfig', noremap = true })
-- [Windows] Refresh neovim config
vim.keymap.set('n', '<leader>rnc',
    ":w! C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua <bar> :source C:\\Users\\raranjan\\AppData\\Local\\nvim\\init.lua<CR>"
    , { desc = '[R]efresh [N]vim [C]onfig', noremap = true })
-- [Windows] Edit powershell config
vim.keymap.set('n', '<leader>epcp',
    ":wincmd v <bar>:e E:\\OneDrive\\OneDrive - Microsoft\\Documents\\PowerShell\\Microsoft.PowerShell_profile.ps1<bar> :wincmd =<CR>"
    , { desc = '[E]dit [P]owershell [C]onfig [P]rofile', noremap = true })
-- Convert tsv to csv
vim.keymap.set('n', '<leader>tc', ':%s/\t/,/g<CR>', { desc = 'Covert [T]SV to [C]SV', noremap = true })
vim.keymap.set('n', '<leader>u', ':UndotreeShow<CR>', { desc = '[U]ndo tree pane', noremap = true })
-- Formatting helpers
-- Fix exception logs
vim.keymap.set('n', '<leader>fel', ":%s/\\n/\\r/g<CR>", { desc = '[F]ix [E]xception [L]ines', noremap = true })
-- Fix Windows Exception Carriage Returns
vim.keymap.set('n', '<leader>fcr',
    ":%s/\\r\\n/\r/g <bar> :%s/\\\\\"/\"/g <bar> :%s/\\r\\\\n/\\r/g <bar> :%s/\\\\/\\//g <bar> %s/\\/\\//\\//g <bar> :noh <bar> :w <CR>"
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
vim.keymap.set('n', '<leader>crf', '"+p0"+yydd', { desc = '[C]opy [R]emove [F]ormatting', noremap = true })
-- Yank word from anywhere
vim.keymap.set('n', '<leader>yw', '"ayiw', { desc = '[Y]ank [W]ord', noremap = true })
-- Paste last yanked word
vim.keymap.set('n', '<leader>pw', 'viw"aP', { desc = '[P]aste yanked [Word]', noremap = true })
-- Copy to system clipboard
vim.keymap.set('v', '<leader>c', '"+y', { desc = '[C]opy to system clipboard', noremap = true })
-- Copy all lines to system clipboard
vim.keymap.set('n', '<leader>ya', 'gg0"+yG', { desc = '[C]opy to system clipboard', noremap = true })
-- Paste from system clipboard
vim.keymap.set('n', '<leader>v', ' "+p', { desc = '[Y]ank [A]ll lines to the system clipboard', noremap = true })
-- Move line above
vim.keymap.set('n', 'J', ' mzJ`z', { desc = 'Move line above', noremap = true })
-- Move lines around in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move highlighted line down', noremap = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move highlighted line up', noremap = true })
-- Save and quit remaps
vim.keymap.set('n', '<leader>w', ':w! <CR>', { desc = 'Save', noremap = true })
vim.keymap.set('n', '<leader>wa', ':wa! <CR>', { desc = 'Save [A]ll', noremap = true })
vim.keymap.set('n', '<leader>wq', ':wq <CR>', { desc = 'Save and Quit', noremap = true })
vim.keymap.set('n', '<leader>Q', ':qa! <CR>', { desc = 'Force Quit All', noremap = true })
-- Harpoon settings
vim.keymap.set('n', '<leader>m', ':lua require("harpoon.mark").add_file()<CR>', { desc = '[M]ark file', noremap = true })
vim.keymap.set('n', '<leader>n', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {
    desc = '[N]avigate file',
    noremap = true
})
vim.keymap.set('n', '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>',
    { desc = 'Navigate to marked file[1]', noremap = true })
vim.keymap.set('n', '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>',
    { desc = 'Navigate to marked file[2]', noremap = true })
vim.keymap.set('n', '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>',
    { desc = 'Navigate to marked file[3]', noremap = true })
vim.keymap.set('n', '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>',
    { desc = 'Navigate to marked file[4]', noremap = true })
vim.keymap.set('n', '<leader>5', ':lua require("harpoon.ui").nav_file(5)<CR>',
    { desc = 'Navigate to marked file[5]', noremap = true })
vim.keymap.set('n', '<leader>6', ':lua require("harpoon.ui").nav_file(6)<CR>',
    { desc = 'Navigate to marked file[6]', noremap = true })
vim.keymap.set('n', '<leader>7', ':lua require("harpoon.ui").nav_file(7)<CR>',
    { desc = 'Navigate to marked file[7]', noremap = true })
-- Git Stuff
vim.keymap.set('n', '<leader>gs', ':G<CR>', { desc = '[G]it [S]tatus', noremap = true })
vim.keymap.set('n', '<leader>gl', ':G log<CR>', { desc = '[G]it [L]ist', noremap = true })
vim.keymap.set('n', '<leader>gj', ':diffget //3<CR>', { desc = '[G]it take right', noremap = true })
vim.keymap.set('n', '<leader>gf', ':diffget //2<CR>', { desc = '[G]it take left', noremap = true })
vim.keymap.set('n', '<leader>gd', ':Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>',
    { desc = '[G]it [D]iff', noremap = true })
vim.keymap.set('n', '<leader>gc', ':G commit <bar> :wincmd = <CR>', { desc = '[G]it Commit', noremap = true })
vim.keymap.set('n', '<leader>gp', ':G -c push.default=current push <CR>', { desc = '[G]it [p]ush', noremap = true })
vim.keymap.set('n', '<leader>gP', ':G fetch origin<bar>:G pull<CR>', { desc = '[G]', noremap = true })
vim.keymap.set('n', '<leader>gwp', ':wq<bar>:G -c push.default=current push<CR><CR>',
    { desc = '[G]it [P]ush', noremap = true })
vim.keymap.set('n', '<leader>gS', ':G stash<CR>', { desc = '[G]it [S]tash', noremap = true })
vim.keymap.set('n', '<leader>gSl', ':lua require("telescope.builtin").git_stash()<CR>',
    { desc = '[G]it [S]tash [L]ist', noremap = true })
vim.keymap.set('n', '<leader>gb', ':lua require("telescope.builtin").git_branches()<CR>', {
    desc = '[G]it [B]ranch',
    noremap = true
})
vim.keymap.set('n', '<leader>gB', ':G blame<CR>', {
    desc = '[G]it [B]lame',
    noremap = true
})
vim.keymap.set('n', '<leader>gCl', ':lua require("telescope.builtin").git_commits()<CR>',
    { desc = '[G]it [C]ommits [L]ist', noremap = true })
vim.keymap.set('n', '<leader>gcm',
    ':G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>',
    { desc = '[G]it [C]heckout [M]aster', noremap = true })
vim.keymap.set('n', '<leader>gpom', ':G pull origin master<CR>',
    { desc = '[G]it [P]ull [O]rigin [M]aster', noremap = true })
vim.keymap.set('n', '<leader>ch', ':noh<CR>',
    { desc = '[C]lear [H]ighlights', noremap = true })
-- Generate Percentiles for JMX Results
vim.keymap.set('n', '<leader>jp', ':!python D:\\JMeter\\Results\\generate_percentiles.py --file %<CR>',
    { desc = '[J]Meter Results [P]ercentiles', noremap = true })
vim.keymap.set("n", "-", ':Explore<CR>', { desc = 'Open Netrw Explorer at current directory', noremap = true })
-- [Linux] Open shell in hortizontal split
vim.keymap.set('n', '<leader>t', ':wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal pwsh<CR>',
    { desc = 'Open [T]erminal', noremap = true })
-- [Windows] Open powershell core in hortizontal split
-- vim.keymap.set('n', '<leader>t',':wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal pwsh <CR>', { desc = 'Open [T]erminal', noremap = true})
-- LSP restart
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { desc = '[L]sp [R]estart', noremap = true })
vim.keymap.set('n', '<leader>Rg', ':lua require("nvim-ripgrep").grep()', { desc = '[L]sp [R]estart', noremap = true })
vim.keymap.set('n', '<leader>km', ':Telescope keymaps<CR>', { desc = 'Show [K]ey[M]aps', noremap = true })
-- [Windows] TODO Figvre out how to make this work on mac
vim.keymap.set('n', '<leader>oe', ':execute \'!start explorer /select,\' . expand(\'%:p\')<CR><CR>',
    { desc = '[O]pen [E]xplorer', noremap = true })
