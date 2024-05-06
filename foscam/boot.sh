#!/bin/sh
tar Jxf /mnt/mtd/app/zmodules.tar.xz -C /tmp/
cd /tmp/modules
product_config_path="/mnt/mtd/app/config/ProductConfig.xml"
eval $(cat $product_config_path | grep '<model>' | awk -F ">" '{print $2}' | awk -F "<" '{printf("MODELNUM=\"%d\"",$1);}') 
eval $(cat $product_config_path | grep 'modelName' | awk -F ">" '{print $2}' | awk -F "<" '{printf("MODELNAME=\"%s\"",$1);}') 
eval $(cat $product_config_path | grep 'sensorType' | awk -F ">" '{print $2}' | awk -F "<" '{printf("SENSOR=%d",$1);}') 
eval $(cat $product_config_path | grep 'wifiType' | awk -F ">" '{print $2}' | awk -F "<" '{printf("WIFI=%d",$1);}') 
eval $(cat $product_config_path | grep 'language' | awk -F ">" '{print $2}' | awk -F "<" '{printf("LANGUAGE=%d",$1);}') 
eval $(cat $product_config_path | grep 'modelVersion' | awk -F ">" '{print $2}' | awk -F "<" '{printf("MODELVERSION=%d",$1);}') 
echo "==== Your model name is $MODELNAME SENSOR=$SENSOR WIFI=$WIFI LANGUAGE=$LANGUAGE MODELVERSION=$MODELVERSION MODELNUM=$MODELNUM ===="
./load3518 -i $SENSOR $WIFI "$MODELNAME" $MODELVERSION $MODELNUM
ptzstate_xmlcfg=1
prehorpos_xmlcfg=0
preverpos_xmlcfg=0
ptz_config_path="/mnt/mtd/app/config/PTZConfig.xml"
if [ ! -f $ptz_config_path ];then
	echo "can not find ptz config file!!!"
else
	eval $(cat $ptz_config_path | grep 'SelfTestMode' | awk -F ">" '{print $2}' | awk -F "<" '{printf("ptzstate_xmlcfg=%d",$1);}') 
	eval $(cat $ptz_config_path | grep 'PreHorPos_Appointed' | awk -F ">" '{print $2}' | awk -F "<" '{printf("prehorpos_xmlcfg=%d",$1);}') 
	eval $(cat $ptz_config_path | grep 'PreVerPos_Appointed' | awk -F ">" '{print $2}' | awk -F "<" '{printf("preverpos_xmlcfg=%d",$1);}') 
fi

case $MODELVERSION in
	11|12|13|14)
		case $MODELNUM in
			7|19|33|41|42|43|46|47) #28W\963W\28P\FC8513WZ\FC8513PZ\FC8513EZ\28WV0\963WV0
				/sbin/insmod /tmp/modules/extdrv/fos_ptz_9828.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg zoom_max_step=930 zoom_desire_pos=100
				if [ $? -ne 0 ];then
					/sbin/insmod /tmp/modules/extdrv/fos_ptz_9828.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0 zoom_max_step=930 zoom_desire_pos=100
				fi
				;;
			*)
				/sbin/insmod /tmp/modules/extdrv/fos_ptz.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg
				if [ $? -ne 0 ];then
					/sbin/insmod /tmp/modules/extdrv/fos_ptz.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0
				fi
				;;
		esac
		;;
	21|22|23|24)
		case $MODELNUM in
			1001|1002|1003|1004|1005|1006|1007|1008|1009|1010|1011|1012|1013|1014|1015|1029|1030|1031|1032|1025|1026)
				#"HD950"|"HD950W"|"HD950E"|"FI9803"|"FI9803W"|"FI9803E"|"EH9501"|"EH9502"|"EH9503"|"HD933"|"HD933E"|"FI9853"|"FI9853E"|"EH9331"|"EH9333"|"FI9851"|"HD931"|"FI9851W"|"HD931W"|"FC5412P"|"FC5413P"
				;;
			1023) #FC2403P
				/sbin/insmod /tmp/modules/extdrv/fos_ptz_fc2403p.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg
				if [ $? -ne 0 ];then
					/sbin/insmod /tmp/modules/extdrv/fos_ptz_fc2403p.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0
				fi
				;;
			1035|1036) #"FI9826P V2"|"HD818P V2"
				/sbin/insmod /tmp/modules/extdrv/fos_ptz_hi3518c_zoom.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg
				if [ $? -ne 0 ];then
					/sbin/insmod /tmp/modules/extdrv/fos_ptz_hi3518c_zoom.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0
				fi
				;;
			*)
				/sbin/insmod /tmp/modules/extdrv/fos_ptz_hi3518c.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg
				if [ $? -ne 0 ];then
					/sbin/insmod /tmp/modules/extdrv/fos_ptz_hi3518c.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0
				fi
				;;
		esac
		;;
	41|42|43|44)
		/sbin/insmod /tmp/modules/extdrv/fos_ptz.ko ptz_state=$ptzstate_xmlcfg horizen_desire_pos=$prehorpos_xmlcfg vertical_desire_pos=$preverpos_xmlcfg
		if [ $? -ne 0 ];then
			/sbin/insmod /tmp/modules/extdrv/fos_ptz.ko ptz_state=1 horizen_desire_pos=0 vertical_desire_pos=0
		fi
		;;
	*)
		;;
