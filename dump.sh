#!/bin/bash
fl='/opt/kdesni/sni.log'
echo "" >> $fl
echo "" >> $fl
echo "-------------------------------------------------------------------" >> $fl
dt=`date`
echo $dt >> $fl
cat /sys/kernel/debug/kisni/keys >> $fl
echo "-------------------------------------------------------------------" >> $fl

