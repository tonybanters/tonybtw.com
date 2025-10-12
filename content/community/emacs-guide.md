---
title: "Emacs Beginner Guide"
date: 2025-10-11
author: csode
tags: ["emacs", "editor", "linux", "text"]
---

> This is a quick guide on how to set emacs for a daily use if you are a beginner.
> Hopefully advanced users could also learn a thing or two.
> Guide is made with artix linux for the packages.
> But it will work the exact same on other distribution.

---

## Overview

![Basic Emacs](/img/community/emacs-guide/emacs-1.png)

## Requirments

For this guide we will:

- Use Iosevka Nerd Font.

- Our Colorscheme will be gruber darker.

### Package Setup

Install the following programs.
```bash
sudo pacman -S ttf-iosevka-nerd
```
>You can use what ever font.

# Configuration

For ease of use we will be mostly on a one file configuration.
Create a .emacs file in your home folder and open emacs and use C-x C-f.

#### Evaluation
Since emacs operates on modes will be focusing on major modes and doing basic changes.
```lisp
(tool-bar-mode 0)
```

You can go to the end of the file and do C-x C-e. To temporarily load it useful so it is easier to test.

## Base Configuration

This is the bare bones setup I think people should have.
```lisp
;; Basic Settings
(tool-bar-mode 0)
(scroll-bar-mode 0)
(menu-bar-mode 0)

;; Completion for M-x
(ido-mode 1)
(ido-everywhere 1)

;; Line Number
(column-number-mode 1)
(global-display-line-numbers-mode 1)

```

## Packages

For package manager I used [tsoding](https://github.com/rexim/dotfiles/blob/master/.emacs.rc/rc.el) that will autoload them for you after cloning them.

Save this as *****rc.el***** in your home directory.
```lisp
;; -*- lexical-binding: t; -*-
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (when (not rc/package-contents-refreshed)
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (when (not (package-installed-p package))
    (rc/package-refresh-contents-once)
    (package-install package)))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

(defun rc/require-theme (theme)
  (let ((theme-package (->> theme
                            (symbol-name)
                            (funcall (-flip #'concat) "-theme")
                            (intern))))
    (rc/require theme-package)
    (load-theme theme t)))

(rc/require 'dash)
(require 'dash)

(rc/require 'dash-functional)
(require 'dash-functional)
```

To load this file to our **.emacs** add the following
```lisp
(load-file "~/rc.el")
```

## Themeing and Fonts 

### Theme

To use [gruber-darker](https://github.com/rexim/gruber-darker-theme) Add this to your ***.emacs*** file.
```lisp
(rc/require-theme 'gruber-darker)
```

Be sure to add the following before your basic setting.
```lisp
(package-initialize)
(setq package-install-upgrade-built-in t)
```

### Font

To change your font add the following to your ***.emacs***
```lisp
(add-to-list 'default-frame-alist `(font . "IosevkaNerdFont-18"))
```

## Useful Emacs Packages

These are some of the useful emacs packages I really recommend as a new user.

### Smex

This will add more autocompletion for your M-x.
```lisp
(rc/require 'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
```

### Multiple Cursor

This is one of the greatest emacs package that will let u have multiple cursor.
```lisp
(rc/require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)
```

### Magit

This is a git client for emacs. By Far the most superior git client out there.
```lisp
(require 'seq)
(rc/require 'magit)
(setq magit-display-buffer-function
      #'magit-display-buffer-fullframe-status-v1)
```

### Company

This is a buffer autocompletion plugin
```lisp
(rc/require 'company)
(global-company-mode)
```

## Links

- Emacs-Dotfiles : https://github.com/xsoder/emacs-guide
- Tsoding        : https://github.com/rexim/dotfiles
- Magit          : https://magit.vc
- Gnu Melpa      : https://melpa.org/#/
