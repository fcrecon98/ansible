./configure \
--prefix=/usr/local/nginx-{{ nginx_version }} \
--user=nginx \
--group=nginx \
--http-client-body-temp-path=/var/nginx/client/ \
--http-proxy-temp-path=/var/nginx/proxy/ \
--http-fastcgi-temp-path=/var/nginx/fastcgi/ \
--with-pcre \
--with-zlib=/usr/local/src/zlib-1.2.8 \
--with-http_realip_module \
--with-http_addition_module \
--with-http_sub_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--without-http_ssi_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
{{ nginx_configure_option }}
