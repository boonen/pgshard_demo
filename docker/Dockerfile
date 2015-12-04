FROM gliderlabs/alpine:3.2
MAINTAINER Jan Boonen <jan.boonen@geodan.nl>

ENV POSTGIS_VERSION 2.2.0
ENV GEOS_VERSION 3.5.0
ENV PROJ4_VERSION 4.9.2
ENV GDAL_VERSION 2.0.1
ENV PG_SHARD_VERSION 1.2.3

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories

# Install PostgreSQL and build Proj.4, GEOS, GDAL, PostGIS and PG_Shard from sources. Then cleanup
RUN apk update && \
  apk add curl libxml2-dev json-c-dev alpine-sdk autoconf automake libtool \
    "postgresql@edge>9.4" "postgresql-contrib@edge>9.4" "postgresql-dev@edge>9.4" && \
  rm /var/cache/apk/* && \
  mkdir -p /tmp/build && cd /tmp/build && \
  curl -o postgis-${POSTGIS_VERSION}.tar.gz -sSL http://download.osgeo.org/postgis/source/postgis-${POSTGIS_VERSION}.tar.gz && \
  curl -o geos-${GEOS_VERSION}.tar.gz -sSL https://github.com/libgeos/libgeos/archive/${GEOS_VERSION}.tar.gz && \
  curl -o proj4-${PROJ4_VERSION}.tar.gz -sSL https://github.com/OSGeo/proj.4/archive/${PROJ4_VERSION}.tar.gz && \
  curl -o gdal-${GDAL_VERSION}.tar.gz -sSL http://download.osgeo.org/gdal/2.0.1/gdal-${GDAL_VERSION}.tar.gz && \
  curl -o pg_shard-{PG_SHARD_VERSION}.tar.gz -sSL https://github.com/citusdata/pg_shard/archive/v${PG_SHARD_VERSION}.tar.gz
  export PATH=/usr/local/pgsql/bin/:$PATH && \
  tar xzf *.tar.gz && \
  cd proj.4-${PROJ4_VERSION}* && ./configure && make && make install && \
  cd ../geos-${GEOS_VERSION} && ./autogen.sh && ./configure CFLAGS="-D__sun -D__GNUC__" && make && make install && \
  cd ../gdal-$GDAL_VERSION && ./configure --with-static-proj4=/usr/local/lib --without-ogr && make && make install && \
  cd ../postgis-${POSTGIS_VERSION} && ./configure -- && make && make install && \
  cd ../pg_shard-{PG_SHARD_VERSION} && \
    make PG_CPPFLAGS="--std=c99 -Wall -Wextra -Wno-error -Wno-unused-parameter -Iinclude -I/usr/include -Itest/include -I. -I./ -I/usr/include/postgresql/server -I/usr/include/postgresql/internal" && \
    make install && \
  apk del curl libxml2-dev json-c-dev alpine-sdk autoconf automake libtool git --force && \
  rm /var/cache/apk/* && \
  rm -rf /tmp/build && \
  curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" && \
  chmod +x /usr/local/bin/gosu

RUN mkdir /docker-entrypoint-initdb.d

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data

VOLUME $PGDATA

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432

CMD ["postgres"]
