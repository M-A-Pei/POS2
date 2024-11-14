# Use PHP 8.2 as the base image
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies, PHP extensions, and Nginx
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libicu-dev \
    nginx && \
    docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code
COPY . /var/www

# Set permissions (for the whole app directory)
RUN chown -R www-data:www-data /var/www && \
    chmod -R 755 /var/www

# Configure Nginx (copying configuration files from your project)
COPY nginx/default.conf /etc/nginx/sites-available/default
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Accept build arguments for environment variables
ARG APP_NAME
ARG APP_ENV
ARG APP_KEY
ARG APP_DEBUG
ARG APP_URL
ARG LOG_CHANNEL
ARG LOG_LEVEL
ARG DB_CONNECTION
ARG DB_HOST
ARG DB_PORT
ARG DB_DATABASE
ARG DB_USERNAME
ARG DB_PASSWORD
ARG BROADCAST_DRIVER
ARG CACHE_DRIVER
ARG QUEUE_CONNECTION
ARG SESSION_DRIVER
ARG SESSION_LIFETIME
ARG MEMCACHED_HOST
ARG REDIS_HOST
ARG REDIS_PASSWORD
ARG REDIS_PORT
ARG MAIL_MAILER
ARG MAIL_HOST
ARG MAIL_PORT
ARG MAIL_USERNAME
ARG MAIL_PASSWORD
ARG MAIL_ENCRYPTION
ARG MAIL_FROM_ADDRESS
ARG MAIL_FROM_NAME
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG AWS_BUCKET
ARG PUSHER_APP_ID
ARG PUSHER_APP_KEY
ARG PUSHER_APP_SECRET
ARG PUSHER_APP_CLUSTER
ARG MIX_PUSHER_APP_KEY
ARG MIX_PUSHER_APP_CLUSTER

# Pass the environment variables to the runtime
ENV APP_NAME=${APP_NAME}
ENV APP_ENV=${APP_ENV}
ENV APP_KEY=${APP_KEY}
ENV APP_DEBUG=${APP_DEBUG}
ENV APP_URL=${APP_URL}
ENV LOG_CHANNEL=${LOG_CHANNEL}
ENV LOG_LEVEL=${LOG_LEVEL}
ENV DB_CONNECTION=${DB_CONNECTION}
ENV DB_HOST=${DB_HOST}
ENV DB_PORT=${DB_PORT}
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}
ENV BROADCAST_DRIVER=${BROADCAST_DRIVER}
ENV CACHE_DRIVER=${CACHE_DRIVER}
ENV QUEUE_CONNECTION=${QUEUE_CONNECTION}
ENV SESSION_DRIVER=${SESSION_DRIVER}
ENV SESSION_LIFETIME=${SESSION_LIFETIME}
ENV MEMCACHED_HOST=${MEMCACHED_HOST}
ENV REDIS_HOST=${REDIS_HOST}
ENV REDIS_PASSWORD=${REDIS_PASSWORD}
ENV REDIS_PORT=${REDIS_PORT}
ENV MAIL_MAILER=${MAIL_MAILER}
ENV MAIL_HOST=${MAIL_HOST}
ENV MAIL_PORT=${MAIL_PORT}
ENV MAIL_USERNAME=${MAIL_USERNAME}
ENV MAIL_PASSWORD=${MAIL_PASSWORD}
ENV MAIL_ENCRYPTION=${MAIL_ENCRYPTION}
ENV MAIL_FROM_ADDRESS=${MAIL_FROM_ADDRESS}
ENV MAIL_FROM_NAME=${MAIL_FROM_NAME}
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
ENV AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION}
ENV AWS_BUCKET=${AWS_BUCKET}
ENV PUSHER_APP_ID=${PUSHER_APP_ID}
ENV PUSHER_APP_KEY=${PUSHER_APP_KEY}
ENV PUSHER_APP_SECRET=${PUSHER_APP_SECRET}
ENV PUSHER_APP_CLUSTER=${PUSHER_APP_CLUSTER}
ENV MIX_PUSHER_APP_KEY=${MIX_PUSHER_APP_KEY}
ENV MIX_PUSHER_APP_CLUSTER=${MIX_PUSHER_APP_CLUSTER}

# Install application dependencies and set cache driver
ENV CACHE_DRIVER=file
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --no-scripts

# Expose the ports for Nginx and PHP-FPM
EXPOSE 80 9000

# Clear caches before starting
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# Start Nginx and PHP-FPM
CMD echo "runtimeeeee APP_ENV: $APP_ENV" && \
    echo "DB_HOST: $DB_HOST" && \
    echo "DB_DATABASE: $DB_DATABASE" && \
    echo "MAIL_HOST: $MAIL_HOST" && \
    php-fpm & \
    nginx -g 'daemon off;'
