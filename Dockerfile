FROM php:8.1-fpm

# Cài đặt các thư viện hệ thống cần thiết
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# Dọn dẹp cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài đặt các PHP extensions hỗ trợ cho Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Cài đặt Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Thiết lập thư mục làm việc
WORKDIR /var/www

# Copy mã nguồn hiện tại vào container
COPY . .

# Phân quyền cho www-data
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage \
    && chmod -R 775 /var/www/bootstrap/cache

USER www-data

EXPOSE 9000
CMD ["php-fpm"]
