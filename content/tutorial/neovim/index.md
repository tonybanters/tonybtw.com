+++
title = "Neovim on Linux — Complete IDE Tutorial"
author = ["Tony", "btw"]
description = "A quick and painless guide on installing and configuring Neovim, and how to use it as your full daily driver IDE, btw."
date = 2025-05-10
draft = false
image = "/img/neovim.png"
showTableOfContents = true
+++

## Intro {#intro}

A clean and painless guide to turning Neovim into a modern IDE.

Neovim is a Vim-based text editor built for extensibility and usability. In this tutorial, you’ll learn how to set it up with plugins, keybinds, and full LSP support. This guide assumes you're using a Unix-like system and are comfortable with basic terminal commands.


## Install Neovim and dependencies {#install-neovim-and-dependencies}

Use your system’s package manager to install Neovim, along with a few tools that will be required later (like npm and ripgrep).

```sh
# Gentoo
sudo emerge app-editors/neovim
sudo emerge net-libs/nodejs
sudo emerge sys-apps/ripgrep

# Arch
sudo pacman -S neovim nodejs npm ripgrep
```


## Set up your Neovim config directory {#set-up-your-neovim-config-directory}

Create your config folder and add the main config file.

```sh
mkdir -p ~/.config/nvim
cd ~/.config/nvim
nvim .
```

In Neovim, press `%` to create a new file named `init.lua`:

```lua
print("I use Neovim by the way")
```

Save and quit with `:wq`, then reopen Neovim.


## Create a Lua module for options {#create-a-lua-module-for-options}

```sh
mkdir -p ~/.config/nvim/lua/config
nvim lua/config/options.lua
```

```lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.shiftwidth = 4
```

Then in `init.lua`:

```lua
require("config.options")
```


## Add keybindings {#add-keybindings}

```lua
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
```

In `init.lua`:

```lua
require("config.keybinds")
```


## Install Lazy.nvim {#install-lazy-dot-nvim}

Clone it into your runtime path.

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({})
```

Then:

```lua
require("config.lazy")
```


## Add a theme plugin {#add-a-theme-plugin}

```lua
return {
  "folke/tokyonight.nvim",
  config = function()
    vim.cmd.colorscheme("tokyonight")
  end,
}
```


## Add Telescope for fuzzy finding {#add-telescope-for-fuzzy-finding}

```lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
    vim.keymap.set("n", "<leader>fh", builtin.help_tags)
  end,
}
```


## Add Treesitter for syntax highlighting {#add-treesitter-for-syntax-highlighting}

```lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = { "lua" },
      auto_install = false,
    })
  end,
}
```


## Add Harpoon for file bookmarking {#add-harpoon-for-file-bookmarking}

```lua
return {
  "ThePrimeagen/harpoon",
  config = function()
    local harpoon = require("harpoon")
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  end,
}
```


## Add LSP, autocompletion, and snippets {#add-lsp-autocompletion-and-snippets}

```lua
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({ ensure_installed = { "lua_ls" } })

    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})

    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      }),
      sources = { { name = "nvim_lsp" }, { name = "luasnip" } },
    })
  end,
}
```


## One-liner utility plugins {#one-liner-utility-plugins}

```lua
return {
  { "tpope/vim-fugitive" },
  { "ojroques/nvim-osc52" },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
}
```


## Final `init.lua` Example {#final-init-dot-lua-example}

```lua
require("config.options")
require("config.keybinds")
require("config.lazy")
```

```sh
/home/tony/.config/nvim
├── init.lua
├── lazy-lock.json
├── lua
│   ├── config
│   │   ├── keybinds.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   └── plugins
│       ├── colors.lua
│       ├── harpoon.lua
│       ├── init.lua
│       ├── lsp.lua
│       ├── lualine.lua
│       ├── one-liners.lua
│       ├── orgmode.lua
│       ├── telescope.lua
│       └── treesitter.lua
├── plugin
│   └── flterm.lua
└── README.md

5 directories, 16 files

