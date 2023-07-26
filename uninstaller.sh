#!/bin/bash

version="0.0.6a"


# ASCII art with color codes
printf "\n\n\e[1;31m \n"
printf "  ____  _ _   _   _ _       _         _    _       _           _        _ _            \n"
printf " |  _ \(_) | | \ | (_)     (_)       | |  | |     (_)         | |      | | |           \n"
printf " | |_) |_| |_|  \| |_ _ __  _  __ _  | |  | |_ __  _ _ __  ___| |_ __ _| | | ___ _ __  \n"
printf " |  _ <| | __| . \` | | '_ \| |/ _\` | | |  | | '_ \| | '_ \/ __| __/ _\` | | |/ _ \ '__| \n"
printf " | |_) | | |_| |\  | | | | | | (_| | | |__| | | | | | | | \__ \ || (_| | | |  __/ |    \n"
printf " |____/|_|\__|_| \_|_|_| |_| |\__,_|  \____/|_| |_|_|_| |_|___/\__\__,_|_|_|\___|_|     \n"
printf "                          _/ |                                                         \n"
printf "                         |__/                                                          \n"
printf "\n\e[0m\n"

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "[Uninstaller]> This script must be run as root to uninstall BitNinja Completely"
   echo "[Uninstaller]> sudo ./uninstall.sh [OPTIONS]"
   exit 1
fi


__usage="
Usage: $(basename $0) [OPTIONS]

Options:
  full                         Uninstall BitNinja completely
  reinstall                    Reinstall BitNinja (keep custom configurations)
  -h, --help                   Show this help message
  -v, --version                Show version information
  -d, --debug                  Enable debug mode
  -a, --appid-fix	       Fix App_Id Eror 
"

# Function to display the help message
show_help() {
  echo "$__usage"
}

fix_appid() {
  currentLicense=$(awk -F "'" '/license_key/{print $4}' /etc/bitninja/license.php)

  if [[ "$currentLicense" == "<change_me>" ]]; then
    sudo chmod u+w /etc/bitninja/license.php
    # Prompt the user to enter the new license key
    read -p "Enter your BitNinja license key: " newLicenseKey

    sed -i "s/'license_key' => '<change_me>'/'license_key' => '$newLicenseKey'/g" /etc/bitninja/license.php

    sudo chmod u-w /etc/bitninja/license.php
    echo "License key updated successfully."

  fi

  # Run the bitninjacli command and extract the instanceId using awk
  instanceId=$(bitninjacli --serverinfo | awk -F'"' '/instanceId/{print $4}')

  # Check if the instanceId is not empty
  if [[ -n "$instanceId" ]]; then
    # Insert the instanceId into /etc/bitninja/app_id
    echo "$instanceId" > /etc/bitninja/app_id
    echo "AppId fixed with the correct one: ${instanceId}"
  else
    echo "Error: Unable to fetch the instanceId from bitninjacli --serverinfo."
  fi
}



reinstall_apt() {
printf "++++####++++#+##x++++xXXX++#####+5++fsf######gj#####+++#######đ++ff########\n"
printf "\n"
printf "                     Oh no, reinstalling BitNinja?                         \n"
printf "         Please contact our support if you need assistance!                \n"
printf " Visit your dashboard at admin.bitninja.io or email at support@bitninja.io \n"
printf "\n"
printf "++++3++#####++++#258hh gllkg+9++++glglg#+++#+####XXX+######++589fsf#####g+g\n\n"
apt-get -qq purge bitninja* -y
apt-get -qq install bitninja* -y
}

reinstall_yum() {
printf "++++####++++#+##x++++xXXX++#####+5++fsf######gj#####+++#######đ++ff########\n"
printf "\n"
printf "                     Oh no, reinstalling BitNinja?                         \n"
printf "         Please contact our support if you need assistance!                \n"
printf " Visit your dashboard at admin.bitninja.io or email at support@bitninja.io \n"
printf "\n"
printf "++++3++#####++++#258hh gllkg+9++++glglg#+++#+####XXX+######++589fsf#####g+g\n\n"
yum -q remove bitninja* -y
yum -q install bitninja* -y
}

