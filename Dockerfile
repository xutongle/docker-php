ARG PHP_BASE_IMAGE_VERSION
FROM xutl/php:${PHP_BASE_IMAGE_VERSION}

LABEL maintainer="xutongle@gmail.com"

# Environment settings
ENV PATH=/app:/app/vendor/bin:$PATH

RUN set -xe \
	&& buildDeps=" \
		libmemcached-dev \
		libyaml-dev \
		libnghttp2-dev \
		libssl-dev \
	" \
	\
#	&& sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list \
	&& apt-get update && apt-get install -y --no-install-recommends --no-install-suggests libmemcached11 libyaml-0-2 libnghttp2-14 $buildDeps && rm -r /var/lib/apt/lists/* \
	\
	&& msgpackVersion=2.0.2 \
		igbinaryVersion=2.0.5 \
		memcachedVersion=3.0.4 \
		redisVersion=3.1.6 \
		yamlVersion=2.0.2 \
		swooleVersion=2.0.12 \
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/msgpack-${msgpackVersion}.tgz -o msgpack-${msgpackVersion}.tgz \
	&& tar zxf msgpack-${msgpackVersion}.tgz \
	&& rm -rf msgpack-${msgpackVersion}.tgz \
	&& cd msgpack-${msgpackVersion} \
	&& phpize \
	&& ./configure \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/msgpack-${msgpackVersion} \
	&& echo "extension=msgpack.so" >> ${PHP_INI_DIR}/php/msgpack.ini \
	\
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/igbinary-${igbinaryVersion}.tgz -o igbinary-${igbinaryVersion}.tgz \
	&& tar zxf igbinary-${igbinaryVersion}.tgz \
	&& rm -rf igbinary-${igbinaryVersion}.tgz \
	&& cd igbinary-${igbinaryVersion} \
	&& phpize \
	&& ./configure \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/igbinary-${igbinaryVersion} \
	&& echo "extension=igbinary.so" >> ${PHP_INI_DIR}/php/igbinary.ini \
	\
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/memcached-${memcachedVersion}.tgz -o memcached-${memcachedVersion}.tgz \
	&& tar zxf memcached-${memcachedVersion}.tgz \
	&& rm -rf memcached-${memcachedVersion}.tgz \
	&& cd memcached-${memcachedVersion} \
	&& phpize \
	&& ./configure --enable-memcached --enable-memcached-igbinary --enable-memcached-json --enable-memcached-msgpack --with-libdir=lib64 \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/memcached-${memcachedVersion} \
	&& echo "extension=memcached.so" >> ${PHP_INI_DIR}/php/memcached.ini \
	\
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/redis-${redisVersion}.tgz -o redis-${redisVersion}.tgz \
	&& tar zxf redis-${redisVersion}.tgz \
	&& rm -rf redis-${redisVersion}.tgz \
	&& cd redis-${redisVersion} \
	&& phpize \
	&& ./configure --enable-redis --enable-redis-igbinary \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/redis-${redisVersion} \
	&& echo "extension=redis.so" >> ${PHP_INI_DIR}/php/redis.ini \
	\
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/yaml-${yamlVersion}.tgz -o yaml-${yamlVersion}.tgz \
	&& tar zxf yaml-${yamlVersion}.tgz \
	&& rm -rf yaml-${yamlVersion}.tgz \
	&& cd yaml-${yamlVersion} \
	&& phpize \
	&& ./configure \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/yaml-${yamlVersion} \
	&& echo "extension=yaml.so" >> ${PHP_INI_DIR}/php/yaml.ini \
	\
	&& cd /usr/local/src \
	&& curl -fSL https://github.com/redis/hiredis/archive/v0.13.3.tar.gz -o hiredis-0.13.3.tar.gz \
	&& tar zxf hiredis-0.13.3.tar.gz \
	&& rm -rf hiredis-0.13.3.tar.gz \
	&& cd hiredis-0.13.3 \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/hiredis-0.13.3 \
	\
	&& cd /usr/local/src \
	&& curl -fSL http://pecl.php.net/get/swoole-${swooleVersion}.tgz -o swoole-${swooleVersion}.tgz \
	&& tar zxf swoole-${swooleVersion}.tgz \
	&& rm -rf swoole-${swooleVersion}.tgz \
	&& cd swoole-${swooleVersion} \
	&& phpize \
	&& ./configure --enable-http2 --enable-openssl --enable-sockets --enable-mysqlnd --enable-async-redis \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /usr/local/src/swoole-${swooleVersion} \
	&& echo "extension=swoole.so" >> ${PHP_INI_DIR}/php/swoole.ini \
	\
	&& apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
	&& mkdir /app \
	&& chown -R www-data:www-data /app

WORKDIR /app