```


## My keybinds {#my-keybinds}

If you want to just copy my nvim config, my keybind documentation is here:


### General {#general}

| Mode | Key                          | Action                                       |
|------|------------------------------|----------------------------------------------|
| n    | &lt;leader&gt;cd             | Open Ex mode (\`:Ex\`)                       |
| n    | J                            | Join lines while keeping the cursor in place |
| n    | &lt;C-d&gt;                  | Scroll half-page down and center cursor      |
| n    | &lt;C-u&gt;                  | Scroll half-page up and center cursor        |
| n    | n                            | Next search result (centered)                |
| n    | N                            | Prev search result (centered)                |
| n    | Q                            | Disable Ex mode                              |
| n    | &lt;C-k&gt;                  | Next quickfix entry (centered)               |
| n    | &lt;C-j&gt;                  | Prev quickfix entry (centered)               |
| n    | &lt;leader&gt;k              | Next location list entry (centered)          |
| n    | &lt;leader&gt;j              | Prev location list entry (centered)          |
| i    | &lt;C-c&gt;                  | Exit insert mode                             |
| n    | &lt;leader&gt;x              | Make current file executable                 |
| n    | &lt;leader&gt;u              | Toggle Undotree                              |
| n    | &lt;leader&gt;rl             | Reload config                                |
| n    | &lt;leader&gt;&lt;leader&gt; | Source current file                          |


### Visual Mode {#visual-mode}

| Mode | Key             | Action                              |
|------|-----------------|-------------------------------------|
| v    | J               | Move block down                     |
| v    | K               | Move block up                       |
| x    | &lt;leader&gt;p | Paste without overwriting clipboard |
| v    | &lt;leader&gt;y | Yank to system clipboard            |


### Linting &amp; Formatting {#linting-and-formatting}

| Mode | Key              | Action           |
|------|------------------|------------------|
| n    | &lt;leader&gt;cc | Run php-cs-fixer |
| n    | &lt;F3&gt;       | Format (LSP)     |


### Telescope {#telescope}

| Mode | Key              | Action                               |
|------|------------------|--------------------------------------|
| n    | &lt;leader&gt;ff | Find files                           |
| n    | &lt;leader&gt;fg | Git-tracked files                    |
| n    | &lt;leader&gt;fo | Recent files                         |
| n    | &lt;leader&gt;fq | Quickfix list                        |
| n    | &lt;leader&gt;fh | Help tags                            |
| n    | &lt;leader&gt;fb | Buffers                              |
| n    | &lt;leader&gt;fs | Grep string under cursor             |
| n    | &lt;leader&gt;fc | Grep current filename (no extension) |
| n    | &lt;leader&gt;fi | Search in ~/.config/nvim             |


### Harpoon {#harpoon}

| Mode | Key              | Action                    |
|------|------------------|---------------------------|
| n    | &lt;leader&gt;a  | Add to Harpoon            |
| n    | &lt;C-e&gt;      | Toggle Harpoon quick menu |
| n    | &lt;leader&gt;fl | Telescope Harpoon marks   |
| n    | &lt;C-p&gt;      | Prev Harpoon mark         |
| n    | &lt;C-n&gt;      | Next Harpoon mark         |


### LSP {#lsp}

| Mode | Key        | Action                 |
|------|------------|------------------------|
| n    | K          | Hover docs             |
| n    | gd         | Go to definition       |
| n    | gD         | Go to declaration      |
| n    | gi         | Go to implementation   |
| n    | go         | Go to type definition  |
| n    | gr         | List references        |
| n    | gs         | Signature help         |
| n    | gl         | Show diagnostics float |
| n    | &lt;F2&gt; | Rename symbol          |
| n,x  | &lt;F3&gt; | Format code            |
| n    | &lt;F4&gt; | Code actions           |


### Misc {#misc}

| Mode | Key              | Action                       |
|------|------------------|------------------------------|
| n    | &lt;leader&gt;dg | Run DogeGenerate             |
| n    | &lt;leader&gt;s  | Replace word on current line |


## Final Thoughts {#final-thoughts}

You're now ready to use Neovim as a modern, fast, and extensible code editor.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
