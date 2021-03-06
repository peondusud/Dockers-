FROM debian:jessie

MAINTAINER peondusud

LABEL Description="rtorrent+nginx+php5-fmp docker image based on debian jessie"

# based on latest debian:jessie
ARG installed_deps="libc6 libstdc++6 libtinfo5 libgcc1 libncursesw5"
ARG lib_deps="curl libcurl3 libsigc++-2.0-0c2a"
ARG build_deps="git automake build-essential libtool pkg-config subversion libxml2-dev libssl-dev libcurl4-openssl-dev libxml2-dev libcppunit-dev libsigc++-2.0-dev libncurses5-dev"
ARG nginx_deps="ca-certificates apache2-utils nginx gettext-base php5 php5-cli php5-fpm php5-curl php5-geoip"
ARG rutorrent_deps="curl unzip unrar rar zip bzip2 buildtorrent mediainfo ffmpeg"

# echo -e "deb http://packages.dotdeb.org jessie all\ndeb-src http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && curl http://www.dotdeb.org/dotdeb.gpg | apt-key add -

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
    cd xmlrpc-c && \
    ./configure --disable-cplusplus && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf xmlrpc-c && \
    ldconfig && \
    git clone https://github.com/rakshasa/libtorrent.git && \
    cd libtorrent && \
    git checkout 0.13.6 && \
    ./autogen.sh && \
    ./configure --with-posix-fallocate && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf libtorrent-* && \
    ldconfig && \
    git clone https://github.com/rakshasa/rtorrent.git && \
    cd rtorrent && \
    git checkout 0.9.6 && \
    ./autogen.sh && \
    ./configure --with-xmlrpc-c --with-ncurses && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf rtorrent-* && \
    ldconfig && \
    apt-get purge -y --auto-remove ${build_deps} && \
    apt-get autoremove -y && \
    apt-get autoremove --purge -y && \
    rm -rf /var/lib/apt/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/* \
    rm -rf /usr/share/man/ /usr/share/doc/ && \
    set +x



# forward request and error logs to docker log collector
RUN rm /etc/nginx/conf.d/default.conf && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log


RUN cd /tmp && \
    curl -Lk -o rutorrent-master.zip https://github.com/Novik/ruTorrent/archive/master.zip && \
    unzip  rutorrent-master.zip && \
    mkdir -p /var/www && \
    mv ruTorrent-master /var/www/rutorrent && \
    curl -Lk -o rutorrentMobile-master.zip https://github.com/xombiemp/rutorrentMobile/archive/master.zip && \
    unzip  rutorrentMobile-master.zip && \
    mv rutorrentMobile-master /var/www/rutorrent/plugins/mobile && \
    curl -Lk -o rutorrent-thirdparty-plugins-stable.zip  https://github.com/nelu/rutorrent-thirdparty-plugins/archive/stable.zip && \
    unzip  rutorrent-thirdparty-plugins-stable.zip && \
    mv  rutorrent-thirdparty-plugins-stable/* /var/www/rutorrent/plugins/ && \
    rm -rf /tmp/rutorrent* && \
    chown -R www-data:www-data /var/www/rutorrent 

# rtorrent ports
EXPOSE 50000-65000
EXPOSE 80


COPY nginx.conf /etc/nginx/nginx.conf
COPY rutorrent.conf /etc/nginx/conf.d/rutorrent.conf
COPY rtorrent.rc  /root/.rtorrent.rc
COPY conf.sh /root/conf.sh
RUN chmod +x /root/conf.sh

VOLUME /home/

CMD ["/root/conf.sh"]
