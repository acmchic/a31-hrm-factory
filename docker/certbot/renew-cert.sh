#!/bin/bash

# Certbot certificate renewal script for A31 Factory
echo "🔄 Renewing SSL certificates..."

# Renew certificates
certbot renew --quiet

# Reload nginx if certificates were renewed
if [ $? -eq 0 ]; then
    echo "✅ Certificate renewal completed"
    # Signal nginx to reload (if running in same network)
    if docker ps | grep -q nginx; then
        docker exec $(docker ps --format "table {{.Names}}" | grep nginx | head -1) nginx -s reload
        echo "🔄 Nginx reloaded"
    fi
else
    echo "❌ Certificate renewal failed"
fi
