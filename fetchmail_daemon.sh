#!/bin/sh
echo "Start supervisor"
supervisord -c /etc/supervisord.conf

echo "Supervisord started"

while true; do
	tail -f /var/log/messages
	sleep 10
done	
