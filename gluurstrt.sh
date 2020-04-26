while :
do
	sudo tail -f /opt/gluu-server/opt/gluu/jetty/oxauth/logs/oxauth_script.log | grep -q "Metaspace"
	date -d now
	echo "Metaspace Error Found, restarting..."
	sudo gluu-serverd restart
	date -d now
	echo "Restarted - Sleeping for 2 min..."
	sleep 2m
done
