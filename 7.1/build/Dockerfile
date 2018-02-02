FROM xutongle/php:7.1-cli

LABEL maintainer="xutongle@gmail.com"

RUN set -xe \
	&& apk add --no-cache openssh-client git subversion curl wget unzip diffutils gpgme openjdk8 \
# Disable host key checking from within builds as we cannot interactively accept them
# TODO: It might be a better idea to bake ~/.ssh/known_hosts into the container
	&& mkdir -p ~/.ssh \
	&& printf "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

ENV XDEBUG_VERSION 2.5.5

RUN set -xe \
	&& apk add --no-cache --virtual .build-deps \
		$PHPIZE_DEPS \
	&& cd /tmp \
	&& curl -fSL http://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz -o xdebug-${XDEBUG_VERSION}.tgz \
	&& tar zxf xdebug-${XDEBUG_VERSION}.tgz \
	&& rm -rf xdebug-${XDEBUG_VERSION}.tgz \
	&& cd xdebug-${XDEBUG_VERSION} \
	&& phpize \
	&& ./configure --enable-xdebug \
	&& make -j "$(nproc)" \
	&& make install \
	&& rm -rf /tmp/xdebug-${XDEBUG_VERSION} \
	&& echo "zend_extension=xdebug.so" >> ${PHP_INI_DIR}/php/xdebug.ini \
	\
	&& apk del .build-deps

ENV YUI_COMPRESSOR_VERSION=2.4.8
ENV YUI_COMPRESSOR_JAR=https://github.com/yui/yuicompressor/releases/download/v${YUI_COMPRESSOR_VERSION}/yuicompressor-${YUI_COMPRESSOR_VERSION}.jar

RUN cd /tmp \
	&& curl -fSL ${YUI_COMPRESSOR_JAR} -o /usr/local/bin/yuicompressor.jar

ENV COMPILER_VERSION=20171203
ENV COMPILER_TGZ=http://dl.google.com/closure-compiler/compiler-${COMPILER_VERSION}.tar.gz

RUN mkdir -p /tmp/c \
	&& cd /tmp/c \
	&& curl -fSL ${COMPILER_TGZ} -o compiler-${COMPILER_VERSION}.tar.gz \
	&& tar zxf compiler-${COMPILER_VERSION}.tar.gz \
	&& mv -v closure-compiler-v${COMPILER_VERSION}.jar /usr/local/bin/closure-compiler.jar \
	&& rm -rf /tmp/c

# gpg keys listed at https://github.com/nodejs/node#release-team
RUN set -ex \
	&& for key in \
		94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
		FD3A5288F042B6850C66B31F09FE44734EB7990E \
		71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
		DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
		C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
		B9AE9905FFD7803F25714661B63B535A4C206CA9 \
		56730D5401028683275BD23C23EFEFE93C4CFFFE \
		77984A986EBC2AA786BC0F66B01FBB92821C587A \
		; do \
		gpg --keyserver pgp.mit.edu --recv-keys "${key}" || \
		gpg --keyserver keyserver.pgp.com --recv-keys "${key}" || \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${key}" ; \
	done

ENV NODE_VERSION=8.9.4

RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
	&& case "${dpkgArch##*-}" in \
		amd64) ARCH='x64';; \
		ppc64el) ARCH='ppc64le';; \
		s390x) ARCH='s390x';; \
		arm64) ARCH='arm64';; \
		armhf) ARCH='armv7l';; \
		i386) ARCH='x86';; \
		*) echo "unsupported architecture"; exit 1 ;; \
	esac \
	&& curl -SLO "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" \
	&& curl -SLO --compressed "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt.asc" \
	&& gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
	&& grep " node-v${NODE_VERSION}-linux-${ARCH}.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
	&& tar -xJf "node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
	&& rm "node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
	&& ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV YARN_VERSION 1.3.2

RUN set -ex \
	&& for key in \
		6A010C5166006599AA17F08146C2130DFD2497F5 \
	; do \
		gpg --keyserver pgp.mit.edu --recv-keys "${key}" || \
		gpg --keyserver keyserver.pgp.com --recv-keys "${key}" || \
		gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "${key}" ; \
	done \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz" \
	&& curl -fSLO --compressed "https://yarnpkg.com/downloads/${YARN_VERSION}/yarn-v${YARN_VERSION}.tar.gz.asc" \
	&& gpg --batch --verify yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz \
	&& mkdir -p /opt/yarn \
	&& tar -xzf yarn-v${YARN_VERSION}.tar.gz -C /opt/yarn --strip-components=1 \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
	&& ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
	&& rm yarn-v${YARN_VERSION}.tar.gz.asc yarn-v${YARN_VERSION}.tar.gz