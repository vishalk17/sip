FROM debian:buster

USER root

# Set Environment Variables
ENV DEBIAN_FRONTEND noninteractive

ARG OPENSIPS_VERSION=3.4
ARG OPENSIPS_BUILD=releases

RUN sed -i -e '$adeb http://ftp.de.debian.org/debian buster main non-free' /etc/apt/sources.list
RUN apt-get update 
RUN apt-get -y  --quiet --force-yes upgrade curl iproute2 \
  && apt-get install -y --no-install-recommends ca-certificates gcc g++ make build-essential git iptables-dev libavfilter-dev \
  libevent-dev libpcap-dev libxmlrpc-core-c3-dev markdown \
  libjson-glib-dev default-libmysqlclient-dev libhiredis-dev libssl-dev \
  libcurl4-openssl-dev libavcodec-extra gperf libspandsp-dev libwebsockets-dev flex bison bash libncurses5-dev m4 libmicrohttpd-dev locate git sed wget tar libjson-c-dev libsnmp-dev php php-curl redis-tools snmp snmp-mibs-downloader librabbitmq-dev python3 python3-pip python3-dev gcc default-libmysqlclient-dev python3-mysqldb python3-sqlalchemy python3-sqlalchemy-utils python3-openssl
RUN pip3 install mysqlclient sqlalchemy sqlalchemy-utils pyOpenSSL

RUN cd /usr/local/src && git clone https://github.com/OpenSIPS/opensips.git && cd /usr/local/src/opensips 

WORKDIR /usr/local/src/opensips
RUN make && make install

RUN make install include_modules="db_mysql" \ 
&& make install include_modules="signaling" \
&& make install include_modules="sl" \ 
&& make install include_modules="tm" \ 
&& make install include_modules="sipmsgops" \
&& make install include_modules="uac_auth" \ 
&& make install include_modules="uac_registrant" \
&& make install include_modules="permissions" \ 
&& make install include_modules="rabbitmq_consumer" \ 
&& make install include_modules="mi_fifo" \
&& make install include_modules="exec" \
&& make install include_modules="event_route" \
&& make install include_modules="clusterer" \
&& make install include_modules="proto_bin" \
&& make install include_modules="ratelimit" 

COPY ./opensips.cfg /usr/local/etc/opensips/opensips.cfg
EXPOSE 5060/udp 161/udp 5060/tcp 7443/tcp 7441/tcp 7442/tcp 43000/tcp 705/tcp 5566/tcp

RUN cp /usr/local/src/opensips/modules/snmpstats/mibs/* /usr/share/snmp/mibs/ietf/
COPY ./run.sh /run.sh
RUN chmod +x /run.sh


RUN git clone https://github.com/opensips/opensips-cli /src/opensips-cli
WORKDIR /src/opensips-cli
RUN chmod 777 setup.py
RUN python3 setup.py install --user clean
RUN python3 setup.py install clean


ENTRYPOINT ["/run.sh"]
#CMD ["tail", "-f", "/dev/null"]
