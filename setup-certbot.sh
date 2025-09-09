#!/bin/bash

# A31 Factory Certbot Setup Script
# Author: A31 Factory Team
# Description: Setup Let's Encrypt SSL certificates with Certbot

echo "🔒 A31 Factory - Certbot SSL Setup"
echo "=================================="

DOMAIN="quanly.a31"
EMAIL="admin@a31factory.com"

echo "🌐 Domain: ${DOMAIN}"
echo "📧 Email: ${EMAIL}"
echo ""

# Create necessary directories
mkdir -p docker/certbot/conf
mkdir -p docker/certbot/www

echo "📁 Created certbot directories"

# For development/local testing, we'll create a staging certificate
echo "⚠️  This will create a STAGING certificate for testing"
echo "   For production, remove the --staging flag"
echo ""

read -p "Continue with staging certificate? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

echo "🚀 Starting Certbot setup..."

# Stop nginx temporarily
docker-compose stop nginx

# Build and run certbot
docker-compose build certbot
docker-compose run --rm certbot certonly \
    --webroot \
    --webroot-path=/var/www/certbot \
    --email ${EMAIL} \
    --agree-tos \
    --no-eff-email \
    --staging \
    -d ${DOMAIN}

if [ $? -eq 0 ]; then
    echo "✅ Certificate generated successfully!"
    
    # Update nginx to use Certbot configuration
    cp docker/nginx/nginx-certbot.conf docker/nginx/nginx.conf
    echo "🔄 Updated nginx configuration for Certbot"
    
    # Rebuild and restart nginx
    docker-compose build nginx
    docker-compose up -d nginx
    
    echo "🎉 Certbot setup completed!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Test your site: http://${DOMAIN}"
    echo "2. If working, remove --staging flag and run again for production cert"
    echo "3. Set up auto-renewal with cron:"
    echo "   0 12 * * * /path/to/docker-compose run --rm certbot renew"
    echo ""
    
else
    echo "❌ Certificate generation failed!"
    echo "   Make sure:"
    echo "   1. Domain ${DOMAIN} points to this server"
    echo "   2. Port 80 is accessible from internet"
    echo "   3. No firewall blocking access"
    
    # Restart nginx with HTTP-only config
    docker-compose up -d nginx
fi

echo "✨ Done!"