esac

if [ $? -ne 0 ] 
then
   echo "insmod fos_ptz.ko fail, now try default param"
   /sbin/insmod /tmp/modules/extdrv/fos_ptz.ko ptz_state=1
fi

/sbin/insmod /tmp/modules/hirtc.ko
/sbin/insmod /tmp/modules/wdt.ko default_margin=5

mkdir -p /etc/Wireless/RT2870STA
cp -f /mnt/mtd/app/etc/RT2870STA.dat /etc/Wireless/RT2870STA/

mkdir /tmp/www
mkdir /etc/ppp

mkdir /mnt/windows

#init network
#if [ -e /mnt/mtd/debug ]; then
#ifconfig eth0 down
#ifconfig eth0 hw ether 004657166815
#ifconfig eth0 up
#ifconfig eth0 192.168.1.15
#mount -t nfs -o nolock 192.168.1.18:/home/yjt/nfs /mnt/nfs
#fi
ifconfig lo up

tar -Jxf /mnt/mtd/app/www.tar.xz -C /tmp/

#0:CN 1:CNEN 2:13 FL
case $LANGUAGE in
	0)
		cp -rf /mnt/mtd/app/diff_cn/* /tmp/www
		;;
	1)
		cp -rf /mnt/mtd/app/diff_cnen/* /tmp/www
		;;
	*)
		;;
esac

ln -s /mnt/mtd/app/plugins/IPCWebComponents.exe /tmp/www/IPCWebComponents.exe
ln -s /mnt/mtd/app/plugins/plugins.pkg /tmp/www/plugins.pkg

# delete bin files
rm -rf /mnt/mtd/app/bin/*
mkdir /mnt/mtd/app/modules
mkdir /mnt/mtd/app/modules/extdrv

zlib=/mnt/mtd/app/zlib.tar.xz
tar -Jxf ${zlib} -C /usr/
tar -zxf /usr/lib/HZK24.tar.gz -C /lib

zbin=/mnt/mtd/app/zbin.tar.xz
# run bin
tar -Jxf ${zbin} -C /usr/

# 0:ar0130_720p 1:9m034 2:icx692 3:imx104 4:ov9712 5:mn34031 6:ar0130_960p 7:soih22 8:ov2710 9:imx122
case $SENSOR in
	0|6)
		ln -sf /usr/lib/libsns_ar0130_960p.so /usr/lib/libsns_mixsensor.so
		;;
	4)
	        if [ $MODELNUM == 4 ]; then  #FI9821W V2
                    cd /usr/bin
	            ./SensorReader
	            if [ $? -eq 1 ];then
                        echo "#h22 sensor"
                        ln -sf /usr/lib/libsns_soih22.so /usr/lib/libsns_mixsensor.so
                    else
                        echo "#9712 sensor"
                        ln -sf /usr/lib/libsns_ov9712.so /usr/lib/libsns_mixsensor.so
                    fi
                else
                   ln -sf /usr/lib/libsns_ov9712.so /usr/lib/libsns_mixsensor.so               
                fi

		;;
	7)
		ln -sf /usr/lib/libsns_soih22.so /usr/lib/libsns_mixsensor.so
		;;
	8)
		ln -sf /usr/lib/libsns_ov2710.so /usr/lib/libsns_mixsensor.so
		;;
	9)
		ln -sf /usr/lib/libsns_imx122.so /usr/lib/libsns_mixsensor.so
		;;
	*)
		echo "sensor $SENSOR lib is not found"
		;;
esac

# copy cgi to web dir
cp /usr/bin/cgi-bin/* /tmp/www/cgi-bin/
# copy script to pppoe dir
mkdir /bin/ppp
cp /usr/bin/ppp/pppoe-start /bin/ppp
cp /usr/bin/ppp/pppoe-stop /bin/ppp
cp /usr/bin/ppp/pppoe-status /bin/ppp
chmod 777 /bin/ppp/*
cp /usr/bin/ppp/* /usr/sbin/
chmod 777 /usr/sbin/*
#telnetd
mkdir /usr/local
cp -rf /usr/bin/lighttpd-1.4.31-hi/ /usr/local/

rm -rf /tmp/modules

cp /usr/bin/ftpd/FtpPortConfig.xml /mnt/mtd/app/config/
mkdir /usr/local/pureftpd
mkdir /usr/local/pureftpd/etc
cp /usr/bin/ftpd/pureftpd.passwd /usr/local/pureftpd/etc/
cp /usr/bin/ftpd/pureftpd.pdb /usr/local/pureftpd/etc/

export PATH=$PATH:/usr/bin
export PATH=$PATH:/mnt/mtd/app/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/mtd/app/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib

#patch
tar -Jxf /mnt/mtd/app/patch/patch.tar.xz -C /

#dhcp deconfig
if [  -f "/mnt/mtd/default.script" ];then
	rm -rf /usr/share/udhcpc/default.script
	cp /mnt/mtd/default.script  /usr/share/udhcpc/
	chmod +x /usr/share/udhcpc/default.script
fi

rtctool -rtctosys
MsgServer &
sleep 2
/usr/bin/watchdog &
