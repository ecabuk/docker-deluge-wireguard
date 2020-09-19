#!/usr/bin/env bash

AUTH_FILE=${DELUGE_CONFIG_DIR}/auth
USERNAME=$1
PASSWORD=$2
USER_LEVEL=${3:-10}

NEW_LINE=${USERNAME}:${PASSWORD}:${USER_LEVEL}

# Check for exact match
grep -Fxq "${NEW_LINE}" "${AUTH_FILE}"

if [[ $? == 0 ]];then
	>&2 echo "User '${USERNAME}' already exists."
	exit 1
fi

MODIFIED=0

# Check for username
grep -q "^${USERNAME}:" "${AUTH_FILE}"
if [[ $? == 0 ]];then
	# Remove existing entry
	sed -i "/^${USERNAME}:/ d" ${AUTH_FILE}
	MODIFIED=1
fi

# Add entry to the file
echo ${NEW_LINE} >> ${AUTH_FILE}

if [[ ${MODIFIED} == 0 ]];then
	echo "User '${USERNAME}' added successfully."
else
	echo "User '${USERNAME}' modified successfully."
fi