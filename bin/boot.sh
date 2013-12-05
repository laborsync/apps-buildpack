#!/usr/bin/env bash

# Pass the envioronment variables to httpd.conf
for config in `env|cut -f1 -d=`
do
  	echo "PassEnv ${config}" >> /app/vendors/httpd/conf/httpd.conf
done

# Set app appache configs
cat /app/htdocs/heroku/APACHE >> /app/vendors/httpd/conf/httpd.conf

#echo "Configuring New Relic sysmond"
#/app/newrelic/sysmond/scripts/nrsysmond-config -c /app/newrelic/sysmond/daemon/nrsysmond.cfg --set license_key="${NEWRELIC_LICENSE}" logfile="/app/newrelic/logs/sysmond" loglevel="${NEWRELIC_LOGLEVEL}" ssl=true

#echo "Launching New Relic sysmond"
#/app/newrelic/sysmond/daemon/nrsysmond -c /app/newrelic/sysmond/daemon/nrsysmond.cfg

export PATH=/usr/local/bin:/usr/bin:/bin:/app/bin:/app/vendors/apr/bin:/app/vendors/apr-util/bin::/app/vendors/httpd/bin:/app/vendors/lynx/bin:/app/vendors/pcre/bin:/app/vendors/php/bin

touch /app/logs/apache/error_log
touch /app/logs/apache/access_log
touch /app/logs/newrelic/php-daemon
touch /app/logs/newrelic/php-agent
#touch /app/logs/newrelic/sysmond
touch /app/logs/codeigniter/log
tail -F /app/logs/apache/error_log &
tail -F /app/logs/apache/access_log &
tail -F /app/logs/newrelic/php-daemon &
tail -F /app/logs/newrelic/php-agent &
#tail -F /app/logs/newrelic/sysmond &
tail -F /app/logs/codeigniter/log &
#export LD_LIBRARY_PATH=/app/php/ext

#echo "Launching PHP FPM"
#/app/vendors/php/sbin/php-fpm -y /app/vendors/php/php-fpm.conf -c /app/vendors/php/php.ini

echo "Launching apache"
exec /app/vendors/httpd/bin/httpd -DNO_DETACH