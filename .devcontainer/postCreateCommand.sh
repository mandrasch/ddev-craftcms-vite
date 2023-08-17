
#!/bin/bash
set -ex

# debug output for https://github.com/orgs/community/discussions/63776#discussioncomment-6731616
docker context ls
# echo $PATH
docker ps

# This file is called in three scenarios:
# 1. fresh creation of devcontainer
# 2. rebuild
# 3. full rebuild

# ddev default commands
# see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces

# important, since ddevs internal routing is not usable on codespaces
ddev config global --omit-containers=ddev-router

# this is not necessary since we already have a .ddev/config.yaml in this project
# ddev config --auto

# optional, just a quick speedup trick to have all needed images available
ddev debug download-images

# Rebuilds (not full rebuilds) are a bit tricky since some docker containers 
# are still there on restart, maybe this needs more improvement in future.
# See: https://github.com/ddev/ddev/issues/5071#issuecomment-1620570680
ddev poweroff

# Workaround for vite:
# We expose port 5174 for vite on codespaces, because ddev-router is not used  on codespace instances. 
# Routing is handled by codespaces itself. This will  create an additional config file for DDEV 
# which will expose port 5174. This port needs to be set to  public + HTTPS manually in ports tab, 
# otherwise CORS errors will occur. See config/vite.php and vite.config.js as well. 

if [ ! -f ".ddev/docker-compose.codespaces-vite.yaml" ]; then
    echo "Creating vite port workaround file for port exposing ..."
    # create workaround file for port exposing (if it does not exist yet)
    # info: this file should not be commited to git since it shouldn't be used on local DDEV
    cat >.ddev/docker-compose.codespaces-vite.yaml <<EOL
services:
  web:
    ports:
    - 5174:5174
EOL

fi

# start ddev project
ddev start -y

# DDEV will automatically set the codespaces preview URL in .env. 
# If this is not working in future, you can use this snippet for replacement:
# ddev exec 'sed -i "/PRIMARY_SITE_URL=/c APP_URL=$DDEV_PRIMARY_URL" .env'

# Current workaround for https://github.com/ddev/ddev/issues/5256, can be removed later
ddev exec 'sed -i "s/preview.app.github.dev/app.github.dev/g" .env'

# normal project setup
ddev composer install 
ddev npm install

# you could also perform a `ddev pull` here to get an existing remote database 

# the following is just an example, you could also remove it here and run this in codespaces terminal,
# it will just prompt for your password:
# ddev craft install/craft --interactive=0 --username=admin --email=admin@example.com --site-name=Testsite

# install craft via CLI
ddev craft install/craft \
  --interactive=0 \
  --username=admin \
  --password=newPassword \
  --email=admin@example.com \
  --site-name=Testsite

# if craft was also installed (e.g. when you do a codespaces rebuild/full rebuild), this command
# will just state "craft already installed". 

# install the vite plugin by nystudio107
# TODO: remove later, save activation of plugin in project config 
ddev craft plugin/install vite

