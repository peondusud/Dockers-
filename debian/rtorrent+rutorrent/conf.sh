#!/bin/bash

rtorrent_user="torrent"

useradd -ms /bin/bash ${rtorrent_user}
mkdir -p "/home/${rtorrent_user}/rtorrent"/{.session,download,complete,log,watch/load,watch/start}


# test if file already exist, elseif keep the mounted one
if [ ! -f /home/${rtorrent_user}/.rtorrent.rc ]; then
    mv /root/.rtorrent.rc /home/${rtorrent_user}/
    sed -i "s/<username>/${rtorrent_user}/g" /home/${rtorrent_user}/.rtorrent.rc
    chown -R ${rtorrent_user}:${rtorrent_user} /home/${rtorrent_user}/{*,.*}
fi


sed -i "s|\(\"php\".*\)'',|\1'$(which php)',|" /var/www/rutorrent/conf/config.php
sed -i "s|\(\"curl\".*\)'',|\1'$(which curl)',|" /var/www/rutorrent/conf/config.php
sed -i "s|\(\"gzip\".*\)'',|\1'$(which gzip)',|" /var/www/rutorrent/conf/config.php
sed -i "s|\(\"id\".*\)'',|\1'$(which id)',|" /var/www/rutorrent/conf/config.php
sed -i "s|\(\"stat\".*\)'',|\1'$(which stat)',|" /var/www/rutorrent/conf/config.php

sed -i "s|false|buildtorrent|" /var/www/rutorrent/plugins/create/conf.php
sed -i "s|\(pathToCreatetorrent = '\)';|\1$(which buildtorrent)';|" /var/www/rutorrent/plugins/create/conf.php

sed -i "s|\(pathToExternals\['rar'\] = '\)';|\1$(which rar)';|"  /var/www/rutorrent/plugins/filemanager/conf.php
sed -i "s|\(pathToExternals\['zip'\] = '\)';|\1$(which zip)';|"  /var/www/rutorrent/plugins/filemanager/conf.php
sed -i "s|\(pathToExternals\['unzip'\] = '\)';|\1$(which unzip)';|"  /var/www/rutorrent/plugins/filemanager/conf.php
sed -i "s|\(pathToExternals\['tar'\] = '\)';|\1$(which tar)';|"  /var/www/rutorrent/plugins/filemanager/conf.php

echo -e "\n[ipad]
enabled = no
[httprpc]
enabled = no
[retrackers]
enabled = no
[rpc]
enabled = no
[rutracker_check]
enabled = no" >>  /var/www/rutorrent/conf/plugins.ini


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
