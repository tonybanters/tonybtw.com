---
title: "Tmux with Zero Plugins"
author: ["Tony", "btw"]
description: "This is a quick and painless guide on how to configure tmux with zero plugins. Heavily inspired by Henry Misc's via negativa philosophy on removing things to solve problems, rather than adding them."
date: 2025-11-13
draft: false
image: "/img/tmux.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today I'm gonna give you a quick and painless guide on configuring tmux with ZERO plugins.

Tmux is probably the most essential tool in my development workflow. It's a terminal multiplexer that allows you to split your terminal into multiple panes, create multiple windows, and detach/reattach sessions.

In the past, I relied on TPM as a plugin manager, but taking inspiration from Henry Misc, I decided to debloat my entire config into a plugin-less config. This means I don't need to rely on any plugins, and can just use the native Tmux settings.

Let's jump into it.


## What is Tmux? {#what-is-tmux}

Tmux stands for "Terminal Multiplexer". Here's what that means:

-   **Sessions**: A tmux session is like a workspace. You can detach from it, close your terminal, and reattach later - everything is still there.
-   **Windows**: Think of these like browser tabs. Each window is a full terminal view.
-   **Panes**: These are splits within a window. You can have multiple terminals visible at once.

This is crucial if you SSH into servers, work on multiple projects, or just want to keep your terminal organized without using a tiling window manager.


## Installation {#installation}

Alright so I'm on arch linux, btw, but this is going to work on literally any distro. Tmux is in every package manager.

For arch:

```sh
sudo pacman -S tmux
```

For Ubuntu/Debian:

```sh
sudo apt install tmux
```

