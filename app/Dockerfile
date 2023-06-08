FROM composer:2.4.4 AS composer
WORKDIR /app
COPY code/composer.json .
COPY code/composer.lock .
RUN composer install \
    --ignore-platform-reqs

FROM php:8.1.12-apache-buster
ENV PHALCON_VERSION="5.1.4"

RUN apt update -y && \
    apt install -y \
        apt-utils \
        gettext \
        libzip-dev \
        sudo \
        zip
RUN pecl install phalcon-${PHALCON_VERSION} \
      xdebug
RUN docker-php-ext-install \
      gettext \
      pdo_mysql \
      zip \
    && docker-php-ext-enable \
      opcache \
      phalcon \
      xdebug \
    && a2enmod rewrite \
    && apt autoremove -y \
    && apt autoclean -y \
    && apt clean -y \
    && rm -rf /tmp/* /var/tmp/* \
    && find /var/cache/apt/archives /var/lib/apt/lists /var/cache \
      -not -name lock \
      -type f \
      -delete \
    && find /var/log -type f | while read f; do echo -n '' > ${f}; done

COPY config/extra.ini /usr/local/etc/php/conf.d/
WORKDIR /var/www
COPY --chown=www-data:www-data ./code .
COPY --chown=www-data:www-data ./code/public ./html
COPY --chown=www-data:www-data config/.env ./.env
COPY --chown=www-data:www-data --from=composer /app/vendor/ ./vendor

EXPOSE 80
