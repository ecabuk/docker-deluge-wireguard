#!/usr/bin/env bash

USERNAME=$1
AUTH_FILE=${DELUGE_CONFIG_DIR}/auth

if [[ ! -f "${AUTH_FILE}" ]];then
	>&2 echo "auth file does not exists."
	exit 1
fi

grep -q "^${USERNAME}:" "${AUTH_FILE}"
if [[ $? == 0 ]];then
	sed -i "/^${USERNAME}:/ d" ${AUTH_FILE}
	echo "User '${USERNAME}' successfully removed."
else
	>&2 echo "User '${USERNAME}' does not exist."
	exit 1
fi