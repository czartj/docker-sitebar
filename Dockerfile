FROM php:8.2.17-fpm-alpine3.18

ARG BUILD_DATE
ARG VCS_REF

LABEL maintainer="CzarTJ" \
  org.label-schema.name="SiteBar" \
  org.label-schema.description="Minimal SiteBar docker image based on Alpine Linux." \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/czartj/docker-sitebar" \
  org.label-schema.schema-version="1.0"

ARG UID=1502
ARG GID=1502

RUN set -ex \
  && apk update \
  && apk upgrade \
  && apk add \
    alpine-sdk \
    autoconf \
    bash \
    nginx \
    postgresql-dev \
    postgresql-libs \
    supervisor \
    tini \
    wget \
# PHP Extensions
  && docker-php-ext-install mysqli opcache pdo_mysql pdo_pgsql pgsql \
  && pecl install APCu-5.1.23 \
  && docker-php-ext-enable apcu \
# Remove dev packages
  && apk del \
    alpine-sdk \
    autoconf \
    postgresql-dev \
  && rm -rf /var/cache/apk/* \
# Add user for sitebar
  && addgroup -g ${GID} sitebar \
  && adduser -u ${UID} -h /opt/sitebar -H -G sitebar -s /sbin/nologin -D sitebar \
  && mkdir -p /opt \
# Download SiteBar from: Fri Mar 24 18:12:21 2023 +0100
  && cd /tmp \
  && SITEBAR_VER_TAG="1.1" \
  && wget -q https://github.com/czartj/sitebar/archive/refs/tags/v${SITEBAR_VER_TAG}.zip \
# Extract
  && unzip v${SITEBAR_VER_TAG}.zip -d /opt \
  && mv /opt/sitebar-${SITEBAR_VER_TAG} /opt/sitebar \
  && rm -Rf /opt/sitebar/adm \
  && mkdir /config \
  && ln -s /config /opt/sitebar/adm \
# Clean up
  && rm -rf /tmp/* /root/.gnupg /var/www/*

COPY root /

RUN chmod +x /usr/local/bin/run.sh \
  && chmod +x /usr/local/bin/build_config.sh

VOLUME ["/config"]

EXPOSE 80

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/local/bin/run.sh"]
