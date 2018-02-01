ARG PHP_BASE_IMAGE_VERSION
FROM xutl/php:${PHP_BASE_IMAGE_VERSION}

LABEL maintainer="xutongle@gmail.com"

# Environment settings
ENV PATH=/app:$PATH

RUN set -xe \
	&& mkdir /app \
	&& chown -R www-data:www-data /app

WORKDIR /app