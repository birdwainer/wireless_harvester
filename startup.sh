. ./.env

export CANARY_IPV4=$(ip -4 a s dev $CANARY_NIC | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
export CANARY_IPV6=$(ip -6 a s dev $CANARY_NIC | grep -oP '(?<=inet6\s)[\da-f:]+')

echo $CANARY_IPV4
echo $CANARY_IPV6

/usr/bin/docker compose -f open-canary.compose.yml up -d

# echo "Starting Kismet listenin on $KISMET_NIC"
# /usr/bin/kismet -c $KISMET_NIC
