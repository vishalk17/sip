FROM debian:buster

RUN apt-get update \
  && apt-get -y --quiet --force-yes upgrade curl iproute2 \
  && apt-get install -y --no-install-recommends ca-certificates gcc g++ make build-essential git iptables-dev libavfilter-dev \
  libevent-dev libpcap-dev libxmlrpc-core-c3-dev markdown \
  libjson-glib-dev default-libmysqlclient-dev libhiredis-dev libssl-dev \
  libcurl4-openssl-dev libavcodec-extra gperf libspandsp-dev libwebsockets-dev 

WORKDIR /usr/local/src/
#RUN git clone https://github.com/sipwise/rtpengine.git
RUN apt-get -y install git wget 
# wget https://github.com/sipwise/rtpengine/archive/mr9.0.1.1.tar.gz && tar -xzvf mr9.0.1.1.tar.gz
RUN git clone https://github.com/sagarmalam/rtpengine

#RUN git checkout mr9.0.1 && git checkout tags/9.0.0.1 && make && make install \
WORKDIR /usr/local/src/rtpengine/
RUN make && make install 
RUN cp /usr/local/src/rtpengine/daemon/rtpengine /usr/local/bin/rtpengine

VOLUME ["/tmp"]

EXPOSE 23000-32768/udp 22222/udp

#COPY docker/rtpengine/entrypoint.sh /entrypoint.sh

#COPY docker/rtpengine/rtpengine.conf /etc

ENTRYPOINT ["/entrypoint.sh"]

CMD ["rtpengine"]

