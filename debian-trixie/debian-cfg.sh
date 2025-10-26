#!/bin/bash

# Katerina's debian package installation script.
# The minimum of what I typically need, I guess.

# This script is a little dumb and assumes that
# this is a very, VERY fresh install. My advice
# is to ideally use it only in that context/env


# We're logging everything so when packages eat
# the asphalt, they can be installed from other
# sources. Thankies to Michal Zielinski for the
# memory jog on file descriptors during the god
# awful brainfog I'm experiencing at the moment
LOGFILE="pkglog.log"
exec 3>&1 1>"$LOGFILE" 2>&1


# The AppImage Zone. A recommendation, perhaps,
# could be to use the AppimageLauncher package,
# but it appears to be not recommended nowadays
mkdir ~/Applications
wget -O Feishin.AppImage https://github.com/jeffvli/feishin/releases/latest/download/Feishin-linux-x86_64.AppImage
chmod +x ~/Applications/Feishin.AppImage


# Everything below this uses privs.
# Request sudo since we really kinda need that.
[[ "$EUID" == 0 ]] || exec sudo -s "$0" "$@"

# Needed for wine
dpkg --add-architecture i386

# Naturally
apt update


# These just aren't available on the debian repo
# so I'm grabbing them here instead.I've grabbed
# Vivaldi because it seems to be the least awful
# of the various chromium derivatives.
wget https://downloads.vivaldi.com/stable/vivaldi-stable_7.6.3797.56-1_amd64.deb
# *sigh* Mirosoft....
wget -O vscode.deb https://go.microsoft.com/fwlink/?LinkID=760868


# Go.
for i in $(cat installpkgs); do sudo apt install -y $i; done

# Download and Run the NVM installer
wget https://raw.githubusercontent.com/nvm-sh/nvm/releases/latest/install.sh | bash

# Add the base flathub repository.
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo



# Done with package installation. Cleanup time~!
rm *.deb
rm install.sh

# Echo this out
echo "
Installation Script completed.

A Reminder: Flatpak install may require a reboot"
