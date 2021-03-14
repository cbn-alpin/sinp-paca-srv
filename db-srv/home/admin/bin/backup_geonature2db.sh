#!/bin/bash
# Encoding : UTF-8
# Backup GeoNature Postgresql Database

BACKUP_DIR="/home/admin/backups/postgresql"
BACKUP_NAME="$(date +%F)_gonature2db"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}"

mkdir -p "${BACKUP_DIR}"
cd "${BACKUP_DIR}"

pg_dump --file "${BACKUP_PATH}" \
	--host "localhost" \
	--port "5432" \
	--username "geonatadmin" \
	--verbose \
	--format=d \
	--jobs=$(grep -c ^processor /proc/cpuinfo) \
	--compress 9 \
	geonature2db
tar -cvf "${BACKUP_NAME}.tar" -C "${BACKUP_DIR}" "${BACKUP_NAME}/"

rm -fR "${BACKUP_NAME}/"
find "${BACKUP_DIR}" -name "*_gonature2db.tar" -type f -mtime +5 -exec rm -f {} \;
