---
title: "Hyprland on NixOS (w/ UWSM)"
author: ["Tony", "btw"]
description: "This is a quick and painless tutorial on how to setup Hyprland on NixOS using flakes + home manager, and optionally using UWSM (the Universal Wayland Session Manager)"
date: 2025-10-08
draft: false
image: "/img/nixos-hyprland.png"
showTableOfContents: true
---

## Intro {#intro}

It's the year 20xx. Everyone's prebuilt PC at best buy comes with Linux and hyprland installed by default. The apple stores have Macbooks with a new propietary version of hyprland called iLand. Your grandson asks you, "My laptop broke, but I don't know how to re-install my operating system. Can you help me??"

What's up guys, my name is Tony, and today, I'm going to give you a quick and painless guide on setting up Hyprland on NixOS optionally with UWSM.

Hyprland is a wayland compositor that really feels like the King of beginner friendly compositors. It just works out of the box, with clean and aesthetically pleasing animations, and its getting more and more people into wayland, and linux in general. If you are converting over from a Desktop Environment such as Gnome, or Kde plasma, and you want to start with a wayland compositor, Hyprland is a great entry level choice.

Setting it up with NixOS is quite easy, so let's jump straight into the installation process.


## Installation {#installation}

We're jumping straight into the minimal iso, and we'll speed run this since you've probably seen it 3 times by now, but a written guide will be provided below the subscribe button.

First thing we need to do is run lsblk to know what our disk is named. We see its vda, so lets run

```sh
cfdisk /dev/vda
```

And let's setup 2 partitions. First one will be 1gb, and lets change the type to EFI Filesystem, which is going to be our 1 gigabyte boot partition.

Secondly, we'll just hit enter twice to use the remaining space for our root file system. Let's write, type yes, and quit here.

Now lets make the filesystems.

```sh
mkfs.ext4 -L nixos /dev/vda2
mkfs.fat -F 32 -n BOOT /dev/vda1
```

And lets mount these:

```sh
mount /dev/vda2 /mnt
mount --mkdir /dev/vda1 /mnt/boot
```

And we can type lsblk to confirm here:

```sh
[root@nixos:~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0    7:0    0  1.5G  1 loop /nix/.ro-store
sr0     11:0    1  1.6G  0 rom  /iso
vda    253:0    0   50G  0 disk
├─vda1 253:1    0    1G  0 part /mnt/boot
└─vda2 253:3    0   49G  0 part /mnt
```

And we're already ready to generate the nixos configuration file.


### Initial NixOS Config {#initial-nixos-config}

