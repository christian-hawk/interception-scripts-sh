#!/bin/bash

PY_WORKING="/home/christian/gluu-repos/oxAuthRepo/Server/integrations/saml-passport/*.py"
XHTML_WORKING=""
PY_GLUU_CHMOD='/opt/gluu-server/custom/.'
XHTML_GLUU_CHMOD=''

# Leave REMOTE_GLUU_SERVER and REMOTE_SERVER_USERNAME empty ('') if local
REMOTE_GLUU_SERVER='chris.gluulocal.org'
REMOTE_SERVER_USERNAME='ubserver'


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
		if [ ! -z "$REMOTE_GLUU_SERVER" ]
		then
			date -d now
			echo "Remote server $REMOTE_GLUU_SERVER exists... connecting"
			echo "Creating temp dir.."
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER sudo mkdir interceptsh
			sleep 2s
			echo "Adding permissions..."
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER sudo chmod 777 interceptsh
			sleep 2s
			echo "updating PY..."
			scp $PY_WORKING $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER:interceptsh
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER sudo cp ./interceptsh/*.* $PY_GLUU_CHMOD
			sleep 1s
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER sudo rm ./interceptsh/*.*

			echo "Files *.py updated on gluu-server chmod"
			scp $XHTML_WORKING $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER:interceptsh
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER cp ./interceptsh/*.* $XHTML_GLUU_CHMOD
			echo "Files *.xhtml updated on gluu-server chmod"
			echo "Removing directory..."
			ssh -t $REMOTE_SERVER_USERNAME@$REMOTE_GLUU_SERVER sudo rm -r interceptsh

		else
			date -d now 
			echo "Working on local server..."
			echo "updating PY files on running gluu-server..."
			sudo cp $PY_WORKING $PY_GLUU_CHMOD
			echo "Files *.py updated on gluu-server chmod"
			sleep 2s
			echo "updating XHTML files on gluu-server chmod..."
			sudo cp $XHTML_WORKING $XHTML_GLUU_CHMOD
			echo "Files *.xhtml updated on gluu-server chmod"
			sleep 1
		fi
	done

	
