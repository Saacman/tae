---
layout: default
title: Install via script
parent: Installing the Tools
nav_order: 1
permalink: /docs/tools-guide/script
---

# Bash script to install the tools

To install all the needed tools and the PDK, use one of the following options:
<div class="code-example" markdown="1">
**Via wget**
</div>
```bash
bash -c "$(wget https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh -O -)"
```
<div class="code-example" markdown="1">
**Via curl**
</div>
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Saacman/tae/scripts/tools/installer.sh)"
```
