FROM debian:jessie

MAINTAINER peondusud

LABEL Description="rtorrent+nginx+php5-fmp docker image based on debian jessie"
LABEL Version="LITE"

# based on latest debian:jessie
ARG installed_deps="libc6 libstdc++6 libtinfo5 libgcc1 libncursesw5"
ARG lib_deps="curl libcurl3 libsigc++-2.0-0c2a"
ARG build_deps="ca-certificates automake build-essential libtool pkg-config subversion libxml2-dev libssl-dev libcurl4-openssl-dev libxml2-dev libcppunit-dev libsigc++-2.0-dev libncurses5-dev"
ARG nginx_deps="ca-certificates apache2-utils nginx nginx-module-geoip nginx-module-image-filter nginx-module-perl gettext-base php5 php5-cli php5-fpm php5-curl php5-geoip"
ARG rutorrent_deps="curl unzip unrar rar zip bzip2 buildtorrent mediainfo ffmpeg"
ARG tardis_deps="nodejs"


RUN set -x  && \
    sed -ri 's/main$/main contrib non-free/g' /etc/apt/sources.list && \
    echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list && \
    echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list && \
    apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 && \
    apt-get update && \
    apt-get install  --allow-unauthenticated  deb-multimedia-keyring && \
    apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y ${build_deps} ${lib_deps} ${nginx_deps} ${rutorrent_deps} && \
    svn checkout https://svn.code.sf.net/p/xmlrpc-c/code/stable/ xmlrpc-c && \
#    cd xmlrpc-c && \
#    ./configure --disable-cplusplus && \
#    make -j$(nproc) && \
#    make install && \
#    cd .. && rm -rf xmlrpc-c && \
#    ldconfig && \
#    curl -Lk -o libtorrent-master.zip https://github.com/rakshasa/libtorrent/archive/master.zip && \
#    unzip libtorrent-master.zip && \
#    cd libtorrent-master && \
#    ./autogen.sh && \
#    ./configure --with-posix-fallocate && \
#    make -j$(nproc) && \
#    make install && \
#    cd .. && rm -rf libtorrent-* && \
#    ldconfig && \
#    curl -Lk -o rtorrent-master.zip https://github.com/rakshasa/rtorrent/archive/master.zip && \
#    unzip rtorrent-master.zip && \
#    cd rtorrent-master && \
#    ./autogen.sh && \
#    ./configure --with-xmlrpc-c --with-ncurses && \
#    make -j$(nproc) && \
#    make install && \
#    cd .. && rm -rf rtorrent-* && \
    ldconfig && \
    curl -Lsk  https://deb.nodesource.com/setup_4.x | bash - && \
    apt-get install --no-install-recommends --no-install-suggests -y ${tardis_deps} && \
    echo $(which curl) && \
    echo $(which npm) && \
    npm install -g bower && \
    curl -Lsk -o tardistart.zip  https://github.com/Jedediah04/TARDIStart/archive/master.zip && \
    unzip tardistart.zip -d tardistart && cd tardistart && \
    #bower install && \
    #apt-get purge -y --auto-remove ${build_deps} && \
    #apt-get autoremove -y && \
    #apt-get autoremove --purge -y && \
    #rm -rf /var/lib/apt/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/* \
    #rm -rf /usr/share/man/ /usr/share/doc/ && \
    set +x


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log


RUN cd && curl -Lk -o rutorrent-master.zip https://github.com/Novik/ruTorrent/archive/master.zip && \
    unzip  rutorrent-master.zip && \
    rm -f rutorrent-master.zip && \
    mkdir -p /var/www && \
    mv ruTorrent-master /var/www/rutorrent && \
    chown -R www-data:www-data /var/www/rutorrent


RUN curl -k https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md | grep -A9999 '^######' | grep -B9999 '^### END' > /root/.rtorrent.rc

# rtorrent ports
EXPOSE 50000-50000
EXPOSE 80

COPY rutorrent.conf /etc/nginx/conf.d/rutorrent.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY conf.sh /root/conf.sh

RUN chmod +x /root/conf.sh
VOLUME /home/
CMD ["/root/conf.sh"]
