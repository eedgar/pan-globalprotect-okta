FROM	alpine:3.15

WORKDIR	/

RUN	apk update && apk add --no-cache \
	curl git \
	automake autoconf libtool gcc musl-dev make linux-headers \
	gettext openssl-dev libxml2-dev lz4-dev libproxy-dev python3-dev \
        libffi-dev cargo\
	py3-lxml py3-requests py3-pip \
	&& rm -rf /var/cache/apk/*
RUN  pip3 install pyotp fido2


RUN	mkdir -p /usr/local/sbin
RUN	curl -o /usr/local/sbin/vpnc-script http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script
RUN	chmod +x /usr/local/sbin/vpnc-script

RUN	git clone -b "v8.10" --single-branch --depth=1 https://gitlab.com/openconnect/openconnect.git
WORKDIR	/openconnect
RUN	./autogen.sh
RUN	./configure --without-gnutls --with-vpnc-script=/usr/local/sbin/vpnc-script
RUN	make check
RUN	make

CMD	["/openconnect/gp-okta/gp-okta.py","/openconnect/gp-okta/gp-okta.conf"]
