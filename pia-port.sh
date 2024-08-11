#!/bin/bash

trap 'exit 0' SIGTERM

PORTFILEDIR="/piashared"

# Use --monitor to keep inotifywait running forever
# Use --quiet to prevent spurious output

inotifywait --quiet --monitor --event modify --event create ${PORTFILEDIR} --format '%f'| while read FILENAME ; do
	echo "File ${FILENAME} changed"
	PORT=$(cat ${PORTFILEDIR}/$FILENAME)
	echo "Forwarded port is ${PORT}"

	# Authenticate with qBitTorrent
	echo "Authenticating against ${HOST}"
	curl --silent --retry 10 --retry-delay 15 --max-time 10 \
		--data "username=${USERNAME}&password=${PASSWORD}" \
		--cookie-jar /tmp/qb-cookies.txt \
		http://${HOST}/api/v2/auth/login

	echo "Setting port to ${PORT}"
	
	# Set the port in qBitTorrent
	curl --silent --retry 10 --retry-delay 15 --max-time 10 \
		--data 'json={"listen_port": "'"$PORT"'"}' \
		--cookie /tmp/qb-cookies.txt \
		http://${HOST}/api/v2/app/setPreferences

	echo "Update complete"
done
