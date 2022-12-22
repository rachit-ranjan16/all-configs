local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-vinegar'
  use 'vuciv/vim-bujo'
  use 'jremmen/vim-ripgrep'
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
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
  use 'neomake/neomake'
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }
  use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}
--   use {
--   'glepnir/galaxyline.nvim', branch = 'main', config = function() require 'statusline' end,
--   requires = {'kyazdani42/nvim-web-devicons'}
-- }
  use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}
--  use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}
  if packer_bootstrap then
    require('packer').sync()
  end
end)

