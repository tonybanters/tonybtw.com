---
title: "How to Install and Customize DWL | Wayland Minimalism Endgame?"
author: ["Tony", "btw"]
description: "This is a quick and painless guide on how to install and customize DWL, which is a DWM port to wayland, more or less. Is it the end game of desktop minimalism?"
date: 2025-09-22
draft: false
image: "/img/dwl.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today I'm gonna give you a quick and painless guide on installing and configuring DWL.

DWL is basically a drop in replacement for DWM, but for the wayland display server. DWM is often reffered to as the most minimal window manager you can run on xorg, however, due to xorg's client/server model, many people view wayland as a better late-game solution for security and simplicity.

If you're someone who loves the simplicity, extensibility, and minimality of DWM, but prefers the wayland display protocol over xorg, this is the perfect solution for you. Let's jump right into it.


## Install Dependencies for DWL {#install-dependencies-for-dwl}

Alright so I'm on arch linux, btw, but this is going to work on Nix, gentoo, etc. I'll leave install instructions for all 3 of those distributions in this written guide in a link below the subscribe button.

For arch, here are the dependencies we need to install:

1.  wayland, wayland-protocols
2.  wlroots_0_19 (dependency for dwl)
3.  foot (terminal emulator)
4.  base-devel (so we can compile dwl)
5.  git (to clone the 2 repos for dwl, and slstatus)
6.  wmenu (a dmenu clone for wayland)
7.  wl-clipboard (wayland clipboard tool)
8.  grim, slurp for screenshots
9.  swaybg (for wallpapers)
10. firefox (web browser)
11. ttf-jetbrains-mono-nerd (font)

And let's clone dwl, and slstatus while we're at it.

```sh
git clone https://codeberg.org/dwl/dwl.git
git clone https://git.suckless.org/slstatus
```

Alright, let's start modifying dwl before we launch it.


### Installation Commands by Distribution {#installation-commands-by-distribution}


#### Arch Linux {#arch-linux}

```sh
sudo pacman -S wayland wayland-protocols wlroots_0_19 foot base-devel git wmenu wl-clipboard grim slurp swaybg firefox ttf-jetbrains-mono-nerd
```


#### Gentoo Linux {#gentoo-linux}

```sh
sudo emerge -av dev-libs/wayland dev-libs/wayland-protocols gui-libs/wlroots x11-terms/foot sys-devel/base-devel dev-vcs/git gui-apps/wmenu gui-apps/wl-clipboard media-gfx/grim gui-apps/slurp gui-apps/swaybg www-client/firefox media-fonts/jetbrains-mono
```


#### NixOS {#nixos}

Add to your `configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  wayland
  wayland-protocols
  wlroots_0_19
  foot
  git
  wmenu
  wl-clipboard
  grim
  slurp
  swaybg
  firefox
  jetbrains-mono
];
```


## Create config file {#create-config-file}

Let's jump into our config.def.h file and setup some sane defaults before launching into dwl

As always, I'm going to change my mod key from alt to super. We can do that here on line 110:

```c
#define MODKEY WLR_MODIFIER_LOGO
```

And on line 66, we have the repeat delay settings right here:

```c
static const int repeat_rate = 35;
static const int repeat_delay = 200;
```

Also, lets change up some keybinds here to what I'm used to.

```c
static const Key keys[] = {
    { MODKEY,                    XKB_KEY_d,          spawn,          {.v = wmenucmd} },
    { MODKEY,                    XKB_KEY_Return,     spawn,          {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_q,          killclient,     {0} },

    // To avoid duplicate keybind, swap inc master to p
    { MODKEY,                    XKB_KEY_p,          incnmaster,     {.i = -1} },
};
```

I just like to change my terminal to super enter, my run prompt to super d, and my kill client with super q.
Alright I think that should be good enough for a first build. Let's save and quit this file, run sudo make clean install,
lets jump into a tty, and run dwl.


## Load DWL {#load-dwl}

We're in dwl now by and as you can see, it's literally just a blank screen with a mouse cursor. Super minimal.

