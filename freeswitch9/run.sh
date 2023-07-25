#!/bin/sh


set -xe

CFG_PATH="/usr/local/freeswitch/conf/vars.xml"

FS_IP="65.109.6.104"
FS_PORT="5062"
GLOBAL_CODEC_FS="OPUS,G722,PCMU,PCMA,H264,VP8"
OUTBOUND_CODEC_FS="OPUS,G722,PCMU,PCMA,H264,VP8"


sed -i "s/FS_IP/$FS_IP/g" $CFG_PATH
sed -i "s/FS_PORT/$FS_PORT/g" $CFG_PATH
sed -i "s/GLOBAL_CODEC_FS/$GLOBAL_CODEC_FS/g" $CFG_PATH
sed -i "s/OUTBOUND_CODEC_FS/$OUTBOUND_CODEC_FS/g" $CFG_PATH

/usr/local/freeswitch/bin/freeswitch
