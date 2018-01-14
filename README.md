# powerfull docker alpine nginx php 7.1 and drivers for all databases

This Docker Image containg:
- alpine edge
- php 7.1 (cli and fpm)
- php extensions:
    - mysql
    - mongodb
    - pear
    - mbstring
    - mcrypt
    - tokenizer
    - xml (xml, xmlwriter, xmlrpc, xmlreader, simplexml)
    - soap
    - openssl
    - json
    - curl
    - gd 
    - (veja o restante no Dockerfile)

Tanto o nginx, quanto o php-fpm rodam sob o usuário 'www', logo o diretório '/var/www/src' sempre será executado sob esse usuário (evitar ter que aplicar chmod especial em algum diretório para que o php possa operar).

# docker pull
```
docker pull jgcl88/alpine-nginx-php71
```

Mais dados no docker hub:
[https://hub.docker.com/r/jgcl88/alpine-nginx-php71/](https://hub.docker.com/r/jgcl88/alpine-nginx-php71/)

# docker run
```
docker run \
    --name=meucontainer \
    -v /diretorio/seuconteudo:/var/www/src \
    --link mysql:mysql \
    --link mongodb:mongodb \
    -p 8180:80 \
    -d jgcl88/alpine-nginx-php71
```

# docker compose

Acompanha um docker-compose de exemplo, subindo o container com php (e seu projeto) além do banco mysql e mongodb. Basta rodar:
```
docker-compose up -d
```

E para encerrar:
```
docker-compose down
```

Caso queira fazer o build:
```
docker build -t nomeDaSuaImagem -f Dockerfile .
```