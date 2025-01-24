FROM debian:10.10-slim

# Prepare man directories and update system
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done \
    && apt update && apt -y --quiet --allow-remove-essential upgrade

# Install dependencies
RUN apt install -y --quiet --no-install-recommends \
    vim gnupg2 apt-utils wget curl git lsb-release cmake libpcap-dev libncurses5-dev libgsl-dev \
    automake autoconf libtool libtool-bin build-essential pkg-config ca-certificates \
    libswscale-dev libldns-dev libmp3lame-dev nano net-tools unixodbc unixodbc-dev tcpdump procps \
    lua5.2 lua5.2-dev libssl-dev luarocks librabbitmq-dev libtiff5-dev \
    build-essential libavformat-dev libpq-dev python3-pip php libapache2-mod-php \
    uuid-dev zlib1g-dev libjpeg-dev libsqlite3-dev libcurl4-openssl-dev libpcre3-dev \
    libspeexdsp-dev libedit-dev yasm libopus-dev libsndfile1-dev sngrep dnsutils \
    ncat default-mysql-client jq sqlite3 libfreetype6 awscli xmlstarlet --no-install-recommends

# Install GNU autoconf
RUN wget https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz \
    && tar -xzvf autoconf-2.71.tar.gz \
    && cd autoconf-2.71 \
    && ./configure \
    && make \
    && make install \
    && cd .. && rm -rf autoconf-2.71*

# Install spandsp library
RUN git clone https://github.com/freeswitch/spandsp.git \
    && cd spandsp \
    && ./bootstrap.sh \
    && ./configure \
    && make install \
    && cd .. && rm -rf spandsp

# Install sofia-sip library
RUN git clone https://github.com/freeswitch/sofia-sip.git \
    && cd sofia-sip \
    && ./bootstrap.sh \
    && ./configure \
    && make install \
    && cd .. && rm -rf sofia-sip

# Download and extract FreeSWITCH
WORKDIR /usr/local/src
RUN wget https://files.freeswitch.org/releases/freeswitch/freeswitch-1.10.9.-release.tar.gz \
    && tar -xvf freeswitch-1.10.9.-release.tar.gz \
    && rm freeswitch-1.10.9.-release.tar.gz

# Build and install FreeSWITCH
WORKDIR /usr/local/src/freeswitch-1.10.9.-release
COPY ./files/modules.conf .
RUN ./rebootstrap.sh \
    && ./configure \
    && make && make install \
    && make sounds-install moh-install

# Install MySQL ODBC driver
RUN mkdir -p /usr/lib/odbc \
    && wget https://cdn.mysql.com/archives/mysql-connector-odbc-8.0/mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit.tar.gz \
    && tar xvf mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit.tar.gz \
    && mv mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit/lib/* /usr/lib/odbc/ \
    && rm -rf mysql-connector-odbc-8.0.23-linux-glibc2.12-x86-64bit*

# Install Lua rocks
RUN luarocks install luasocket \
    && luarocks install luasec \
    && luarocks install ftcsv \
    && luarocks install enum

# Install SIPp
WORKDIR /usr/local/src
RUN mkdir -p sipp && cd sipp \
    && wget https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz \
    && tar -xvzf sipp-3.6.1.tar.gz \
    && cd sipp-3.6.1 \
    && cmake . -DUSE_PCAP=1 \
    && make && make install \
    && cd ../.. && rm -rf sipp

# Install Keepalived
RUN mkdir -p keepalived && cd keepalived \
    && wget http://www.keepalived.org/software/keepalived-2.2.7.tar.gz \
    && tar -xvzf keepalived-2.2.7.tar.gz \
    && cd keepalived-2.2.7 \
    && ./configure --prefix=/usr \
    && make && make install \
    && cd ../.. && rm -rf keepalived

# Clean up unnecessary files and set up aliases
RUN cd /usr/local/freeswitch \
    && ln -s /usr/local/freeswitch/bin/freeswitch /usr/bin/freeswitch \
    && ln -s /usr/local/freeswitch/bin/fs_cli /usr/bin/fs_cli \
    && luarocks install ftcsv 1.2.0-1 \
    && echo "alias freeswitch='/usr/local/freeswitch/bin/freeswitch'" >> ~/.bashrc \
    && echo "alias fs_cli='/usr/local/freeswitch/bin/fs_cli'" >> ~/.bashrc

# Copy run script and set permissions
COPY ./run.sh /run.sh
RUN chmod 777 /run.sh

# Expose ports
EXPOSE 5060 5060/udp 5061 5061/udp 5080 5080/udp 5081 7443 8021 8081 8082

RUN apt-get update && apt-get install libspandsp2 -y

# Entrypoint
CMD ["/bin/sh", "/run.sh"]

