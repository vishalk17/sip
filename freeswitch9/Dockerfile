FROM debian:10.10-slim 


RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done \
	&& apt update && apt -y --quiet --allow-remove-essential upgrade \
	&& apt install -y --quiet --no-install-recommends vim gnupg2 apt-utils wget curl git lsb-release cmake libpcap-dev libncurses5-dev libgsl-dev automake autoconf libtool libtool-bin build-essential pkg-config ca-certificates  libswscale-dev libldns-dev libmp3lame-dev nano net-tools unixodbc unixodbc-dev tcpdump procps \ 
        && apt install -y lua5.2 lua5.2-dev libssl-dev luarocks librabbitmq-dev libtiff5-dev \
        && apt install -y build-essential libavformat-dev libpq-dev libswscale-dev python3-pip php libapache2-mod-php librabbitmq-dev pkg-config uuid-dev zlib1g-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev libpcre3-dev libspeexdsp-dev libldns-dev libedit-dev libtiff5-dev yasm libopus-dev libsndfile1-dev sngrep vim dnsutils ncat default-mysql-client curl jq sqlite3 unixodbc libfreetype6 libcurl4-openssl-dev libedit2 libsndfile1 wget iputils-ping awscli xmlstarlet --no-install-recommends  


RUN  wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz \
     && tar -xzvf autoconf-2.71.tar.gz
WORKDIR autoconf-2.71
RUN ./configure \
    && make \
    && make install

RUN apt update \
    &&  git clone https://github.com/freeswitch/spandsp.git 
WORKDIR spandsp/ 
RUN    ./bootstrap.sh \ 
        && ./configure \
        && make install  
RUN  git clone https://github.com/freeswitch/sofia-sip.git
WORKDIR sofia-sip/ 
RUN  ./bootstrap.sh \
        && ./configure \
        && make install 

WORKDIR /usr/local/src 
RUN  wget https://files.freeswitch.org/releases/freeswitch/freeswitch-1.10.9.-release.tar.gz \
     && tar -xvf freeswitch-1.10.9.-release.tar.gz
 

WORKDIR /usr/local/src/freeswitch-1.10.9.-release
COPY ./modules.conf /usr/local/src/freeswitch-1.10.9.-release/
RUN     ./rebootstrap.sh && ./configure \
	&& make && make install \
	&& make sounds-install moh-install \
	&& mkdir /usr/lib/odbc/ \
        && ln -s /usr/local/freeswitch/bin/freeswitch /usr/bin/ &&  ln -s /usr/local/freeswitch/bin/fs_cli /usr/bin/ \
	&& cd /usr/lib/odbc/ \
	&& wget https://cdn.mysql.com/archives/mysql-connector-odbc-8.0/mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit.tar.gz \
	&& tar xvf mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit.tar.gz \
	&& mv mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit/lib/* /usr/lib/odbc/ \
	&& rm -rf mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit* \
	&& apt install -y lua5.2 lua5.2-dev libssl-dev luarocks \
	&& luarocks install luasocket && luarocks install luasec && luarocks install ftcsv && luarocks install enum \
	&& apt update \
	&& cd /usr/local/src \
	&& mkdir sipp && cd sipp \
	&& wget https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz \
	&& tar -xvzf sipp-3.6.1.tar.gz && cd sipp-3.6.1 \
	&& cmake . -DUSE_PCAP=1 && make && make install \
	&& cd /usr/local/src \
	&& mkdir keepalived && cd keepalived \
	&& wget http://www.keepalived.org/software/keepalived-2.2.7.tar.gz \
	&& tar -xvzf keepalived-2.2.7.tar.gz && cd keepalived-2.2.7 \
	&& ./configure --prefix /usr && make && make install 
	

RUN 	cd /usr/local/freeswitch \
	&& rm -Rf conf/dialplan/* conf/sip_profiles/* conf/directory/* htdocs fonts images \
	&& cd /usr/local && rm -Rf src share include games etc \
	&& cd /usr && rm -Rf games include \
	&& cd /usr/share && rm -Rf freeswitch man \
	#&& rm /usr/local/freeswitch/lib/libfreeswitch.a \
	#&& rm -Rf /var/lib/{apt,dpkg,cache,log}/* \
	#&& rm -Rf /var/lib/apt/lists/* \
	#&& rm -Rf /usr/local/src/sipp \
	#&& rm -Rf /usr/local/src/keepalived \
	&& luarocks install ftcsv 1.2.0-1 \
	&& echo "alias freeswitch='/usr/local/freeswitch/bin/freeswitch'" >> ~/.bashrc \ 
	&& echo "alias fs_cli='/usr/local/freeswitch/bin/fs_cli'" >> ~/.bashrc \
	&& luarocks install enum \
        && apt update && apt-get install -y libspandsp2

#COPY docker/freeswitch/conf/lua.conf.xml /usr/local/freeswitch/conf/autoload_configs/lua.conf.xml
#COPY docker/freeswitch/conf/conference.conf.xml /usr/local/freeswitch/conf/autoload_configs/conference.conf.xml
#COPY docker/freeswitch/conf/opus.conf.xml /usr/local/freeswitch/conf/autoload_configs/opus.conf.xml
#COPY ./event_socket.conf.xml /usr/local/freeswitch/conf/autoload_configs/event_socket.conf.xml
#COPY ./internal.xml /usr/local/freeswitch/conf/sip_profiles/internal.xml 
#COPY docker/freeswitch/conf/3-way-conf.xml /usr/local/freeswitch/conf/dialplan/3-way-conf.xml
#COPY docker/freeswitch/conf/3-way-call.xml /usr/local/freeswitch/conf/dialplan/3-way-call.xml
#COPY docker/freeswitch/conf/3-way-conf-end.lua /usr/local/freeswitch/scripts/3-way-conf-end.lua
#COPY docker/freeswitch/conf/3-way-conf.lua  /usr/local/freeswitch/scripts/3-way-conf.lua   
#COPY docker/freeswitch/conf/call-hangup.lua  /usr/local/freeswitch/scripts/call-hangup.lua
#COPY docker/freeswitch/conf/handoff.lua  /usr/local/freeswitch/scripts/handoff.lua
#COPY docker/freeswitch/conf/uuid_kill.lua  /usr/local/freeswitch/scripts/uuid_kill.lua
#COPY docker/freeswitch/conf/senddtmf.lua  /usr/local/freeswitch/scripts/senddtmf.lua
#COPY docker/freeswitch/conf/on_callupdate.lua  /usr/local/freeswitch/scripts/on_callupdate.lua
COPY ./vars.xml /usr/local/freeswitch/conf/vars.xml 
COPY ./modules.conf.xml /usr/local/freeswitch/conf/autoload_configs/modules.conf.xml 
COPY ./run.sh /run.sh
RUN chmod -R 777 /run.sh
EXPOSE 5062 5062/udp 5063 5063/udp 5080 5080/udp 5081 7443 8021 8081 8082
ENTRYPOINT ["/bin/sh", "/run.sh"]
