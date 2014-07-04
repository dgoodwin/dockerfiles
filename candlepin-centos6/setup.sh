#! /bin/bash

setup_supervisor() {
    pip install supervisor
    mkdir -p /var/log/supervisor
    mkdir -p /etc/supervisor/conf.d
    cat > /etc/supervisord.conf <<SUPERVISOR
[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid

[include]
files=/etc/supervisor/conf.d/*.conf

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock

[unix_http_server]
file=/var/run/supervisor.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
SUPERVISOR
    cat > /etc/supervisor/conf.d/rsyslog.conf <<RSYSLOG_SUPERVISOR
[program:rsyslog]
command=/sbin/rsyslogd -n -c 5
RSYSLOG_SUPERVISOR
}

setup_ssh() {
    RSA_KEY=/etc/ssh/ssh_host_rsa_key
    DSA_KEY=/etc/ssh/ssh_host_dsa_key

    ssh-keygen -q -t dsa -f $DSA_KEY -C '' -N '' >&/dev/null
    chmod 600 $DSA_KEY
    chmod 644 $DSA_KEY.pub

    ssh-keygen -q -t rsa -f $RSA_KEY -C '' -N '' >&/dev/null
    chmod 600 $RSA_KEY
    chmod 644 $RSA_KEY.pub
    cat > /etc/supervisor/conf.d/sshd.conf <<SSH_SUPERVISOR
[program:sshd]
command=/usr/sbin/sshd -D
SSH_SUPERVISOR
}

setup_postgresql() {
    echo 'NETWORKING=yes' > /etc/sysconfig/network
    su - postgres -c 'initdb --auth=trust -D /var/lib/pgsql/data'
    service postgresql start
    su - postgres -c 'createuser -dls candlepin'

    cat > /etc/supervisor/conf.d/postgres.conf <<POSTGRES_SUPERVISOR
[program:postgres]
user=postgres
environment=PGDATA="/var/lib/pgsql/data"
command=/usr/bin/postgres
stopsignal=INT
redirect_stderr=true
POSTGRES_SUPERVISOR
}

# CentOS 6 Setup:
rpm -i http://fedora.mirror.nexicom.net/epel/6/i386/epel-release-6-8.noarch.rpm
wget -O /etc/yum.repos.d/candlepin.repo http://repos.fedorapeople.org/repos/candlepin/candlepin/epel-candlepin.repo

yum install -y wget vim-enhanced openssh-server postgresql postgresql-server python-pip pwgen candlepin candlepin-tomcat6

setup_supervisor
setup_ssh
setup_postgresql

/usr/share/candlepin/cpsetup

# Just in case we'll shut down postgres cleanly:
service postgresql stop
