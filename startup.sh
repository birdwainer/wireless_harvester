#! /bin/bash
. ./.env

export CANARY_IPV4=$(ip -4 a s dev $CANARY_NIC | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
export CANARY_IPV6=$(ip -6 a s dev $CANARY_NIC | grep -oP '(?<=inet6\s)[\da-f:]+')

echo $CANARY_IPV4
echo $CANARY_IPV6
echo $CAPTURE_PREFIX

# delete if not existing
if [ -d "./opencanary" ]; then
	/usr/bin/rm -rf "./opencanary"
fi

/usr/bin/git clone --depth=1 https://github.com/birdwainer/opencanary.git
/usr/bin/cp ./oc_custom/*.html ./opencanary/opencanary/modules/data/http/skin/nasLogin/

/usr/bin/docker compose -f open-canary.compose.yml up -d --build

TSHARK_FILE="$CAPTURE_PREFIX"_tshark.pcapng
echo "Starting tshark listening on $CANARY_NIC with data sent to $TSHARK_FILE"
/usr/bin/tshark -Q -b duration:600 -b filesize:10240 -f "not host bw-conference-data.s3.us-east-1.amazonaws.com" -w data/pcaps/tshark/$TSHARK_FILE -i $CANARY_NIC &
echo "$!" > tshark.pid

KISMET_FILE="$CAPTURE_PREFIX"_kismet
echo "Starting Kismet listening on $KISMET_NIC"
sudo /usr/bin/kismet -s -c $KISMET_NIC -c hci0 --override kismet.conf -t $KISMET_FILE &
echo "$!" > kismet.pid

RF_FILE="$CAPTURE_PREFIX"_sweep.tsv
echo "Starting Hackrf Sweep sending data to $RF_FILE."
/usr/bin/hackrf_sweep -f 1:6000 -w 1000000 -l 32 -g 8 -r data/hackrf/$RF_FILE &
echo "$!" > hackrf.pid
