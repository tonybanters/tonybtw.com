---
title: "Hyprland on Arch — Minimal Setup Guide"
author: ["Tony", "btw"]
description: "A zero to hero Hyprland setup, which if you follow along, will help you produce a rice thats truly yours."
date: 2025-08-24
draft: false
image: "/img/hyprland.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today, I'm going to give you a quick and painless guide
on installing Hyprland on Arch linux.

Hyprland is a dynamic window manager and wayland compositor that is highly customizable, and it
emphasizes aesthetics, functionality, and extensibility.

We're going to be using Arch linux today, but hyprland is available on most distrobutions, so if you
are a NixOS user, or Gentoo, or even Debian, check out the wiki for installation instructions, but other
than that, the customization aspect of this guide will still apply to you.

At the end of this guide, you will no longer be using x11, and you will be able to fully
customize your own build of hyprland on your own hardware.


## Install Arch Linux {#install-arch-linux}

-   basic stuff
-   pacstrap everything

The first thing I'm going to do is install a fresh Arch linux, and since today's guide is not about
how to install Arch linux, I'm going to speed through that process and catch you guys at the login
screen. If you want help installing arch linux, check out my Arch Linux tutorial.

[Arch Linux Tutorial](https://youtu.be/oeDbo-HRaZo)


## Install required tools for hyprland {#install-required-tools-for-hyprland}

Alright, so we're staring at a very minimal arch build, we only installed base, base-devel, linux, linux-firmware, and sof-firmware.
That's all you need to get started, and if you are an arch user, you can start basically anywhere as long as you've installed these
basic packages, and got a bootloader up and running.

So lets start by installing all of the required packages for today's setup. The beatiful thing about starting on a fresh install
like this is that, you guys get to see the most minimal setup as possible in terms of packages. So let's grab all the hyprland
tools.

The 'hyprland' package actually comes with a lot on Arch linux. It comes with the wayland compositor among other things. Let's grab that,
xorg-xwayland (just in case we need to use xwayland utils), and hyprpaper (a minimal hyprland wallpaper tool)

[Hyprland Arch Wiki Page](https://archlinux.org/packages/extra/x86_64/hyprland/)

For other packages, I'm going to be using vim today to edit all the files, you can feel free to use your text editor of choice.
We need wofi (an application launcher for wayland), foot (a terminal emulator in wayland), waybar (the powerbar that we'll be using today),
dolphin (a file manager that works in wayland), and firefox. Let's also grab git for version controlling.

Lastly, we want a nerd font to render some of the icons here, so lets grab \`ttf-jetbrains-mono-nerd\`

And that's basically it. We really don't need much, and if we need anything else along the way, we can just grab it from pacman.

-   hyprland
-   vim
-   git
-   foot
-   waybar
-   firefox
-   wofi
-   kitty (hyprland default terminal)
-   dolphin
-   jetbrains mono nerd

<!--listend-->

```sh
sudo pacman -S hyprland xorg-xwayland hyprpaper
sudo pacman -S vim wofi git foot waybar firefox dolphin
sudo pacman -S ttf-jetbrains-mono-nerd
```


## Create config file {#create-config-file}

Let's create the directory for the hyprland config file here, and copy the template config file into it. This is important because we're using foot
instead of kitty, we have to do this before launching hyprland.

```sh
mkdir -p ~/.config/hypr; cp /usr/share/hypr/hyprland.conf ~/.config/hypr/
```

Edit this file, swap kitty with foot.

```hyprlang
$terminal = foot;
```


## Load hyprland {#load-hyprland}

We're ready to launch hyprland, and we can do so easily by just typing hyprland.

```sh
hyprland
```

From inside of hyprland, we'll open a terminal with super Q
and lets immediately edit the monitors block:

Since my monitor is 1920x1080, I'll set that in my hyprland config. Also, we'll change this last 'auto' flag to 1.0.
This is the scale flag, and auto will set it to 1.5.

```text
monitor=,1920x1080,auto,1.0
```

You can display what monitor we have with:

```sh
hyprctl monitors
```


## Foot config {#foot-config}

Now lets jump into our foot config to quickly make our terminal readable
lets set this up,

```sh
mkdir .config/foot
vim .config/foot/foot.ini
```

```ini
font=JetBrainsMono NF:size=16
pad=8x8 center-when-maximized-and-fullscreen
```

And we're going to go with a tokyonight theme for todays rice, so lets check this website out for tokyonight ports. I'll leave a link
to this site below the subscribe button of this video.

[Tokyo Night Theme Site](https://wixdaq.github.io/Tokyo-Night-Website/ports.html)

Let's navigate to 'foot', and copy this colors block, and add it to our foot.ini file.

```ini
[colors]
foreground=c0caf5
background=1a1b26

## Normal/regular colors (color palette 0-7)
regular0=15161E  # black
regular1=f7768e  # red
regular2=9ece6a  # green
regular3=e0af68  # yellow
regular4=7aa2f7  # blue
regular5=bb9af7  # magenta
regular6=7dcfff  # cyan
regular7=a9b1d6  # white

## Bright colors (color palette 8-15)
bright0=414868   # bright black
bright1=f7768e   # bright red
bright2=9ece6a   # bright green
bright3=e0af68   # bright yellow
bright4=7aa2f7   # bright blue
bright5=bb9af7   # bright magenta
bright6=7dcfff   # bright cyan
bright7=c0caf5   # bright white

## dimmed colors (see foot.ini(5) man page)
dim0=ff9e64
dim1=db4b4b

alpha=0.9
```

Alright that looks great. Let's jump into the next step


## Hyprland and Waybar {#hyprland-and-waybar}

When we modify hyprlands config file, it automatically refreshes hyprland on save, which is convenient.
lets jump back into the hyprland.conf file and change a few things for QoL

We're gonna use waybar today, and in order to quickly reload that, we can use one line command here:
Also, to add it to start when we load hyprland, lets add it to exec-once.

```cfg
$reload_waybar = pkill waybar; waybar &
exec-once = waybar &
```

And we scroll down here and ensure our reload waybar script is binded:

```cfg
bind = $mainMod, R, exec, $reload_waybar
```

While we're in the binding section, lets clean up some of these binds. I like Q for quit, Enter for
terminal, and D for $menu (which is wofi)

```cfg
bind = $mainMod, Return, exec, $terminal
bind = $mainMod, Q, killactive,
bind = $mainMod, D, exec, $menu
```

Now that these are good to go, lets do one or two more huge qol updates:

```cfg
input {
    # xset r rate 200 35
    # This allows your key repeat rate set to 200ms delay, 35 repeats per second
    repeat_rate = 35
    repeat_delay = 200
}

cursor {
    # this ensures your mouse cursor doesn't glitch out
    inactive_timeout = 30
    no_hardware_cursors = true
}
```

Alright, we should be good to go for now and move on to the next step.


## Waybar {#waybar}

Now that Waybar is binded to super R, lets go ahead and load it once with super R.
Let's customize this by opening up the config file:
Lets copy over the default waybar config, since its loading a null config file now.
To ensure we can edit it, we need to change ownership of the file from root to tony. (use your username here)

```bash
sudo cp -R /etc/xdg/waybar ~/.config/waybar
sudo chown -R tony:tony .config/waybar
vim .config/waybar/.
```

So this has 2 parts to it, style.css, and config.jsconc. let's start with config.jsonc, thats where all the
widgets, and workspace stuff lives.

At the top of this file we see layer, position, etc. If you are a bottom bar user, you can swap this to bottom, and it would look like this:
We're gonna put the bar on the top today, and build it out from there.


### Config.jsonc {#config-dot-jsonc}


#### Left Modules {#left-modules}

So we see in config.jsonc, there are a bunch of modules loaded on the left side.

```json
"modules-left": [
    "sway/workspaces",
    "sway/mode",
    "sway/scratchpad",
    "custom/media"
],
```

We can delete the bottom 3 of these, they aren't needed. We only want the workspaces module on the left for now
and since we're not using sway, we're using hyprland, lets just change sway to hyprland. Sway is an i3 clone for
wayland. Will be a video on that in the future.

```json
"modules-left": [
    "hyprland/workspaces",
],
```

So this module exists, but its not defined in our file, lets go down to where the sway/workspaces module was defined.
Luckily, these modules use the same syntax, so all we need to do is switch sway to hyprland here too.

```json
"hyprland/workspaces": {
    "disable-scroll": true,
    "all-outputs": true,
    "warp-on-scroll": false,
    "format": "{name}: {icon}",
    "format-icons": {
        "1": "",
        "2": "",
        "3": "",
        "4": "",
        "5": "",
        "urgent": "",
        "focused": "",
        "default": ""
    }
},
```

So lets just uncomment this block, and change 'sway' to 'hyprland'.
Lets save this file, and reload waybar with that super R keybind.

And now we see this workpace module on the left side. Beautiful. Let's clean this up a little bit.

These Icons are customizable, similar to my dwm config, where if you know whats going on that workspace
at all times, you can use a font awesome or nerd font icon for that application, and throw it on that
workspace number. For us today, we're going to just go with the classic 1,2,3,4 ... so lets delete this block
here, and change this to just {name}

```json
"hyprland/workspaces": {
    "disable-scroll": true,
    "all-outputs": true,
    "warp-on-scroll": false,
    "format": "{name}",
},
```

We can reload this again with super R, and there we go. much better already.

Also, we'll add persistent-workspaces, so that all the numbers show even if they aren't active.

```json
"persistent-workspaces": {
    "*": 9,
}
```

One more thing for now, lets add the window module that displays what is open in your current window.
lets just put it on the left side for now

And let's define this module here, and add 2 attributes to it:
max-length, and separate-outputs: false
Max length is just making the max length 40 characters, so it doesn't impede on the right side that we'll setup next.
Separate-outputs: This is for those of you with multiple monitors, it will show the window thats focused on all monitors
instead of showing it on a per monitor basis.

```json
"modules-left": [
    "hyprland/workspaces",
    "hyprland/window"
],

"hyprland/window": {
    "max-length": 40,
    "separate-outputs": false
},
```

Let's work on some of these right-side modules.


#### Center Module {#center-module}

Lets leave this empty for now. It's easier to handle spacing imo if we just do left and right side modules.

```json
"modules-center": [],
```


#### Right Modules {#right-modules}

Lets start by deleting a lot of these modules. most of them aren't needed, and we are going for a semi-minimal
config today. Remember, that you can take this information from this tutorial, and really make your bar custom for
your own setup.

```json
"modules-right": [
    "mpd",
    "idle_inhibitor",
    "pulseaudio",
    "network",
    "power-profiles-daemon",
    "cpu",
    "memory",
    "temperature",
    "backlight",
    "keyboard-state",
    "sway/language",
    "battery",
    "battery#bat2",
    "clock",
    "tray",
    "custom/power"
],
```

Let's trim this down to just this for now: we can remove all of these, lets remove temperature
, lets get backlight, keyboard-state, language out of here. if you're on a laptop, keep batery. otherwise, get rid of it.
lets keep clock, and keep tray. we'll add some in here as well, but this is good for now.

```json
"modules-right": [
    "network",
    "cpu",
    "memory",
    // "battery",
    "clock",
    "tray"
],
```

Let's reload this with super R, and there we go. super minimal config for now. lets add 1 or 2 custom modules here, and then move onto
the styling.

Let's make this network widget super minimal.

```json
"network": {
    "format": "Online",
    "format-disconnected": "Disconnected ()"
},
```

Let's change the CPU widget to something more clean:

```json
"cpu": {
    "format": "CPU: {usage}%",
    "tooltip": false
},
```

Same thing for RAM:

```json
"memory": {
    "format": "Mem: {used}GiB"
},
```

Let's add a disk widget, and this is inspired by DT's xmonad widgets a little bit, which i've been interested in for my qtile setup.

Interval so that it doesnt run every 1 seconds (the default value)

```json
"disk": {
    "interval": 60,
    "path": "/",
    "format": "Disk: {free}",
},
```

And let's add "disk" to the right modules array:

```json
"modules-right": [
    "cpu",
    "memory",
    "disk",
    "battery",
    "clock",
    "tray"
],
```

Heres the battery modifications: (for those of you with laptops, this should be included)

```json
"battery": {
    "states": {
        "good": 80,
        "warning": 30,
        "critical": 15
    },
    "format": "Bat: {capacity}% {icon} {time}",
    "format-alt": "Bat: {capacity}%",
    "format-time": "{H}:{M}",
    "format-icons": ["", "", "", "", ""]
},
```

And lets add a simple separator module as follows:

```json
"custom/sep": {
    "format": "|",
    "interval": 0,
    "tooltip": false
},
```

Now lets add this separator in between all of our widgets. it will look weird for now, but we'll fix the styling after.

```json
"modules-left": [
    "hyprland/workspaces",
    "custom/sep",
    "hyprland/window",
    "custom/sep"
],
"modules-center": [
],

"modules-right": [
    "custom/sep",
    "network",
    "custom/sep",
    "cpu",
    "custom/sep",
    "memory",
    "custom/sep",
    "disk",
    "custom/sep",
    "clock",
    "custom/sep",
    "tray"
],
```

And thats it for the modules, we can move into the styles of these now.


### Styles {#styles}

The first thing we want to do is have our colors match the tokyonight aesthetic, so lets define these colors at the top of the file. Note, you can just copy and
paste these from my github repo.

[Github Repo](https://github.com/tonybanters/hyprland-btw)

```css
@define-color bg    #1a1b26;
@define-color fg    #a9b1d6;
@define-color blk   #32344a;
@define-color red   #f7768e;
@define-color grn   #9ece6a;
@define-color ylw   #e0af68;
@define-color blu   #7aa2f7;
@define-color mag   #ad8ee6;
@define-color cyn   #0db9d7;
@define-color brblk #444b6a;
@define-color wht   #ffffff;
```

Alright, now we see the global styles with '\*', lets add some options here.

```css
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 16px;
    font-weight: bold;
}
```

We're just changing the font to Jetbrains mono, and we are making it bold, and increasing the zie a little bit so its readable.

Now for the actual window on waybar, lets change some stuff here:

```css
window#waybar {
  background: @bg;
  color: @fg;
}
```

Let's get rid of the border, and get rid of the transition propertys for now. Keep it minimal,
since we added those variables at the top for the colors, its going to make our lives much easier when setting up these styles.

And yea, this is already looking much better as far as usability, and stylistically speaking. Let's keep going.

Lets handle the behaviour of the workspace toggles, so that the colors of the workspaces that have applications running on them
are all the same, but there is a visual indicator of the active workspace.

```css
#workspaces button {
    padding: 0 6px;
    color: @cyn;
    background: transparent;
    border-bottom: 3px solid @bg;
}
#workspaces button.active {
    color: @cyn;
    border-bottom: 3px solid @mag;
}
#workspaces button.empty {
    color: @wht;
}
#workspaces button.empty.active {
    color: @cyn;
    border-bottom: 3px solid @mag;
}
```

So this basically says that if the workspace is active, it will be visually indicated with the purple underline. if it
is not active, but not empty, it will still be cyan, but not be underlined. Waybar has a weird issue where when you swap
to a new workspace, and dont open an application on it yet, its technically empty, and active. so we will cover for that case here
as well. Feel free to copy and paste this from my config file.

Let's clean up this file now. I think we can delete pretty much everything except this massive block that just adds padding to every
widget here.

We're going to add custom separators here, so lets add that to this list, and add the css for it now, so when we jump back into the json file
we can already have it styled

```css
#clock,
#custom-sep,
#battery,
#cpu,
#memory,
#disk,
#network,
#tray {
    padding: 0 8px;
    color: @white;
}

