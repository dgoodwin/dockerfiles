#!/bin/bash

git clone https://github.com/dgoodwin/crypton.git /crypton
cd /crypton
git checkout fedora-docker
cd /crypton/server
npm link

# Start postgres so we can initialize the db:
/usr/bin/supervisord -c /etc/supervisord.conf &
sleep 5

cd /crypton/test
sh bin/setup_test_environment.sh

su - postgres -c 'createuser -dls crypton_test_user'
supervisorctl stop postgres

