---
title: "Nix Package Hunting on The Big Screen"
date: 2025-09-18
author: "Emzy"
description: "A Better Way to Discover Nix Packages"
tags: ["nix", "nixos", linux", "cli"]
---

# Tuning in to nix-search-tv
Nix-search-tv is a terminal tool that allows you to fuzzy search through nix packages, nixos options and even home-manager.
This guide will show you how to setup nix-search-tv with fzf/television integration.

![nix-search-tv showcase](/img/community/emzy/nix-search-tv-showcase.png)

---

## Install Methods

### Barebones

One way to install nix-search-tv is to add it to your system packages.

```nix
environment.systemPackages = with pkgs; [
    nix-search-tv
];
```

Installing this way is very barebones and running nix-search-tv would only print out all nix packages. Nix-search-tv is meant to be adaptable so it doesn't do the searching itself
but rather integrates with other general purpose fuzzy finders, such as televsion and fzf.
Next sections show how we can setup integration with [televesion](https://github.com/alexpasmantier/television) or [fzf](https://github.com/junegunn/fzf)


### Television Integration

If using home-manager. an option is already provided.

```nix
programs.nix-search-tv.enableTelevisionIntegration = true;
```

Otherwise, add `nix.toml` file to your television cables directory with the content below.

```toml
[metadata]
name = "nix"
requirements = ["nix-search-tv"]

[source]
command = "nix-search-tv print"

[preview]
command = "nix-search-tv preview {}"
```

And thats it :) you can now *tune* into nix-search-tv


### Fzf Integration

A straightforward integration might look like

```sh
alias ns="nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history"
```

But nix-search-tv already provides a more complete fzf integration script. It adds shortcuts along with the same search functionality.
Lets see how we can use it.

```nix
pkgs.writeShellApplication {
  name = "ns";
  runtimeInputs = with pkgs; [
    fzf
    nix-search-tv
  ];
  text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
}
```

Here we're using the nix writer, `writeShellApplication` instead of the typical `writeShellScriptBin` as it allows us to specify runtime dependencies of the script,
without this fzf would need to be installed in your config and in PATH.

## That's it

You can now enjoy the greatness of fuzzy search and avoid opening up your browser. Spread the gospel and stay safe :)  
_PS: both integrations are executable with `ns`_

---

## Links
- nix-search-tv: https://github.com/3timeslazy/nix-search-tv
- television: https://github.com/alexpasmantier/television
- fzf: https://github.com/junegunn/fzf
