FROM php:8.2-apache

# Desactivar MPM conflictivos y dejar solo el compatible con PHP/Apache
RUN rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* /etc/apache2/mods-enabled/mpm_prefork.* \
    && a2enmod mpm_prefork rewrite

# Instalar extensiones de MySQL para PHP
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar archivos del proyecto al directorio de Apache
COPY . /var/www/html/

# Asegurar permisos correctos
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80
