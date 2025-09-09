#!/bin/bash

# Create SSL directory
mkdir -p /etc/ssl/certs
mkdir -p /etc/ssl/private

# Generate private key
openssl genrsa -out /etc/ssl/private/quanly.a31.key 2048

# Generate certificate signing request
openssl req -new -key /etc/ssl/private/quanly.a31.key -out /etc/ssl/certs/quanly.a31.csr -subj "/C=VN/ST=HCM/L=HCM/O=A31 Factory/OU=IT/CN=quanly.a31"

# Generate self-signed certificate
openssl x509 -req -days 365 -in /etc/ssl/certs/quanly.a31.csr -signkey /etc/ssl/private/quanly.a31.key -out /etc/ssl/certs/quanly.a31.crt

# Set proper permissions
chmod 600 /etc/ssl/private/quanly.a31.key
chmod 644 /etc/ssl/certs/quanly.a31.crt

echo "SSL certificate generated successfully!"
