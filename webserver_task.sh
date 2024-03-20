#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Install httpd
echo "Installing httpd..."
yum install -y httpd

# Create directory /var/www/html/sa
echo "Creating directory /var/www/html/sa..."
mkdir -p /var/www/html/sa

# Create directory directive with config files /etc/httpd/conf.d/sa.conf
echo "Creating directory directive with config files /etc/httpd/conf.d/sa.conf..."
cat << EOF > /etc/httpd/conf.d/sa.conf
<Directory "/var/www/html/sa">
    AllowOverride All
</Directory>
EOF

# Create .htaccess with authentication
echo "Creating .htaccess with authentication..."
htpasswd -bc /var/www/html/sa/.htpasswd username password
cat << EOF > /var/www/html/sa/.htaccess
AuthType Basic
AuthName "Restricted Access"
AuthUserFile /var/www/html/sa/.htpasswd
Require valid-user
EOF

# Restart httpd
echo "Restarting httpd service..."
systemctl restart httpd

echo "Setup completed successfully."
