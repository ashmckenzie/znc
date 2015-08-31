FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV APP_HOME {{ userdata.app.home }}

RUN apk add --update-cache bash sudo ca-certificates znc znc-extra
RUN mkdir -p ${APP_HOME}/configs ${APP_HOME}/users

WORKDIR ${APP_HOME}
COPY ./config/znc.conf configs/znc.conf

RUN sed -i 's%<ZNC_PORT>%{{ userdata.znc.port }}%' configs/znc.conf
RUN sed -i 's%<ZNC_SSL_CERT>%{{ userdata.znc.ssl_cert }}%' configs/znc.conf

RUN sed -i 's%<ZNC_IRC_SERVER_HOST>%{{ userdata.znc.irc_server.host }}%' configs/znc.conf
RUN sed -i 's%<ZNC_IRC_SERVER_PORT>%{{ userdata.znc.irc_server.port }}%' configs/znc.conf

RUN sed -i 's%<ZNC_PASSWORD_SHA>%{{ secrets.znc.password.sha }}%' configs/znc.conf

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE {{ userdata.znc.port }}

CMD [ "/start" ]
