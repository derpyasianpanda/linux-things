-- Paq Package Manager Setup
vim.cmd("packadd paq-nvim")
local paq = require("paq-nvim").paq
paq{"savq/paq-nvim", opt = true}

-- General UI Plugins
paq{"kyazdani42/nvim-web-devicons"}
paq{"lukas-reineke/indent-blankline.nvim", branch = "lua"}

-- General Language Plugins
paq{"neoclide/coc.nvim"}
paq{"folke/lsp-colors.nvim"}

-- General Utility Plugins
paq{"tpope/vim-repeat"}
paq{"tpope/vim-surround"}
paq{"nvim-lua/popup.nvim"}
paq{"bkad/CamelCaseMotion"}
paq{"nvim-lua/plenary.nvim"}
paq{"dstein64/vim-startuptime"}
paq{"kyazdani42/nvim-tree.lua"}
paq{"nvim-telescope/telescope.nvim"}

-- Colorscheme Setup
paq{"arcticicestudio/nord-vim"}
vim.cmd("colorscheme nord")
-- Colorbuddy retired until startup times fixed
--[[ paq{"maaslalani/nordbuddy"}
paq{"tjdevries/colorbuddy.nvim"}
vim.g.nord_spell = "underline"
vim.g.nord_italic = false -- Disable italics because it's weird in Windows Terminal ☹
require("colorbuddy").colorscheme("nordbuddy") ]]

-- Status Line
paq{"vim-airline/vim-airline-themes"}
paq{"vim-airline/vim-airline"}
vim.g.airline_theme = "deus"

-- Git Signs on the side
paq{"lewis6991/gitsigns.nvim"}
require("gitsigns").setup()

-- Kommentary (Commenting)
paq{"b3nj5m1n/kommentary"}
require("kommentary.config").setup()

-- Color highlighter
paq{"norcalli/nvim-colorizer.lua"}
require("colorizer").setup()

-- Smooth Scrolling for Window Movement
paq{"karb94/neoscroll.nvim"}
require("neoscroll").setup()

-- Bufferline (File tabs)
paq{"akinsho/nvim-bufferline.lua"}
require("bufferline").setup()

-- TODO Comments Plugin
paq{"folke/todo-comments.nvim"}
require("todo-comments").setup {
    pattern = "(KEYWORDS):"
}

-- Trouble (Diagnostics) Setup
paq{"folke/trouble.nvim"}
require("trouble").setup()

-- Better Language Parsing with Tree Sitter
paq{"p00f/nvim-ts-rainbow"}
paq{ "nvim-treesitter/nvim-treesitter"
   , run = function() vim.cmd(":TSUpdate") end }
require("nvim-treesitter.configs").setup {
    ensure_installed = "all",
    highlight = { enable = true },
    indent = { enable = true },
    rainbow = {
        enable = true,
        extended_mode = true,
        colors = { "Cyan1", "PaleGreen1", "Magenta1", "Gold1" },
        termcolors = { 51, 121, 201, 220 }
    }
}

--  Configuration for colorful matching brackets
--  This plugin doesn't work with Lua or Rust so I'm using two
--  Rainbow Plugins XD
paq{"luochen1990/rainbow"}
vim.g.rainbow_active = 1
vim.g.rainbow_conf = {
	guifgs = {"Cyan1", "PaleGreen1", "Magenta1", "Gold1"},
	ctermfgs = { 51, 121, 201, 220 }
}

-- Vim Wiki Setup
paq{"vimwiki/vimwiki"}
vim.g.vimwiki_list = {{
    path = "D:/documents/obsidian/",
    syntax = "markdown",
    ext = ".md"
}}

-- Neovim tree (File explorer)
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_special_files = { "README.md", "Makefile", "MAKEFILE" }

-- Haskell Vim
paq{"neovimhaskell/haskell-vim"}
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords

-- Which Key (Hotkey reminders)
paq{"folke/which-key.nvim"}
local wk = require("which-key")
wk.setup()
wk.register({
    tt          = "Trouble Diagnostics",
    ["/"]       = "Fuzzy Find (Telescope)",
    [","]       = "First Char of Line",
    ["."]       = "Last Char of Line",
    f = {
        name    = "Telescope",
        f       = "Find Files",
        t       = "Find TODOs",
        b       = "Find Buffers",
        g       = "Find w/ grep",
        h       = "Find Help (From Vim)",
        m       = "Find Man Page",
        e       = "File Explorer"
    },
    s = {
        name    = "Spelling",
        a       = "Add to Dictionary",
        r       = "Remove from Dictionary",
        u       = "Undo Last Dictionary Action"
    },
    b = {
        name    = "Buffers",
        n       = "Next Buffer",
        p       = "Previous Buffer",
        mn      = "Move Buffer to Next",
        mp      = "Move Buffer to Previous"
    },
    g = {
        name    = "COC",
    },
    c = { name = "Commenting" },
    h = { name = "Git Signs" },
    w = { name = "Vim Wiki" }
}, { prefix = "<Leader>" })
