#!/bin/bash
set -Eeuo pipefail

#!/bin/bash
# Load package dialog if it is not installed
pkgs='dialog'
if ! dpkg -s $pkgs >/dev/null 2>&1; then
sudo apt-get install -y $pkgs
fi

# Dialog stuff
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "Update" on    # any option can be set to default to "on"
         2 "Upgrade" on
         3 "Full Upgrade" off
         4 "Install GIT" off
         5 "Install ZSH (Oh-My-ZSH)" off
         6 "Install Docker" off
         7 "Install Docker-Compose" off
         8 "Add current user to docker group" off
         9 "Start Portainer in Docker" off
         10 "STILL TO COME!! - Start Portainer in Docker-Compose Stack SYS with others" off
         11 "Add .bash_aliases function" off
         12 "Install Python3 and PIP3" off
         20 "REBOOT WITHOUT ASKING!!!" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            sudo apt-get -y update
            ;;
        2)
            sudo apt-get -y upgrade
            ;;
        3)
            sudo apt-get -y full-upgrade
            ;;
        4)
            sudo apt install -y git
            git --version
            ;;
        5)
            # bash SUB/ZSH/first-inst-zsh.sh
            ;;
        6)
            echo "----- Install docker"
            sudo apt install -y docker.io
            sudo systemctl enable --now docker
            docker --version
            docker run hello-world
            ;;
        7)
            echo "----- Install docker-compose"
            sudo apt install -y docker-compose
            docker-compose version
            ;;
        8)
            echo "Add current user to docker group"
            sudo usermod -aG docker ${USER}
            ;;
        9)
            echo "----- Portainer"
            echo "----- Create Volume for Portainer"
            docker volume create portainer_data
            echo "----- Run Portainer"
            docker run -d -p 9000:9000 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
            ;;
        10)
            echo "The function to mount stack SYS is still to come!"
            ;;
        11)            
            # This is to make it global for bash. You need to enter your user password. Works only if you are a sudoer.
            ;;
        12)
            sudo apt install -y python3-pip
            pip3 --version
            echo "As for the installation of Python3 you should already have it installed with the OS"
            echo "If not use: sudo apt-get install python3.6 or whatever is current."
            ;;
        20)
            sudo reboot now
            ;;
     esac
done
