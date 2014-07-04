#! /bin/bash

if [ ! -f /root/.root_password ]; then
    ROOT_PASSWORD=$(pwgen --no-capitalize --no-numerals -B 8 1)
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo -n "$ROOT_PASSWORD" > /root/.root_password
    chmod 600 /root/.root_password
else
    ROOT_PASSWORD=$(cat /root/.root_password)
fi

echo "Root Password: $ROOT_PASSWORD"


service tomcat6 start
/usr/bin/supervisord -c /etc/supervisord.conf
