
#!/bin/bash
set -ex

# ddev default commands
# (see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces)
ddev config global --omit-containers=ddev-router
ddev config --auto
ddev debug download-images

# rebuilds (not full rebuilds) are a bit tricky since some docker containers 
# are still there on restart, see https://github.com/ddev/ddev/issues/5071#issuecomment-1620570680 (WIP)
ddev poweroff

# start ddev project
ddev start -y

# TODO: is this done automatically anyhow?
# replace primary site url with GitHub Codespaces URL (dynamic)
ddev exec 'sed -i "/PRIMARY_SITE_URL=/c APP_URL=$DDEV_PRIMARY_URL" .env'

# expose port 5174 for vite on codespaces, because ddev-router is not used
# on codespace instances. Routing is handled by codespaces itself. This will
# create an additional config file for DDEV which will expose port 5174. 
# Needs to be set to public + HTTPS manually, otherwise CORS errors occur.
cat >.ddev/docker-compose.codespaces-vite.yaml <<EOL
services:
  web:
    ports:
    - 5174:5174
EOL

ddev restart

# normal project setup
ddev composer install
ddev npm install

# install craft via CLI
ddev craft install/craft --interactive=0 --username=admin --password=newPassword --email=admin@example.com --site-name=Testsite
ddev craft plugin/install vite

