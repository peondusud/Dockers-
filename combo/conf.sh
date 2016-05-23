#!/bin/bash

rtorrent_user="torrentz"

useradd -ms /bin/bash ${rtorrent_user}
mkdir -p "/home/${rtorrent_user}/rtorrent"/{.session,download,complete,log,watch/load,watch/start}

sed -i "s/USERNAME/${rtorrent_user}/g" /root/.rtorrent.rc
sed -i '9s/^/scgi_port = 127.0.0.1:5000\n/' /root/.rtorrent.rc

# test if file already exist, elseif keep the mounted one
if [ ! -f /home/${rtorrent_user}/.rtorrent.rc ]; then
    mv /root/.rtorrent.rc /home/${rtorrent_user}/
fi
chown -R ${rtorrent_user}:${rtorrent_user} /home/${rtorrent_user}/{*,.*}


rm /etc/nginx/conf.d/default.conf


tmpz=$(which php); sed -i "s|\(\"php\".*\)'',|\1'$tmpz',|" /var/www/rutorrent/conf/config.php
tmpz=$(which curl); sed -i "s|\(\"curl\".*\)'',|\1'$tmpz',|" /var/www/rutorrent/conf/config.php
tmpz=$(which gzip); sed -i "s|\(\"gzip\".*\)'',|\1'$tmpz',|" /var/www/rutorrent/conf/config.php
tmpz=$(which id); sed -i "s|\(\"id\".*\)'',|\1'$tmpz',|" /var/www/rutorrent/conf/config.php
tmpz=$(which stat); sed -i "s|\(\"stat\".*\)'',|\1'$tmpz',|" /var/www/rutorrent/conf/config.php

#sed -i "s/\(\$scgi_host =\).*;$/\1 \"${rtorrent_scgi_host}\";/" /var/www/rutorrent/conf/config.php
#sed -i "s/\(\$scgi_port =\).*;$/\1 ${rtorrent_scgi_port};/" /var/www/rutorrent/conf/config.php


sed -i "s/^\(listen =\).*$/\1 \/var\/run\/php5-fpm.sock/"  /etc/php5/fpm/pool.d/www.conf
sed -i "s/^\(listen\.user =\).*$/\1 www-data/"  /etc/php5/fpm/pool.d/www.conf
sed -i "s/^\(listen\.group =\).*$/\1 www-data/"  /etc/php5/fpm/pool.d/www.conf

sed -i "s/^\(expose_php =\).*$/\1 Off/" /etc/php5/fpm/php.ini
sed -i "s/^\(file_uploads =\).*$/\1 On/" /etc/php5/fpm/php.ini
sed -i "s/^\(post_max_size =\).*$/\1 10M/" /etc/php5/fpm/php.ini
sed -i "s/^\(upload_max_filesize =\).*$/\1 10M/" /etc/php5/fpm/php.ini
sed -i "s/^;\(date\.timezone =\).*$/\1 Europe\/Paris/" /etc/php5/fpm/php.ini
sed -i "s/^;\(cgi\.fix_pathinfo=1\)$/\1/" /etc/php5/fpm/php.ini


service php5-fpm restart
service nginx restart
su ${rtorrent_user} -c "rtorrent"
