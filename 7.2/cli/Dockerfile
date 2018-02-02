FROM xutl/base-php:alpine-3.7

LABEL maintainer="xutongle@gmail.com"

ARG PHP_VERSION

# Environment settings
ENV PHP_VERSION ${PHP_VERSION:-7.2.1}
ENV PHP_TGZ_URL http://cn.php.net/distributions/php-${PHP_VERSION}.tar.gz
ENV PHP_INI_DIR=/usr/local/etc \
	PATH=/root/.composer/vendor/bin:$PATH \
	TERM=linux \
	COMPOSER_ALLOW_SUPERUSER=1

# Apply stack smash protection to functions using local buffers and alloca()
# Make PHP's main executable position-independent (improves ASLR security mechanism, and has no performance impact on x86_64)
# Enable optimization (-O2)
# Enable linker optimization (this sorts the hash buckets to improve cache locality, and is non-default)
# Adds GNU HASH segments to generated executables (this is used if present, and is much faster than sysv hash; in this configuration, sysv hash is also generated)
# https://github.com/docker-library/php/issues/272
ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O2"
ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O1 -Wl,--hash-style=both -pie"

RUN set -xe \
	&& buildDeps=" \
		coreutils \
		curl-dev \
		libedit-dev \
		libressl-dev \
		libxml2-dev \
		sqlite-dev \
		gettext-dev \
		bzip2-dev \
		jpeg-dev \
		libpng-dev \
		freetype-dev \
		icu-dev \
		gmp-dev \
		tidyhtml-dev \
		libxslt-dev \
		libzip-dev \
	" \
	\
#	&& echo -e "https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.7/main\nhttps://mirrors.tuna.tsinghua.edu.cn/alpine/v3.7/community" > /etc/apk/repositories \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
	    $buildDeps  \
	\
	&& export CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
	&& cd /tmp \
	&& curl -fSL ${PHP_TGZ_URL} -o php-${PHP_VERSION}.tar.gz \
	&& tar zxf php-${PHP_VERSION}.tar.gz \
	&& rm -f php-${PHP_VERSION}.tar.gz \
	&& cd /tmp/php-${PHP_VERSION} \
	&& ./configure \
		--prefix=/usr/local \
		--libdir=/usr/local/lib64 \
		--with-config-file-path=${PHP_INI_DIR} \
		--with-config-file-scan-dir=${PHP_INI_DIR}/php \
		--with-libxml-dir \
		--with-openssl \
		--with-kerberos \
		--with-zlib \
		--with-curl \
		--with-bz2 \
		--with-png-dir \
		--with-gd \
		--with-jpeg-dir \
		--with-libzip \
		--with-xmlrpc \
		--with-libedit \
		--with-iconv-dir=/usr/local \
		--with-xsl \
		--with-gmp \
		--with-tidy \
		--with-pcre-dir \
		--with-readline \
		--with-pcre-regex \
		--with-pcre-jit \
		--with-freetype-dir \
		--with-zlib-dir \
		--without-pear \
		--with-mcrypt \
		--with-mysqli=mysqlnd \
		--with-pdo-mysql=mysqlnd \
		--with-pdo-sqlite \
		--with-sqlite3 \
		--with-mhash \
		--with-gettext \
		--with-libdir=lib64 \
		--enable-bcmath \
		--enable-calendar \
		--enable-exif \
		--disable-cgi \
		--enable-ftp \
		--enable-gd-native-ttf \
		--enable-mbstring \
		--enable-mbregex \
		--enable-shmop \
		--enable-soap \
		--enable-sockets \
		--enable-sysvmsg \
		--enable-sysvsem \
		--enable-sysvshm \
		--enable-wddx \
		--enable-zip \
		--enable-xml \
		--disable-rpath \
		--enable-inline-optimization \
		--enable-pcntl \
		--enable-fileinfo \
		--enable-intl \
		--enable-opcache \
		--enable-cli \
	&& make ZEND_EXTRA_LIBS='-liconv' \
	&& make install \
	&& rm -rf /tmp/php-${PHP_VERSION} \
	&& mkdir -p ${PHP_INI_DIR}/php \
	&& mkdir -p /var/lib/php \
	&& apk del .build-deps

# Add configuration files
COPY image-files/ /

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
	&& php -r "unlink('composer-setup.php');" \
	&& composer global require hirak/prestissimo --optimize-autoloader \
	&& composer global dumpautoload --optimize \
	&& composer clear-cache

ENTRYPOINT ["docker-entrypoint"]

CMD ["php", "-a"]