---
title: "MangoWC Installation + Customization Guide"
author: ["Tony", "btw"]
description: "This is a quick and painless guide on how to install and customize MangoWC, which is a non-suckless alternative to DWL, without the friction!"
date: 2025-10-15
draft: false
image: "/img/mangowc.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today I'm gonna give you a quick and painless guide on installing and configuring MangoWC.

MangoWC is a wayland compositor inspired by DWL, but turned into something much greater. It has adopted new features such as scrolling, scratchpad functionality, overview, gestures, animations, and more. It very well may be the best wayland compositor out there.

A quote from the developer:

> "Mango is as lightweight as dwl, and can be built completely within a few seconds. Despite this, Mango does not compromise on functionality."
> – DreamMaoMao


## Install Dependencies for Mango {#install-dependencies-for-mango}

Alright so I'm on arch linux, btw, but this is going to work on NixOS, Gentoo, Slackware, etc. I'll leave install instructions for all 3 of those distributions in this written guide in a link below the subscribe button.

For arch, here are the dependencies we need to install:

[Mango's Official Github](https://github.com/DreamMaoMao/mangowc)

```sh
yay -S mangowc-git
```


### Requirements for MangoWC {#requirements-for-mangowc}

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

-   foot (terminal emulator)
-   wmenu (a dmenu clone for wayland)
-   wl-clipboard (wayland clipboard tool)
-   grim, slurp for screenshots
-   swaybg (for wallpapers)
-   firefox (web browser)
-   ttf-jetbrains-mono-nerd (font)


## Installation Guide per Distro: {#installation-guide-per-distro}


### Arch Linux {#arch-linux}

For Arch Linux, installation is straightforward using the AUR:

```sh
yay -S mangowc-git
```

Then install the required dependencies:

```sh
sudo pacman -Sy foot wl-clipboard wmenu grim slurp swaybg firefox ttf-jetbrains-mono-nerd
```


### NixOS {#nixos}

For NixOS, you'll need to add MangoWC as a flake input to your configuration.
First, add the flake input to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    mangowc = {
      url = "github:DreamMaoMao/mangowc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, mangowc, ... }: {
    nixosConfigurations.yourHostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        mangowc.nixosModules.default
      ];
    };
  };
}
```

Then enable MangoWC in your `configuration.nix`:

```nix
{ config, pkgs, ... }:

