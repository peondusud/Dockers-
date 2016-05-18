FROM debian:jessie

MAINTAINER peondusud

ARG rtorrent_scgi_host="172.17.0.2"
ARG rtorrent_scgi_port="5000"
#authority = ip:port
ARG rtorrent_scgi_authority="${rtorrent_scgi_host}:${rtorrent_scgi_port}"

ARG nginx_deps="ca-certificates apache2-utils nginx nginx-module-geoip nginx-module-image-filter nginx-module-perl nginx-module-njs nginx-module-xslt gettext-base php5 php5-cli php5-fpm php5-curl php5-geoip"
ARG rutorrent_deps="subversion git curl git unzip unrar rar zip buildtorrent mediainfo"

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    apt-get update && apt-get install --no-install-recommends --no-install-suggests -y ${nginx_deps} && \
    rm -rf /var/lib/apt/lists/* && rm /etc/nginx/conf.d/default.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


RUN sed -ri 's/main$/main contrib non-free/g' /etc/apt/sources.list && \
    echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list && \
    apt-get update && apt-get install  --allow-unauthenticated  deb-multimedia-keyring && \
    apt-get update && apt-get install --no-install-recommends -y ${rutorrent_deps} ffmpeg

COPY rutorrent.conf /etc/nginx/conf.d/rutorrent.conf
COPY nginx.conf /etc/nginx/nginx.conf


RUN curl -Lk -o rutorrent-master.zip https://github.com/Novik/ruTorrent/archive/master.zip && \
    unzip  rutorrent-master.zip && \
    rm -f rutorrent-master.zip && \
    mkdir -p /var/www && \
    mv ruTorrent-master /var/www/rutorrent && \
    chown -R www-data:www-data /var/www/rutorrent


RUN sed -i "s/\(scgi_pass   \).*;$/\1 ${rtorrent_scgi_authority};/" /etc/nginx/conf.d/rutorrent.conf && \
    sed -i "s/\(\$scgi_host =\).*;$/\1 \"${rtorrent_scgi_host}\";/" /var/www/rutorrent/conf/config.php && \
    sed -i "s/\(\$scgi_port =\).*;$/\1 ${rtorrent_scgi_port};/" /var/www/rutorrent/conf/config.php

RUN sed -i "s/^\(listen =\).*$/\1 \/var\/run\/php5-fpm.sock/"  /etc/php5/fpm/pool.d/www.conf && \ 
    sed -i "s/^\(listen\.user =\).*$/\1 www-data/"  /etc/php5/fpm/pool.d/www.conf && \ 
    sed -i "s/^\(listen\.group =\).*$/\1 www-data/"  /etc/php5/fpm/pool.d/www.conf && \ 
    sed -i "s/^\(expose_php =\).*$/\1 Off/" /etc/php5/fpm/php.ini && \ 
    sed -i "s/^\(file_uploads =\).*$/\1 On/" /etc/php5/fpm/php.ini && \
    sed -i "s/^\(post_max_size =\).*$/\1 10M/" /etc/php5/fpm/php.ini && \
    sed -i "s/^\(upload_max_filesize =\).*$/\1 10M/" /etc/php5/fpm/php.ini && \ 
    sed -i "s/^;\(date\.timezone =\).*$/\1 Europe\/Paris/" /etc/php5/fpm/php.ini && \ 
    sed -i "s/^;\(cgi\.fix_pathinfo=1\)$/\1/" /etc/php5/fpm/php.ini && \
    service php5-fpm restart 


RUN apt-get install -y nano vim
EXPOSE 80 443


#service php5-fpm restart; service nginx restart
CMD ["nginx", "-g", "daemon off;"]

