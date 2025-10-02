---
title: "How to Customize Vim in 2026"
author: ["Tony", "btw"]
description: "This is a quick and painless tutorial on how to get vanilla vim up and running."
date: 2025-10-01
draft: false
image: "/img/vim.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today, I'm going to give you a quick and painless guide on Vim.

Vim is a blazingly fast text editor that leverages different modes in order to facilitate a keyboard centric efficient experience.

I use neovim on my main machine, but I find myself on servers a lot, or inside of install iso images, where I only have access to vi, or vim if I'm lucky. That's why I always keep my vanilla vim config up to date.


## Install Dependencies for Vim {#install-dependencies-for-vim}

To get things started, we're gonna need some dependencies. I have a written article to accompany this tutorial in a link below the subscribe button that will show you how to install these on your favorite operating system, but for today's guide, we're going to be using Arch, btw, so heres what we need:

```nil
yay -S git vim ripgrep fd fzf rust-analzyer
```

-   git
-   vim
-   ripgrep
-   fd
-   fzf
-   rust_analyzer


### Arch Linux {#arch-linux}

```nil
sudo pacman -S git vim ripgrep fd fzf rust-analyzer
```


### NixOS {#nixos}

```nix
# vim.nix
{ config, pkgs, lib, ...}

{
  # Install Vim and dependencies
  home.packages = with pkgs; [
    # Tools required for Telescope
    ripgrep
    fd
    fzf
    # Language Servers
    rust-analzyer
  ];

  programs.git.enable = true;
  programs.vim.enable = true;

}
```


### Gentoo {#gentoo}

```sh
sudo emerge -q \
  app-shells/fzf \
  sys-apps/ripgrep \
  sys-apps/fd \
  dev-util/rust-analyzer \
  app-editors/vim
```


## Create config file {#create-config-file}

ls .vim
mkdir .vim
vim .vimrc

```vim
echom "hello world"
```

We can use \`:so\` to source this file immediately
and we see, 'hello world' in the console.

lets add a print statement to vimrc inside of our .vim folder, so its easier to modularize.

cd .vim
vim vimrc

```vimrc
echom "subsrcibe to my channel"
```

now in our ~/.vimrc, lets source this file

```vimrc
echom "hello world"
source ~/.vim/vimrc
```

Now vim will always load the ~/.vim/vimrc file when launched. we can test by running \`vim\`

## Bare minimum (what i use on servers) {#bare-minimum--what-i-use-on-servers}

this is my 8 line copy paste that i use on servers, or take with me in isos

```vim
filetype plugin indent on
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set number
set relativenumber
set smartindent
set showmatch
set backspace=indent,eol,start
syntax on
```

This will get you by for like 90% of your needs, unless you are into lsps and programming. If you literally just tinker with config files, this is enough.

Let's go further though.

## Modularize options {#modularize-options}

Let's move these options over to an options file, and lets also add a keybinds file.
So, lets actually just yank this entire file, since its all options, and then lets press y to yank all of it. Now we can do :e options.vim, to create and open options.vim and just paste this here. we can save this new file with :w, and now if we hit control-o to get back to our vimrc, we can delete all of this by pressing shift v, shift g to highlight everything in visual mode, and press c to delete and enter insert mode, and lets just replace it with source options.vim. Now we can modularize everything and source it right in our vimrc.

```vim
source ~/.vim/options.vim
```

## Keybinds! {#keybinds}

for keybinds, lets create a keybinds.vim file. let's just presource it here, since we know its coming.

```vim
source ~/.vim/options.vim
source ~/.vim/keybinds.vim
```

:e keybinds.vim

Lets start by adding a leader key, its going to be the key that we press before hitting a keycombo in order to bind stuff.

```vim
" Set leader key
let mapleader = " "

" Open netrw with <leader>cd
nnoremap <leader>cd :Ex<CR>
```

Let's source this file with :so, and now we can test this bind here by pressing space cd (for change directory), and BOOM we're right in our netrw.

We'll certainly add more keybinds later. Let's move onto plugins.

## Plugins {#plugins}

There is a plugin manager called 'plug', but I just wrote my own 6 line function to handle plugins. its a glorified wrapper for \`git clone\`. You guys can just paste it in here, I'll share it in a link below the subscribe button.

```vimscript
let s:plugin_dir = expand('~/.vim/plugged')

function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name

  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif

  execute 'set runtimepath+=' . fnameescape(path)
