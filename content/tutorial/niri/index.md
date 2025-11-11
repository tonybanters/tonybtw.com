---
title: "Niri, btw"
author: ["Tony", "btw"]
description: "This is a quick and painless tutorial on how to setup Niri on Arch/NixOS/Gentoo. It is a wonderful wayland compositor masquerading as a window manager."
draft: false
date: 2025-11-05
image: "/img/niri.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today I'm gonna give you a quick and painless guide on installing and configuring Niri.

Niri is a "scrollable-tiling" wayland compositor that masquerades as a window manager. Here are some of the unique features of niri:

-   Infinite horizontal Scroll
-   Dynamic workspaces like in GNOME
-   An Overview that zooms out workspaces and windows
-   Built-in screenshot UI
-   Per Monitor Workspaces (Shoutout to The Linux Cast because I know he loves that so much, and he loves xwayland-sattelite.)
-   and much more.

A quote from the famous philosopher, Argocrates:

> "Niri is the anti-window manager. I can just constantly spawn new windows, without having to worry about my window manager trying to "manage" my windows layout against a set output size. The only downside is that sometimes I forget I have 300 terminals opened all the way to the right."

Let's jump into the installation.


## Install Dependencies for Niri {#install-dependencies-for-niri}

Alright so I'm on arch linux, btw, but this is going to work on NixOS, Gentoo, LFS, etc. I'll leave install instructions for all 3 of those distributions in this written guide in a link below the subscribe button.

For arch, here are the dependencies we need to install:

[Github Repo](https://github.com/YaLTeR/niri)


#### Arch Linux {#arch-linux}

```sh
yay -S niri noctalia-shell
```


#### NixOS {#nixos}

For NixOS, you can add niri to your system configuration. Here's how to enable it:

```nix
# In your configuration.nix or flake.nix
{
  programs.niri.enable = true;

  # Or add to your packages
  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite
  ];
}
```

For noctalia-shell on NixOS, you'll need to add it as a flake input (see the noctalia-shell section below for details).


#### Gentoo {#gentoo}

For Gentoo, niri can be installed from GURU overlay:

```sh
# Add the GURU overlay
sudo eselect repository enable guru
sudo emerge --sync guru

# Install niri
sudo emerge gui-wm/niri
```

We're going to use Noctalia Shell today as a bar, because I've used waybar for all of my previous wayland videos, I wanted to shake things up a bit. I'll do more of a deep dive on Quickshell in a separate video, but for today we're going to focus on Niri and how to customize and utilize it.


### Requirements for Niri {#requirements-for-niri}

-   glibc
-   wayland
-   wayland-protocols
-   libinput
-   libdrm
-   libxkbcommon
-   pixman
-   git
-   meson
-   ninja
-   libdisplay-info
-   libliftoff
-   hwdata
-   seatd
-   pcre2


### Extra stuff for my setup today: {#extra-stuff-for-my-setup-today}

-   alacritty (terminal emulator)
-   fuzzel (a dmenu clone for wayland)
-   swaybg (for wallpapers)
-   firefox (web browser)
-   ttf-jetbrains-mono-nerd (font)
-   xwayland-sattelite

So let's install these with pacman -Sy

```sh
sudo pacman -Sy alacritty fuzzel swaybg firefox ttf-jetbrains-mono-nerd xwayland-sattelite
```

Alright, lets jump into niri by typing 'Niri'


## Load Niri {#load-niri}

We're in niri now by and as you can see, this awesome help tool reminds you of the default kebinds. You can open this at any time with super shift slash.

So lets hit Super + T to open alacritty, by defualt.

Open up .config/niri/config.kdl, and lets change a few keybinds, and options.

First, lets add this option to the top of the file:

```kdl
prefer-no-csd
```

This flag will make niri ask the applications to omit their client-side decorations, so we won't see this header on alacritty.

As always, let's fix the repeat rate and repeat delay, heres how to do it in niri:

```kdl
input {
    keyboard {
        repeat-delay 200
        repeat-rate 35
    }
}
```

For touchpad settings, this is up to you, I prefer 'natural-scroll' off, but I'll leave all these options commented out in my config so you guys can adjust them as needed for your preferences.

And let's uncomment this so our focus follows our mouse:

```kdl
focus-follows-mouse max-scroll-amount="0%"
```

Let's add some keybinds here:

```kdl
    Mod+Return hotkey-overlay-title="Open a Terminal: alacritty" { spawn "alacritty"; }
    Mod+D hotkey-overlay-title="Run an Application: fuzzel" { spawn "fuzzel"; }

    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }
    Mod+Shift+6 { move-column-to-workspace 6; }
    Mod+Shift+7 { move-column-to-workspace 7; }
    Mod+Shift+8 { move-column-to-workspace 8; }
    Mod+Shift+9 { move-column-to-workspace 9; }
```

And lets change control to shift here as well for moving things to separate workspaces.

Now for the layout section, let's customize the gaps and focus ring:

```kdl
layout {
    gaps 5

    focus-ring {
        width 1.5
        active-color "#7fc8ff"
        inactive-color "#505050"
    }

    border {
        off
    }
}
```

I also like to add some rounded corners to my windows with window rules:

```kdl
window-rule {
    geometry-corner-radius 4
    clip-to-geometry true
}
```

This is about 90% complete, and thats because the defaults for niri are already really good imo. If you have multiple monitors, you need to edit the monitors block, and you can get information about your monitors with \`niri msg outputs\`

The file reloads automatically so we can test opening another terminal here, and boom there we go.

Alright this is nice, but we can do better. I personally could get by just like this, but lets add that noctalia shell.


## Noctalia Shell + Autostart {#noctalia-shell-plus-autostart}

So for noctalia shell, we've already installed it with yay if you're on Arch. Here are the instructions for all distributions:


#### Arch Linux {#arch-linux}

```sh
yay -S noctalia-shell
```


#### NixOS {#nixos}

For NixOS, noctalia-shell needs to be added as a flake input. Add this to your flake.nix:

```nix
{
  description = "NixOS configuration with Noctalia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";  # Use same quickshell version
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      modules = [
        # ... other modules
        ./noctalia.nix
      ];
    };
  };
}
```

And in your configuration.nix:

```nix 
{ pkgs, inputs, ... }:
{
  # install package
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${system}.default
    # ... maybe other stuff
  ];
}
```


#### Gentoo {#gentoo}

For Gentoo, noctalia-shell can be compiled from source:

```sh
# Install quickshell first (dependency)
git clone https://github.com/outfoxxed/quickshell
cd quickshell
# Follow the build instructions in their README

