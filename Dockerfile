# Base image
FROM serversideup/php:8.2-fpm-nginx

# Switch to root to install dependencies
USER root

# https://serversideup.net/open-source/docker-php/docs/customizing-the-image/installing-additional-php-extensions
# Install required dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    git \
    unzip \
    && apt-get clean

# Install Composer globally if it's not installed
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add bcmath for craftcms
RUN install-php-extensions bcmath intl

# Switch back to the default user to avoid running as root
USER www-data

# Set working directory to the CraftCMS project root
WORKDIR /var/www/html

# Copy the project files to the container
COPY ./ /var/www/html

# Copy custom nginx.conf into the container nginx auto-include dir
COPY nginx-craftcms.conf /etc/nginx/conf.d/craftcms.conf

# TODO: necessary?
# Ensure the correct permissions for nginx.conf
# RUN chown -R www-data:www-data /etc/nginx/conf.d/craftcms.conf

# Run Composer install to install dependencies
RUN composer install --no-dev --optimize-autoloader

# Switch to root to install dependencies
USER root

# Ensure the correct permissions for storage 
RUN chown -R www-data:www-data /var/www/html/storage

# Switch back to the default user to avoid running as root
USER www-data

# TODO: is something needed here for serversideup?