FROM nimmis/apache

MAINTAINER peavers <peavers@gmail.com>

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && \
    apt-get install -y  \
    sudo \
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
    php-xml \
    php-tidy

# Configure packages
RUN phpenmod mcrypt

# Install Composer
RUN cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Apache + xdebug configuration
RUN { \
                echo "<VirtualHost *:80>"; \
                echo "  DocumentRoot /var/www/html"; \
                echo "  LogLevel warn"; \
                echo "  ErrorLog /var/log/apache2/error.log"; \
                echo "  CustomLog /var/log/apache2/access.log combined"; \
                echo "  ServerSignature Off"; \
                echo "  <Directory /var/www/html>"; \
                echo "    Options +FollowSymLinks"; \
                echo "    Options -ExecCGI -Includes -Indexes"; \
                echo "    AllowOverride all"; \
                echo; \
                echo "    Require all granted"; \
                echo "  </Directory>"; \
                echo "  <LocationMatch assets/>"; \
                echo "    php_flag engine off"; \
                echo "  </LocationMatch>"; \
                echo; \
                echo "  IncludeOptional sites-available/000-default.local*"; \
                echo "</VirtualHost>"; \
	} | tee /etc/apache2/sites-available/000-default.conf

# Settings
RUN echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf && \
    echo "memory_limit=512M" > /etc/php/7.0/apache2/conf.d/memory-limit.ini && \
	echo "date.timezone = Pacific/Auckland" > /etc/php/7.0/apache2/conf.d/timezone.ini && \
	a2enmod rewrite expires remoteip cgid && \
	usermod -u 1000 www-data && \
	usermod -G staff www-data