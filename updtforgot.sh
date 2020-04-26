#!/bin/bash

PY_WORKING="/home/christian/gluu-repos/oxAuthRepo/Server/integrations/forgot_password/*.py"
XHTML_WORKING="/home/christian/gluu-repos/oxAuthRepo/Server/src/main/webapp/auth/forgot_password/*.xhtml"
PY_GLUU_CHMOD='/opt/gluu-server/custom/.'
XHTML_GLUU_CHMOD='/opt/gluu-server/opt/gluu/jetty/oxauth/custom/pages/auth/forgot_password/.'

nohup bash gluurstrt.sh &
pid="$!"
echo "PID var is $pid"
#trap "sudo kill -9 $pid" INT
trap ctrl_c INT

function ctrl_c()
{
	echo "Trapped CTRL+C"
	sudo kill -9 $pid
}



while inotifywait -e close_write $PY_WORKING $XHTML_WORKING ;
do
	date -d now 
	sudo cp /home/christian/gluu-repos/oxAuthRepo/Server/integrations/forgot_password/*.py /opt/gluu-server/custom/.
	echo "Files *.py updated on gluu-server chmod"
	wait 2
	sudo cp /home/christian/gluu-repos/oxAuthRepo/Server/src/main/webapp/auth/forgot_password/*.xhtml /opt/gluu-server/opt/gluu/jetty/oxauth/custom/pages/auth/forgot_password/.
	echo "Files *.xhtml updated on gluu-server chmod"
	sleep 1
done
