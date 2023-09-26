# Build:
#   $ docker build --build-arg USER=<USER> --build-arg PASSWORD=<PASSWORD> -t my/postfix-outlook .
#
# Run:
#   $ docker run -it -v /tmp:/mnt --rm my/postfix-outlook
#
# Send:
#   $ /root/send.sh $ADDR /mnt/path/to/email.html

FROM alpine:3.18.3

ARG USER
ARG PASSWORD

ENV ADDR $USER

WORKDIR /root
COPY send.sh entry-point.sh .
RUN chmod +x send.sh entry-point.sh

RUN apk --no-cache add \
  postfix \
  ca-certificates \
  cyrus-sasl-login \
  libsasl \
  cyrus-sasl \
  cyrus-sasl-crammd5 \
  postfix-pcre

RUN postconf -e 'mynetworks = 127.0.0.0/8' \
  && postconf -e "relayhost = [smtp-mail.outlook.com]:587"

RUN echo "[smtp-mail.outlook.com]:587 ${USER}:${PASSWORD}" > /etc/postfix/sasl_passwd \
  && postmap lmdb:/etc/postfix/sasl_passwd \
  && postconf -e 'smtp_sasl_auth_enable = yes' \
  && postconf -e 'smtp_sasl_security_options = noanonymous' \
  && postconf -e 'smtp_sasl_password_maps = lmdb:/etc/postfix/sasl_passwd'

RUN postconf -e 'smtp_use_tls = yes' \
  && postconf -e 'smtp_tls_loglevel = 1' \
  && postconf -e 'smtp_tls_security_level = encrypt' \
  && postconf -e 'smtp_tls_note_starttls_offer = yes'

ENTRYPOINT ["./entry-point.sh"]