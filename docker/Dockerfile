FROM gliderlabs/alpine:3.2
MAINTAINER Jan Boonen <jan.boonen@geodan.nl>

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update && apk add curl git alpine-sdk "postgresql@edge>9.4" "postgresql-contrib@edge>9.4" "postgresql-dev@edge>9.4" && rm /var/cache/apk/*

RUN mkdir -p /tmp/build && cd /tmp/build
RUN git clone https://github.com/citusdata/pg_shard.git && \
  cd pg_shard && \
  export PATH=/usr/local/pgsql/bin/:$PATH && \
  make && \
  make install

RUN apk remove alpine-sdk

RUN mkdir /docker-entrypoint-initdb.d

RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data
VOLUME /var/lib/postgresql/data

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]