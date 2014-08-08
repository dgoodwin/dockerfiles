#!/bin/bash
/usr/bin/supervisord -c /etc/supervisord.conf

sleep 3

crypton-server -c /crypton/server/config/config.json start

