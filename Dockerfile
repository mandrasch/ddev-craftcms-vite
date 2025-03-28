# Base image
FROM serversideup/php:8.4-fpm-nginx

# Install Composer globally if it's not installed
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory to the CraftCMS project root
WORKDIR /var/www/html

# Copy the project files to the container (CraftCMS project assumed to be in "html" directory)
COPY ./html /var/www/html

# Run Composer install to install dependencies
RUN composer install --no-dev --optimize-autoloader

# Ensure the correct permissions for storage and web/assets
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/web/assets

# Expose ports (optional, for debugging purposes)
EXPOSE 80 443

# Start PHP-FPM and Nginx (they are in the same container)
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]   