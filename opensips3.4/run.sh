#!/bin/bash
##############ATTENTION ATTENTION#####################################################################################################
## If you are putting / in any of the value below then then put \ as escape character for. For example DB URL VAL is actually 
## mysql://root:ec0sm0bt@127.0.0.1/ecodialer  but you need to it like this mysql:\/\/root:ec0sm0bt@127.0.0.1\/ecodialer
##############ATTENTION ATTENTION###########################################################################################

# skip syslog and run opensips at stderr
/usr/local/sbin/opensips -FD