#custom-sep {
    color: @brblk;
}
```

This tells waybar to show a white font for all the text on all these widgets by default, and
also tells the separator to use this special black font, which will add later.

Let's quickly go through these right side widgets, and make them more minimal.
I like the underline style here, feel free to tinker with the colors on your setup, but im going for the
more minimal tokyonight style.

```css
#clock {
    color: @cyn;
    border-bottom: 4px solid @cyn;
}

#battery {
    color: @mag;
    border-bottom: 4px solid @mag;
}

#disk {
    color: @ylw;
    border-bottom: 4px solid @ylw;
}

#memory {
    color: @mag;
    border-bottom: 4px solid @mag;
}

#cpu {
    color: @grn;
    border-bottom: 4px solid @grn;
}

#network {
    color: @blu;
    border-bottom: 4px solid @blu;
}
```

Alright, thats enough css for one day... This bar is looking really good. Feel free to customize it even further from here.
Let's setup wofi, add a wallpaper, and get this show on the road.


## Wallpaper {#wallpaper}

First thing we need to do is get a wallpaper.. so lets head over to firefox and grab this one i picked out for this rice, its on my github.
Let's save this into a folder in the home directory called walls, and save it is wall1.png

Now let's create a hyprpaper.conf file in the hypr directory like so:

vim .config/hypr/hyprpaper.conf

```cfg
preload = ~/walls/wall1.jpg
wallpaper = ,~/walls/wall1.jpg
```

Now in our hyprland.conf, lets turn on hyprpaper like so:

```nil
exec-once waybar & hyprpaper
```

I'll run this in a terminal here but it will now always launch when we start hyprland. And there we go. Awesome
Last thing to do is get a proper config for wofi.


## Wofi {#wofi}

For this wofi config, we'll grab it from that same website of tokyonight configs, but I modified it slightly as follows:

```sh
mkdir .config/wofi
vim .config/wofi/config
```

```nil
# mode & placement
show=drun
location=top
width=700
lines=8
columns=2
dynamic_lines=false