[Official NixOS Installation Handbook](https://nixos.org/manual/nixos/stable/index.html#sec-installation-manual)

Alright, we're ready to generate the config file, so let's do so with the following command:

This part is going to be a lot of configuration and text editing, so if you want everything I've put into these files, just follow along this written article.

```nil
nixos-generate-config --root /mnt
cd /mnt/etc/nixos/
```

Let's create flake.nix, and home.nix

(This is my minimal vimrc that I use even on install ISOs)

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


#### flake.nix {#flake-dot-nix}

vim flake.nix

Jumping into our flake.nix, this is where we define where our packages come from, so both configuration.nix and home.nix can inherit them through the flake and use them consistently.

Couple of things worth noting here:

1.  nixpkgs is shorthand for github:NixOS/nixpkgs/nixos-unstable
2.  inputs.nixpkgs.follows = "nixpkgs": This prevents home-manager from pulling its own version of nixpkgs, keeping everything consistent and avoiding mismatched package sets.
3.  This modules section tells our flake to build the system using configuration.nix, and to configure Home Manager for the tony user using home.nix, with some options set inline.
4.  We include home-manager as a NixOS module here because we want Home Manager to be managed by the flake itself — meaning we don’t need to bootstrap it separately, and we don’t need to run home-manager switch. Instead, everything gets applied in one go with nixos-rebuild switch.

vim flake.nix

```nix
{
  description = "Hyprland on Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.tony = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
```

We're ready to move onto our configuration.nix file.


#### configuration.nix {#configuration-dot-nix}

One of the beautiful things about NixOS is that your system is defined in various config files. You can think of it almost like of how your window manager is defined with config files, and you can port your window manager dotfiles to another distro, or another computer, and use the same keybinds/options on both machines. Well nixos has a 'config file' that lives above those window manager dotfiles from a heirerarchical perspective.

Alright, so I'm going to start off by deleting a bunch of comments.
I'll change the hostname here to \`nixos-btw\`, because I'm using NixOS, by the way.
We'll remove the wpa supplicant option and just uncomment the NetworkManager block here. If you are using wifi, keep the wpa supplicant option, and remove the NetworkManager block instead.
For my situation, I am going to chnage the timezone to America/Los Angeles.
We can delete all these proxy settings comments.

```nix
{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.getty.autologinUser = "tony";

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  users.users.tony = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    waybar
    kitty
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.05";

}

```

And we can use the getty auto login service above. Feel free to skip UWSM if you are not interested in it, as it is more or less deprecated.

Alright we're ready to move on to our home.nix.


#### home.nix {#home-dot-nix}

Let's set up our home.nix. we'll heavily modify this after installing nixos and logging in for the first time.

Just going to specify the home directory, enable git, and for a sanity check, let's setup a bash alias so we can confirm everything worked when we initially log in.

vim home.nix

```nix
{ config, pkgs, ... }:

{
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "25.05";
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };
}
```


### Install: {#install}

Alright we're finally ready to install this. We can do that with this command here, to specify the location of the flake.

```sh
nixos-install --flake /mnt/etc/nixos#nixos-btw

## type your password
nixos-enter --root /mnt -c 'passwd tony'
reboot
```

Make sure to create this password otherwise you wont be able to log in

Let's boot into our system!


## Create config file {#create-config-file}

And we see we are instantly booted into hyprland. Awesome. Let's do a little tinkering here so that our monitor is actually the correct resolution. So we see its super Q to open a terminal, and lets vim the config file. We'll clean this up later, but for now, lets just change this one line here:

To 1920x1080. For me, that should do it.

Alright, I'm going to clone a couple of my dotfiles for my terminal, my hyprland and my waybar configurations. This video is more of a how to install hyprland on nixos video, and I'll show a really cool nix feature after.

```sh
mkdir ~/nixos-dotfiles/config
cd ~/nixos-dotfiles/config
git clone https://github.com/tonybanters/hypr
git clone https://github.com/tonybanters/waybay
git clone https://github.com/tonybanters/foot
```

So in home.nix lets specify that our configs are going to come from config like so:

```nix
home.file.".config/hypr".source = ./config/hypr;
home.file.".config/waybar".source = ./config/waybar;
home.file.".config/foot".source = ./config/foot;
```

And we can rebuild like so:

```nil
sudo nixos-rebuild swith --flake ~/nixos-dotifles#hyprland-btw
```


## Nix Search TV {#nix-search-tv}

So we messed around with nix shells already, lets actually show something that I use on a daily basis, called nix-search-tv. This guide was written up by my friend Emzy, and we can use it to install a great tool that helps us search for nix packages, and use commands to just jump right into a nix shell.

So let's add this to our home manager packages list:

```nix
#home.nix

home.packages = with pkgs; [
  (pkgs.writeShellApplication {
    name = "ns";
    runtimeInputs = with pkgs; [
      fzf
      nix-search-tv
    ];
    text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
  })
];

```

Now we can rebuild/switch again, and run ns to demo this. Incredible


## Outro {#outro}

Alright, thats gonna be it for todays video. If you have any questions or recommendations on any other linux related content, as usual just drop a comment.

It wouldn't be a proper video without an obligatory neofetch.
