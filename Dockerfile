FROM alpine:edge

MAINTAINER Joao Gabriel C. Laass <gabriel@orangepixel.copm.br>

# Install packages
RUN apk --update add --no-cache \
        tzdata \
        nginx \
        nano \
        curl \
        supervisor \
        gd \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        git \
        php7 \
        php7-dom \
        php7-fpm \
        php7-mbstring \
        php7-mcrypt \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-json \
        php7-dev \
        php7-pear \
        php7-xml \
        php7-xmlwriter \
        php7-xmlrpc \
        php7-xmlreader \
        php7-simplexml \
        php7-soap \
        php7-tokenizer \
        php7-phar \
        php7-openssl \
        php7-json \
        php7-curl \
        php7-ctype \
        php7-session \
        php7-gd \
        php7-zlib \
        # to compile pecl
        autoconf openssl-dev g++ make

RUN rm -rf /var/cache/apk/* \
    # install php drive mongodb
    && pecl install mongodb \
    && echo 'extension=mongodb.so' > /etc/php7/conf.d/30_mongodb.ini

    # Configuring timezones
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" >  /etc/timezone \
    # Install Composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    # Create application folder
    && mkdir -p /var/www/src \
    # user www for nginx and php-fpm (in setup.sh, we change workdir user/group to www)
    && addgroup -g 1000 -S www \
    && adduser -u 1000 -D -S -G www -h /var/www/src -g www www \
    && chown -R www:www /var/lib/nginx

# Configure Nginx
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/default /etc/nginx/sites-enabled/default

# Configure PHP-FPM
COPY config/php/php.ini /etc/php7/php.ini
COPY config/php/www.conf /etc/php7/php-fpm.d/www.conf

# Configure supervisord
COPY config/supervisord.conf /etc/supervisord.conf

# Coping PHP example files
COPY src/ /var/www/src/

# Setting the workdir
WORKDIR /var/www/src

# Start Supervisord
ADD config/start.sh /start.sh
RUN chmod +x /start.sh

# Start Supervisord
CMD ["/start.sh"]