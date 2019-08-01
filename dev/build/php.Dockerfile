FROM php:7.3-fpm-alpine

RUN apk --update add \
       libxml2-dev \
       zlib-dev \
  && docker-php-ext-install mbstring pdo pdo_mysql tokenizer xml \
  && apk del libxml2-dev zlib-dev

ARG PHP_INI_PATH=/usr/local/etc/php/php.ini
ARG PHP_FPM_INI_PATH=/usr/local/etc/php-fpm.d/www.conf

RUN \
    adduser -D -u 1000 php && \
    mv /usr/local/etc/php/php.ini-production $PHP_INI_PATH && \
    sed -i \
      -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
      -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
      -e "s/;daemonize\s*=\s*yes/daemonize = no/g" \
      -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
      $PHP_INI_PATH && \
    sed -i \
      -e "s/^user =/;user =/g" \
      -e "s/^group =/;group =/g" \
      -e "s/^listen = 127.0.0.1:/listen = /g" \
      -e "s/^;clear_env = no$/clear_env = no/" \
      $PHP_FPM_INI_PATH && \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && \
    mv composer.phar /usr/local/bin/composer

RUN mkdir /app && \
  chown php:php /app
USER php
EXPOSE 9000
WORKDIR /app