# icons
allow_images=true
image_size=36

# search & UX
matching=fuzzy
insensitive=true
hide_scroll=false
prompt=

# terminal
term=foot

# keybinds (vim-ish)
key_up=Ctrl-k
key_down=Ctrl-j
key_left=Ctrl-h
key_right=Ctrl-l
key_submit=Return
key_forward=Tab
key_backward=Shift-ISO_Left_Tab

# stylesheet
style=/home/tony/.config/wofi/style.css
```

And to make that stylesheet, its right here in the style.css file of that config,

so lets make this file:

```sh
vim ~/.config/wofi/style.css
```

```css
* {
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 16px;
    font-weight: bold;
}

window {
    margin: 0px;
    border: 2px solid #414868;
    border-radius: 5px;
    background-color: #24283b;
    font-family: monospace;
    font-size: 12px;
}

#input {
    margin: 5px;
    border: 1px solid #24283b;
    color: #c0caf5;
    background-color: #24283b;
}

#input image {
    color: #c0caf5;
}

#inner-box {
    margin: 5px;
    border: none;
    background-color: #24283b;
}

#outer-box {
    margin: 5px;
    border: none;
    background-color: #24283b;
}

#scroll {
    margin: 0px;
    border: none;
}

#text {
    margin: 5px;
    border: none;
    color: #c0caf5;
}