{
  programs.mangowc.enable = true;

  environment.systemPackages = with pkgs; [
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    firefox
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
```

Rebuild your system:

```sh
sudo nixos-rebuild switch --flake .#your_hostname
```


### Gentoo {#gentoo}

For Gentoo users, you'll need to add MangoWC via an overlay or manually compile it.
First, install the dependencies:

```sh
sudo emerge --ask \
  dev-libs/wayland \
  dev-libs/wayland-protocols \
  gui-libs/wlroots \
  dev-libs/libinput \
  x11-libs/libdrm \
  x11-libs/libxkbcommon \
  x11-libs/pixman \
  dev-util/meson \
  dev-util/ninja \
  sys-apps/hwdata \
  sys-auth/seatd \
  dev-libs/libpcre2 \
  gui-apps/foot \
  gui-apps/wmenu \
  gui-apps/wl-clipboard \
  gui-apps/grim \
  gui-apps/slurp \
  gui-apps/swaybg \
  www-client/firefox \
  media-fonts/jetbrains-mono
```

Then clone and build MangoWC from source:

```sh
git clone https://github.com/DreamMaoMao/mangowc
cd mangowc
meson setup build
ninja -C build
sudo ninja -C build install
```


## Load MangoWC {#load-mangowc}

We're in mangowc now by and as you can see, it's literally just a blank screen with a mouse cursor. Super minimal.

Let's jump into mango's config.conf and get started with some keybinds.
So lets hit Alt + Enter to open foot, by defualt.

Open up .config/mango/config.conf, and lets change a few keybinds, and add a wmenu script.

```cfg
bind=SUPER,Return,spawn,foot
bind=SUPER,q,killclient,
bind=SUPER,d,spawn,wmenu-run -l 10
```

We can reload the config file with Super R. Now we can spawn terminals with Super Enter as we are used to. Alright this is nice, but we can do better. I personally could get by just like this, with no bar, but lets add one.

Let's add some custom binds for movements, and whatnot later, but for now lets move on to the bar. I encourage you to play around with this file and add/change your binds as needed, and a great place to start especially if you are coming over from dwm is to checkout ArgosNothing's DWM config conversion, and add stuff to it. He made this mango config and this article about it on my website here:
<https://tonybtw.com/community/mango>


## Waybar + Autostart {#waybar-plus-autostart}

So the file structure for the config directory is gonna be pretty simple today, we're just going to use an autostart.sh, a config.conf, and we'll put waybar's config.jsonc and style.css in here. This will allow you to use waybar with other configs as needed, and not disrupt your other wayland compositor's waybar configs.

```sh
/home/tony/.config/mango
├── autostart.sh
├── config.conf
├── config.jsonc
├── menu.sh
├── rebar.sh
└── style.css
```

I already made a video about waybar, so I'm just going to clone my waybar config and start it up with autostart.sh. If you want guidance on customizing waybar, I encourage you to check out the waybar video.

```nil
git clone https://github.com/tonybanters/waybar
cp waybar/* ~/.config/mango/.
```

And let's add waybar to our autostart.sh

```nil
vim ~/.config/mango/autostart.sh
waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
```

This will tell mango to start up with a wallpaper, and waybar.
So we're ready to launch Mango at this point. Let's go ahead and do so, by typing \`mango\`


## Wallpaper {#wallpaper}

We need a wallpaper. With swaybg, we can set one, but we need to download one first. so lets open firefox, and head over to wallhaven.cc and pick one from there.

Let's grab this one, and put it in ~/walls/wall1.png

Now we can set that with

```sh
swaybg -i ~/walls/wall1.png & disown
```

Let's add disown here so when we close this terminal, our wallpaper persists.

But we see the issue here, we want this wallpaper to be enabled whenever we launch mangoWC. We can accomplish this simply by adding it to autostart.sh

```sh
vim ~/.config/mango/autostart.sh
waybar -c ~/.config/mango/config.jsonc -s ~/.config/mango/style.css >/dev/null 2>&1 &
swaybg -i ~/walls/wall1.png >/dev/null 2>&1 &
```

Now if we relaunch mangoWC, we see our wallpaper persists.


## Screenshot Script {#screenshot-script}

We can add a screenshot script here with \`grim\`, \`slurp\`, and \`wl-copy\`

```sh
#!/bin/sh
grim -l 0 -g "$(slurp)" - | wl-copy
```

And bind this screenshot in our config.conf here:

```cfg
bind=SUPER,s,spawn,snip
```


## My Keybinds: {#my-keybinds}

Here's a breakdown of all the essential keybinds for MangoWC. These are configured in your `~/.config/mango/config.conf` file:


### Basic Controls {#basic-controls}

| Keybind             | Action               | Description                                         |
|---------------------|----------------------|-----------------------------------------------------|
| `Super + Enter`     | Launch Terminal      | Opens foot terminal emulator                        |
| `Super + d`         | Application Launcher | Opens wmenu for launching applications              |
| `Super + q`         | Kill Window          | Closes the currently focused window                 |
| `Super + Shift + r` | Reload Config        | Reloads the MangoWC configuration file              |
| `Super + R`         | Reload Waybar        | Runs the rebar script to restart waybar             |
| `Super + s`         | Screenshot           | Takes a screenshot of selected area (using snip.sh) |


### Workspace Management {#workspace-management}

| Keybind       | Action          | Description                              |
|---------------|-----------------|------------------------------------------|
| `Super + 1-9` | Switch Tag      | Switches to workspace/tag 1 through 9    |
| `Super + i`   | Increase Master | Adds one more window to master area      |
| `Super + p`   | Decrease Master | Removes one window from master area      |
| `Super + 0`   | Toggle Overview | Shows overview of all windows/workspaces |


### Window Management {#window-management}

| Keybind                  | Action         | Description                                    |
|--------------------------|----------------|------------------------------------------------|
| `Super + j`              | Focus Next     | Focuses the next window in the stack           |
| `Super + k`              | Focus Previous | Focuses the previous window in the stack       |
| `Super + h`              | Focus Left     | Focuses the window to the left                 |
| `Super + l`              | Focus Right    | Focuses the window to the right                |
| `Super + Shift + j`      | Swap Down      | Swaps current window with the one below        |
| `Super + Shift + k`      | Swap Up        | Swaps current window with the one above        |
| `Super + Shift + h`      | Swap Left      | Swaps current window with the one on the left  |
| `Super + Shift + l`      | Swap Right     | Swaps current window with the one on the right |
| `Ctrl + Shift + j/k/h/l` | Smart Move     | Moves window in specified direction            |


### Layout Controls {#layout-controls}

| Keybind             | Action            | Description                              |
|---------------------|-------------------|------------------------------------------|
| `Super + t`         | Tile Layout       | Sets layout to tiled mode                |
| `Super + v`         | Vertical Grid     | Sets layout to vertical grid             |
| `Super + c`         | Spiral Layout     | Sets layout to spiral mode               |
| `Super + x`         | Scroller Layout   | Sets layout to scroller mode             |
| `Super + n`         | Switch Layout     | Cycles through available layouts         |
| `Super + a`         | Toggle Gaps       | Toggles window gaps on/off               |
| `Super + f`         | Toggle Float      | Toggles floating mode for current window |
| `Super + Shift + f` | Toggle Fullscreen | Toggles fullscreen for current window    |


### Mouse Bindings {#mouse-bindings}

| Keybind               | Action        | Description                             |
|-----------------------|---------------|-----------------------------------------|
| `Super + Left Click`  | Move Window   | Click and drag to move floating windows |
| `Super + Right Click` | Resize Window | Click and drag to resize windows        |


### Touchpad Gestures {#touchpad-gestures}

| Gesture                           | Action          | Description                           |
|-----------------------------------|-----------------|---------------------------------------|
| 3-finger swipe left/right/up/down | Focus Direction | Focuses window in the swipe direction |
| 4-finger swipe left               | Previous Tag    | Switches to previous tag with clients |
| 4-finger swipe right              | Next Tag        | Switches to next tag with clients     |
| 4-finger swipe up/down            | Toggle Overview | Shows/hides workspace overview        |


## Final Thoughts {#final-thoughts}

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
