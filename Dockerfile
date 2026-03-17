FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    libldap2-dev libzip-dev zip unzip curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip ldap opcache

RUN a2enmod rewrite

RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# 🔥 FIX GLPI PUBLIC
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

RUN curl -L https://github.com/glpi-project/glpi/releases/download/11.0.6/glpi-11.0.6.tgz \
    | tar -xz --strip-components=1

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
