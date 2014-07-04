FROM centos:6.4
MAINTAINER Devan Goodwin <dgoodwin@redhat.com>

ENV LANG en_US.UTF-8

ADD setup.sh /root/setup.sh
RUN /bin/bash /root/setup.sh

EXPOSE 22
EXPOSE 8443

ADD startup.sh /root/startup.sh
CMD ["/bin/bash", "/root/startup.sh"]
