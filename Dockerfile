FROM php:fpm-alpine as base

ARG WORKFOLDER

ENV WORKPATH ${WORKFOLDER}
ENV COMPOSER_ALLOW_SUPERUSER 1

RUN docker-php-ext-install pdo_mysql

COPY docker/php/conf/php.ini /usr/local/etc/php/php.ini

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN mkdir -p ${WORKPATH} \
    && chown -R www-data /tmp/ \
    && mkdir -p \
       ${WORKPATH}/var/cache \
       ${WORKPATH}/var/logs \
       ${WORKPATH}/var/sessions \
    && chown -R www-data ${WORKPATH}/var

WORKDIR ${WORKPATH}

COPY --chown=www-data:www-data . ./
