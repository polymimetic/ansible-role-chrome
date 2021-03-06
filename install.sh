#! /usr/bin/env bash
set -e
###########################################################################
#
# Chrome Bootstrap Installer
# https://github.com/polymimetic/ansible-role-chrome
#
# This script is intended to replicate the ansible role in a shell script
# format. It can be useful for debugging purposes or as a quick installer
# when it is inconvenient or impractical to run the ansible playbook.
#
# Usage:
# wget -qO - https://raw.githubusercontent.com/polymimetic/ansible-role-chrome/master/install.sh | bash
#
###########################################################################

if [ `id -u` = 0 ]; then
  printf "\033[1;31mThis script must NOT be run as root\033[0m\n" 1>&2
  exit 1
fi

###########################################################################
# Constants and Global Variables
###########################################################################

readonly GIT_REPO="https://github.com/polymimetic/ansible-role-chrome.git"
readonly GIT_RAW="https://raw.githubusercontent.com/polymimetic/ansible-role-chrome/master"

###########################################################################
# Basic Functions
###########################################################################

# Output Echoes
# https://github.com/cowboy/dotfiles
function e_error()   { echo -e "\033[1;31m✖  $@\033[0m";     }      # red
function e_success() { echo -e "\033[1;32m✔  $@\033[0m";     }      # green
function e_info()    { echo -e "\033[1;34m$@\033[0m";        }      # blue
function e_title()   { echo -e "\033[1;35m$@.......\033[0m"; }      # magenta

###########################################################################
# Install Chrome
# https://www.google.com/chrome/
#
# https://www.linuxbabe.com/ubuntu/install-google-chrome-ubuntu-16-04-lts
# http://www.pontikis.net/blog/setup-google-chrome-on-ubuntu-16.04
# https://developer.chrome.com/extensions/external_extensions
# https://www.eff.org/deeplinks/2015/11/guide-chromebook-privacy-settings-students
# https://decentraleyes.org/configure-https-everywhere/
###########################################################################

install_chrome() {
  e_title "Installing Chrome"

  local chrome_files="${SCRIPT_PATH}/files/chrome"

  local chrome_extensions=(
    cjpalhdlnbpafiamejdnhcphjbkeiagm # uBlock
    hdokiejnpimakedhajhdlcegeplioahd # Lastpass
    # nngceckbapebfimnlniiiahkandclblb # Bitwarden
    gcbommkclmclpchllfjekcdonpmejbdp # HTTPs Everywhere
    pkehgijcmpdhfbdbbnkijodmdjhbjlgp # Privacy Badger
    ldpochfccmkkmhdbclfhpagapcfdljkj # DecentralEyes
  )

  # Install google-chrome
  wget -qO - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt-get update
  sudo apt-get install -yq google-chrome-stable

  # Configure chrome preferences
  if [[ -d "${HOME}/.config/google-chrome/Default"  ]]; then
    rm -r "${HOME}/.config/google-chrome/Default"
  fi
  mkdir -p "${HOME}/.config/google-chrome/Default"
  cp "${chrome_files}/Preferences" "${HOME}/.config/google-chrome/Default"

  # Configure chrome extensions
  if [[ ! -d "/usr/share/google-chrome/extensions/ " ]]; then
    sudo mkdir -p "/usr/share/google-chrome/extensions/ "
  fi

  for i in ${chrome_extensions}; do
    sudo cp "${chrome_files}/extension.json" "/usr/share/google-chrome/extensions/ /$i.json"
  done

  e_success "Chrome installed"
}

###########################################################################
# Program Start
###########################################################################

program_start() {
  install_chrome
}

program_start