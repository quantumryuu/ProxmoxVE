# Community Helper scripts for developing LXCs
## How to use

 1. Start by forking the repository (community-scripts/ProxmoxVE)
 2. Download the three scripts provided:
	 - new_lxc.sh
	 - cleanup_lxc.sh
	 - change_lxc.sh
 3. Make them executable by running:
`chmod u+x ./new_lxc.sh && chmod u+x ./cleanup_lxc.sh && chmod u+x ./change_lxc.sh`.
 4. Edit all three scripts and change `quantumryuu` located in line #3 to your GitHub account name.
 5. Run `./new_lxc.sh` and provide the LXC name when asked.
 6. After pushing the last changes, make sure to run `cleanup_lxc.sh`.
 7. After running `cleanup_lxc.sh` push the changes to your LXC branch and create a PR!

## Scripts walkthrough
### new_lxc.sh
1. Asks for LXC name.
2. Checks if repository is cloned (automatically cloned if missing).
3. Checks for a build branch (automatically created if missing).
4. Here a lot of things happen, here's a list:
	- Grabs a fresh copy of **build.func** and **install.func**.
	- Modifies these copies so they reflect the GitHub account and the LXC branch. This is needed since it'll fail for the sole reason of not finding the LXC files because by default as you know it looks for them under the official repo.
5. Checks for the LXC branch (automatically created if missing).
6. Grabs a copy of `evcc.sh & evcc-install.sh` as templates, renames them to the LXC name provided and changes the `source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)` to reflect to the GitHub account and LXC name like the build files above.
7. Lastly it pushes the changes and you're ready to start creating the script!

### cleanup_lxc.sh - Should be used just before creating a PR.
1. Asks for LXC name.
2. Checks if repository is cloned (automatically cloned if missing).
3. Checks for the LXC branch (exits if not found).
4. Cleans up the following files of the LXC branch:
	 - LXC-install.sh - Removes empty last line.
	 - LXC.sh - Removes empy last line && reverts to `source <(curl -s https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)`. 
	 - LXC.json - Removes empty last line.

### [WIP] change_lxc.sh - Used to change between LXC branches (modifies build.func and install.func from build branch)
1. Asks for LXC name.
2. Checks if repository is cloned (automatically cloned if missing).
3. Checks for the LXC branch (exits if not found).
4. Grabs a fresh copy of **build.func** and **install.func**.
5. Modifies said copies to point to the LXC name
