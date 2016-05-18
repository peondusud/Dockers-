#!/bash

rm /etc/nginx/conf.d/default.conf



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

