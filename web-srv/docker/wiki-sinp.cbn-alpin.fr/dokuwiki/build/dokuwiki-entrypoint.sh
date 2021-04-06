#!/bin/bash
set -e

# Copy Dokuwiki upgraded files into volume...
DW_VERSION_CURRENT=$(cat "${HTML_PATH}/VERSION")
CYellow="\\033[1;33m"
CGreen="\\033[1;32m"
CRed="\\033[1;31m"
CReset="\\033[0;39m"
if [[ -d "/tmp/dokuwiki-${DW_VERSION_DATE}" ]]; then
	echo -e ${CYellow}"/tmp/dokuwiki-${DW_VERSION_DATE} exists !"${CReset}
	if grep -q '${DW_VERSION}' "${HTML_PATH}/VERSION"; then
		echo -e ${CGreen}'Dokuwiki already in version ${DW_VERSION}. Dokuwiki will not be upgraded !'${CReset}
	else
		echo -e ${CYellow}'Dokuwiki upgrading to ${DW_VERSION} !'${CReset}
		'cp' -af /tmp/dokuwiki-${DW_VERSION_DATE}/* ${HTML_PATH}/
		cd ${HTML_PATH}/
		grep -Ev '^($|#)' ${HTML_PATH}/data/deleted.files | xargs -n 1 rm -fr
		rm -fR /tmp/dokuwiki-${DW_VERSION_DATE}/
		chown -R www-data: ${HTML_PATH}
	fi
else
	echo -e ${CGreen}"/tmp/dokuwiki-${DW_VERSION_DATE} NOT exists."${CReset}
	echo -e ${CGreen}"Dokuwiki already in version ${DW_VERSION_CURRENT}. Dokuwiki will not be upgraded !"${CReset}
fi

exec "$@"
