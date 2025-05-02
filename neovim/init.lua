-- Bootstrap lazy.nvim and plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Configure lazy.nvim
require("lazy").setup({
    -- Copilot
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    keymap = {
                        accept = "<M-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = true,
                    markdown = true,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    ["."] = false,
                },
            })
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
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
        end,
    },

    -- Editor friendly plugins
    {
        'navarasu/onedark.nvim',  -- Theme inspired by Atom
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd [[colorscheme onedark]]
        end,
    },

    {
        'nvim-lualine/lualine.nvim',  -- Fancier statusline
        event = "VeryLazy",
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = false,
                    theme = 'onedark',
                    component_separators = '|',
                    section_separators = '',
                },
            }
        end,
    },

    {
        'lukas-reineke/indent-blankline.nvim',  -- Add indentation guides
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('ibl').setup()
        end,
    },

    {
        'numToStr/Comment.nvim',  -- "gc" to comment visual regions/lines
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('Comment').setup()
        end,
    },



    -- Git related plugins with configuration
    {
        'tpope/vim-fugitive',
        dependencies = { 'tpope/vim-rhubarb' },
        event = "VeryLazy",
        keys = {
            { '<leader>gs', ':G<CR>', desc = '[G]it [S]tatus' },
            { '<leader>gl', ':G log<CR>', desc = '[G]it [L]ist' },
            { '<leader>gj', ':diffget //3<CR>', desc = '[G]it take right' },
            { '<leader>gf', ':diffget //2<CR>', desc = '[G]it take left' },
            { '<leader>gd', ':Gdiffsplit <bar> :wincmd = <bar> :resize +20<CR>', desc = '[G]it [D]iff' },
            { '<leader>gc', ':G commit <bar> :wincmd = <CR>', desc = '[G]it Commit' },
            { '<leader>gp', ':G -c push.default=current push <CR>', desc = '[G]it [p]ush' },
            { '<leader>gP', ':G fetch origin<bar>:G pull<CR>', desc = '[G]it Pull' },
            { '<leader>gwp', ':wq<bar>:G -c push.default=current push<CR><CR>', desc = '[G]it [P]ush' },
            { '<leader>gS', ':G stash<CR>', desc = '[G]it [S]tash' },
            { '<leader>gB', ':G blame<CR>', desc = '[G]it [B]lame' },
            { '<leader>gcm', ':G reset --hard <bar> :G checkout master <bar>:G remote prune origin <bar> :G pull origin master<CR>', desc = '[G]it [C]heckout [M]aster' },
            { '<leader>gpom', ':G pull origin master<CR>', desc = '[G]it [P]ull [O]rigin [M]aster' },
        },
    },
    
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    -- Navigation
                    vim.keymap.set('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, buffer = bufnr})

                    vim.keymap.set('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, buffer = bufnr})
                end
            }
        end,
    },

    {
        'rinx/nvim-ripgrep',
        cmd = 'Rg',
        keys = {
            { '<leader>Rg', ':lua require("nvim-ripgrep").grep()<CR>', desc = 'Ripgrep Search' },
        },
        config = function()
            require('nvim-ripgrep').setup {
                -- Open quickfix window automatically
                open_qf_window = true,
                -- Show search count and search status
                show_status = true,
                -- Ripgrep additional arguments
                additional_args = {
                    '--hidden',
                    '--glob',
                    '!.git/*',
                },
            }
        end,
    },

    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    width = 35,
                },
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                    follow_current_file = true,
                    use_libuv_file_watcher = true,
                },
            })
        end,
        keys = {
            { '<leader>fe', ':Neotree toggle<CR>', desc = 'Toggle [F]ile [E]xplorer' },
            { '<leader>fn', ':Neotree focus<CR>', desc = '[F]ile Explorer [N]avigate' },
        },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPost", "BufNewFile" },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'scala' },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "txt" }
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
                        lookahead = true, -- Automatically jump forward to textobj
                        keymaps = {
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
                        set_jumps = true,
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
        end,
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
    },

    {
        'jparise/vim-graphql',  -- GraphQL syntax
        ft = { 'graphql', 'gql' },
    },

    -- Telescope and extensions
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local builtin = require('telescope.builtin')

            telescope.setup({
                defaults = {
                    path_display = { truncate = 3 },
                    sorting_strategy = "ascending",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            preview_width = 0.55,
                        },
                    },
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-u>"] = false,
                            ["<C-d>"] = false,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<esc>"] = actions.close,
                        },
                        n = {
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                            ["<C-a>"] = actions.select_all,
                            ["<C-s>"] = actions.toggle_selection,
                            ["<C-d>"] = actions.drop_all,
                        },
                    },
                    file_ignore_patterns = {
                        "^.git/",
                        "^node_modules/",
                        "^target/",
                        "^dist/",
                    },
                    preview = {
                        filesize_limit = 1, -- in MB
                        treesitter = true,
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                    live_grep = {
                        additional_args = function()
                            return { "--hidden" }
                        end,
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    file_browser = {
                        theme = "dropdown",
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {
                                ["<C-h>"] = actions.which_key,
                            },
                            ["n"] = {
                                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                            },
                        },
                    },
                },
            })

            -- Load telescope extensions
            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
            telescope.load_extension('file_browser')

            -- Setup keymaps
            vim.keymap.set('n', '<c-p>', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
            vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>H', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = '[L]ive [G]rep' })
            vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind in [D]iagnostics' })
            vim.keymap.set('n', '<leader>gSl', builtin.git_stash, { desc = '[G]it [S]tash [L]ist' })
            vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranch' })
            vim.keymap.set('n', '<leader>gCl', builtin.git_commits, { desc = '[G]it [C]ommits [L]ist' })
            vim.keymap.set('n', '<leader>km', ':Telescope keymaps<CR>', { desc = 'Show [K]ey[M]aps' })
        end,
    },

    {
        'ThePrimeagen/harpoon',
        config = function()
            require("harpoon").setup({
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                },
            })
        end,
        keys = {
            { '<leader>m', ':lua require("harpoon.mark").add_file()<CR>', desc = '[M]ark file' },
            { '<leader>n', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = '[N]avigate file' },
            { '<leader>1', ':lua require("harpoon.ui").nav_file(1)<CR>', desc = 'Navigate to marked file[1]' },
            { '<leader>2', ':lua require("harpoon.ui").nav_file(2)<CR>', desc = 'Navigate to marked file[2]' },
            { '<leader>3', ':lua require("harpoon.ui").nav_file(3)<CR>', desc = 'Navigate to marked file[3]' },
            { '<leader>4', ':lua require("harpoon.ui").nav_file(4)<CR>', desc = 'Navigate to marked file[4]' },
            { '<leader>5', ':lua require("harpoon.ui").nav_file(5)<CR>', desc = 'Navigate to marked file[5]' },
            { '<leader>6', ':lua require("harpoon.ui").nav_file(6)<CR>', desc = 'Navigate to marked file[6]' },
            { '<leader>7', ':lua require("harpoon.ui").nav_file(7)<CR>', desc = 'Navigate to marked file[7]' },
        },
    },

    {
        'mbbill/undotree',
        cmd = 'UndotreeToggle',
        keys = {
            { '<leader>u', ':UndotreeShow<CR>', desc = '[U]ndo tree pane' },
        },
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', tag = 'legacy' },
            'b0o/schemastore.nvim',  -- JSON Schema support
        },
        config = function()
            -- LSP settings
            -- See `:help vim.lsp`

            local on_attach = function(_, bufnr)
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
                lsp_nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                lsp_nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
                lsp_nmap('GD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                lsp_nmap('<leader>waf', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
                lsp_nmap('<leader>wrf', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
                lsp_nmap('<leader>wlf', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [L]ist Folders')
                lsp_nmap('<leader>ff', function()
                    if vim.lsp.buf.format then
                        vim.lsp.buf.format()
                    elseif vim.lsp.buf.formatting then
                        vim.lsp.buf.formatting()
                    end
                end, 'Format current buffer with LSP')
            end

            -- Setup mason so it can manage external tooling
            require('mason').setup()

            -- Enable the following language servers with their correct names
            local servers = {
                'clangd',
                'ts_ls',
                'ruff',
                'lua_ls',
                'pyright',      -- preferred Python LSP
                'jsonls',
                'marksman',     -- Markdown
                'dockerls',     -- Docker
                'elixirls',     -- Elixir
                'jdtls',        -- Java
            }

            -- Ensure the servers above are installed
            require('mason-lspconfig').setup {
                ensure_installed = servers,
                automatic_installation = true,
            }

            -- Wait for mason-lspconfig to install servers before configuring them
            require('mason-lspconfig').setup_handlers {
                function(server_name)
                    local capabilities = require('cmp_nvim_lsp').default_capabilities()
                    

                    -- Server-specific settings
                    local settings = {
                        ['lua_ls'] = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT',
                                    path = vim.split(package.path, ';'),
                                },
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file('', true),
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            },
                        },
                        ['pyright'] = {
                            python = {
                                analysis = {
                                    typeCheckingMode = 'basic',
                                    autoSearchPaths = true,
                                    useLibraryCodeForTypes = true,
                                },
                            },
                        },
                        ['jsonls'] = {
                            json = {
                                schemas = require('schemastore').json.schemas(),
                                validate = { enable = true },
                            },
                        },
                    }

                    require('lspconfig')[server_name].setup {
                        on_attach = on_attach,
                        capabilities = capabilities,
                        settings = settings[server_name],
                    }
                end,
            }

            -- Turn on lsp status information
            require('fidget').setup()
        end,
    },
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

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Tab settings
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Keep only non-plugin keymaps in the general keymaps section
-- [[ Basic Keymaps ]]
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- General keymaps
vim.keymap.set('n', '<leader>tc', ':%s/\t/,/g<CR>', { desc = 'Convert [T]SV to [C]SV', noremap = true })

