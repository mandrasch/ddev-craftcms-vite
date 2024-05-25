#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Workaround for Vite:
# Normally expose port 5173 for Vite in .ddev/config.yaml, but ddev-router 
# is not used  on Gitpod / Codespaces, etc. The Routing is handled by Gitpod /
# Codespaces itself. Therefore we will create an additional config file for 
# DDEV which will expose port 5173 without ddev-router.
cp .gitpod/templates/docker-compose.vite-workaround.yaml .ddev/.

# Start the DDEV project 
# (will automatically get URL from env, adds db connection to .env)
export DDEV_NONINTERACTIVE=true
ddev start -y

# Prepare Laravel website
ddev composer install
ddev npm install

ddev craft install/craft \
  --interactive=0 \
  --username=admin \
  --password=newPassword \
  --email=admin@example.com \
  --site-name=Testsite

# You could also remove it here and run this in terminal, it will just prompt for your password:
# ddev craft install/craft --username=admin --email=admin@example.com --site-name=Testsite

# If craft was also installed (e.g. when you do a rebuild/full rebuild), this command
# will just state "craft already installed". 

# install the vite plugin by nystudio107 after fresh install
ddev craft plugin/install vite

# Further steps - you could also import a database here:
# ddev import-db --file=dump.sql.gz
# if you import a dump, you might need:
# ddev craft setup/keys
# or use 'ddev pull' to get latest db / files from remote
# https://ddev.readthedocs.io/en/stable/users/providers/