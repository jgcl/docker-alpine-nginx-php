# powerfull docker alpine nginx php 7.1 and drivers for all databases

This Docker Image containing:
- alpine edge
- php 7.1 (cli and fpm)
- php database extensions:
    - mysql
    - oracle (via oci8)
    - mongodb
    - sql server
    - sqlite
    
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
[https://hub.docker.com/r/jgcl88/alpine-nginx-php/](https://hub.docker.com/r/jgcl88/alpine-nginx-php/)

# docker run
```
docker run \
    --name=myContainerName \
    -v /myFolder:/app \
    -p 80:80 \
    -d jgcl88/alpine-nginx-php
```

# docker compose

Powerfull example containing:
- application
- oracle database
- mysql database
- sql server database
- sqlite database
- mongo database 

```
version: '3'

services:
  mysql:
    container_name: mysql
    image: mysql:5.7
    #volumes:
      #- ~/docker-volumes/mysql/:/var/lib/mysql
    environment:
      - TZ=America/Sao_Paulo
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_DATABASE=test
      - MYSQL_USER=test
      - MYSQL_PASSWORD=test1234
    ports:
      - "3306:3306"
    network_mode: "bridge"

  sqlsrv:
    container_name: sqlsrv
    image: microsoft/mssql-server-linux:latest
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=TestPassWord1234
      - MSSQL_PID=Express
    #volumes:
      #- ~/docker-volumes/sqlsrv:/var/opt/mssql
      # /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'TestPassWord1234'
    ports:
      - "1433:1433"
    network_mode: "bridge"

  oraclesrv:
    container_name: oraclesrv
    image: wnameless/oracle-xe-11g
    environment:
      - ORACLE_ALLOW_REMOTE=true
      - ORACLE_PASSWORD_VERIFY=false
      - ORACLE_DISABLE_ASYNCH_IO=true
      - ORACLE_ENABLE_XDB=false
    ports:
      - "1521:1521"
    network_mode: "bridge"

  app:
    container_name: app
    image: jgcl88/alpine-nginx-php
    command: ["sh", "-c", "/docker/start.sh"]
    links:
      - sqlsrv
      - mysql
      - oraclesrv
    volumes:
      - ./app:/app
    ports:
      - "80:80"
    network_mode: "bridge"

```

#### to up...

```
docker-compose up -d
```

See Powerfull Lumen 5.5 example using this image and swagger-ui to change data in all databases:
[https://github.com/jgcl/powerfull-lumen-base-project](https://github.com/jgcl/powerfull-lumen-base-project)