---
title: "Example Community Article: My Minimal DWM Rice"
date: 2025-09-15
author: your-handle
tags: ["dwm", "rice", "linux", "dotfiles"]
# Put this file at: content/community/<your-title>.md
# Screenshots should live under: static/img/community/<your-name>/
---

> This is an example of how to contribute to the **community** section of tonybtw.com.
> Share a Linux tip, a rice showcase, or a small guide others will enjoy.

---

## Short Description
A lightweight DWM setup using JetBrainsMono Nerd Font, Gruvbox colors, and a few small patches.

## Screenshots
Place images in the repo at:
```
static/img/community/<your-name>/<file>.png
```

Then reference them in your Markdown like this (Hugo will serve from `/img/...`):
```
![My DWM rice](/img/community/your-name/dwm-rice.png)
```
![Bugs DWM rice](/img/community/your-name/dwm-rice.png)

## What This Is
- A quick write-up of your setup or tutorial.
- Keep it reproducible and concise.
- Link out to full dotfiles instead of dumping huge configs here.

## Steps / Explanation
1) Install DWM from source.

2) Apply a couple of patches (e.g., vanity gaps, systray).  
   Example snippet for fonts in `config.h`:
```
static const char *fonts[] = {
    "JetBrainsMono Nerd Font Mono:style=Bold:size=14",
};
```

3) Set some Gruvbox colors in `config.h`:
```
static const char col_gray1[] = "#282828";
static const char col_gray2[] = "#3c3836";
static const char col_gray3[] = "#ebdbb2";
```

4) Rebuild and start DWM. Include a short note on any keybinds you changed and why.

## Tips for Good Submissions
- Use fenced code blocks (three backticks) for configs and commands.
- Add 1–2 screenshots (compressed PNG/JPEG/WebP is best).
- Include a one-sentence summary at the top and a few tags.

## Links
- Full dotfiles: https://github.com/yourname/dotfiles
- DWM homepage: https://dwm.suckless.org

---
**File placement recap**
- This file: `content/community/example.md`
- Your images: `static/images/community/<your-handle>/...`
- In Markdown, link images as: `/images/community/<your-handle>/<file>.png`

