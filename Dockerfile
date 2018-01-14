FROM frolvlad/alpine-glibc

#https://hub.docker.com/r/frolvlad/alpine-glibc/
#https://github.com/asg1612/alpine-oracle-instantclient

COPY . /

ENV ORACLE_BASE /usr/lib/instantclient_12_1
ENV LD_LIBRARY_PATH /usr/lib/instantclient_12_1
ENV TNS_ADMIN /usr/lib/instantclient_12_1
ENV ORACLE_HOME /usr/lib/instantclient_12_1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add libaio \
    && cp /docker/instantclient_12_1.zip ./ \
    && unzip instantclient_12_1.zip \
    && mv instantclient_12_1/ /usr/lib/ \
    && rm instantclient_12_1.zip \
    && ln /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/libclntsh.so \
    && ln /usr/lib/instantclient_12_1/libocci.so.12.1 /usr/lib/libocci.so \
    && ln /usr/lib/instantclient_12_1/libociei.so /usr/lib/libociei.so \
    && ln /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/libnnz12.so \
    && apk add --no-cache \
        nginx \
        nano \
        curl \
        supervisor \
        git \
        zip \
        unzip \
        php7 \
        php7-phar \
        php7-dom \
        php7-fpm \
        php7-mbstring \
        php7-mcrypt \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \ # mysql
        php7-pdo_pgsql \ # postgre
        php7-pdo_sqlite \ #sqlite
        php7-pdo_odbc \ #sqlserver
        php7-pdo_dblib \ #sqlserver
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
        php7-openssl \
        php7-json \
        php7-curl \
        php7-ctype \
        php7-zlib \
        php7-posix \
        php7-mongodb \
        php7-pcntl \
        php7-iconv \
        php7-session \
        gcc musl-dev make \
    # php oci8
    && cp /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/instantclient_12_1/libclntsh.so \
    && cp /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/instantclient_12_1/libnsl.so.1 \
    && echo 'instantclient,/usr/lib/instantclient_12_1' | pecl install -f oci8 \
    && echo 'extension=oci8.so' > /etc/php7/conf.d/oracle.ini \
    # group
    && addgroup -g 1000 -S www \
    && adduser -u 1000 -D -S -G www -h /app -g www www \
    && chown -R www:www /var/lib/nginx \
    # config files
    && mkdir -p /etc/nginx/sites-enabled \
    && mkdir -p /etc/php7/php-fpm.d \
    && cp -rf /docker/nginx/nginx.conf                  /etc/nginx/nginx.conf \
    && cp -rf /docker/nginx/default.conf                /etc/nginx/sites-enabled/default \
    && cp -rf /docker/php/php.ini                       /etc/php7/php.ini \
    && cp -rf /docker/php/www.conf                      /etc/php7/php-fpm.d/www.conf \
    && cp -rf /docker/supervisor/supervisor.conf        /etc/supervisord.conf \
    # php composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

WORKDIR /app

# portal
EXPOSE 80

# start
CMD ["/docker/start.sh"]
