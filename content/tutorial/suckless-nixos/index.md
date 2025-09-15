---
title: "How to Install Suckless Programs on NixOS | Dwm, Dmenu, St"
author: ["Tony", "btw"]
description: "This is the 5th installment of the NixOS Tutorials. We discuss dev shells and how to implement suckless utilities in NixOS, such as dwm, dmenu, and st."
date: 2025-09-14
draft: false
image: "/img/suckless-nixos.png"
showTableOfContents: true
---

## Intro {#intro}

What's up guys, my name is Tony, and today I'm going to give you a quick and painless guide on installing suckless utilities on NixOS, the right way.

Disclaimer: This guide is heavily nix and programming oriented. If you aren't tapped into this type of content, I suggest jumping over to a channel more suitable for you such as MR.BEAST or Ms. Rachel

NixOS is great, but the hardest part of most people's journey into it is installing DWM, Dmenu, St, and other suckless utilities. This is because of how Nix stores binaries, and how there is no 'config file' with sucless software, in the same way as other software such as qtile, i3, hyprland, etc. This is by design, in a good way, because Suckless Software is meant to be minimal and extensible, so the source code is the config.

```quote
"Unfortunately, the tendency for complex, error-prone and slow software seems to be prevalent in the present-day software industry. We intend to prove the opposite with our software projects." - suckless philosophy
```

Let's get into it.


## Dependencies {#dependencies}

Part of this tutorial is going to be assuming you already have flakes, and home manager set up. If you watched my nixos from scratch series, it covers all of that. If not, I highly suggest just cloning the nixos-from-scratch repo, and following along this tutorial with that config directory already set up.

