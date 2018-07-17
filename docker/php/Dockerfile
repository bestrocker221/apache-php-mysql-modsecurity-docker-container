FROM php:7.1-fpm-alpine
 
ARG WEB_USER
ARG WEB_GROUP
ARG PHP_ROOT_DIR


COPY config/www.conf ${PHP_ROOT_DIR}/php-fpm.d/www.conf
COPY config/php.ini ${PHP_ROOT_DIR}/php/
 
RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories && \
	apk update && apk --no-cache add  \
    freetype-dev \
	alpine-sdk \
	libjpeg-turbo-dev \
	libcrypto1.0 \
	libpng-dev  \
	zlib-dev \
	curl-dev \
	icu-dev \
	autoconf \
	shadow
		
RUN	pecl update-channels  \
		&& pecl install timezonedb \
		&& docker-php-ext-enable timezonedb \
		&& docker-php-ext-configure intl \
		&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
		&& docker-php-ext-install -j$(nproc) mbstring pdo pdo_mysql \
		mysqli zip curl gd intl

# install APCu for only data store
# OPcache for only opcode cache

RUN pecl install apcu \
		&& docker-php-ext-enable apcu \
		&& docker-php-ext-install -j$(nproc) opcache \
		&& docker-php-ext-enable opcache

# Copy configuration
COPY config/opcache.ini $PHP_INI_DIR/conf.d/
COPY config/apcu.ini $PHP_INI_DIR/conf.d/


RUN usermod -u 1000 ${WEB_USER} \
 		&& groupmod -g 1000 ${WEB_GROUP} \
 		&& chgrp -R ${WEB_GROUP}  ${PHP_ROOT_DIR}/php-fpm.d/www.conf