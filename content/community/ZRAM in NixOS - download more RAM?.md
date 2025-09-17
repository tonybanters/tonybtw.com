---
title: "ZRAM in NixOS - download more RAM?"
author: "Errium"
date: 2025-09-17
description: "You've read the title bruh"
tags: ["linux", "swap", "zram", "nixos"]
---

# ZRAM in NixOS - download more RAM?
This guide will show how to enable and set up ZRAM on a normal desktop machine (PC or laptop). Servers, smart fridges, stupid TVs, and your grandma’s wrist watch might need a different setup.

![ZRAM is only for based people](/img/community/errium/frfr.jpg)

---

## What is ZRAM?

ZRAM is a technology that compresses data in RAM. It lets you create a virtual block of memory that works like normal swap, but way faster and without using disk space.

In NixOS, ZRAM is super easy to set up through the system `configuration.nix` - literally two minutes and you're done.

---

## Why use ZRAM?

1. **Saves disk space** - no need to reserve swap space.
2. **Speed** - ZRAM is much faster than standard swap, especially with the right compression algorithm.
3. **Reduces SSD wear** - self explanatory.

---

## ZRAM quirks

1. If you have a laptop and want hibernation, you still need a swap partition the size of your RAM.
2. Can use more CPU for compressing/decompressing data. But with the right algorithm, it’s mostly negligible.

---

## Setting up ZRAM on NixOS

### Step 1: Enable ZRAM

```nix
{
  zramSwap = {
    enable = true;
  }
}
```

…but that would be a shitty guide if I didn’t explain how to actually tune it for your system.

---

### Step 2: Set priority

Set a priority so the system uses ZRAM when swap is needed. You *can* skip this, but I strongly recommend specifying it:

```nix
{
  zramSwap = {
    ...
    priority = 100; # example value
  }
}
```

* Default swap priority is usually `-2`. You can check that with `swapon --show` command.
* Priority set to 100 is usually enough; no need to go higher unless you have a good reason.

---

### Step 3: Pick an algorithm

Algorithms are really important if you want yourself the best ZRAM config. Here’s what NixOS offers:

1. **zstd (Zstandard)** - as the name implies it's a standard algorithm. Good compression, but uses CPU more than other algorithms do. The price to pay is small, but can matter on low-powered machines.
2. **lz4** - compresses less than zstd, but a lot faster and uses less CPU.
3. **lzo** - compresses even less than lz4, very fast, minimal CPU usage.
4. **lz4hc** - compresses more than lz4 but less than zstd, faster than zstd, slower than lz4, more CPU usage than lz4.

Other algorithms exist and are available in `configuration.nix`, but these four are enough for any machine.

> “Which algorithm should I pick?! I don’t get it”
> - lz4. In 99% of cases, it’s fine. Fast, light, still compresses well.

Enable an algorithm:

```nix
{
  zramSwap = {
    ...
    algorithm = "lz4"; # example, pick what you need
  }
}
```

---

### Step 4: Set memoryPercent

`memoryPercent` sets the MAX amount of RAM ZRAM can use. Important: **ZRAM does not steal your RAM**. It only compresses memory *when swap is actually needed*.

* Example: 16GB RAM, `memoryPercent = 50` → it won’t grab 8GB right away. It just means ZRAM can compress up to 8GB if swap is needed.

**Simple examples:**

* Need 300MB swap → ZRAM (lz4) compresses around 150MB RAM
* Need 7GB swap → ZRAM compresses \~3.5GB RAM
* Need 20GB swap → ZRAM tries 10GB, but limit is 8GB → only 8GB compressed, rest is like swap ran out

When idle, ZRAM does nothing - your RAM is fully yours.

Set it in config:

```nix
{
  zramSwap = {
    ...
    memoryPercent = 50; # example value
  }
}
```

---

### Step 5: Make sure that everything is good

In the end your ZRAM config should look something like this:

```nix
{
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };
}
```
This configuration is solid and should work just fine. This is what I rock on my main machine.

---

## Final steps

After declaring ZRAM in your config:

```bash
sudo nixos-rebuild switch
```
*...Or whatever, you know how to rebuild...*

Reboot. It's needed, frfr. 

Then you cab check ZRAM status and make sure that all is in fact good:

```bash
swapon --show
```

---

## That's it!

Thanks everyone! Love your mom, and use ZRAM!