endfunction
```

We need to add this file to our vimrc like so:

```vimrc
source ~/.vim/options.vim
source ~/.vim/keybinds.vim
source ~/.vim/plugins.vim
```

And to use this plugin script, all we need to do as add a plugin to the bottom like so:

### Colors.vim {#colors-dot-vim}

First lets head over to this [github link](https://github.com/ghifarit53/tokyonight-vim) and take a look at this plugin. We have a simple colorscheme plugin here for the tokyonight flavor, we can yank this url here, and throw it in the bottom of our plugin.vim:

```vim
call s:ensure('ghifarit53/tokyonight-vim')
```

And lets source this file, and we see that tokyonight starts to download. Now that its downloaded, we can see it worked by typing :colorscheme tokyonight.

But lets add a custom colors.vim file to handle some options related to this plugin.

:e colors.vim (or space cd, and %colors.vim)

### Fzf file searching {#fzf-file-searching}

One of the best plugins for neovim besides treesitter is Telescope, but we can achieve the same thing in vanilla vim here with f (zed) f .vim

```nil
call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')
```

Source this file now to install these with :so

And let's create fzf.vim to setup some options and binds for it:
:e fzf.vim

```nil
" FZF keymaps (requires Plug 'junegunn/fzf.vim')

" Files
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fo :History<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fq :CList<CR>    " For quickfix list
nnoremap <leader>fh :Helptags<CR>

" Grep current string
nnoremap <leader>fs :Rg <C-r><C-w><CR>

" Grep input string (fzf prompt)
nnoremap <leader>fg :Rg<Space>

" Grep for current file name (without extension)
nnoremap <leader>fc :execute 'Rg ' . expand('%:t:r')<CR>

" Find files in your Vim config
nnoremap <leader>fi :Files ~/.vim<CR>
```

So now we can type space ff and we see our files. let's clean this up though, this is way too many files by default
First lets change fzf to point to fd instead of find. This has to be done in our .bashrc, or .zshrc if you're into that

```bash
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow'
```

Now we can create a file that tells fd what to ignore called \`.fdignore\` like so:

vim ~/.fdignore

And lets add these 3 folders to it:

```nil
undodir/
plugged/
.git
```

Now lets source bash, and check it out, we only see our files in .vim that we want to see. We can do the same with rg... .rgignore

Let's test rg by typing space fg and searching for vim. nice, we see 19 entries here.

So this is pretty much my fzf.vim config


### Lightline {#lightline}

Let's get a powerline here:

```nil
call s:ensure('itchyny/lightline.vim')
```

And lets import our lightline config like so:

:e lightline.vim

```nil
set laststatus=2
let g:lightline = {
      \ 'colorscheme' : 'tokyonight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \   'filename': 'LightlineFilename'
      \ }
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
endfunction
```

Now we just need to add lightline to our vimrc, and we're good to go.

```nil
source ~/.vim/lightline.vim
```


### LSP {#lsp-dot-dot-dot}

Alright so this is the hard part. an lsp that works on vim!
I've tried to make this as simple as possible so let's roll with it. First lets download this plugin:

```nil
call s:ensure('yegappan/lsp')
```

Lets create our lsp.vim file, and just paste this in there (my lsp config)

```nil
" Enable diagnostics highlighting
let lspOpts = #{autoHighlightDiags: v:true}
autocmd User LspSetup call LspOptionsSet(lspOpts)
let lspServers = [
      \ #{
      \   name: 'rust-analyzer',
      \   filetype: ['rust'],
      \   path: 'rust-analyzer',
      \   args: []
      \ }
      \ ]

autocmd User LspSetup call LspAddServer(lspServers)

" Key mappings
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
inoremap <silent> <C-Space> <C-x><C-o>

" Set omnifunc for completion
autocmd FileType rust setlocal omnifunc=lsp#complete

" Custom diagnostic sign characters
autocmd User LspSetup call LspOptionsSet(#{
    \   diagSignErrorText: '✘',
    \   diagSignWarningText: '▲',
    \   diagSignInfoText: '»',
    \   diagSignHintText: '⚑',
    \ })

```

You have to install rust_analyzer, I already have it installed, but on arch, we can do it like so:

```nil
npm install -g rust-analzyer
```

And we see we have rust analyzer here, so lets open a rust project and test if its working.

vim ~/repos/oxwm/src/main.rs
and we can test hover with shift k, and if we add bad code here we should see an error.
Bad Code
And go to definition works!

## Final Thoughts {#final-thoughts}

Vim is really all you need for editing text, and its minimality is what makes it great. I hope you found this guide helpful.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
