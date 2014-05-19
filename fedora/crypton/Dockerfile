FROM fedora/systemd-systemd
MAINTAINER Devan Goodwin <dgoodwin@redhat.com>

ENV container docker

RUN echo 'root:password' |chpasswd

# Setup sshd:
RUN yum -y install openssh-server
RUN /usr/sbin/sshd-keygen
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN systemctl enable sshd.service
EXPOSE 22

# Setup postgresql:
RUN yum -y install postgresql postgresql-server

CMD ["/usr/sbin/init"]
