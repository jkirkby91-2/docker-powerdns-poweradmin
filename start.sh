#!/bin/bash
MYSQL_HOST=${MYSQL_HOST:-db}
MYSQL_PORT=${MYSQL_PORT:-3306}
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASSWORD=${DB_ENV_MYSQL_ROOT_PASSWORD}
MYSQL_DB=${MYSQL_DB:-pdns}
PDNS_ALLOW_AXFR_IPS=${PDNS_ALLOW_AXFR_IPS:-127.0.0.1}
PDNS_MASTER=${PDNS_MASTER:-yes}
PDNS_SLAVE=${PDNS_SLAVE:-no}
PDNS_CACHE_TTL=${PDNS_CACHE_TTL:-20}
PDNS_DISTRIBUTOR_THREADS=${PDNS_DISTRIBUTOR_THREADS:-3}
PDNS_RECURSIVE_CACHE_TTL=${PDNS_RECURSIVE_CACHE_TTL:-10}
PDNS_ALLOW_RECURSION=${PDNS_ALLOW_RECURSION:-127.0.0.1}
PDNS_RECURSOR=${PDNS_RECURSOR:-no}
POWERADMIN_HOSTMASTER=${POWERADMIN_HOSTMASTER:-}
POWERADMIN_NS1=${POWERADMIN_NS1:-}
POWERADMIN_NS2=${POWERADMIN_NS2:-}

### PDNS setup
sed -i "s/{{MYSQL_HOST}}/${MYSQL_HOST}/" /etc/powerdns/pdns.d/pdns.local.gmysql.conf
sed -i "s/{{MYSQL_PORT}}/${MYSQL_PORT}/" /etc/powerdns/pdns.d/pdns.local.gmysql.conf
sed -i "s/{{MYSQL_USER}}/${MYSQL_USER}/" /etc/powerdns/pdns.d/pdns.local.gmysql.conf
sed -i "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/" /etc/powerdns/pdns.d/pdns.local.gmysql.conf
sed -i "s/{{MYSQL_DB}}/${MYSQL_DB}/" /etc/powerdns/pdns.d/pdns.local.gmysql.conf
sed -i "s/{{PDNS_ALLOW_AXFR_IPS}}/${PDNS_ALLOW_AXFR_IPS}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_MASTER}}/${PDNS_MASTER}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_SLAVE}}/${PDNS_SLAVE}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_CACHE_TTL}}/${PDNS_CACHE_TTL}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_DISTRIBUTOR_THREADS}}/${PDNS_DISTRIBUTOR_THREADS}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_RECURSIVE_CACHE_TTL}}/${PDNS_RECURSIVE_CACHE_TTL}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_ALLOW_RECURSION}}/${PDNS_ALLOW_RECURSION}/" /etc/powerdns/pdns.conf
sed -i "s/{{PDNS_RECURSOR}}/${PDNS_RECURSOR}/" /etc/powerdns/pdns.conf

### Setup poweradmin on master
if [ "${PDNS_MASTER}" == "yes" ]; then
    mv /srv/config.inc.php /srv/www/inc/
    sed -i "s/{{MYSQL_HOST}}/${MYSQL_HOST}/" /srv/www/inc/config.inc.php
    sed -i "s/{{MYSQL_PORT}}/${MYSQL_PORT}/" /srv/www/inc/config.inc.php
    sed -i "s/{{MYSQL_USER}}/${MYSQL_USER}/" /srv/www/inc/config.inc.php
    sed -i "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}/" /srv/www/inc/config.inc.php
    sed -i "s/{{MYSQL_DB}}/${MYSQL_DB}/" /srv/www/inc/config.inc.php
    sed -i "s/{{POWERADMIN_HOSTMASTER}}/${POWERADMIN_HOSTMASTER}/" /srv/www/inc/config.inc.php
    sed -i "s/{{POWERADMIN_NS1}}/${POWERADMIN_NS1}/" /srv/www/inc/config.inc.php
    sed -i "s/{{POWERADMIN_NS2}}/${POWERADMIN_NS2}/" /srv/www/inc/config.inc.php
    rm -Rf /srv/www/install
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
