#!/bin/bash
# Encoding : UTF-8
# Backup GeoNature-Atlas Postgresql Database

BACKUP_DIR="/home/admin/backups/postgresql"
BACKUP_NAME="$(date +%F)_gnatlas"
BACKUP_PATH="${BACKUP_DIR}/${BACKUP_NAME}.sql"

mkdir -p "${BACKUP_DIR}";
cd "${BACKUP_DIR}"

pg_dump --file "${BACKUP_PATH}" \
	--host "localhost" \
	--port "5432" \
	--username "geonatatlas" \
	--verbose \
	--format=p \
	gnatlas
tar -cvf "${BACKUP_NAME}.tar" -C "${BACKUP_DIR}" "${BACKUP_NAME}.sql"

rm -f "${BACKUP_PATH}"
find "${BACKUP_DIR}" -name "*_gnatlas.tar" -type f -mtime +365 -exec rm -f {} \;
