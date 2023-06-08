FROM wordpress:6.2.2-php8.2-fpm
# https://hub.docker.com/_/wordpress

# Install utils and sendmail
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim \
	&& rm -rf /var/lib/apt/lists/*

# Override upload properties to php.ini
COPY upload.ini /usr/local/etc/php/conf.d/upload.ini

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

# Use new entry point wrapper
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
