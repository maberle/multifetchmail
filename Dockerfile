FROM alpine:latest
LABEL maintainer="mabdev@aberlenet.de"

ENV FETCHMAIL_OPTS="-t 60 -e 50"
ENV HTTP_USER=admin
ENV HTTP_PASSWORD=admin

#install necessary packages
RUN apk update; \
    apk upgrade; \
    apk add fetchmail openssl supervisor; \
    apk add runit tzdata && rm -rf /var/cache/apk/* \
    && cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime \
    && echo "Europe/Berlin" >  /etc/timezone 

#set workdir
WORKDIR /data

#setup fetchmail stuff, fetchmail user is created by installing the fetchmail package
RUN chown fetchmail:fetchmail /data; \
    chmod 0744 /data; 

#add logrotate fetchmail config
#add startup script
ADD start.sh /bin/start.sh
ADD mksvconf /bin/mksvconf
ADD supervisord.conf.templ /etc/supervisord.conf.templ

#add fetchmail_daemon script
ADD fetchmail_daemon.sh /bin/fetchmail_daemon.sh

#set startup script rights
RUN chmod 0700 /bin/start.sh; \
    chown fetchmail:fetchmail /bin/fetchmail_daemon.sh

VOLUME ["/data"]
EXPOSE 9101

CMD ["/bin/sh", "/bin/start.sh"]