-- Formatting helpers
vim.keymap.set('n', '<leader>fel', ":%s/\\n/\\r/g<CR>", { desc = '[F]ix [E]xception [L]ines', noremap = true })
vim.keymap.set('n', '<leader>feq', ":%s/\\\\\" / \\\"/g<bar> :noh <CR>", { desc = 'Fix [E]scaped [Q]uotes', noremap = true })
vim.keymap.set('n', '<leader>flp',
    ":%s/\\[//g <bar> :%s/\\]//g <bar> :%s/\\,/\r/g <bar> :%s/\\\\/\\//g <bar> :StripWhitespace <bar> :noh <CR>",
    { desc = '[F]ormat [L]ist in [P]ython format to newline separated values', noremap = true })
vim.keymap.set('n', '<leader>flc', ":%s/\\,/\\,\\r/g<bar> :%s/\\ /\\ /g <CR>",
    { desc = '[F]ormat [L]ist in csv to newline separated values', noremap = true })

-- File and window operations
vim.keymap.set('n', '<leader>no', ' :wincmd v <bar> :wincmd l <bar> :e ~/Notes.txt<CR>',
    { desc = '[O]pen [N]otes', noremap = true })
vim.keymap.set('n', '<leader>re', ' :e!<CR>', { desc = '[R]eload file', noremap = true })
vim.keymap.set('n', '<leader>t', ':wincmd s <bar> :wincmd j <bar> :resize -10  <bar> :terminal zsh<CR>',
    { desc = 'Open [T]erminal', noremap = true })

