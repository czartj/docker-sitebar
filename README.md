# docker-sitebar
Docker version of a  [SiteBar](http://sitebar.org), the online Bookmark manager

This is a updated version of : [https://github.com/j3lamp/docker-sitebar/](https://github.com/j3lamp/docker-sitebar/)

Added the **Environment variables**:

    SITEBAR_BASEURL
    SITEBAR_DATABASE_NAME
    SITEBAR_DATABASE_PASSWORD
    SITEBAR_DATABASE_USER

The variavle *SITEBAR_BASEURL* useful when you are going to access the site through a subdirectory, such as https://yourdomain.com/sb/

If defined will build/modify a 'config.inc.php' on startup,  which lets you skip adding one manually or through the config process.
So if you create a .env file such as
```
BASEURL=/sb
DB_NAME=sitebar
DB_USER=sitebar
DB_PASSWORD=sbpass
DB_ROOT_PASSWORD=mspass
```
You can use a 'docker-compose.yaml' file:
```
---
version: '3'
services:
  sitebar:
    container_name: sitebar
    image: czartj/docker-sitebar:latest
    environment:
      - SITEBAR_BASEURL=${BASEURL}
      - SITEBAR_DATABASE_NAME=${DB_NAME}
      - SITEBAR_DATABASE_USER=${DB_USER}
      - SITEBAR_DATABASE_PASSWORD=${DB_PASSWORD}
    volumes:
      - ./data/sitebar:/config
    ports:
      - 8082:80
    depends_on:
      - db
  db:
    image: mariadb:10
    expose:
      - 3306
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
    volumes:
      - ./data/mysql_sb:/var/lib/mysql:z
  adminer:
    image: adminer
    command: php -S 0.0.0.0:8080 -t /var/www/html
    restart: always
    ports:
      - 8083:8080
```

You can then use a Reverse Proxy for apache with something like this added in the \<VirtualHost *:443> block:

```
               <Location /sbar>
                        ProxyPass http://localhost:8082/
                        ProxyPassReverse http://localhost:8082
                </Location>

                <Location /sb_adminer>
                        ProxyPass http://localhost:8083/
                        ProxyPassReverse http://localhost:8083
                </Location>
```

Which would let you access it like:

 https://yourdomian.com/sb/

And:

https://yourdomian.com/sb_adminer/
