./configure \
--prefix=/usr/local/apache-{{ apache_version }} \
--with-mpm=worker \
--enable-rewrite \
--enable-proxy \
--enable-proxy-ajp \
--enable-so \
--enable-ssl \
--enable-headers
