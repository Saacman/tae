---
layout: default
title: Install via script
parent: Installing the Tools
nav_order: 1
permalink: /docs/getting-linux/w10
---

# Bash script to install the tools

To install all the needed tools and the PDK, use one of the following options:

**Via wget**
```bash
bash -c "$(wget https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh -O -)"
```

**Via curl**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh)"
```
