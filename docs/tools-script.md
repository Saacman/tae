---
layout: default
title: Installing the Tools
nav_order: 3
has_children: false
permalink: /docs/tools-script
---

# Installing the EDA Tool set
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---


The goal of this guide is to install the open-source EDA Tool set, and configure correctly the Skywater PDK. The following apps will be installed:
1. Magic VLSI
2. Netgen LVS
3. NGSpice

## Installing apt available packages

Make sure to have git and make already installed. Since NGSpice and Netgen are available as pre-compiled packages, we can install them using apt too.

```bash
sudo apt install -y git make netgen-lvs ngspice ngspice-doc build-essential
```

## Installing Magic VLSI

Since the PDK requires Magic 8.3.177 or higher, we'll build the latest version from source. First install the required dependencies using apt.

```bash
sudo apt install -y m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev mesa-common-dev libglu1-mesa-dev
```
Then, clone the git repository, and change the working directory to cloned repository.

```bash
git clone git://opencircuitdesign.com/magic
cd magic/
```

Finally, run the configuration script, compile and install magic into the default path `/user/local/`

```bash
./configure
make
sudo make install
```

## Installing the PDK

After installing the needed tools, we can install the SkyWater PDK. Since installing the full PDK is slow and requires a lot of storage, we'll install a minimal version with the needed cells.

First we clone the Skywater repository, and initialize the needed submodules. 

<div class="code-example" markdown="1">
Warning
{: .label .label-red }
Make sure to **go back to your home directory.**
</div>

```bash
cd ~/
git clone https://github.com/google/skywater-pdk
cd skywater-pdk/
git submodule init libraries/sky130_fd_io/latest
git submodule init libraries/sky130_fd_pr/latest
git submodule init libraries/sky130_fd_sc_hd/latest
git submodule update
make timing

```

Now, clone the Open PDKs repo to configure and install the repository. Since we already cloned the PDK repo, we'll indicate the configuration script where to find it, instead of pulling the full repo.

<div class="code-example" markdown="1">
Warning
{: .label .label-red }
Make sure to **go back to your home directory.**
</div>

```bash
cd ~/
git clone git://opencircuitdesign.com/open_pdks
cd open_pdks/
./configure --enable-sky130-pdk=~/skywater-pdk
make
sudo make install
```
Now we can clean the generated files
```bash
make distclean
```

If desired, the installation repos can also ve removed to free additional storage.

```bash
cd ~/
rm -rf magic/
```

## Adding env variables to .bashrc

Copy and paste the following commands to add the environment variables to your .bashrc file.

```bash
echo "export PDK_ROOT=\"/usr/local/share/pdk/\"" >> ~/.bashrc
echo "export PDK_PATH=\"$PDK_ROOT/sky130A\"" >> ~/.bashrc
echo "alias magicsky=\"magic -T $PDK_PATH/libs.tech/magic/sky130A.tech\"" >> ~/.bashrc
source ~/.bashrc
```
Now you can use `magicsky` to run magic with the PDK tech file.