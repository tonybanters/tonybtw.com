---
title: "Helix on linux - best nix ide?"
author: "Tey"
date: 2025-09-17
description: "Helix"
tags: ["linux", "nixos", "code editor"]
---

---
## Helix guide - best code editor for nix?
This guide will show how to set up Helix on linux
---

---
## What is helix?
Helix is post modern text editor but im using to configure my nixos config
---

---
## Why should you use helix for nix?
**Saves time for long nixos configs** - no need to search packages 
**Config** - Helix is pretty easy to config i will show it on the bottom
---

---
## how to setup helix?
###Step 1: Intall it here are commands for most popular distribuitions: ["Sudo pacman -S helix", "Sudo apt install helix", "On nixos just add helix to your configuration.nix", "sudo dnf install helix", "sudo emerge --ask app-editors/helix"]
---

---
### Step 2: Navigate to .config then type mkdir -p helix 
---

---
### Step 3: type cd helix and then run command touch config.toml dont worry about C-g its git support if you want you can change your theme
## here is my config.toml:
theme = "tokyonight"
[keys.normal]
C-g = [":new", ":insert-output lazygit", ":buffer-close!", ":redraw"]
[editor]
mouse = false
line-number = "relative"
bufferline = "multiple"
---

---
### Step 4: run this command touch languages.toml here is example:
[[language]]
name = "rust"
auto-format = false

[language-server.rust-analyzer]
command = "rust-analyzer"

[language-server.rust-analyzer.config]
inlayHints.bindingModeHints.enable = false
inlayHints.closingBraceHints.minLines = 10
inlayHints.closureReturnTypeHints.enable = "with_block"
inlayHints.discriminantHints.enable = "fieldless"
inlayHints.lifetimeElisionHints.enable = "skip_trivial"
inlayHints.typeHints.hideClosureInitialization = false

[[language]]
name = "c"
auto-format = true

[language-server.clangd]
command = "clangd"
args = ["--background-index", "--clang-tidy"]

[[language]]
name = "nix"
auto-format = true

[language-server.nil]
command = "nil"
args = []

---

---
### Step 5: run this command hx 
---

---
You are done but if you want you can customize it everything was just example its very simmilar to nvim but one moment that can make you angry that x is not deleting one char its selecting line if you want to delete one char you can press d
---

