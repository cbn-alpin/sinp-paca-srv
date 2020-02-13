FROM php:7.3.14-fpm-buster

LABEL author="Jean-Pascal MILCENT" \
  version="1" \
  maintainer="jp.milcent@cbn-alpin.fr"

ARG BACKUP_DATE

ENV DW_VERSION=2018-04-22b
ENV DW_DOWNLOAD_URL=https://download.dokuwiki.org/src/dokuwiki/dokuwiki-${DW_VERSION}.tgz
ENV DW_MD5_CHECKSUM=605944ec47cd5f822456c54c124df255
ENV HTML_PATH /var/www/html

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        vim \
		wget \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev && \
    docker-php-ext-install -j$(nproc) iconv && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
	apt-get clean autoclean && \
	apt-get -y autoremove && \
	rm -rf /var/lib/{apt,dpkg,cache,log}

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /tmp
SHELL ["/bin/bash", "-c"]
RUN wget -q -O dokuwiki.tgz ${DW_DOWNLOAD_URL}
RUN if [ "$DW_MD5_CHECKSUM" != "$(md5sum dokuwiki.tgz | awk '{print($1)}')" ];then \
      echo "Dokuwiki downloaded file have wrong md5sum !"; \
      exit 1; \
    fi
RUN tar xzf dokuwiki.tgz -C /var/www/html --strip-components 1
RUN rm -f dokuwiki.tgz
RUN rm -fR dokuwiki-${DW_VERSION}/
#COPY    ./do/wakka.config.php ${HTML_PATH}/wakka.config.php
#COPY    ./yeswiki/themes ${HTML_PATH}/themes
ADD ./${BACKUP_DATE}_wiki-sinp_backup.tar.bz2 ${HTML_PATH}
RUN chown -R www-data: ${HTML_PATH}

WORKDIR ${HTML_PATH}
