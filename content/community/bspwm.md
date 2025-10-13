---
title: "BSPWM! A seamless guide to install BSPWM"
date: 2025-09-29
author: NullSector-dev
tags: ["bspwm", "window-manager", "linux/BSD", "guide"]
---

![bspwmlogo](/img/community/nullsector-dev/bspwm.png)

# What is BSPWM?
**BSPWM** or almost never known as _Binary Space Partioning Window Manager_, well it's a tiling window manager that represents windows as the leaves of a full binary tree.

Key take aways:-
1. **bspwm** does not directly respond to your keyboard or mouse.
2. It waits for instuctions to be sent to a socket to act upon.
3. **bspc** is a program that feeds bspwm instructions through a socket.
4. **sxhkd** is a X daemon that reacts to inputs and feeds necessary instructions to bspc.

Here is a pictoral representaion of the process.
```
               (Input)        (Procces)        (Socket)      
Keyboard/mouse -------> sxhkd ---------> bspc --------> bspwm
```
# Prerequisite:-
1. Base installation of your preferred Operating System.
2. A text editor of your choice, we'll be going with Vim in this guide.
3. Patience.

I'll be Guiding you to install it on FreeBSD/Archlinux but you may follow along even if you are on a different Operating System.

# Installation & Configuration

Prior to installing dependencies update your system and the repos.
```bash
# FreeBSD
doas pkg update && doas pkg upgrade
# Archlinux
sudo pacman -Syyu
```
### Step 1
List of dependencies to install prior to the window manager:-
1. xorg(if you are on FreeBSD)
2. xorg-server
3. xorg-xinit
4. xorg-xrandr
5. xorg-xsetroot
6. xorg-xset
7. xorg-xprop
8. xorg-xdpyinfo
9. vim

Installation of dependencies....
```bash
# FreeBSD
doas pkg install xorg
# Archlinux
sudo pacman -S xorg-server xorg-xinit xorg-xrandr xorg-xsetroot xorg-xset xorg-xprop xorg-xdpyinfo vim
```
### Step 2
Now we can go ahead and install bspwm and sxhkd!
```bash
# FreeBSD
doas pkg install bspwm sxhkd
# Archlinux
sudo pacman -S bspwm sxhkd
```

### Step 3
Now that we have installed bspwm and the required X hotkey daemon.

Do not start your Xsession yet we have to configure keybinds and Desktop behaviour.
The following steps are universal.

```bash
# Changing to Home Directory
cd
# Creating required directories
mkdir ~/.config/bspwm
mkdir ~/.config/sxhkd
```

### Step 4

Lets start with configuring our Desktop behavior. Creating a file in ``~/.config/bspwm``.
```bash
vim ~/.config/bspwm/bspwmrc
```
I'll give you a very basic bspwmrc file to get bspwm get up and running.

Add the following to the file
```bash
#!/bin/sh

# Naming workspaces

bspc monitor -d 1 2 3 4 5 6 7 8 9 10
# You can replace them with whatever you like for example
# bspc monitor -d I II III IV V VI VII VIII IX X
# bspc monitor -d Term Browser Editor Misc

# Setting up Border rules

bspc config border_width              2         # Width of the border.
bspc config window_gap                5         # gap between windows.
bspc config split_ratio               0.5       # split ratio between windows, the ratios are set between 0 and 1.
bspc config focus_follows_pointer     true      # window focus follows pointer.
bspc config focused_border_color      "#FFFFFF" # White
bspc config normal_border_color       "858585"  # Gray

# Workspace rules

bspc rule -a Alacritty desktop='^1' follow=on   #Ties alacritty to workspace 1 and follow
bspc rule -a firefox desktop='^2' follow=on     #Ties firefox to workspace 2 and follow

# Auto Start

feh --bg-scale ~/(wallpaper path) &              # Set wallpaper
sxhkd &                                          # Starts Hotkey daemon(required)
# pulseaudio &
# picom &
```

This is basic bspwmrc required to start a bspwm session properly

now make the file executable

```bash
chmod +x ~/.config/bspwm/bspwmrc
```

### Step 5

Let's now configure the keybinds. Start by creating the required file in ``~/.config/sxhkd``.
```bash
vim ~/.config/sxhkd/sxhkdrc
```
I'll give you a basic ``sxhkdrc`` file

```bash
# I'll be using alt as my mod key you may replace with super
# App Binds
 
 alt + Return
    alacritty                                                            # You may replace with your prefered terminal emulator

alt + space
    rofi -show drun                                                     # App launcher

alt + a
    maim ~/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png                   # Screenshot tool


# Window Binds

alt + q
    bspc node -c                                                        #Quit current window

alt + {h,j,k,l}
    bspc node -f {west,south,north,east}                                # Switch window focus

alt + shift + {h,j,k,l}
    bspc node -s {west,south,north,east}                                # Interchange windows

alt + f
    bspc node -t ~floating                                              # Toggle floating

alt + shift + f
    bspc node -t ~fullscreen                                            # Toggle fullscreen

# Workspace binds

alt + {1-9,0}
    bspc destop -f {1-9,10}                                             # Switch between workspaces

alt + shift + {1-9,0}
    bspc node -d {1-9,10}                                               # Shift windows to different workspaces

# Session Binds

alt + shift + r                                                         # Reload bspwm
    bspc wm -r

alt + shift + q                                                         # Quit bspwm
    bspc quit
```

This is a bare bones ``sxhkdrc`` file. (**WARN: Do not make this executable!**).

With this you have successfully Installed and Configured **BSPWM**.

### Initiating Window Manager

Move to your Home Directory
```bash
cd
```

Do the following
```bash
# Adding exec command to xinitrc
echo "exec bspwm" >> .xinitrc

# Making it executable
chmod +x .xinitrc
```

Now you can Initiate your window manager by
```bash
startx
```

![bspwmscreenshot](/img/community/nullsector-dev/bspwmss.png)

**Good Luck!**

## Links:
[BSPWM](https://github.com/baskerville/bspwm)
[SXHKD](https://github.com/baskerville/sxhkd)
[Basic bspwm files](https://codeberg.org/NullSector-dev/basic_bspwm)
[My Codeberg](https://codeberg.org/NullSector-dev)







