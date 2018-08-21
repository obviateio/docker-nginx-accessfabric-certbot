# docker-nginx-accessfabric-certbot
[![Travis (.org)](https://img.shields.io/travis/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://travis-ci.org/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub issues](https://img.shields.io/github/issues-raw/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub](https://img.shields.io/github/license/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub stars](https://img.shields.io/github/stars/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge&label=Stars)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![GitHub last commit](https://img.shields.io/github/last-commit/obviateio/docker-nginx-accessfabric-certbot.svg?style=for-the-badge)](https://github.com/obviateio/docker-nginx-accessfabric-certbot)  [![Docker Stars](https://img.shields.io/docker/stars/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)  [![Docker Pulls](https://img.shields.io/docker/pulls/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)  [![MicroBadger Layers](https://img.shields.io/microbadger/layers/shakataganai/nginx-accessfabric-certbot.svg?style=for-the-badge)](https://hub.docker.com/r/shakataganai/nginx-accessfabric-certbot/)

Create and automatically renew website SSL certificates using the letsencrypt free certificate authority, and its client *certbot*. Built upon [obviateio/docker-nginx-accessfabric](https://github.com/obviateio/docker-nginx-accessfabric) for use with ScaleFT Access Fabric. For regular Nginx, see [staticfloat/docker-nginx-certbot](https://github.com/staticfloat/docker-nginx-certbot).


# Usage
* Login to [ScaleFT](https://app.scaleft.com/)
* Create a project 
* Go into that project & create an application
* Verify your origin URL (ex: `gitlab.ext.company.tld`) is in DNS and externally resolveable
* Cname the custom hostname (ex: `gitlab.company.tld`) to the application URL (ex: `random-words-1234.accessfabric.com`)
* mkdir ./letsencrypt/
* mkdir ./conf.d/
* Add a `.conf` such as (ex: `./conf.d/gitlab.conf`):
```nginx
server {
    auth_accessfabric	on;
    auth_accessfabric_audience "https://random-words-1234.accessfabric.com";
    listen              443 ssl;
    server_name         gitlab.ext.company.tld gitlab.company.tld random-words-1234.accessfabric.com";
    ssl_certificate     /etc/letsencrypt/live/gitlab.ext.company.tld/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/gitlab.ext.company.tld/privkey.pem;

    location / {
        proxy_pass http://gitlabinstance.company.int:80;
    }
}
```
* Run docker container: 
```
docker run --name=nginx \
 -e CERTBOT_EMAIL=opsteam@company.tld \
 -v /home/myuser/conf.d/:/etc/nginx/conf.d/ \
 -v /home/myuser/letsencrypt/:/etc/letsencrypt/ \
 -p 80:80 -p 443:443 \
 --restart=always \
 -d shakataganai/nginx-accessfabric-certbot:latest
```

When the container first starts, if the key's are not detected it will turn the `.conf` off. Once certbot aquires a certificate, the `.conf` will be turned back on and nginx reloaded. If there are issues, run `docker log nginx`.  Accessing `gitlab.ext.company.tld` should result in a 401 Access Denied. Accessing `gitlab.company.tld` should result in functional Access Fabric login proccess and your end-service.
