# Use PHP 8.2 as the base image
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libicu-dev && \
    docker-php-ext-install pdo_mysql mysqli mbstring exif pcntl bcmath gd intl

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application code
COPY . /var/www

# Set permissions (optional, depending on your app)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

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

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]

RUN echo "APP_ENV=$APP_ENV" && echo "APP_URL=$APP_URL" && echo "DB_HOST=$DB_HOST" # Add more variables as needed

