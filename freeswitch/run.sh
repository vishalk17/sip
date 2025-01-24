#!/bin/sh
set -e

# Configure FreeSWITCH
CFG_PATH="/usr/local/freeswitch/conf/vars.xml"

# Default values
: ${FS_IP:="localhost"}
: ${FS_PORT:="5060"}
: ${GLOBAL_CODEC_FS:="OPUS,G722,PCMU,PCMA,H264,VP8"}
: ${OUTBOUND_CODEC_FS:="OPUS,G722,PCMU,PCMA,H264,VP8"}

# Update configuration
sed -i "s/FS_IP/$FS_IP/g" $CFG_PATH
sed -i "s/FS_PORT/$FS_PORT/g" $CFG_PATH
sed -i "s/GLOBAL_CODEC_FS/$GLOBAL_CODEC_FS/g" $CFG_PATH
sed -i "s/OUTBOUND_CODEC_FS/$OUTBOUND_CODEC_FS/g" $CFG_PATH

# Start FreeSWITCH
/usr/local/freeswitch/bin/freeswitch
