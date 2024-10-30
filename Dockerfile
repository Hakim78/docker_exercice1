# Debian Buster comme base
FROM debian:buster

# Variables d'env
ENV MYSQL_ROOT_PASSWORD=root
ENV WORDPRESS_DB_NAME=docker_db
ENV WORDPRESS_DB_USER=admin
ENV WORDPRESS_DB_PASSWORD=root

# Download des paquets
RUN apt-get update && apt-get install -y \
    apache2 \
    mariadb-server \
    php libapache2-mod-php php-mysql \
    wget unzip \
    && apt-get clean

# Démarrage du service MySQL et configuration de la base de données
RUN service mysql start && \
    mysql -e "CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB_NAME};" && \
    mysql -e "CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'localhost' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';" && \
    mysql -e "GRANT ALL PRIVILEGES ON ${WORDPRESS_DB_NAME}.* TO '${WORDPRESS_DB_USER}'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

# Téléchargement et installation de WordPress
RUN wget -q https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /var/www/html/wordpress && \
    rm latest.tar.gz

# Configuration de WordPress
RUN cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php && \
    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wordpress/wp-config.php && \
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wordpress/wp-config.php && \
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wordpress/wp-config.php

# Téléchargement et installation phpMyAdmin
RUN wget -q https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz && \
    tar -xzf phpMyAdmin-latest-all-languages.tar.gz && \
    mv phpMyAdmin-*-all-languages /var/www/html/phpmyadmin && \
    rm phpMyAdmin-latest-all-languages.tar.gz
    

COPY index.php /var/www/html/index.php

# Configuration d'Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# port HTTP
EXPOSE 80

# le script d'entrée pour démarrer MySQL et Apache
CMD bash -c 'service mysql start && apache2ctl -D FOREGROUND'
