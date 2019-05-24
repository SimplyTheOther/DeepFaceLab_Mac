# Installation via script

Clone the repository and run one of the ``osx-[type]-installer.sh`` scripts from the root directory of DeepFaceLab_Mac.

Don't directly run ``osx-base-installer.sh`` - this just installs shared dependencies and will not lead to a full installation.

Note that you will either need all non-Python library dependencies already installed or a package manager like Homebrew or MacPorts in order to use these scripts.

Non-Python library dependencies include:
* Python 3 itself
* cmake
* ffmpeg
* Xcode/Xcode Command Line Tools, etc.

# Installation via Anaconda (untested)

This is probably possible given Anaconda has a Mac version but I haven't figured it out. Here's the Linux version.

### Install Anaconda3
Download the installer for Python 3.7 at [https://www.anaconda.com/distribution/#linux](https://www.anaconda.com/distribution/#linux). 

Initialize conda for your shell.
```bash
export PATH=~/anaconda3/bin:$PATH
conda init bash
# Restart your shell
```

### Install DeepFaceLab

```bash
conda create -y -n deepfacelab python=3.6.6 cudatoolkit=9.0 cudnn=7.3.1
conda activate deepfacelab
git clone https://github.com/SimplyTheOther/DeepFaceLab_Mac.git
cd DeepFaceLab_Mac
python -m pip install -r requirements-cuda.txt
```

# Native Installation Instructions

## Installation for Ubuntu 16.04

An installation script has been created to automatically install all of the required dependencies for Ubuntu 16.04. Clone the repository and run ``ubuntu16.04-cuda9-installer.sh`` from the root directory of DeepFaceLab_Linux. 

## Installation for Ubuntu 18.04

#### Add NVIDIA package repositories
```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-get update
```

#### Install NVIDIA Video Driver
```bash
sudo apt-get install --no-install-recommends nvidia-driver-418
```
**Reboot your system.**

For this method, we will create an Ubuntu 16.04 container on your system. In order to do this, we will need to install and configure LXD. 
```bash
sudo snap install lxd
sudo lxd init
sudo adduser "$USER" lxd
```
**Reboot or logout so the new group membership can take effect**

After you have finished installing and configuring lxd to your needs. We will now need to create the container. 

```bash
echo "root:$UID:1" | sudo tee -a /etc/subuid /etc/subgid #Only run once and never again!
wget https://blog.simos.info/wp-content/uploads/2018/06/lxdguiprofile.txt #Thanks to Simos Xenitellis for his GUI LXC profile!
lxc profile create gui
cat lxdguiprofile.txt | lxc profile edit gui
lxc launch --profile default --profile gui ubuntu:16.04 deepfacelab
# Wait 30s so the environment can fully setup without issue.
# Logging in before the inital setup is done can cause problems.
# The next command will fix the DeepFaceLab GUI to allow it to show up correctly.
lxc exec deepfacelab -- sh -c "echo 'export QT_X11_NO_MITSHM=1' >> /home/ubuntu/.bashrc"
```

You can now access your container at any time with the following command
```bash
lxc exec deepfacelab -- su ubuntu
```

While in the container, change to your home directory with ``cd ~\`` and then run the installation instructions for Ubuntu 16.04 and you will have created an identical environment.

**WARNING: Make sure you install the same video driver in the container as installed in the host!**
