#! /bin/bash

if [ -f "tshark.pid" ]; then
	TSHARK_PID=$(/usr/bin/cat tshark.pid);
	kill $TSHARK_PID;
	rm tshark.pid;
fi

if [ -f "kismet.pid" ]; then
	KISMET_PID=$(/usr/bin/cat kismet.pid);
	sudo kill $KISMET_PID;
	rm kismet.pid;
fi

/usr/bin/docker compose -f open-canary.compose.yml down
