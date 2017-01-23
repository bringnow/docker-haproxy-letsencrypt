FROM debian:stretch
MAINTAINER bringnow team <wecare@bringnow.com>

ARG DEBIAN_FRONTEND=noninteractive
ARG ACME_PLUGIN_VERSION=0.1.1

RUN buildDeps='curl ca-certificates' runtimeDeps='haproxy inotify-tools lua-sec rsyslog' \
	&& apt-get update && apt-get upgrade -y && apt-get install -y $buildDeps $runtimeDeps --no-install-recommends \
	&& curl -sSL https://github.com/janeczku/haproxy-acme-validation-plugin/archive/${ACME_PLUGIN_VERSION}.tar.gz -o acme-plugin.tar.gz \
	&& tar -C /etc/haproxy/ -xf acme-plugin.tar.gz --strip-components=1 --no-anchored acme-http01-webroot.lua \
	&& rm *.tar.gz \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf /var/lib/apt/lists/*

EXPOSE 80 443

COPY entrypoint.sh /

VOLUME /etc/letsencrypt
VOLUME /var/acme-webroot

ENTRYPOINT ["/entrypoint.sh"]
