---
title: "DWM on Arch | Minimal Config Tutorial"
author: ["Tony", "btw"]
description: "A complete DWM setup on Arch Linux with minimal patches, autostart, custom bar, and keybinds."
date: 2025-04-27
draft: false
image: "/img/dwm.png"
showTableOfContents: true
---

## Introduction {#introduction}

This is a full DWM tutorial for Arch users who want a minimal, fast, patched build without bloat.

The philosophy of the developers of dwm is as follows:
Keep things simple, minimal and usable.

> "Unfortunately, the tendency for complex, error-prone and slow software seems to be prevalent in the present-day software industry. We intend to prove the opposite with our software projects. "
> – DWM Developers

Because of this philosophy, DWM is blazingly fast, and strikes a balance of minimalism, efficienty, and extensibility.

You’ll get a working, beautiful setup with basic patches, autostart, a functional bar, and a clean workflow.


## Installation {#installation}

The pre-requisites for today's tutorial are: xorg, make, gcc, and a few others. If you follow the video guide,
I'm starting from almost a brand new arch install, so you can just start from that, and get the following packages like so:

```sh
pacman -S git base-devel xorg xorg-xinit xorg-xrandr
git clone https://git.suckless.org/dwm
cd dwm
sudo make clean install
```

We will need st as well, a terminal manager made by the developers of dwm. Same concept here.

```sh
git clone https://git.suckless.org/st
cd st
sudo make clean install
```

Note: If you are on another distribution such as Debian, or Gentoo, getting dwm will be exactly the same, but getting the xorg server and developer tools to build dwm (base-devel on arch) will be slightly different. Refer
to your distribution's handbook on how to get these tools.

I personally am a 'startx' kinda guy, but if you have a display manager, just add dwm to your display manager list.

Last thing here is to add exec dwm to the .xinitrc file:

```sh
echo 'exec dwm' >> .xinitrc
```


## Modifying config.h (Keybinds) {#modifying-config-dot-h--keybinds}

Alright, let's open a terminal here and start modifying config.h.

```sh
chown -R dwm
cd dwm; vim config.h
```

The first thing we want to do is head on down to the modkey section, and change
mod1mask to mod4mask (this changes the mod key from alt to super)

```c
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
```

Let's take a look at the keybinds section here, and I'm going to change stuff for my personal needs, you feel free to tinker with this as usual. The usual suspects for me are, change opening a terminal to Super + Enter,
change the application launcher menu to Super + D, and change closing a program to Super + Q.

```c
static const Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_b,      togglebar,      {0} },
    { MODKEY,                       XK_q,      killclient,     {0} },
    TAGKEYS(                        XK_1,                      0)
    TAGKEYS(                        XK_2,                      1)
};
```

Once you're done with these first small changes, go ahead and run:

```sh
sudo make clean install; pkill x; startx
```

Beautiful. You've succesfully rebuilt your first DWM binary. You can officialy tell all of your friends that you are a C developer. Let's move on to the next step.


## Aliases {#aliases}

For QoL, I like to use 2 aliases for dwm, one to just jump into the config file, and another to rebuild dwm.
So if you want those, open up your bashrc file and add these aliases:

```bash
alias cdwm="vim ~/dwm/config.h"
alias mdwm="cd ~/dwm; sudo make clean install; cd -";
```

This will make it so you can jump straight into your config.h file, and rebuild dwm from anywhere and return back to whatever directory you were in after rebuilding it.


## Commands {#commands}

Let's mess with some of the commands. I like to use rofi, although dmenu is perfectly fine if not better, rofi just ports over really nice to all my other configs, so I'll show you how to set that up in dwm.

