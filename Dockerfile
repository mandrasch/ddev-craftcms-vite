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
    php8.2-bcmath \
    && apt-get clean

# Install Composer globally if it's not installed
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Switch back to the default user to avoid running as root
USER www-data

# Set working directory to the CraftCMS project root
WORKDIR /var/www/html

# Copy the project files to the container
COPY ./ /var/www/html

# Run Composer install to install dependencies
RUN composer install --no-dev --optimize-autoloader

# Ensure the correct permissions for storage and web/assets
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/web/assets

# Expose ports (optional, for debugging purposes)
EXPOSE 80 443

# Start PHP-FPM and Nginx (they are in the same container)
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]   