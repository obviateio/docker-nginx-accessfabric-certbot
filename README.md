# docker-nginx-certbot
[![Travis (.org)](https://img.shields.io/travis/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://travis-ci.org/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub issues](https://img.shields.io/github/issues-raw/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub](https://img.shields.io/github/license/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub stars](https://img.shields.io/github/stars/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge&label=Stars)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub last commit](https://img.shields.io/github/last-commit/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![Docker Stars](https://img.shields.io/docker/stars/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)  [![Docker Pulls](https://img.shields.io/docker/pulls/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)  [![MicroBadger Layers](https://img.shields.io/microbadger/layers/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)

Create and automatically renew website SSL certificates using the letsencrypt free certificate authority, and its client *certbot*. Built upon [shakataganai/docker-nginx-accessfabric](https://github.com/obviateio/docker-nginx-accessfabric) for use with ScaleFT Access Fabric. For regular Nginx, see [staticfloat/docker-nginx-certbot](https://github.com/staticfloat/docker-nginx-certbot).

# More information

Find out more about letsencrypt: https://letsencrypt.org

Certbot github: https://github.com/certbot/certbot

This repository was originally forked from `@henridwyer`, many thanks to him for the good idea.  I've rewritten about 90% of this repository, so it bears almost no resemblance to the original.  This repository is _much_ more opinionated about the structure of your webservers/containers, however it is easier to use as long as all of your webservers follow that pattern.

# Usage

Use this image with a `Dockerfile` such as:
```Dockerfile
FROM staticfloat/nginx-certbot
COPY *.conf /etc/nginx/conf.d/
```

And a `.conf` file such as:
```nginx
server {
    listen              443 ssl;
    server_name         server.company.com;
    ssl_certificate     /etc/letsencrypt/live/server.company.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/server.company.com/privkey.pem;

    location / {
        ...
    }
}
```

Wrap this all up with a `docker-compose.yml` file:
```yml
version: '3'
services:
    frontend:
        restart: unless-stopped
        build: frontend
        ports:
            - 80:80/tcp
            - 443:443/tcp
        environment:
            - CERTBOT_EMAIL=owner@company.com
  ...
```
