FROM alpine:3.11.6

LABEL maintainer="Emanuele Falzone <emanuele.falzone@polimi.it>"

RUN apk add --update bash curl wget \
    && rm -rf /var/cache/apk/*

COPY wait-for.sh /
COPY start.sh /

RUN chmod +x /wait-for.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]