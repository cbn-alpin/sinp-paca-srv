FROM matomo:4.2.1-fpm
# See : https://www.projekt-rootserver.de/matomo-docker-image-erstellen/2019/09/

ARG MSMTP_OVH_PWD

# Install utils and sendmail
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		apt-utils less vim sudo \
		msmtp msmtp-mta bsd-mailx mailutils \
	&& rm -rf /var/lib/apt/lists/*

# Override php.ini properties for Matomo
COPY matomo.ini /usr/local/etc/php/conf.d/matomo.ini

# Create Msmtp config file
COPY msmtprc.conf /etc/msmtprc
RUN sed -i "s/\$MSMTP_OVH_PWD/${MSMTP_OVH_PWD}/g" /etc/msmtprc
RUN chmod 600 /etc/msmtprc && \
	chown www-data:www-data /etc/msmtprc

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

# Use new entry point wrapper
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
