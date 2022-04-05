#!/bin/bash
# check if the reboot flag file exists. 
if [ ! -f /var/tmp/resume-after-reboot_dist1 ]; then
  echo "running script for the first time.."
  
  #Get Release
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
  
  #create a flag file to check if we are resuming from reboot.
  sudo touch /var/tmp/resume-after-reboot_dist1
 
#reboot 1. Time
  echo "rebooting.."
  sudo reboot
fi 

if [[ -f "/var/tmp/resume-after-reboot_dist1" ]]; then
    echo "File exists."
     echo "resuming script after reboot.."
  
    # remove the temporary file that we created to check for reboot
    sudo rm -f /var/tmp/resume-after-reboot_dist1

   #Make the release Upgrade
   sudo do-release-upgrade -f DistUpgradeViewNonInteractive
   sudo apt autoremove -y
   sudo apt update -y
   lsb_release -a
    
fi

