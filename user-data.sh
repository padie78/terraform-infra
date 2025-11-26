#!/bin/bash
# Actualiza paquetes e instala Apache + PHP + herramientas
apt-get update -y
apt-get install -y apache2 php php-curl libapache2-mod-php php-mysql jq

# Abre el puerto HTTP en el firewall (si UFW está habilitado)
ufw allow 'Apache Full' || true

# Usuario de AWS (Ubuntu)
usermod -a -G ubuntu ubuntu

# Crear directorio web y asignar permisos
mkdir -p /var/www/html
chown -R ubuntu:ubuntu /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

cd /var/www/html

# Obtener metadata de la instancia AWS y guardarla en index.html
curl -s http://169.254.169.254/latest/meta-data/ | jq > index.html
sed -i '1i<pre>' index.html
sed -i '$a</pre>' index.html

# Descargar ejemplo de aplicación PHP
sudo curl -O https://raw.githubusercontent.com/padie78/terraform-infra/main/app/index.php


# Configurar Apache para priorizar index.php
echo "DirectoryIndex index.php index.html" > /etc/apache2/mods-enabled/dir.conf

# Reiniciar Apache
systemctl restart apache2


