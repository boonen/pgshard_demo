FROM gliderlabs/alpine:3.2
MAINTAINER Jan Boonen <jan.boonen@geodan.nl>

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update && \
  apk add curl git alpine-sdk "postgresql@edge>9.4" "postgresql-contrib@edge>9.4" "postgresql-dev@edge>9.4" && \
  rm /var/cache/apk/* && \
  mkdir -p /tmp/build && cd /tmp/build && \
  git clone https://github.com/citusdata/pg_shard.git && \
  cd pg_shard && \
  export PATH=/usr/local/pgsql/bin/:$PATH && \
  make PG_CPPFLAGS="--std=c99 -Wall -Wextra -Wno-error -Wno-unused-parameter -Iinclude -I/usr/include -Itest/include -I. -I./ -I/usr/include/postgresql/server -I/usr/include/postgresql/internal" && \
  make install && \
  apk del alpine-sdk --force && \
  curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
  chmod +x /usr/local/bin/gosu

RUN mkdir /docker-entrypoint-initdb.d

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

VOLUME /var/lib/postgresql/data

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