-- Clear highlights and LSP
vim.keymap.set('n', '<leader>ch', ':noh<CR>', { desc = '[C]lear [H]ighlights', noremap = true })
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { desc = '[L]sp [R]estart', noremap = true })

-- System integration
vim.keymap.set('n', '<leader>oe', ':execute "!open " . expand("%:p:h")<CR>',
    { desc = '[O]pen in [F]inder', noremap = true })

-- Neovim config editing
vim.keymap.set('n', '<leader>enc', ":wincmd v <bar>:e ~/.config/nvim/init.lua<bar>:wincmd =<CR>",
    { desc = '[E]dit [N]eovim [C]onfig', noremap = true })

-- Yank word 
vim.keymap.set('n', '<leader>yw', 'viw"0p', { desc = '[Y]ank [W]ord', noremap = true })
-- Paste word
vim.keymap.set('n', '<leader>pw', 'viw"0P', { desc = '[P]aste [W]ord', noremap = true })
-- Yank line
vim.keymap.set('n', '<leader>Y', 'V"0y', { desc = '[Y]ank [L]ine', noremap = true })

-- Window Operations
-- navigate to left window
vim.keymap.set('n', '<leader>h', '<C-w>h', { desc = 'Navigate to left window', noremap = true })
-- navigate to right window
vim.keymap.set('n', '<leader>l', '<C-w>l', { desc = 'Navigate to right window', noremap = true })
-- navigate to up window
vim.keymap.set('n', '<leader>k', '<C-w>k', { desc = 'Navigate to up window', noremap = true })
-- navigate to down window
vim.keymap.set('n', '<leader>j', '<C-w>j', { desc = 'Navigate to down window', noremap = true })