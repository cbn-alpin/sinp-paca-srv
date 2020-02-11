FROM wordpress:5.3.2-php7.4-fpm

# Install utils and sendmail
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		less vim \
		#sendmail \
	&& rm -rf /var/lib/apt/lists/*

# Configure php to use sendmail
#RUN echo "sendmail_path=sendmail -t -i -f mailer@cbn-alpin.fr" >> /usr/local/etc/php/conf.d/sendmail.ini
# Create script to use as new entrypoint, which
# 1. Creates a localhost entry for container hostname in /etc/hosts
# 2. Restarts sendmail to discover this entry
# 3. Calls original docker-entrypoint.sh
#RUN	echo '#!/bin/bash' >> /usr/local/bin/docker-entrypoint-wrapper.sh \
#	&& echo 'set -euo pipefail' >> /usr/local/bin/docker-entrypoint-wrapper.sh \
#	&& echo 'echo "127.0.0.1 $(hostname) localhost localhost.localdomain" >> /etc/hosts' >> /usr/local/bin/docker-entrypoint-wrapper.sh \
#	&& echo 'service sendmail restart' >> /usr/local/bin/docker-entrypoint-wrapper.sh \
#	&& echo 'exec docker-entrypoint.sh "$@"' >> /usr/local/bin/docker-entrypoint-wrapper.sh \
#	&& chmod +x /usr/local/bin/docker-entrypoint-wrapper.sh
# Use new entry point wrapper
#ENTRYPOINT ["docker-entrypoint-wrapper.sh"]

# Add /etc/vim/vimrc.local
RUN echo "runtime! defaults.vim" > /etc/vim/vimrc.local \
	&& echo "let g:skip_defaults_vim = 1" >> /etc/vim/vimrc.local  \
	&& echo "set mouse=" >> /etc/vim/vimrc.local

# Uncomment alias from /root/.bashrc
RUN sed -i 's/^# alias/alias/' /root/.bashrc

# Use new entry point wrapper
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
