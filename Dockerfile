FROM frolvlad/alpine-glibc as builder

COPY ./instantclient /

ENV ORACLE_BASE /usr/lib/instantclient_12_1
ENV LD_LIBRARY_PATH /usr/lib/instantclient_12_1
ENV TNS_ADMIN /usr/lib/instantclient_12_1
ENV ORACLE_HOME /usr/lib/instantclient_12_1

RUN apk update \
    && apk add libaio \
    && unzip instantclient_12_1.zip \
    && mv instantclient_12_1/ /usr/lib/ \
    && rm instantclient_12_1.zip \
    && cp /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/libclntsh.so \
    && cp /usr/lib/instantclient_12_1/libocci.so.12.1 /usr/lib/libocci.so \
    && cp /usr/lib/instantclient_12_1/libociei.so /usr/lib/libociei.so \
    && cp /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/libnnz12.so \
    && apk add --no-cache \
        php7 \
        php7-phar \
        php7-dom \
        php7-dev \
        php7-pear \
        gcc musl-dev make \
    && cp /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/instantclient_12_1/libclntsh.so \
    && cp /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/instantclient_12_1/libnsl.so.1 \
    && echo 'instantclient,/usr/lib/instantclient_12_1' | pecl install -f oci8 \
    && echo 'extension=oci8.so' > /etc/php7/conf.d/oracle.ini \
    && php -m

FROM alpine:3.7

COPY ./docker /
COPY ./app /app
COPY --from=builder /lib/* /lib/
COPY --from=builder /lib64/* /lib64/
COPY --from=builder /usr/lib/* /usr/lib/
COPY --from=builder /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /usr/glibc-compat/lib/ld-linux-x86-64.so.2

ENV ORACLE_BASE /usr/lib/instantclient_12_1
ENV LD_LIBRARY_PATH /usr/lib/instantclient_12_1
ENV TNS_ADMIN /usr/lib/instantclient_12_1
ENV ORACLE_HOME /usr/lib/instantclient_12_1

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
        libaio \
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
        php7-pdo_mysql \
        php7-pdo_pgsql \
        php7-pdo_sqlite \
        php7-pdo_odbc \
        php7-pdo_dblib \
        php7-mongodb \
        php7-json \
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
        php7-pcntl \
        php7-iconv \
        php7-session \
    && echo 'extension=oci8.so' > /etc/php7/conf.d/oracle.ini \
    && addgroup -g 1000 -S www \
    && adduser -u 1000 -D -S -G www -h /app -g www www \
    && chown -R www:www /var/lib/nginx \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer \
    && php -m

WORKDIR /app

# portal
EXPOSE 80

# start
CMD ["/docker/start.sh"]