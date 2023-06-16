#!/usr/bin/env bash
# Encoding : UTF-8
# Script to restore GeoNature database custom dump into Postgresql container.

set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes


# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [options]
     -h | --help: display this help
     -v | --verbose: display more infos
     -x | --debug: display debug script infos
     -c | --config: path to config file to use (default : settings.ini)

Specific options:
     -d | --dump-file: database dump file name
EOF
    exit 0
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parseScriptOptions() {
    # Transform long options to short ones
    for arg in "${@}"; do
        shift
        case "${arg}" in
            "--help") set -- "${@}" "-h" ;;
            "--verbose") set -- "${@}" "-v" ;;
            "--debug") set -- "${@}" "-x" ;;
            "--config") set -- "${@}" "-c" ;;
            "--dump-file") set -- "${@}" "-d" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxc:d:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
            "c") setting_file_path="${OPTARG}" ;;
            "d") setting_dump_file="${OPTARG}" ;;
            *) exitScript "ERROR : parameter invalid ! Use -h option to know more." 1 ;;
        esac
    done
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    #+----------------------------------------------------------------------------------------------------------+
    # Load utils
    source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    #redirectOutput "${default_log_file}"

	#+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "${app_name} script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
	setConstants
	printInfos
	restoreGeoNatureDbDump


    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

# DESC: Define value of gnrs_dump_file variable
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: variable gnrs_dump_file indicating command-line parameters and options
function setConstants() {
	readonly gnrs_dump_file="${setting_dump_file-${POSTGRES_RESTORE_FILE-'geonature2db.dump'}}"
	readonly gnrs_pgrestore_log="/restore/$(date +"%Y-%m-%d")_pgrestore.log"
}


function printInfos() {
	printVerbose "Informations about this script..." ${Yel}
	printVerbose "\tScript running:${Whi} ${script_path} ${script_params}" ${Gra}
	printVerbose "\tDump file:${Whi} ${gnrs_dump_file}" ${Gra}
	printVerbose "\tsetting_dump_file:${Whi} ${setting_dump_file}" ${Gra}
	printVerbose "\tPOSTGRES_RESTORE_FILE:${Whi} ${POSTGRES_RESTORE_FILE}" ${Gra}
	printVerbose "\tDatabase:${Whi} ${gnrs_db_name} @ ${gnrs_db_host}:${gnrs_db_port} used by ${gnrs_db_user}" ${Gra}
}

function restoreGeoNatureDbDump() {
	if psql --username "${gnrs_db_user}" -lqt | cut -d \| -f 1 | grep -qw "${gnrs_db_name}"; then
		psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${gnrs_db_name}' AND pid <> pg_backend_pid();" 
		dropdb --username "${gnrs_db_user}" --if-exists "${gnrs_db_name}" 
	fi
	#psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command "ALTER ROLE ${gnrs_db_user} SUPERUSER;"
	createdb --username "${gnrs_db_user}" -T template0 "${gnrs_db_name}"
	psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command "GRANT ALL PRIVILEGES ON DATABASE ${gnrs_db_name} TO ${gnrs_db_user};" 
	pg_restore --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --jobs "$(nproc)" --verbose "/restore/${gnrs_dump_file}" 2>&1 | tee "${gnrs_pgrestore_log}" 
	psql --username "${gnrs_db_user}" --dbname "${gnrs_db_name}" --command "ALTER ROLE geonatadmin NOSUPERUSER;"
}

main "${@}"
