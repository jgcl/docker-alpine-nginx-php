# powerfull docker alpine nginx php 7.1 and drivers for all databases

[![](https://images.microbadger.com/badges/image/jgcl88/alpine-nginx-php:oracle.svg)](https://microbadger.com/images/jgcl88/alpine-nginx-php:oracle "Get your own image badge on microbadger.com")

[![](https://raw.githubusercontent.com/play-with-docker/stacks/cff22438cb4195ace27f9b15784bbb497047afa7/assets/images/button.png)](http://play-with-docker.com/?stack=https://github.com/jgcl/docker-alpine-nginx-php/blob/oracle/docker-compose.yml "Test Online in play with docker")

This Docker Image containing:
- Alpine 3.7;
- PHP 7.1 (CLI and FPM);
- PHP database extensions:
    - MySQL
    - SQL Server
    - PostgreSQL
    - SQLite
    - MongoDB
    - Oracle 
    
- all php extensions:
```
Core
ctype
curl
date
dom
filter
hash
iconv
json
libxml
mbstring
mcrypt
mongodb
mysqlnd
oci8 
openssl
pcntl
pcre
PDO
pdo_dblib
pdo_mysql
PDO_ODBC
pdo_pgsql
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
soap
SPL
standard
tokenizer
xml
xmlreader
xmlrpc
xmlwriter
Zend OPcache
zlib
```

# docker pull
```
docker pull jgcl88/alpine-nginx-php
```

More info on Docker Hub:
[https://hub.docker.com/r/jgcl88/docker-alpine-nginx-php/](https://hub.docker.com/r/jgcl88/docker-alpine-nginx-php/)

# docker run
```
docker run \
    --name=myContainerName \
    -v /myFolder:/app \
    -p 80:80 \
    -d jgcl88/alpine-nginx-php:oracle
```

# docker compose

Example containing:
- Simple phpinfo displaying all available drivers
- MySQL database
- SQL Server database
- PostgreSQL database
- SQLite database
- MongoDB database
- Oracle database
- Migrations

See docker-compose.yml and docker-compose-databases.yml files.

#### to up...

```
docker-compose up -d
or
docker-compose -f docker-compose-databases.yml up -d
```

See Powerfull Lumen 5.5 example using this image and swagger-ui to change data in all databases:
[https://github.com/jgcl/powerfull-lumen-base-project](https://github.com/jgcl/powerfull-lumen-base-project)