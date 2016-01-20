FROM camptocamp/haproxy-luasec
MAINTAINER bringnow team <wecare@bringnow.com>

ENV ACME_PLUGIN_VERSION 0.1.1

RUN buildDeps='curl ca-certificates' runtimeDeps='inotify-tools' \
	&& apt-get update && apt-get install -y $buildDeps $runtimeDeps --no-install-recommends \
	&& curl -SL https://github.com/janeczku/haproxy-acme-validation-plugin/archive/${ACME_PLUGIN_VERSION}.tar.gz -o acme-plugin.tar.gz \
	&& tar xzf acme-plugin.tar.gz --strip-components=1 --no-anchored acme-http01-webroot.lua -C /etc/haproxy/ \
	&& rm *.tar.gz \
	&& apt-get purge -y --auto-remove $buildDeps

EXPOSE 80 443

COPY entrypoint.sh /

VOLUME /etc/letsencrypt
VOLUME /var/acme-webroot

ENTRYPOINT ["/entrypoint.sh"]
