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

# Check if build branch exists.
build_branch=$(git ls-remote origin build)
if [[ ! -z ${build_branch} ]]; then
    echo "Build branch exists!"
else
echo "Creating build branch"
git checkout -b build main -q
git add . &>/dev/null
git commit -am "build branch creation" &>/dev/null
git push --quiet -u --no-progress origin build 
fi

# Check if branch exists.
check_branch=$(git ls-remote origin ${LXC_Name})
if [[ ! -z ${check_branch} ]]; then
    echo "${LXC_Name} exists. Exiting..."
    exit
else

# Change branch and refresh
echo "Changing branch to build and pulling changes."
git checkout build -q
git pull -q

# Reset files
echo "Resetting build files."
curl -s "https://raw.githubusercontent.com/community-scripts/ProxmoxVE/refs/heads/main/misc/build.func" > ~/ProxmoxVE/misc/build.func
curl -s "https://raw.githubusercontent.com/community-scripts/ProxmoxVE/refs/heads/main/misc/install.func" > ~/ProxmoxVE/misc/install.func

# Changing build files to project
echo "Changing build files for ${LXC_Name}."

#install.func file change
sed -i "s/community-scripts\/ProxmoxVE\/raw\/main/$LXC_GHUSERNAME\/ProxmoxVE\/raw\/$LXC_Name/g" ~/ProxmoxVE/misc/install.func

#build file change
#var_install replace
sed -i "s/community-scripts\/ProxmoxVE\/main\/install\//$LXC_GHUSERNAME\/ProxmoxVE\/refs\/heads\/$LXC_Name\/install\//g" ~/ProxmoxVE/misc/build.func
#install_func change
sed -i "s/community-scripts\/ProxmoxVE\/main\/misc\/install.func/$LXC_GHUSERNAME\/ProxmoxVE\/build\/misc\/install.func/g" ~/ProxmoxVE/misc/build.func

# Commiting
echo "Pushing changes."
git add . &>/dev/null
git commit -m "${LXC_Name}" &>/dev/null
git push -q

# Create new branch
echo "Creating new branch for ${LXC_Name}."
git checkout -b ${LXC_Name} main -q

# Create required files
echo "Creating ct and install files."
curl -s "https://raw.githubusercontent.com/community-scripts/ProxmoxVE/refs/heads/main/ct/evcc.sh" > ~/ProxmoxVE/ct/${LXC_Name}.sh
sed -i "s/community-scripts\/ProxmoxVE\/main\/misc\//$LXC_GHUSERNAME\/ProxmoxVE\/refs\/heads\/build\/misc\//g" ~/ProxmoxVE/ct/${LXC_Name}.sh
curl -s "https://raw.githubusercontent.com/community-scripts/ProxmoxVE/refs/heads/main/install/evcc-install.sh" > ~/ProxmoxVE/install/${LXC_Name}-install.sh

# Push new files
echo "Pushing created files."
git add . &>/dev/null
git commit -am "${LXC_Name}" &>/dev/null
git push --quiet -u --no-progress origin "${LXC_Name}" 

echo "Done!"
fi