
#!/bin/bash
set -ex

# This file is called in three scenarios:
# 1. fresh creation of devcontainer
# 2. rebuild
# 3. full rebuild

# ddev default commands
# see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces

# https://github.com/ddev/ddev/pull/5290#issuecomment-1689024764
ddev config global --omit-containers=ddev-router

# download images beforehand
ddev debug download-images

# avoid errors on rebuilds
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

# Current workaround for https://github.com/ddev/ddev/issues/5256, 
# can be removed later if PR is merged in next ddev version
ddev exec 'sed -i "s/preview.app.github.dev/app.github.dev/g" .env'

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

# You could also remove it here and run this in codespaces terminal, it will just prompt for your password:
# ddev craft install/craft --username=admin --email=admin@example.com --site-name=Testsite

# If craft was also installed (e.g. when you do a codespaces rebuild/full rebuild), this command
# will just state "craft already installed". 

# install the vite plugin by nystudio107 after fresh install
ddev craft plugin/install vite
