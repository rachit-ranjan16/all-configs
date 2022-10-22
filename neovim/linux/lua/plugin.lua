return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-vinegar'
  use 'vuciv/vim-bujo'
  use 'jremmen/vim-ripgrep'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use 'ThePrimeagen/harpoon'
  use 'ThePrimeagen/git-worktree.nvim'
  use 'neovim/nvim-lspconfig'
  use 'gruvbox-community/gruvbox'
  use {'folke/tokyonight.nvim', branch='main' }
  use 'shaunsingh/nord.nvim'
  use 'ntpeters/vim-better-whitespace'
  use 'unblevable/quick-scope'
  use 'mbbill/undotree'
  use 'preservim/nerdcommenter'
-- TODO find a version that works or remove this entirely
 -- use {'iamcco/markdown-preview.nvim', run='cd app && yarn install', cmd = 'MarkdownPreview' }
  use 'neomake/neomake'
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }
  use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}
   use {
   'glepnir/galaxyline.nvim', branch = 'main', config = function() require 'statusline' end,
   requires = {'kyazdani42/nvim-web-devicons'}
 }
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)

