#!/bin/bash
uname -a
lsb_release -a
sudo visudo -f /etc/sudoers.d/do-release-upgrade.
sudo apt update -y
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
sudo apt install update-manager-core -y
sudo do-release-upgrade -d -f DistUpgradeViewNonInteractive
