#!/bin/bash
FLASKDIR=$(readlink -e "${0%/*}")

. "$FLASKDIR"/config/settings.ini

echo "Starting $app_name"
echo "$FLASKDIR"

# activate the virtualenv
cd $FLASKDIR/$venv_dir
source bin/activate

export PYTHONPATH=$FLASKDIR:$PYTHONPATH

# Start your unicorn
exec gunicorn server:app \
    --statsd-host=localhost:8125 \
    --statsd-prefix=usershub \
	--access-logfile $FLASKDIR/var/log/access_uhv2.log \
	--pid="${app_name}.pid" \
	-w "${gun_num_workers}" \
	-b "${gun_host}:${gun_port}" \
	-n "${app_name}"
