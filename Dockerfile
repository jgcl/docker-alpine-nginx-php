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
    && php -m \
    && mkdir -p /libs \
    && cp /lib/ld-linux-x86-64.so.2 /libs/ld-linux-x86-64.so.2 \
    && cp /lib64/ld-linux-x86-64.so.2 /libs/ld-linux-x86-64.so.2 \
    && cp /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /libs/ld-linux-x86-64.so.2 \
    && cp /usr/lib/php7/modules/oci8.so /libs/oci8.so \
    && cp /usr/lib/libclntsh.so.12.1 /libs/libclntsh.so.12.1 \
    && cp -r /usr/lib/instantclient_12_1/* /libs

FROM alpine:3.7

COPY ./volume /
COPY --from=builder /libs/* /libs/
#COPY --from=builder /lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2
#COPY --from=builder /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
#COPY --from=builder /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /libs/ld-linux-x86-64.so.2
#COPY --from=builder /usr/lib/php7/modules/oci8.so /usr/lib/php7/modules/oci8.so
#COPY --from=builder /usr/lib/libclntsh.so.12.1 /usr/lib/libclntsh.so.12.1
#COPY --from=builder /usr/lib/instantclient_12_1/* /usr/lib/instantclient_12_1/
#COPY --from=builder /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/libclntsh.so
#COPY --from=builder /usr/lib/instantclient_12_1/libocci.so.12.1 /usr/lib/libocci.so
#COPY --from=builder /usr/lib/instantclient_12_1/libociei.so /usr/lib/libociei.so
#COPY --from=builder /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/libnnz12.so
#COPY --from=builder /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/instantclient_12_1/libclntsh.so
#COPY --from=builder /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/instantclient_12_1/libnsl.so.1

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
    && mkdir -p /usr/lib/instantclient_12_1/ \
    && mkdir -p /lib/ \
    && mkdir -p /lib64/ \
    && mkdir -p /usr/glibc-compat/lib/ \
    && mkdir -p /usr/lib/php7/modules/ \
    && mkdir -p /usr/lib/ \
    && touch /usr/lib/instantclient_12_1/libnsl.so.1 \
    && mv /libs/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 \
    && mv /libs/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 \
    && mv /libs/ld-linux-x86-64.so.2 /usr/glibc-compat/lib/ld-linux-x86-64.so.2 \
    && mv /libs/oci8.so /usr/lib/php7/modules/oci8.so \
    && mv /libs/libclntsh.so.12.1 /usr/lib/libclntsh.so.12.1 \
    && ln /libs/* /usr/lib/instantclient_12_1/ \
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