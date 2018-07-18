FROM httpd:2.4

ARG WEB_USER
ARG WEB_GROUP
ARG APACHE_ROOT_DIR
 


# START modsecurity v3 install -- Remove this part if you don't want modsecurity installed
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends git \
    libtool \
    dh-autoreconf \
    pkgconf \
    libcurl4-gnutls-dev \
    libxml2 \
    libpcre++-dev \
    libxml2-dev \
    libgeoip-dev \
    libyajl-dev \
    liblmdb-dev \
    ssdeep \ 
    ca-certificates \
    build-essential

RUN cd /opt && \
    git clone -b v3/master https://github.com/SpiderLabs/ModSecurity.git ModSecurity && \
    cd /opt/ModSecurity && \
	./build.sh && \
	git submodule init && \
	git submodule update && \
	./configure && \
	make && \
	make install

RUN cd /opt && \
    git clone https://github.com/SpiderLabs/ModSecurity-apache ModSecurity-apache && \
    cd /opt/ModSecurity-apache && \
	./autogen.sh && \
	./configure && \
	make && \
	make install

RUN mkdir -p ${APACHE_ROOT_DIR}/modsecurity.d/ && \
    echo "LoadModule security3_module \"$(find /opt/ModSecurity-apache/ -name mod_security3.so)\"" > ${APACHE_ROOT_DIR}/conf/extra/security.conf && \
    echo "modsecurity_rules 'SecRuleEngine On'" >> ${APACHE_ROOT_DIR}/conf/extra/security.conf && \
	echo "modsecurity_rules_file '${APACHE_ROOT_DIR}/modsecurity.d/include.conf'" >> ${APACHE_ROOT_DIR}/conf/extra/security.conf


RUN cd ${APACHE_ROOT_DIR}/modsecurity.d && \
    git clone https://github.com/SpiderLabs/owasp-modsecurity-crs owasp-crs && \
    cd ${APACHE_ROOT_DIR}/modsecurity.d/ && \
	mv /opt/ModSecurity/modsecurity.conf-recommended ${APACHE_ROOT_DIR}/modsecurity.d/modsecurity.conf && \
    echo "include modsecurity.conf" >> ${APACHE_ROOT_DIR}/modsecurity.d/include.conf && \
    mv ${APACHE_ROOT_DIR}/modsecurity.d/owasp-crs/crs-setup.conf.example ${APACHE_ROOT_DIR}/modsecurity.d/owasp-crs/crs-setup.conf && \
    echo "include owasp-crs/crs-setup.conf" >> ${APACHE_ROOT_DIR}/modsecurity.d/include.conf && \
	echo "include owasp-crs/rules/*.conf" >> ${APACHE_ROOT_DIR}/modsecurity.d/include.conf && \
    sed -i "s/DetectionOnly/On/" ${APACHE_ROOT_DIR}/modsecurity.d/modsecurity.conf && \
    sed -i "s@/var/log/modsec_audit.log@${APACHE_ROOT_DIR}/logs/modsec_audit.log@" ${APACHE_ROOT_DIR}/modsecurity.d/modsecurity.conf && \
    ln -s ${APACHE_ROOT_DIR}/bin/httpd /usr/sbin/httpd

# END modsecurity

# Copy configuration files into apache dir
COPY config/000-default.conf ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf
COPY config/httpd.conf ${APACHE_ROOT_DIR}/conf/httpd.conf

RUN chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/httpd.conf && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}/conf/extra/httpd-vhosts.conf && \
    usermod -u 1000 ${WEB_USER} && \
    groupmod -g 1000 ${WEB_GROUP} && \
    chgrp -R ${WEB_GROUP} ${APACHE_ROOT_DIR}