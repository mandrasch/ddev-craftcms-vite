
#!/bin/bash
set -ex

# ddev default commands
# see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces
ddev config global --omit-containers=ddev-router
ddev config --auto
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

if [ -f ".ddev/docker-compose.codespaces-vite.yaml" ]; then

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

# normal project setup
ddev composer install 
ddev npm install

# install craft via CLI
ddev craft install/craft \
  --interactive=0 \
  --username=admin \
  --password=newPassword \
  --email=admin@example.com \
  --site-name=Testsite

# install the vite plugin by nystudio107
ddev craft plugin/install vite

