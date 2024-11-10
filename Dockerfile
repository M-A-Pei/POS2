# Use an official PHP runtime as the base image
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code
COPY . /var/www

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
