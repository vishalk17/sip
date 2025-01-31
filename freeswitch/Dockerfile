# Stage 1: Builder image
FROM debian:12.9-slim AS builder

# Install build dependencies
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done \
    && apt update && apt -y --quiet --allow-remove-essential upgrade \
    && apt install -y --quiet --no-install-recommends \
        apt-utils automake autoconf awscli build-essential ca-certificates cmake cron curl dnsutils git gnupg2 \
        iputils-ping jq libapache2-mod-php libavformat-dev libcurl4-openssl-dev libedit-dev libfreetype6 libgsl-dev \
        libjpeg-dev libldns-dev liblua5.2-dev libmongoc-dev libmp3lame-dev libncurses5-dev libogg-dev libopus-dev \
        libpcap-dev libpcre3-dev libpq-dev librabbitmq-dev libshout3-dev libsndfile1-dev libspeexdsp-dev libsqlite3-dev \
        libssl-dev libswscale-dev libtiff5-dev libtool libtool-bin libvorbis-dev libvorbis0a lsb-release lua5.2 nano \
        ncat net-tools ngrep odbc-postgresql php pkg-config procps psmisc python3-pip sngrep sqlite3 systemctl tcpdump \
        unixodbc unixodbc-dev wget xmlstarlet yasm zlib1g-dev uuid-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/build

# Build dependencies
RUN git clone https://github.com/freeswitch/sofia-sip.git && \
    cd sofia-sip && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install && \
    cd ..

RUN git clone https://github.com/freeswitch/spandsp.git && \
    cd spandsp && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install && \
    cd ..

RUN git clone https://github.com/signalwire/libks.git && \
    cd libks && \
    cmake . && make && make install && \
    cd ..

RUN wget https://github.com/SIPp/sipp/releases/download/v3.6.1/sipp-3.6.1.tar.gz && \
    tar -xvzf sipp-3.6.1.tar.gz && \
    cd sipp-3.6.1 && \
    cmake . -DUSE_PCAP=1 && \
    make && make install && \
    cd ..

RUN git clone https://github.com/signalwire/signalwire-c.git && \
    cd signalwire-c && \
    cmake . && make && make install && \
    cd ..

# Build FreeSWITCH
RUN wget https://files.freeswitch.org/freeswitch-releases/freeswitch-1.10.12.-release.tar.gz && \
    tar -xzvf freeswitch-1.10.12.-release.tar.gz && \
    mv freeswitch-1.10.12.-release freeswitch

WORKDIR /home/build/freeswitch

COPY modules.conf .
COPY patches/0001-mod_spandsp_dsp.c-resolve-V.18-mode-and-v18_init-com.patch .

RUN patch -p1 < 0001-mod_spandsp_dsp.c-resolve-V.18-mode-and-v18_init-com.patch && \
    ./rebootstrap.sh -j$(nproc) && \
    ./configure --enable-core-pgsql-support && \
    make -j$(nproc) && \
    make install && \
    make sounds-install moh-install

# Stage 2: Final image
FROM debian:12.9-slim AS final

# Install only runtime dependencies
RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates libavformat59 libcurl4 libedit2 libldns3 liblua5.2-0 libmp3lame0 libmpg123-0 libncurses6 \
        libogg0 libopus0 libpcre3 libpq5 librabbitmq4 libshout3 libsndfile1 libspeexdsp1 libsqlite3-0 libssl3 \
        libswscale6 libtiff6 libvorbis0a odbc-postgresql unixodbc wget \
    && rm -rf /var/lib/apt/lists/*

# Copy built artifacts from builder
COPY --from=builder /usr/local /usr/local

# Copy configuration files
COPY etc/odbc.ini /etc/
COPY etc/switch.conf.xml /usr/local/freeswitch/conf/autoload_configs/

# Configure dynamic linker
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf && \
    ldconfig && \
    ln -s /usr/local/freeswitch/bin/freeswitch /usr/bin/freeswitch && \
    ln -s /usr/local/freeswitch/bin/fs_cli /usr/bin/fs_cli

EXPOSE 5060/tcp 5060/udp 5061/tcp 5061/udp 5066/tcp 5080/tcp 5080/udp 5081/tcp 7443/tcp 8021/tcp

CMD ["/usr/local/freeswitch/bin/freeswitch"]