FROM debian:jessie

MAINTAINER peondusud

LABEL Description="rtorrent docker image based on debian jessie"
LABEL Version="LITE" 

ENV rtorrent_user torrentz

# based on latest debian:jessie
ARG installed_deps="libc6 libstdc++6 libtinfo5 libgcc1 libncursesw5"
ARG lib_deps="curl libcurl3 libsigc++-2.0-0c2a" 
ARG build_deps=" ca-certificates automake build-essential libtool pkg-config subversion libxml2-dev libssl-dev libcurl4-openssl-dev libxml2-dev unzip libcppunit-dev libsigc++-2.0-dev libncurses5-dev"

RUN set -x  &&  apt-get update && \
    apt-get install -q -y --no-install-recommends ${build_deps} ${lib_deps} && \
    svn checkout https://svn.code.sf.net/p/xmlrpc-c/code/stable/ xmlrpc-c && \
    cd xmlrpc-c && \
    ./configure --disable-cplusplus && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf xmlrpc-c && \
    ldconfig && \ 
    curl -Lk -o libtorrent-master.zip https://github.com/rakshasa/libtorrent/archive/master.zip && \
    unzip libtorrent-master.zip && \
    cd libtorrent-master && \
    ./autogen.sh && \
    ./configure --with-posix-fallocate && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf libtorrent-* && \
    ldconfig && \
    curl -Lk -o rtorrent-master.zip https://github.com/rakshasa/rtorrent/archive/master.zip && \
    unzip rtorrent-master.zip && \
    cd rtorrent-master && \
    ./autogen.sh && \
    ./configure --with-xmlrpc-c --with-ncurses && \
    make -j$(nproc) && \
    make install && \
    cd .. && rm -rf rtorrent-* && \
    ldconfig && \
    apt-get purge -y --auto-remove ${build_deps} && apt-get autoremove -y &&\
    set +x 

# rtorrent ports
EXPOSE 50000-50000
# scgi port
EXPOSE 5000

RUN useradd -ms /bin/bash ${rtorrent_user}
USER ${rtorrent_user} 
WORKDIR /home/${rtorrent_user}
RUN curl -k https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md | grep -A9999 '^######' | grep -B9999 '^### END' | sed -e "s/USERNAME/${rtorrent_user}/g" | sed '1s/^/scgi_port = :5000\n/' > ~/.rtorrent.rc 

RUN bash -c 'mkdir -p "$HOME/rtorrent"/{.session,download,log,watch/load,watch/start}'

CMD ["rtorrent"]
