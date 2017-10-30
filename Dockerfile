FROM linuxserver/baseimage.apache
MAINTAINER smdion <me@seandion.com>

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Apache version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# copy sources.list
COPY sources.list /etc/apt/

ENV APTLIST="php7.1 libapache2-mod-php7.1 php7.1-cli php7.1-common php7.1-mbstring php7.1-gd php7.1-intl php7.1-xml php7.1-mysql php7.1-mcrypt php7.1-zip wget inotify-tools libapache2-mod-proxy-html"

# install main packages
RUN add-apt-repository -y ppa:ondrej/php && \
apt-get update -qy && \
apt-get install $APTLIST -qy && \

# cleanup
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add some files
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run /etc/service/*/finish /etc/my_init.d/*.sh

# Update apache configuration with this one
RUN a2enmod proxy proxy_http proxy_ajp rewrite deflate substitute headers proxy_balancer proxy_connect proxy_html xml2enc authnz_ldap

# ports and volumes
EXPOSE 80 443
VOLUME /config
