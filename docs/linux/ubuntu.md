---
layout: default
title: Installing Ubuntu
parent: Getting Linux
nav_order: 3
---

# Installing Ubuntu
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Introduction

Ubuntu is one of the most popular Linux distros there is. It is based on Debian, and it uses the APT package manager, which while simple, will allow us to access almost any software or dependency needed.

## Requirements

To install Ubuntu you'll need:

- Ubuntu ISO image
- A 4GB or larger USB drive
- BalenaEtcher (or Rufus)

You can get the latest release of Ubuntu at:
[Ubuntu 22.04](https://releases.ubuntu.com/22.04/ubuntu-22.04-desktop-amd64.iso){: .btn .btn-purple }

The latest version of BalenaEtcher is available at:

[BalenaEtcher](https://www.balena.io/etcher/){: .btn .btn-green }

## Creating a Bootable drive

Mounting the ISO on Balena Etcher only takes three steps:

1. Select the downloaded ISO
2. Select your USB drive
3. Flash your device

![](../../assets/img/balena.png)


## Booting Ubuntu and installation

Boot your computer from the bootable drive by accessing the boot menu of your computer. You can try using `F2`, `F12` or `ESC` to access the boot menu. To find the correct button, find the specific instructions according to your motherboard and BIOS.

After booting from the drive, the GRUB menu will appear. Select the first option.

![](../../assets/img/grub.png)

After booting 