FROM debian:11
LABEL Donker <>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -qqy && \
    apt-get install -y wget git

WORKDIR /
RUN git clone https://github.com/sipwise/rtpengine.git
WORKDIR /rtpengine

RUN wget https://deb.sipwise.com/spce/mr6.2.1/pool/main/b/bcg729/libbcg729-0_1.0.4+git20180222-0.1~bpo9+1_amd64.deb
RUN dpkg -i libbcg729-0_1.0.4+git20180222-0.1~bpo9+1_amd64.deb

RUN wget https://deb.sipwise.com/spce/mr6.2.1/pool/main/b/bcg729/libbcg729-dev_1.0.4+git20180222-0.1~bpo9+1_amd64.deb
RUN dpkg -i libbcg729-dev_1.0.4+git20180222-0.1~bpo9+1_amd64.deb

WORKDIR /rtpengine
RUN apt-get install -qqy git iptables linux-headers-$(uname -r) libbcg729-0 libbcg729-dev libjson-perl libopus-dev libtest2-suite-perl libwebsockets-dev cmake debhelper default-libmysqlclient-dev gperf libxtables-dev libip6tc-dev libip4tc-dev libavcodec-dev libavfilter-dev libavformat-dev libavutil-dev libbencode-perl libcrypt-openssl-rsa-perl libcrypt-rijndael-perl libhiredis-dev libio-multiplex-perl libio-socket-inet6-perl libjson-glib-dev libdigest-crc-perl libdigest-hmac-perl libnet-interface-perl libnet-interface-perl libssl-dev libsystemd-dev libxmlrpc-core-c3-dev libcurl4-openssl-dev libevent-dev libpcap0.8-dev markdown unzip nfs-common dkms libspandsp-dev libiptc-dev libmosquitto-dev python3-websockets
RUN dpkg-buildpackage  --no-sign
RUN dpkg -i ../ngcp-rtpengine-daemon_*.deb ../ngcp-rtpengine-iptables_*.deb ../ngcp-rtpengine-kernel-dkms_*.deb && \
    ( ( apt-get install -y linux-headers-$(uname -r) linux-image-$(uname -r) && \
        module-assistant update && \
        module-assistant auto-install ngcp-rtpengine-kernel-source ) || true )

ADD run.sh /run.sh
RUN chmod 755 /run.sh

CMD /run.sh
#CMD ["rtpengine --interface 172.17.0.2\!54.194.13.129 --listen-ng 172.17.0.2:8800 --dtls-passive -f -m 10000 -M 20000  -E -L 7 --log-facility=local1"]