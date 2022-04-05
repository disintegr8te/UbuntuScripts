#!/bin/bash
# check if the reboot flag file exists. 
# We created this file before rebooting.
if [ ! -f /var/run/resume-after-reboot_dist ]; then
  echo "running script for the first time.."
  
uname -a
lsb_release -a
sudo visudo -f /etc/sudoers.d/do-release-upgrade.
sudo apt update -y
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" dist-upgrade -q -y --allow-downgrades --allow-remove-essential --allow-change-held-packages
sudo apt install update-manager-core -y
sudo sync

  # Preparation for reboot
  script="bash /upgrade.sh"
  
  # add this script to .bashrcso it gets triggered immediately after reboot
  echo "$script" >> ~/.bachrc
  
    # create a flag file to check if we are resuming from reboot.
  sudo touch /var/run/resume-after-reboot_dist
  
  echo "rebooting.."
  sudo reboot
    
else 
  echo "resuming script after reboot.."
  
  # Remove the line that we added in bashrc
  sed -i '/bash/d' ~/.bashrc 
  
  # remove the temporary file that we created to check for reboot
  sudo rm -f /var/run/resume-after-reboot_dist

  # continue with rest of the script
  sudo do-release-upgrade -f DistUpgradeViewNonInteractive
  
fi
