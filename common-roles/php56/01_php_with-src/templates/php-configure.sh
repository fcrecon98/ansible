./configure --prefix=/usr/local/php-{{ php_version }} \
--with-apxs2=/usr/local/apache2/bin/apxs \
--enable-mbstring \
--with-pdo-mysql \
--with-mysql=/usr/bin/ \
--with-libdir=lib64 \
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-curl \
--enable-sockets \
--with-openssl \
--enable-mbstring \
--enable-exif \
--with-mcrypt \

