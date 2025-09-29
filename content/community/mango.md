---
title: "Mango WM"
description: "Your answer to DWM on Wayland"
logo: /img/community/argos/mango-logo.png
date: 2025-09-26
author: 🐢 argos nothings
tags: ["mango", "linux", "compositors"]
---
---

## Purpose
Over the last few weeks I have found myself hunting for the perfect window manager. Trying, qtile, niri, dwm, dwl, hyprland (of course), and several others. I have found that all of them tend to accell at a specific thing but end up lacking in one of more other features that I consider necessary for my workflow. Currently Mango satisfies all my requirements all while having active development, making it appealing to me in particular. This article is mainly just a showcase of tags and mango in general features mango provides. Hopefully this article can at least be an introduction to mango as a viable alternative to the other window managers. 

## Dynamic Window Managers
What makes DWM different from i3? The first thing that may come to mind will likely be the process of patching a new feature into DWM, or editing your config through a header file. A philosophy around directness of software over usability; KISS at its truest. Is it simple to work with as a user? No. But it is *simple*.

Unfortunately this has nothing to do with what makes something a dynamic compositor. So what is *dynamic*?

## Tags 
hyprland has these. right?
!["Hyprland has these! Right?"](/img/community/argos/scrshot1.png)

At first glance what you are seeing appears to be a workspace with two windows in it, Side by side. But this is a bit of a farce. If you notice, there are, instead 2 highlighted numbers for your "workspace" bar.

To work on this article I haven't created a special workspace for my workflow, but instead I have built it up from separate "tags". On demand. Tags allow you to dynamically view multiple windows at once, or you can treat tags exactly like workspaces and just switch to them one at a time. You can also simply work within a single tag, adding more windows to that tag and treating it as you would a i3/sway/hyprland workspace.

# Layouts
Layouts are nothing new in window managers, but in dynamic tilers like mango become very powerful because of two things: 

1. Windows exist independant of the layout it is in - Layouts are effectively owned by the tag itself. 
2. You can view the same window in multiple ways if you change the tags layout, or view multiple windows from different tags under a specific tags layout

### A Simple Example
!["Simple Example in Mango"](/img/community/argos/gif1.gif)

In the above gif I have 3 tags. 
1. Tag 1 is a vertical grid layout with btm monitoring
2. Tag 2 is a vertical scrolling layout with ns
3. Tag 3 is a tile layout with *2* windows. Neovim and a terminal that is running "yes"

With tags we can view multiple windows from different layouts simultaneously, in this case I do that through a comboview, explained in the linked github for this article. The first tag selected will determine the layout, and subsequent selected tags will simply carry their windows to your view.

For DWM users you'll find a lot of the things you would have originally needed patching and a bit of elbowgrease to accomplish exist out of the box. Configuration is done in a standard .conf file, with an autostart.sh acting asa a startup for compositor start. See https://github.com/DreamMaoMao/mangowc/wiki

There is much more you can do specifically in mango, of course.
![](/img/community/argos/gif2.gif)

Maybe you are missing how niri does scrolling layouts? We can sort of emulate this behavior with the scrolling layouts, both vertical and horizontal are available. 
![](/img/community/argos/gif3.gif)

Do you need a scratchpad?
Both named and i3 style stratchpads are available. In addition they let you toggle or launch a new instance by app or title id
![](/img/community/argos/gif4.gif)

That's all! This might be the first of a few articles I do on Mango or perhaps window managers in general. I have included two links. The first is a very simple DWM clone config of mango with hopefully unopinionated other binds to showcase 2 extra layouts. 

## Important Links
- My DWM Mango Config: https://github.com/argosnothing/mango-dwm-config
- Mango Github: https://github.com/DreamMaoMao/mangowc

---
