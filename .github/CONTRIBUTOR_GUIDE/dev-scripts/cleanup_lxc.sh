#!/bin/bash
# Variables - MAKE SURE TO CHANGE!
LXC_GHUSERNAME="quantumryuu"

# Ask user for project name
read -p 'Enter project name: ' LXC_Name

# Check if repo is cloned
echo "Checking if repo exists locally."
if [ -d ~/ProxmoxVE ]; then
  echo "Repo exists locally."
else
  echo "Repo does not exist. Cloning..."
  cd ~
  git clone git@github.com:${LXC_GHUSERNAME}/ProxmoxVE.git --quiet
fi

cd ~/ProxmoxVE

# Check if branch exits.
check_branch=$(git ls-remote origin ${LXC_Name})
if [[ -z ${check_branch} ]]; then
  echo "${LXC_Name} does not exist. Exiting..."
  exit
else

  # Change branch and refresh
  echo "Changing branch to ${LXC_Name} and pulling changes."
  git checkout ${LXC_Name} -q
  git pull -q
fi

echo "Cleaning up files."
if [ -f ~/ProxmoxVE/install/${LXC_Name}-install.sh ]; then
  echo "Cleaning ${LXC_Name}-install.sh"
  sed -i '$ {/^$/d;}' ~/ProxmoxVE/install/${LXC_Name}-install.sh
else
  echo "${LXC_Name}-install.sh not found. Exiting..."
  exit
fi

if [ -f ~/ProxmoxVE/ct/${LXC_Name}.sh ]; then
  echo "Cleaning ct.sh"
  sed -i "s/$LXC_GHUSERNAME\/ProxmoxVE\/refs\/heads\/build\/misc\//community-scripts\/ProxmoxVE\/main\/misc\//g" ~/ProxmoxVE/ct/${LXC_Name}.sh
  sed -i '${/^$/d}' ~/ProxmoxVE/ct/${LXC_Name}.sh

else
  echo "${LXC_Name}.sh not found. Exiting..."
  exit
fi

if [ -f ~/ProxmoxVE/install/${LXC_Name}-install.sh ]; then
  echo "Cleaning ${LXC_Name}.json"
  sed -i '${/^$/d}' ~/ProxmoxVE/json/${LXC_Name}.json
else
  echo "${LXC_Name}.json not found. Exiting..."
  exit
fi

echo "Ready to push changes!"