FROM debian:8-slim

COPY ./updated.ngx_pagespeed.cc /tmp/

RUN \
    apt-get update && \
    apt-get install -y \
        dh-make quilt \
        lsb-release \
        debhelper \
        dpkg-dev \
        dh-systemd \
        build-essential \
        autoconf \
        automake \
        pkg-config \
        libtool \
        libpcre++-dev \
        git \
        unzip \
        wget \
        libssl-dev && \
    mkdir -p /tmp/nginx && cd /tmp/nginx && \
    wget https://nginx.org/download/nginx-1.18.0.tar.gz && \
    tar -xf nginx-1.18.0.tar.gz && \
    wget https://www.openssl.org/source/latest.tar.gz -O openssl-1.1.0.tar.gz && \
    tar -xf openssl-1.1.0.tar.gz && \
    wget https://github.com/pagespeed/ngx_pagespeed/archive/v1.12.34.3-stable.zip && \
    unzip v1.12.34.3-stable.zip && \
    cd incubator-pagespeed-ngx-1.12.34.3-stable && \
    wget https://dl.google.com/dl/page-speed/psol/1.12.34.2-x64.tar.gz && \
    tar -xf 1.12.34.2-x64.tar.gz && rm 1.12.34.2-x64.tar.gz && \
    cp /tmp/updated.ngx_pagespeed.cc src/ngx_pagespeed.cc && \
    cd .. && \
    git clone https://github.com/google/ngx_brotli.git br && cd br && \
    git submodule update --init && \
    cd .. && \
    cd nginx-1.18.0 && \
    ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-threads \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
        --with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-stream \
        --with-stream_realip_module \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        #--with-cc-opt='-g -O2 -fdebug-prefix-map=/data/builder/debuild/nginx-1.17.9/debian/debuild-base/nginx-1.17.9=. -fstack-protector-strong -Wformat -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -fPIC' \
        #--with-ld-opt='-Wl,-z,relro -Wl,-z,now -Wl,--as-needed -pie' \
        --add-module='../br' \
        --add-module='../openssl-1.1.1j' \
        --add-module='../incubator-pagespeed-ngx-1.12.34.3-stable' && \
    make && \
    make install && \
    rm -rf /tmp/nginx && \
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/nginx/*.default && \
    rm -rf /etc/nginx/html && \
    apt-get remove --purge -y \
        dh-make \
        quilt \
        lsb-release \
        debhelper \
        dpkg-dev \
        dh-systemd \
        build-essential \
        autoconf \
        automake \
        pkg-config \
        libtool \
        libpcre++-dev \
        git \
        unzip \
        wget \
        libssl-dev && \
    apt-get autoremove -y && \
    mkdir -p /var/cache/nginx/client_temp

COPY etc /etc
