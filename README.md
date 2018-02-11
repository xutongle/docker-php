# 基于 alpine 3.7 构建的 PHP执行环境

## Build Status

[![Build Status](https://travis-ci.org/xutongle/docker-php.svg?branch=master)](https://travis-ci.org/xutongle/docker-php) 

## 支持的标签和相应的 `Dockerfile` 链接

标签说明，以 `x.x.x-fpm-base` 方式命名的标签，为没有开9000端口的FPM版本。用来作为父镜像打包 `nginx` 版本。

-	[`7.2.1-cli`, `7.2-cli`(*7.2/cli/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.2/cli/Dockerfile)
-	[`7.2.1-fpm`, `7.2-fpm`(*7.2/fpm/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.2/fpm/Dockerfile)
-	[`7.2.1-nginx`, `7.2-nginx`(*7.2/nginx/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.2/nginx/Dockerfile)
-	[`7.2.1-build`, `7.2-build`(*7.2/build/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.2/build/Dockerfile)
-	[`7.2.1-fpm-base`, `7.2-fpm-base`(*7.2/fpm-base/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.2/fpm-base/Dockerfile)
-	[`7.1.13-cli`, `7.1-cli`(*7.1/cli/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.1/cli/Dockerfile)
-	[`7.1.13-fpm`, `7.1-fpm`(*7.1/fpm/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.1/fpm/Dockerfile)
-	[`7.1.13-fpm-base`, `7.1-fpm-base`(*7.1/fpm-base/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.1/fpm-base/Dockerfile)
-	[`7.1.13-build`, `7.1-build` (*7.1/build/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.1/fpm-base/Dockerfile)
-	[`7.1.13-nginx`, `7.1-nginx` (*7.1/nginx/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.1/fpm-base/Dockerfile)
-	[`7.0.27-cli`, `7.0-cli`(*7.0/cli/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.0/cli/Dockerfile)
-	[`7.0.27-fpm`, `7.0-fpm`(*7.0/fpm/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.0/fpm/Dockerfile)
-	[`7.0.27-fpm-base`, `7.1-fpm-base`(*7.0/fpm-base/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.0/fpm-base/Dockerfile)
-	[`7.0.27-build`, `7.1-build`(*7.0/build/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.0/build/Dockerfile)
-	[`7.0.27-nginx`, `7.1-nginx`(*7.0/nginx/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/7.0/nginx/Dockerfile)
-	[`5.6.33-cli`, `5.6-cli`(*5.6/cli/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/5.6/cli/Dockerfile)
-	[`5.6.33-fpm`, `5.6-fpm`(*5.6/fpm/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/5.6/fpm/Dockerfile)
-	[`5.6.33-fpm-base`, `5.6-fpm-base`(*5.6/fpm-base/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/5.6/fpm-base/Dockerfile)
-	[`5.6.33-build`, `5.6-build`(*5.6/build/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/5.6/build/Dockerfile)
-	[`5.6.33-nginx`, `5.6-nginx`(*5.6/nginx/Dockerfile*)](https://github.com/xutongle/docker-php/blob/master/5.6/nginx/Dockerfile)

## Container layout

Container                               | Distribution name        | PHP Version
--------------------------------------- | ------------------------ | --------------
`xutl/php:5.6`      | alpine 3.7             | PHP 5.6
`xutl/php:7.0`      | alpine 3.7             | PHP 7.0
`xutl/php:7.1`      | alpine 3.7             | PHP 7.1
`xutl/php:7.2`      | alpine 3.7             | PHP 7.2

## Filesystem layout

Directory                       | Description
------------------------------- | ------------------------------------------------------------------------------
`/usr/local/etc/php-fpm.d`       | php-fpm pool configuration
`/usr/local/etc/nginx`           | Nginx configuration path
`/usr/local/etc/nginx/sites`     | Nginx sites configuration path

File                                                | Description
--------------------------------------------------- | ------------------------------------------------------------------------------
`/usr/local/etc/php.ini`                          | PHP configuration
`/usr/local/etc/nginx/nginx.conf`                 | Global nginx configuration options
`/usr/local/etc/php-fpm.d/www.conf`               | php-fpm pool configuration
`/usr/local/etc/php/php-fpm.conf`             | PHP FPM daemon configuration

## Expand

Expand                                                | Version
--------------------------------------------------- | ------------------------------------------------------------------------------
`msgpack`                          | 0.5.7/2.0.2
`igbinary`                 | 2.0.5
`memcached`               | 2.2.0/3.0.4
`redis`             | 3.1.6
`yaml`             | 1.3.1/2.0.2
`yaconf`             | 1.0.7
`swoole`             | 2.1.0
`xdebug`             | 2.5.5 Only build tags

## Build Tag

`build` 版标签包含的软件包，用来执行 `composer` 命令，打包前端脚本、执行单元测试(包含 xdebug 扩展)等。 

openssh-client git subversion curl wget nano unzip diffutils ntp openjdk-8-jdk yuicompressor closure-compiler nodejs-8.9.4 yarn-1.3.2

### Path

/usr/local/bin/yuicompressor.jar

/usr/local/bin/closure-compiler.jar




