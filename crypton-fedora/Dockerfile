FROM fedora:20
MAINTAINER Devan Goodwin <dgoodwin@redhat.com>

ENV container docker

RUN echo 'root:password' |chpasswd

RUN yum install -y vim-enhanced tito git tmux screen

# Setup postgresql:
RUN yum -y install postgresql postgresql-server


# Create a PostgreSQL role named ``docker`` with ``docker`` as the password and
# then create a database `docker` owned by the ``docker`` role.

USER postgres
RUN /usr/bin/initdb -D /var/lib/pgsql/data
#RUN /usr/bin/postgresql-check-db-dir /var/lib/pgsql/data
#RUN /usr/bin/postgresql-setup initdb
RUN /usr/bin/pg_ctl start -D /var/lib/pgsql/data -s -o "-p 5432" -w -t 300 &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
    createdb -O docker docker &&\
    /usr/bin/pg_ctl stop -D /var/lib/pgsql/data -s -m fast

USER root

# Allow remote connections:
RUN echo "host all  all    0.0.0.0/0  md5" >> /var/lib/pgsql/data/pg_hba.conf
RUN echo "listen_addresses='*'" >> /var/lib/pgsql/data/postgresql.conf

EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]


# Setup sshd:
RUN yum -y install openssh-server supervisor
RUN /usr/sbin/sshd-keygen
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
#RUN systemctl enable sshd.service
EXPOSE 22

ADD supervisord.ini /etc/supervisord.d/supervisord.ini


# Setup crypton:
RUN yum install -y nodejs npm redis make postgresql-devel

WORKDIR /crypton
RUN git clone https://github.com/dgoodwin/crypton.git
#&& cd crypton && git checkout fedora-docker

RUN useradd -G tty root


CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