1.  [NixOS From Scratch Repo](https://www.github.com/tonybanters/nixos-from-scratch)
2.  [YouTube Guide](https://www.youtube.com/watch?v=2QjzI5dXwDY)


## DWM {#dwm}

Let's get started with dwm. You don't need a flake or home manager to set this up, its actually quite easy.


### Configuration.nix {#configuration-dot-nix}

First, we need to add this block in our services.xserver.windowManager set.

```nix
services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
        src = ./config/dwm;
    };
};
```

So the entire block will look like this:

```nix
  services = {

    displayManager = {
      ly.enable = true;
    };

    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
      windowManager.qtile.enable = true;
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.overrideAttrs {
          src = ./config/dwm;
        };
      };
    };

    picom.enable = true;
  };
```


### Cloning Dwm {#cloning-dwm}

Now we need to ensure our dwm folder exists and is in fact in ~/nixos-dotfiles/config

```sh
git clone https://git.suckless.org/dwm ~/nixos-dotfiles/config/dwm
```

While we have cloned this, before we actually build dwm, let's just change 1 or 2 things so we can show that this works:

let's open \`config.h\` with vim here, \`nvim ~/nixos-dotfiles/config/dwm/.\`

We'll change the font here, and we'll change the terminal to alacritty (since we don't have st installed yet.) Also, we'll change our modkey to super.

```c
static const char *fonts[] = {"JetBrainsMono Nerd Font:size=16"};
// ...
static const char *termcmd[]  = { "alacritty", NULL };
```


### Rebuild {#rebuild}

It's literally that easy. Now dwm will be enabled at the display manager as soon as we rebuild. So let's run:

```sh
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw
```

Remember to replace #nixos-btw with whatever your host is specified in your flake. If you aren't using flakes, just run it without the --flake parameter.

Now we can log out of qtile, or just reboot, and we see Dwm as an option in our display manager.
My logout keybind in qtile is Super Control Q, so I'll hit that right now and there we go.

So we see DWM here in our ly config, and thats perfect. Exactly what we're expecting. Let's hop into it to see if the stuff we changed in config.def.h changed.

Boom, there we go. We see our jetbrains mono nerd font, and we see its size has been adjusted.


## How to Patch DWM in NixOS {#how-to-patch-dwm-in-nixos}

Let's cover how to patch dwm in nixos, the nix way. I will demonstrate this with a quick patch, and then I'll just clone my version of dwm, so we can move onto st and dmenu.

Let's make a folder called patches in our dwm config folder.

Open alacritty with Alt Shift Enter

```sh
mkdir ~/nixos-dotfiles/config/dwm/patches
```

Now we can open up firefox. since we dont have dmenu, lets just run firefox from our terminal.

```sh
firefox & disown
```

And let's go to [Dwm's Patches Directory](https://dwm.suckless.org/patches/)

Let's grab the vanity gaps patch as an example here. So we'll go down to vanity gaps, and we'll
right click-&gt; save link as on this version of it, and lets save it into that patches folder we just created. Now we can exit firefox with super shift c.

There’s a way to put patches straight into the Nix set, but I prefer to do it the old-school way — just patching directly in our folder. Honestly, what’s the point of pointing to our own dwm folder if we aren’t going to patch it ourselves?

Back in our Alacritty terminal, lets cd into that dwm directory and apply the patch.

```sh
cd ~/nixos-dotfiles/config/dwm
patch -i patches/<tab>
```

And based on the output, we see the patch was succesful.

```output
patching file config.def.h
Hunk #1 succeeded at 3 with fuzz 1.
Hunk #2 succeeded at 43 with fuzz 2 (offset 1 line).
Hunk #3 succeeded at 92 (offset 1 line).
patching file dwm.c
Hunk #1 succeeded at 86 (offset -1 lines).
Hunk #2 succeeded at 119 (offset -1 lines).
Hunk #3 succeeded at 205 (offset -1 lines).
Hunk #4 succeeded at 213 (offset -1 lines).
Hunk #5 succeeded at 645 (offset -1 lines).
Hunk #6 succeeded at 1051 (offset -1 lines).
Hunk #7 succeeded at 1530 (offset -1 lines).
Hunk #8 succeeded at 1711 (offset -1 lines).
patching file vanitygaps.c
```

Alright, let's reload rebuild switch one more time here, and reload dwm to show that the patch worked.

```sh
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw
```

Alt Shift Q to reload dwm here. And we'll jump back into it. Now we can just open 2 terminals here and we see the gaps. Great. Let's move onto st and dmenu.


## Install ST and DMENU {#install-st-and-dmenu}

First of all, lets actually create a nixos module for the suckless utilities.

modules/suckless.nix:

```nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.st.overrideAttrs (_: {
      src = ../config/st;
      patches = [ ];
    }))
    (pkgs.dmenu.overrideAttrs (_: {
      src = ../config/dmenu;
      patches = [ ];
    }))
    slock
    surf
  ];
}
```

And let's add it to our home.nix file:

```nil

  imports =
    [
      ./modules/neovim.nix
      ./modules/suckless.nix
    ];

```

Now we just need to clone st, and dmenu into our config directory.

```sh
cd ~/nixos-dotfiles/config
git clone https://git.suckless.org/st
git clone https://git.suckless.org/dmenu
```

So if we run \`sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw\`
we should have st and dmenu ready to go. Now it's time to talk about DevShells


## DevShell to configure ST and Dmenu {#devshell-to-configure-st-and-dmenu}

A dev shell is sort of like a container, but its declarative. I can drop devShell parameters into a flake, and someone else can take my flake, and immediately hop into that devShell with the same environment as me. This makes it really easy to reproduce the expected environment, and move forward with the development process. Let's do it the nix way.


### ST {#st}

Let's set up our dev shell by opening our flake.nix and adding this in the outputs section:

```nix
...
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.suckless = pkgs.mkShell {
        # toolchain + headers/libs
        packages = with pkgs; [
          pkg-config
          xorg.libX11
          xorg.libXft
          xorg.libXinerama
          fontconfig
          freetype
          harfbuzz
          gcc
          gnumake
        ];
      };
      ...
```

Now we can run nixos-rebuild switch again, and jump into this devshell to start working on our st.

```sh
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw
cd ~/nixos-dotfiles
```

To run this devShell, its very simple. lets just run

```sh
nix develop .#suckless
cd config/st
```

We're now in a nix development shell with the packages that we specified in our flake. We can open st by just typing st (our current version of st). We see, its the default st. Let's open up config.def.h and make some changes, and build st again.

Let's just change the font and make it huge, so you can see this works.

```c
static char *font = "JetBrainsMono Nerd Font:pixelsize=24:antialias=true:autohint=true";
```

Alright, let's save this file, and run \`make\`. Looks like it built correctly, so we can now run
this new version of st by typing \`./st\`, and there we go. Beautiful new build of st right there. Let's check out this beautiful default colorscheme with nitch. Wow. Amaazing

So basically, once we're happy with our changes, we can quit out of this devshell, and rebuild our system again. Just type \`make clean\` first, so we can get rid of any extraneous files, and then exit.

Now we run nixos-rebuild switch again, and we can just open st, and now our nixos is pointing to our new build of st.


### DMENU {#dmenu}

For dmenu, we can use the same devShell as before. So let's enter it again here:

```sh
nix develop .#suckless
cd config/dmenu
```

Let's change some stuff here to show what the devshell does again

```c
static const char *fonts[] = {
	"JetBrainsMono Nerd Font:size=16"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
    [SchemeNorm] = { "#7dcfff", "#24283b" },
    [SchemeSel]  = { "#000000", "#7aa2f7" },
    [SchemeOut]  = { "#000000", "#7dcfff" },
};

static unsigned int lines      = 10;
```

We can run make now, and lets test our new build:

```sh
ls | ./dmenu
```

And if we wanted to apply a patch here, we would do the same thing as before.

Once we're happy with what it looks like, we can exit our shell again, but first lets make clean to get rid of the unnecessary files.

```nil
make clean; exit.
sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw
ls | dmenu
```

And there we go. We see our dmenu binary is actualy pointing to the dmenu we just built. Awesome


## Final Thoughts {#final-thoughts}

In the next installment of "NixOS From Scratch", we'll create 2 package variables, and use unstable to update stuff that we don't care if it breaks our system, and lock the core utils to stable.

This has been heavily 'programming oriented', but this will leapfrog you forward in your nixos journey. Let me know if you like this sort of content, or what else you would like to see.

Thanks so much for checking out this tutorial. If you got value from it, and you want to find more tutorials like this, check out
my youtube channel here: [YouTube](https://youtube.com/@tony-btw), or my website here: [tony,btw](https://www.tonybtw.com)

You can support me here: [kofi](https://ko-fi.com/tonybtw)
