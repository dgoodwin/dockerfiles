FROM fedora:rawhide
MAINTAINER Devan Goodwin <dgoodwin@rm-rf.ca>

RUN echo 'root:password' |chpasswd

RUN yum install -y vim-enhanced tito git tmux screen

ADD setup-supervisord.sh /root/
RUN /bin/bash /root/setup-supervisord.sh

# Setup postgresql:
ADD postgresql-setup /root/
ADD setup-postgresql.sh /root/
RUN /bin/bash /root/setup-postgresql.sh

EXPOSE 1025 22

# Prep to build crypton:
RUN yum install -y nodejs npm redis make postgresql-devel

RUN usermod -a -G tty root

RUN unlink /var/run/supervisor.sock

RUN yum install -y sudo

ADD setup-crypton.sh /root/
RUN /bin/bash /root/setup-crypton.sh

ADD config.json /crypton/server/config/

ADD launch.sh /usr/bin/
CMD /usr/bin/launch.sh