full_uninstall_apt() {
printf "++++####++++#+##x++++xXXX++#####+5++fsf######gj#####+++#######đ++ff########\n"
printf "\n"
printf "              Leaving BitNinja? Do you have an issue?                      \n"
printf "	       Pricing, High Load? Incompatibility?			   \n"
printf "         Please contact our support if you need assistance!                \n"
printf " Visit your dashboard at admin.bitninja.io or email at support@bitninja.io \n"
printf "\n"
printf "++++3++#####++++#258hh gllkg+9++++glglg#+++#+####XXX+######++589fsf#####g+g\n\n"
  apt-get -qq purge bitninja* -y
  rm -rf /var/lib/bitninja*
  rm -rf /var/log/bitninja*
  rm -rf /etc/bitninja*
  rm -rf /opt/bitninja*
  rm -rf /etc/init.d/bitninja
  rm -rf /etc/logrotate.d/bitninja
  if dpkg -l | grep -q '^ii.*bitninja'; then
    echo "[Uninstaller]> Warning: Not all BitNinja packages were removed."
  fi

  if [ -e /var/lib/bitninja ] || [ -e /var/log/bitninja ] || [ -e /etc/bitninja ] || [ -e /opt/bitninja ] || \
    [ -e /etc/init.d/bitninja ] || [ -e /etc/logrotate.d/bitninja ]; then
    echo "[Uninstaller]> Warning: Not all BitNinja files were removed."
  else
    echo "[Uninstaller]> BitNinja has been successfully uninstalled."
  fi
}

full_uninstall_yum() {
printf "++++####++++#+##x++++xXXX++#####+5++fsf######gj#####+++#######đ++ff########\n"
printf "\n"
printf "              Leaving BitNinja? Do you have an issue?                      \n"
printf "               Pricing, High Load? Incompatibility?                        \n"
printf "         Please contact our support if you need assistance!                \n"
printf " Visit your dashboard at admin.bitninja.io or email at support@bitninja.io \n"
printf "\n"
printf "++++3++#####++++#258hh gllkg+9++++glglg#+++#+####XXX+######++589fsf#####g+g\n\n"

  yum -q remove bitninja* -y
  rm -rf /var/lib/bitninja*
  rm -rf /var/log/bitninja*
  rm -rf /etc/bitninja*
  rm -rf /opt/bitninja*
  rm -rf /etc/init.d/bitninja
  rm -rf /etc/logrotate.d/bitninja
  if yum list installed | grep -q '^bitninja'; then
    echo "[Uninstaller]> Warning: Not all BitNinja packages were removed."
  fi

  if [ -e /var/lib/bitninja ] || [ -e /var/log/bitninja ] || [ -e /etc/bitninja ] || [ -e /opt/bitninja ] || \
    [ -e /etc/init.d/bitninja ] || [ -e /etc/logrotate.d/bitninja ]; then
    echo "[Uninstaller]> Warning: Not all BitNinja files were removed."
  else
    echo "[Uninstaller]> BitNinja has been successfully uninstalled."
  fi
}

# Check if lsb_release command is available
if ! command -v lsb_release &>/dev/null; then
  echo "lsb_release command not found. Unable to determine the OS."
  exit 1
fi

# Detect Distro
distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')  # Convert to lowercase for case-insensitive check

case "$1" in
  full)
    case "$distro" in
      ubuntu|debian)
        full_uninstall_apt
        ;;
      centos|redhat|almalinux|vzlinux|rocky|amazon)
        full_uninstall_yum
        ;;
      *)
        echo "Unsupported distribution: $distro"
        exit 1
        ;;
    esac
    ;;
  reinstall)
    case "$distro" in
      ubuntu|debian)
        reinstall_apt
        ;;
      centos|redhat|almalinux|vzlinux|rocky|amazon)
        reinstall_yum
        ;;
      *)
        echo "Unsupported distribution: $distro"
        exit 1
        ;;
    esac
    ;;
  -h|--help)
    show_help
    exit 0
    ;;
  -v|--version)
    echo "BitNinja Uninstaller ${version}"
    exit 0
    ;;
  -d|--debug)
	# To Be Implemented... 
    ;;
  -a|--appid-fix)
    fix_appid
    exit 0
    ;;
  *)
    echo "Invalid option: $1"
    show_help
    exit 1
    ;;
esac
