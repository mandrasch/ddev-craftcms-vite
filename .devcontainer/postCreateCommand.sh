
#!/bin/bash
set -ex

# This file is called in three scenarios:
# 1. fresh creation of devcontainer
# 2. rebuild
# 3. full rebuild

# ddev default commands
# see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces

# retry, see https://github.com/ddev/ddev/pull/5592
wait_for_docker() {
  while true; do
    docker ps > /dev/null 2>&1 && break
    sleep 1
  done
  echo "Docker is ready."
}

wait_for_docker

# TODO: remove, might not be needed (auto-detected)
# https://github.com/ddev/ddev/pull/5290#issuecomment-1689024764
ddev config global --omit-containers=ddev-router

# download images beforehand
ddev debug download-images

# avoid errors on rebuilds
ddev poweroff

# Workaround for Vite:
# Normally expose port 5173 for Vite in .ddev/config.yaml, but ddev-router 
# is not used  on Gitpod / Codespaces, etc. The Routing is handled by Gitpod /
# Codespaces itself. Therefore we will create an additional config file for 
# DDEV which will expose port 5173 without ddev-router.
cp .devcontainer/templates/docker-compose.vite-workaround.yaml .ddev/.

# Start the DDEV project
# (will automatically get URL from env, adds db connection to .env)
export DDEV_NONINTERACTIVE=true
ddev start -y

# normal project setup
ddev composer install 
ddev npm install

# you could also perform a `ddev pull` here to get an existing remote database 

# the following is just an example:

# install craft via CLI
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
