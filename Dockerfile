FROM nimmis/apache

MAINTAINER peavers <peavers@gmail.com>

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
    apt-get install -y  \
    php \
    libapache2-mod-php \
    php-fpm \
    php-cli \
    php-mysqlnd \
    php-pgsql \
    php-sqlite3 \
    php-redis \
    php-apcu \
    php-intl \
    php-imagick \
    php-mcrypt \
    php-json \
    php-gd \
    php-curl \
    php-mbstring \
    php-xml

# Configure packages
RUN phpenmod mcrypt

# Increase memory limit
RUN echo "memory_limit=512M" > /etc/php/7.0/apache2/conf.d/memory-limit.ini

# Install Composer
RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Cleanup
RUN rm -rf /var/lib/apt/lists/*