Ok so because dwl is so minimal, we literally have to patch it to get a bar. So lets open firefox here, we have our wmenu binded to super d, and lets type firefox (we'll customize that later), and lets search dwl patches. Here the 2nd link, we see a community repo of patches. Link will be provided to this below the subscribe button.

Let's grab the bar patch, and apply it. Save it to dotfiles/dwl/patches

```sh
cd ~/dotfiles/dwl
patch -i patches/bar.diff
```

And that looks good. Let's customize it a little bit here with the font.
Open up config.def.h and specify the font here:

```c
static const char *fonts[]                 = {"JetBrainsMono Nerd Font Mono:style=Bold:size=16"};
```

While we're in here, let's make our wmenu prompt look a little better by changing our wmenu command to this:

```c
static const char *wmenucmd[] = {
    "wmenu-run",
    "-f", "JetBrainsMono Nerd Font 16",
    "-l", "10",
    NULL
};
```

This just tells wmenu to run in a list of 10 items vertically, and changes the font to match our bar.
Alright, we're ready to bounce rebuild dwl, and relaunch it. Let's give it a go.

```sh
rm config.h
sudo make clean install
```

Why we remove config.h is because config.def.h gets copied into config.h every time we rebuild, and if config.h is already there, we wont see our changes.

We can quit back to the tty with super shift q, and lets run dwl again by typing dwl. Awesome. There is our bar. And if we run wmenu with super d, we see it matches our new setup, and is actually readable. Sweet.

Let's jump into slstatus.


## Slstatus {#slstatus}

So we've cloned slstatus, we really just need to build it. Let's cd into it for now and just use the defaults.

Let's run sudo make clean install. ok lets quit out of dwl here, and now instead of running dwl, lets run

```sh
slstatus -s | dwl
```

That is going to tell slstatus to print to std out, and dwl will take it in.
Now we have a status bar on the right side. It's minimal for now but we'll fix it up later.


## Wallpaper {#wallpaper}

We need a wallpaper. With swaybg, we can set one, but we need to download one first. so lets open firefox, and head over to wallhaven.cc and pick one from there.

Let's grab this one, and put it in ~/walls/wall1.png

Now we can set that with

```sh
swaybg -i ~/walls/wall1.png & disown
```

Let's add disown here so when we close this terminal, our wallpaper persists.

But we see the issue here, we want this wallpaper to be enabled whenever we launch dwl.
So we need to create a 1 line startup script. Let's just do it in our home directory for now, and if you want to use it in a display manager, i advise you move it over to .local/bin, and add that to your path. I'll leave instructions below on that, but for now lets just make a new file caled start_dwl.sh

```sh
#!/bin/sh
slstatus -s | dwl -s "sh -c 'swaybg -i /home/tony/walls/wall1.png &'"
```

If you want to add this to your path, heres how to do it:

```sh
mkdir ~/.local/bin
cp ~/start_dwl.sh ~/.local/bin/start_dwl
vim ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
source ~/.bashrc
```

This will create .local/bin, and add this to your existing script path.

We can launch dwl now with ./start_dwl.sh, and there we go. we see slstatus, we see our wallpaper. Awesome.


## Screenshot Script {#screenshot-script}

We can add a screenshot script here with \`grim\`, \`slurp\`, and \`wl-copy\`

```sh
#!/bin/sh
timeout 10 slurp > /tmp/selection.txt 2>/dev/null
if [ $? -eq 0 ] && [ -s /tmp/selection.txt ]; then
    grim -g "$(cat /tmp/selection.txt)" - | wl-copy
else
    grim - | wl-copy
fi
rm -f /tmp/selection.txt
```


## Remove Boxes, and other cleanup. {#remove-boxes-and-other-cleanup-dot}

So at this point, the world is really your oyster. For me, the first thin I see that is a problem, is that I don't like the visual indicator in my workspace numbers that shows what workspaces are occupied. In DWM, there is a patch to remove these boxes, but there isn't one in dwl, so I had to simply modify the source code. It's not that bad, I just jumped into dwl.c and found this section here where that box was drawn, and removed it.

While I was in this file, I did a lot more, because I wanted a specific setup where I could see differentiate my active, occupied, and empty workspaces just like I do in qtile, hyprland, dwm, etc. So I tinkered with this file a lot, and I'm not going to go through all those changes today. I've went ahead and just pulled down my full version of dwl here, and you can too if you'd like, a link is of course below the subscribe button.

Here you can see the behaviour: Teal numbers if occupied, purple underline if active, white number if empty.
Also, you'll notice I have tweaked my slstatus to accept colors, and underlines as well. That was a heavily lift, but I got it done.


## Keybinds {#keybinds}

Here are all the configured keybinds for this dwl setup. MODKEY is typically the Super/Windows key.


### Application Launchers {#application-launchers}

| Key Combination   | Action | Description             |
|-------------------|--------|-------------------------|
| `MODKEY + d`      | wmenu  | Launch application menu |
| `MODKEY + Return` | foot   | Launch terminal         |


### Screenshots {#screenshots}

| Key Combination      | Action                     | Description                       |
|----------------------|----------------------------|-----------------------------------|
| `Ctrl + F12`         | snip script                | Take screenshot (via script)      |
| `MODKEY + s`         | /home/tony/scripts/snip.sh | Take screenshot                   |
| `MODKEY + Shift + S` | Screenshot selection       | Select area and copy to clipboard |


### Window Management {#window-management}

| Key Combination          | Action            | Description                     |
|--------------------------|-------------------|---------------------------------|
| `MODKEY + j`             | Focus next        | Focus next window in stack      |
| `MODKEY + k`             | Focus previous    | Focus previous window in stack  |
| `MODKEY + q`             | Kill client       | Close focused window            |
| `MODKEY + Return`        | Zoom              | Move focused window to master   |
| `MODKEY + Tab`           | View last tag     | Switch to previously viewed tag |
| `MODKEY + e`             | Toggle fullscreen | Make window fullscreen          |
| `MODKEY + Shift + Space` | Toggle floating   | Make window floating/tiled      |


### Layout Management {#layout-management}

| Key Combination  | Action           | Description                |
|------------------|------------------|----------------------------|
| `MODKEY + t`     | Tiled layout     | Set layout to tiled        |
| `MODKEY + f`     | Floating layout  | Set layout to floating     |
| `MODKEY + m`     | Monocle layout   | Set layout to monocle      |
| `MODKEY + Space` | Toggle layout    | Cycle through layouts      |
| `MODKEY + h`     | Decrease master  | Decrease master area size  |
| `MODKEY + l`     | Increase master  | Increase master area size  |
| `MODKEY + i`     | Increase masters | Increase number of masters |
| `MODKEY + p`     | Decrease masters | Decrease number of masters |


### Status Bar and Gaps {#status-bar-and-gaps}

| Key Combination | Action      | Description                |
|-----------------|-------------|----------------------------|
| `MODKEY + b`    | Toggle bar  | Show/hide status bar       |
| `MODKEY + a`    | Toggle gaps | Enable/disable window gaps |


### Tag Management (Workspaces) {#tag-management--workspaces}

| Key Combination          | Action        | Description                |
|--------------------------|---------------|----------------------------|
| `MODKEY + [1-9]`         | View tag      | Switch to tag 1-9          |
| `MODKEY + Shift + [1-9]` | Move to tag   | Move window to tag 1-9     |
| `MODKEY + 0`             | View all tags | Show windows from all tags |
| `MODKEY + Shift + )`     | Tag all       | Tag window with all tags   |


### Monitor Management {#monitor-management}

| Key Combination      | Action                | Description                  |
|----------------------|-----------------------|------------------------------|
| `MODKEY + ,`         | Focus left monitor    | Focus monitor to the left    |
| `MODKEY + .`         | Focus right monitor   | Focus monitor to the right   |
| `MODKEY + Shift + <` | Move to left monitor  | Move window to left monitor  |
| `MODKEY + Shift + >` | Move to right monitor | Move window to right monitor |


### System Control {#system-control}

| Key Combination          | Action           | Description                 |
|--------------------------|------------------|-----------------------------|
| `MODKEY + Shift + Q`     | Quit dwl         | Exit window manager         |
| `Ctrl + Alt + Backspace` | Terminate server | Force quit (emergency exit) |


## Final Thoughts {#final-thoughts}

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