NixOS... just add \`tmux\` to wherever you install your nixpkgs.

That's it. No plugins, no plugin managers, nothing. Just tmux.


## Key Pivotal Binds {#key-pivotal-binds}


### Prefix Key {#prefix-key}

The most important concept in tmux is the **prefix key**. By default, it's `Ctrl-b`, but we're gonna change it to `Ctrl-a` because it's way easier to reach.

Every tmux command starts with the prefix. So when I say "prefix + c", that means:

1.  Press `Ctrl-a`
2.  Release
3.  Press `c`


### Sessions, Windows &amp; Panes {#sessions-windows-and-panes}

Here's the hierarchy:

-   A **session** contains multiple **windows**
-   A **window** contains multiple **panes**

Think of it like this:

-   Session = Project
-   Window = Task within that project
-   Pane = Terminal view for that task


### Pane Navigation {#pane-navigation}

These are the binds you'll use 1000 times a day:

| Bind               | Action                    |
|--------------------|---------------------------|
| `prefix + \vert`   | Split vertically          |
| `prefix + -`       | Split horizontally        |
| `prefix + h/j/k/l` | Navigate panes (vim-like) |
| `Alt + h/j/k/l`    | Navigate without prefix   |


### Window Management {#window-management}

| Bind         | Action             |
|--------------|--------------------|
| `prefix + c` | Create new window  |
| `prefix + n` | Next window        |
| `prefix + p` | Previous window    |
| `Alt + 1-9`  | Jump to window 1-9 |


### Copy Mode {#copy-mode}

Copy mode lets you scroll through terminal history and copy text:

| Bind         | Action                     |
|--------------|----------------------------|
| `prefix + [` | Enter copy mode            |
| `v`          | Start selection (vim-like) |
| `Ctrl-v`     | Rectangle selection        |
| `y`          | Copy selection             |
| `q`          | Exit copy mode             |


## Configuration {#configuration}

Let's build a clean, readable config with zero plugins.


### Basic Settings {#basic-settings}

Create `~/.config/tmux/tmux.conf`:

```cfg
# Enable 256 color support
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*:RGB"

# Enable mouse support
set -g mouse on

# Enable clipboard
set -g set-clipboard on
```

Let me break these down:

-   `default-terminal "tmux-256color"` tells tmux to advertise itself as a 256-color terminal, which is essential for proper color rendering in modern terminal applications like Neovim.
-   `terminal-overrides ",*:RGB"` enables true color (24-bit RGB) support, giving you access to millions of colors instead of just 256. This is what makes your color schemes look properly vibrant.
-   `mouse on` is controversial in the terminal purist community, but it's genuinely useful for quickly clicking between panes or dragging borders to resize them. You can always disable it later if you go full keyboard-only.
-   `set-clipboard on` allows tmux to integrate with your system clipboard, so when you copy text in tmux copy-mode, it actually goes to your system clipboard.


### Better Keybinds {#better-keybinds}

```cfg
# Change prefix from Ctrl-b to Ctrl-a
unbind C-b
set -g prefix C-a
bind-key C-a send-prefix

# Vim-style pane navigation
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Split windows (opens in same directory)
unbind %
bind | split-window -h -c "#{pane_current_path}"

unbind '"'
bind - split-window -v -c "#{pane_current_path}"

# Reload config
unbind r
bind r source-file $HOME/.config/tmux/tmux.conf

# Alt+hjkl to switch panes without prefix
bind -n M-h select-pane -L
bind -n M-j select-pane -D
bind -n M-k select-pane -U
bind -n M-l select-pane -R

# Alt+number to select window
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5
bind -n M-6 select-window -t 6
bind -n M-7 select-window -t 7
bind -n M-8 select-window -t 8
bind -n M-9 select-window -t 9
```

Let me explain the key concepts here:

-   `unbind C-b` removes the default Ctrl-b prefix because it's awkward to reach. `set -g prefix C-a` changes it to Ctrl-a, which is way more ergonomic since your pinky is already on Ctrl.
-   `bind-key C-a send-prefix` allows you to send the actual Ctrl-a to the terminal (useful in nested tmux sessions or when an app needs Ctrl-a).
-   The vim-style `hjkl` binds are essential if you're a vim user - they let you navigate panes with prefix+h/j/k/l instead of the default arrow keys.
-   `split-window -h -c "#{pane_current_path}"` is crucial - the `-c` flag makes new panes open in the same directory as your current pane. Without this, splits would open in your home directory, which is super annoying.
-   `unbind %` and `unbind '"'` remove the default split bindings so we can use `|` and `-` instead, which are way more intuitive (vertical bar for vertical split, dash for horizontal split).
-   `bind -n` means "bind without prefix". So `bind -n M-h` lets you use Alt+h to switch panes instantly, without hitting prefix first. This is a MASSIVE quality of life improvement once you get used to it.
-   The Alt+number binds (M-1 through M-9) let you jump directly to windows without prefix, similar to how browser tabs work with Ctrl+1-9.


### Theme Colors {#theme-colors}

Now here's where we make it look good. I'm using Tokyo Night Moon colors, but you can swap these out for any color scheme.

```cfg
# Tokyo Night Moon theme colors
thm_bg="#222436"
thm_fg="#c8d3f5"
thm_cyan="#86e1fc"
thm_black="#1b1d2b"
thm_gray="#3a3f5a"
thm_magenta="#c099ff"
thm_pink="#ff757f"
thm_red="#ff757f"
thm_green="#c3e88d"
thm_yellow="#ffc777"
thm_blue="#82aaff"
thm_orange="#ff9e64"
thm_black4="#444a73"

# Status bar settings
set -g status "on"
set -g status-bg "${thm_bg}"
set -g status-justify "left"
set -g status-left-length "100"
set -g status-right-length "100"

# Messages
set -g message-style "fg=${thm_cyan},bg=${thm_gray},align=centre"
set -g message-command-style "fg=${thm_cyan},bg=${thm_gray},align=centre"

# Panes
set -g pane-border-style "fg=${thm_gray}"
set -g pane-active-border-style "fg=${thm_blue}"

# Windows
set -g window-status-activity-style "fg=${thm_fg},bg=${thm_bg},none"
set -g window-status-separator ""
set -g window-status-style "fg=${thm_fg},bg=${thm_bg},none"
```


### Status Bar Customization {#status-bar-customization}

This is where it gets interesting. The status bar shows your current windows and session info.

```cfg
# Statusline - current window
set -g window-status-current-format "#[fg=${thm_blue},bg=${thm_bg}] #I: #[fg=${thm_magenta},bg=${thm_bg}](✓) #[fg=${thm_cyan},bg=${thm_bg}]#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev) #[fg=${thm_magenta},bg=${thm_bg}]"

# Statusline - other windows
set -g window-status-format "#[fg=${thm_blue},bg=${thm_bg}] #I: #[fg=${thm_fg},bg=${thm_bg}]#W"

# Statusline - right side
set -g status-right "#[fg=${thm_blue},bg=${thm_bg},nobold,nounderscore,noitalics]#[fg=${thm_bg},bg=${thm_blue},nobold,nounderscore,noitalics] #[fg=${thm_fg},bg=${thm_gray}] #W #{?client_prefix,#[fg=${thm_magenta}],#[fg=${thm_cyan}]}#[bg=${thm_gray}]#{?client_prefix,#[bg=${thm_magenta}],#[bg=${thm_cyan}]}#[fg=${thm_bg}] #[fg=${thm_fg},bg=${thm_gray}] #S "

# Statusline - left side (empty)
set -g status-left ""

# Modes
set -g clock-mode-colour "${thm_blue}"
set -g mode-style "fg=${thm_blue} bg=${thm_black4} bold"
```

This is where things get interesting. Let me break down what's happening:

-   `window-status-current-format` defines how the active window looks in the status bar. It shows the window index (`#I`), a checkmark, and the last two parts of the current path.
-   The `#(echo '#{pane_current_path}' | rev | cut -d'/' -f-2 | rev)` command runs a shell command every time the status bar updates. It reverses the path, takes the last 2 parts, then reverses again. So `/home/tony/projects/dotfiles` becomes `projects/dotfiles`.
-   `window-status-format` is for inactive windows - just shows the index and window name.
-   `status-right` shows the window name (`#W`), a visual indicator that changes from cyan to magenta when prefix is pressed using `#{?client_prefix,...}` conditional, and the session name (`#S`).
-   `#I` is the window index (number), `#W` is the window name, `#S` is the session name - these are tmux's format variables.

The `#{?client_prefix,...}` syntax is tmux's conditional - it means "if prefix is pressed, use magenta, otherwise use cyan". This gives you a visual indicator when you're in prefix mode.


## Extra Binds &amp; Tweaks {#extra-binds-and-tweaks}

Here are some nice-to-haves that should be placed earlier in the config (after the basic settings):

```cfg
# Change from 0 based to 1 based because keyboard layout
set -g base-index 1
set -g pane-base-index 1
set-window-option -g pane-base-index 1
set-option -g renumber-windows on

# Vim-like copy/paste
set-window-option -g mode-keys vi
bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
unbind -T copy-mode-vi MouseDragEnd1Pane
```

Here's what these do:

-   `base-index 1` makes windows start counting from 1 instead of 0. This is way more ergonomic because window 1 is on the left of your keyboard (the 1 key), not the right (0 is to the right of 9). It's a small thing but it makes a huge difference.
-   `pane-base-index 1` does the same for panes.
-   `renumber-windows on` automatically renumbers your windows when you close one. So if you have windows 1, 2, 3, 4 and you close window 2, the remaining windows become 1, 2, 3. Without this, you'd have gaps like 1, 3, 4.
-   `mode-keys vi` enables vim keybindings in copy mode. This is essential if you're a vim user - it means you can use j/k to navigate, v to start visual selection, etc.
-   The `copy-mode-vi` bindings make `v` start a selection (like visual mode in vim) and `y` yank (copy) the selection.
-   `C-v` lets you do rectangle selection (block visual mode in vim).
-   `unbind -T copy-mode-vi MouseDragEnd1Pane` prevents mouse selection from automatically exiting copy mode, so you can still use `y` to copy after selecting with the mouse.
-   You enter copy mode with `prefix + [`, navigate with vim keys, `v` to select, `y` to copy.


## Final Thoughts {#final-thoughts}

You're now ready to use Neovim as a modern, fast, and extensible code editor.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