# Then install noctalia-shell
git clone https://github.com/noctalia-dev/noctalia-shell
# Copy the config to ~/.config/quickshell/noctalia
```

Lets test to see if we have access to noctalia shell by typing:

\`noctalia-shell\`
\`qs -c ~/.config/quickshell/noctalia\`

So lets add this to our spawn-at-startup!

```kdl
spawn-at-startup "noctalia-shell"
```

Noctalia-shell is highly customizable. Here are some of my settings that you can adjust in \`~/.config/quickshell/noctalia/settings.json\`:

```json
{
    "bar": {
        "position": "top",
        "widgets": {
            "left": [
                { "id": "SystemMonitor", "showCpuTemp": true, "showCpuUsage": true, "showMemoryUsage": true },
                { "id": "ActiveWindow", "showIcon": true, "maxWidth": 145 },
                { "id": "MediaMini", "maxWidth": 145 }
            ],
            "center": [
                { "id": "Workspace", "labelMode": "name", "hideUnoccupied": false }
            ],
            "right": [
                { "id": "ScreenRecorder" },
                { "id": "Tray" },
                { "id": "Battery" },
                { "id": "Volume" },
                { "id": "Clock", "formatHorizontal": "HH:mm ddd, MMM dd" },
                { "id": "ControlCenter" }
            ]
        }
    },
    "colorSchemes": {
        "darkMode": true,
        "predefinedScheme": "Tokyo Night"
    },
    "ui": {
        "fontDefault": "JetBrainsMono Nerd Font Propo"
    }
}
```

The color scheme is in \`~/.config/quickshell/noctalia/colors.json\`, and I'm using a Tokyo Night theme.


## Wallpaper {#wallpaper}

Actually, if you're using noctalia-shell, wallpaper management is built right in! Noctalia has a wallpaper selector and can automatically rotate through your wallpapers.

In your \`~/.config/quickshell/noctalia/settings.json\`, configure the wallpaper settings:

```json
{
    "wallpaper": {
        "directory": "/home/tony/walls",
        "enabled": true,
        "fillMode": "crop",
        "randomEnabled": true,
        "randomIntervalSec": 300,
        "transitionDuration": 1500
    }
}
```

This will automatically handle your wallpapers with smooth transitions. But if you want to use swaybg manually, you can still add it to your niri config:

```kdl
spawn-sh-at-startup "swaybg -i ~/walls/wall1.png"
```


## Screenshot Script {#screenshot-script}

Good news! Niri has a built-in screenshot UI that's actually really nice. You can trigger it with these keybinds (already in the default config):

```kdl
Mod+S { screenshot; }
Ctrl+Print { screenshot-screen; }
Alt+Print { screenshot-window; }
```

Screenshots are saved to \`~/Pictures/Screenshots/\` by default, but you can change this in your config:

```kdl
screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
```

If you prefer the traditional grim + slurp workflow, you can still use that:

```sh
#!/bin/sh
grim -g "$(slurp)" - | wl-copy
```

And bind it in your config.kdl:

```kdl
Mod+Shift+S { spawn "path-to-your-screenshot-script"; }
```


## Additional Customizations {#additional-customizations}

So at this point, the world is really your oyster. Niri is incredibly flexible and customizable.

Here's a summary of my favorite keybinds:

| Keybind         | Action                               |
|-----------------|--------------------------------------|
| Super+Return    | Opens a terminal (alacritty)         |
| Super+D         | Runs fuzzel (application launcher)   |
| Super+Q         | Closes a window                      |
| Super+H/J/K/L   | Navigate between windows (vim-style) |
| Super+1-9       | Switch to workspace 1-9              |
| Super+Shift+1-9 | Move window to workspace 1-9         |
| Super+S         | Take a screenshot                    |
| Super+O         | Toggle Overview mode                 |
| Super+F         | Maximize column                      |
| Super+Shift+F   | Fullscreen window                    |
| Super+R         | Cycle through preset column widths   |
| Super+C         | Center the current column            |

Some advanced features I really like:

Named workspaces - You can create custom named workspaces instead of just numbers:

```kdl
workspace "a" { }
workspace "b" { }
workspace "c" { }
```

Window rules - Automatically manage specific applications:

```kdl
window-rule {
    match title="Firefox"
    open-on-workspace "c"
    open-maximized true
}
```

The Overview feature (Super+O) is absolutely killer - it gives you a birds-eye view of all your workspaces and windows, similar to GNOME's Activities view.


## Final Thoughts {#final-thoughts}

You're now ready to use Neovim as a modern, fast, and extensible code editor.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
