#!/bin/bash
# check if the reboot flag file exists. 
if [ ! -f /var/run/resume-after-reboot_dist1 ]; then
  echo "running script for the first time.."
  
#Get Release
uname -a
lsb_release -a

#Update Package Sources
sudo apt update -y

#Set Flags for Unattended Installation and Removal of Packages and do a dist-upgrade do get the latest packages for that release.
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages

#Install the Update Manager if not present
sudo apt install update-manager-core -y

#Sync Write Buffer before reboot
sudo sync

# Preparation for reboot
script="bash /upgrade.sh"
  
# add this script to .bashrc so it gets triggered immediately after reboot
echo "$script" >> ~/.bachrc
  
# create a flag file to check if we are resuming from reboot.
  sudo touch /var/run/resume-after-reboot_dist1
 
#reboot 1. Time
  echo "rebooting.."
  sudo reboot
    
else 
  echo "resuming script after reboot.."
  
  # Remove the line that we added in bashrc
  sed -i '/bash/d' ~/.bashrc 
  
  # remove the temporary file that we created to check for reboot
  sudo rm -f /var/run/resume-after-reboot_dist1

  #Make the release Upgrade
  sudo do-release-upgrade -f DistUpgradeViewNonInteractive
  
fi
