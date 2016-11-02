./configure \
--prefix=/usr/local/apache{{ apache_version }} \
--with-included-apr \
--with-pcre \
--disable-cgi \
--disable-include \
--enable-ssl \
--enable-rewrite \
--enable-proxy \
--enable-headers \
--enable-deflate \
--enable-so \