#entry:selected {
    background-color: #414868;
    font-weight: normal;
}

#text:selected {
    background-color: #414868;
    font-weight: normal;
}
```

And this system is looking pretty good. We got our waybar all setup, our widgets, we have our foot terminal looking good, our wallpaper, and our wofi config.
This is just the beginning of hyprland, but this should be a great source for you to start customizing your own personal setup.


## Hyprland Keybinds {#hyprland-keybinds}

| Mod Key | Key / Input | Action         | Target / Notes |
|---------|-------------|----------------|----------------|
| SUPER   | Return      | exec           | $terminal      |
| SUPER   | Q           | killactive     |                |
| SUPER   | M           | exit           |                |
| SUPER   | E           | exec           | $fileManager   |
| SUPER   | V           | togglefloating |                |
| SUPER   | D           | exec           | $menu          |
| SUPER   | R           | exec           | $reload_waybar |
| SUPER   | P           | pseudo         | dwindle only   |
| SUPER   | J           | togglesplit    | dwindle only   |


### Directional Focus {#directional-focus}

| Mod Key | Key   | Action    | Direction |
|---------|-------|-----------|-----------|
| SUPER   | left  | movefocus | l         |
| SUPER   | right | movefocus | r         |
| SUPER   | up    | movefocus | u         |
| SUPER   | down  | movefocus | d         |


### Workspaces {#workspaces}

| Mod Key     | Key | Action          | Workspace |
|-------------|-----|-----------------|-----------|
| SUPER       | 1–0 | workspace       | 1–10      |
| SUPER+SHIFT | 1–0 | movetoworkspace | 1–10      |


### Special Workspace {#special-workspace}

| Mod Key     | Key | Action                 | Workspace     |
|-------------|-----|------------------------|---------------|
| SUPER       | S   | togglespecialworkspace | magic         |
| SUPER+SHIFT | S   | movetoworkspace        | special:magic |


### Scroll to Switch Workspaces {#scroll-to-switch-workspaces}

| Mod Key | Mouse Input | Action    | Workspace      |
|---------|-------------|-----------|----------------|
| SUPER   | mouse_down  | workspace | e+1 (next)     |
| SUPER   | mouse_up    | workspace | e-1 (previous) |


## Final Thoughts {#final-thoughts}

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