First, ensure rofi is installed, and a config.rasi exists in .config/rofi/config.rasi (feel free to copy my config.rasi file [here](https://www.github.com/tonybanters/rofi))

Let's jump back into config.h, and look at the commands section.

```c
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *firefoxcmd[]  = { "firefox-bin", NULL };
static const char *slock[]    = { "slock", NULL };
static const char *screenshotcmd[] = { "/bin/sh", "-c", "maim -s | xclip -selection clipboard -t image/png", NULL };
static const char *rofi[]  = { "rofi", "-show", "drun", "-theme", "~/.config/rofi/config.rasi", NULL };
static const char *emacsclient[]  = { "emacsclient", "-c", "-a", "", NULL };
```

These are some of my commands. Notice I have rofi, slock which is a minimal screen lock tool, a screenshot command which just utilizes main and xclip, and i've got an emacsclient command. Don't worry about that emacs command if you are below the age of 30.

Make sure to add these commands to the keybind section like so:

```c
static const Key keys[] = {
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_r,      spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_e,      spawn,          {.v = emacsclient } },
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
    { MODKEY,                       XK_l,      spawn,          {.v = slock } },
    { ControlMask,                  XK_Print,  spawn,          {.v = screenshotcmd } },
    { MODKEY,                       XK_d,      spawn,          {.v = rofi } },
    { MODKEY,                       XK_b,      spawn,          {.v = firefoxcmd } },
    ...
};
```


## Autostart {#autostart}

Use this to launch programs like wallpaper setter, bar, compositor: (if they are not in .xinitrc)

```c
/* add this to config.h */
static const char *autostart[] = {
  "dwm-autostart.sh", NULL
};
```

Example script:

```sh
#!/bin/sh
xwallpaper --zoom ~/wall.png &
dwmblocks &
picom -b
```


## Patches {#patches}

Alright, patches are something that deters people from using dwm because they feel it can be daunting, but its really easy.

Head on over to: [DWM's Official Community Patch List](https://dwm.suckless.org/patches)

Grab a patch, vanity-gaps for example, and right click the patch, and save link as. Put this in dwm/patches/

To patch your dwm, just run

```sh
patch -i ~/dwm/patches/name-of-patch.diff
```

Hopefully you don't get any errors, but if you do, they are usually pretty simple to resolve. Checkout my video on dwm to learn more about resolving patches.

After that, remake dwm with the \`mdwm\` alias, and restart x. Boom, your patch is ready to go.


## DWMBlocks {#dwmblocks}

DWM Blocks is a program that renders blocks in the top right of the dwm bar. Similar to widgets in Qtile, or polybar modules. These blocks can all be customizable sh scripts, and ricing this will be for another tutorial, but for now the base version is good enough. You can take mine as well:

Install:

```sh
git clone https://github.com/tonybanters/dwmblocks
cd dwmblocks
sudo make clean install
```

Basic usage:
Add \`dwmblocks &amp;\` to your autostart script.


## Custom Icons &amp; Fonts {#custom-icons-and-fonts}

For a custom font, I like jetbrains mono nerd font, and we can just install it like so:

```sh
sudo pacman -S ttf-jetbrains-mono-nerd
```

And we can set that font in \`config.h\`:

```c
static const char *fonts[] = { "JetBrainsMono Nerd Font:size=14" };
```


## My personal keybinds {#my-personal-keybinds}

If you want to just clone my build of dwm, thats perfectly fine, just take a look at this table here for my keybinds as a guide:


## DWM Keybindings {#dwm-keybindings}

| Modifier  | Key        | Action            | Description                  |
|-----------|------------|-------------------|------------------------------|
| MOD       | r          | spawn             | Launch dmenu                 |
| MOD       | Return     | spawn             | Launch terminal              |
| MOD       | l          | spawn             | Lock screen (slock)          |
| Ctrl      | Print      | spawn             | Screenshot                   |
| MOD       | d          | spawn             | Launch Rofi                  |
| MOD       | b          | togglebar         | Toggle top bar               |
| MOD       | j          | focusstack +1     | Focus next window            |
| MOD       | k          | focusstack -1     | Focus previous window        |
| MOD       | i          | incnmaster +1     | Increase master windows      |
| MOD       | p          | incnmaster -1     | Decrease master windows      |
| MOD       | g          | setmfact -0.05    | Shrink master area           |
| MOD       | h          | setmfact +0.05    | Grow master area             |
| MOD       | z          | incrgaps +3       | Increase gaps                |
| MOD       | x          | incrgaps -3       | Decrease gaps                |
| MOD       | a          | togglegaps        | Toggle gaps                  |
| MOD+Shift | a          | defaultgaps       | Reset gaps                   |
| MOD       | Tab        | view              | Toggle last workspace        |
| MOD       | q          | killclient        | Close focused window         |
| MOD       | t          | setlayout tile    | Set tiling layout            |
| MOD       | f          | setlayout float   | Set floating layout          |
| MOD       | m          | setlayout monocle | Set monocle layout           |
| MOD       | c          | setlayout custom1 | Custom layout (slot 3)       |
| MOD       | o          | setlayout custom2 | Custom layout (slot 4)       |
| MOD+Shift | Return     | setlayout default | Reset to default layout      |
| MOD+Shift | f          | fullscreen        | Toggle fullscreen            |
| MOD+Shift | Space      | togglefloating    | Toggle floating              |
| MOD       | 0          | view all tags     | View all workspaces          |
| MOD+Shift | 0          | tag all           | Move window to all tags      |
| MOD       | ,          | focusmon -1       | Focus monitor left           |
| MOD       | .          | focusmon +1       | Focus monitor right          |
| MOD+Shift | ,          | tagmon -1         | Send window to monitor left  |
| MOD+Shift | .          | tagmon +1         | Send window to monitor right |
| MOD       | 1–9        | view tag N        | Switch to tag N              |
| MOD+Shift | 1–9        | tag window to N   | Move window to tag N         |
| MOD+Shift | q          | quit              | Exit DWM                     |
| (none)    | XF86Audio+ | pactl +3%         | Raise volume                 |
| (none)    | XF86Audio- | pactl -3%         | Lower volume                 |


## Final Thoughts {#final-thoughts}

This setup is minimalist but powerful. From here, you can add more patches (like systray or gaps), or just keep it lean.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
