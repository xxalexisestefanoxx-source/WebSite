FROM php:8.2-apache

# Desactivar MPM conflictivos y habilitar Apache compatible con PHP
RUN rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* /etc/apache2/mods-enabled/mpm_prefork.* \
    && a2enmod mpm_prefork rewrite

# Instalar extensiones de base de datos
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Copiar archivos del proyecto
COPY . /var/www/html/

# Ajustar permisos
RUN chown -R www-data:www-data /var/www/html

# Railway asigna PORT en tiempo de ejecución; Apache se adapta al valor recibido
CMD ["sh", "-c", "PORT=${PORT:-80}; sed -ri 's/Listen [0-9]+/Listen ${PORT}/' /etc/apache2/ports.conf; sed -ri 's/<VirtualHost \\*:[0-9]+>/<VirtualHost *:${PORT}>/' /etc/apache2/sites-available/000-default.conf; exec apache2-foreground"]

EXPOSE 80
