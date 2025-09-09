#!/bin/bash

echo "Setting up HTTPS for A31 Factory..."

# Update APP_URL to HTTPS
if [ -f .env ]; then
    sed -i 's|APP_URL=http://quanly.a31|APP_URL=https://quanly.a31|g' .env
    echo "✅ Updated .env to use HTTPS"
else
    echo "❌ .env file not found"
fi

# Build and start nginx with SSL
echo "🔧 Building nginx container with SSL..."
docker-compose build nginx

echo "🚀 Starting services..."
docker-compose up -d nginx

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Add to your hosts file (Windows: C:\\Windows\\System32\\drivers\\etc\\hosts):"
echo "   127.0.0.1 quanly.a31"
echo ""
echo "2. Access your site at: https://quanly.a31"
echo "   (You'll need to accept the self-signed certificate warning)"
echo ""
echo "3. To trust the certificate (optional):"
echo "   - Download the cert from https://quanly.a31"
echo "   - Install it in your browser's trusted certificates"
echo ""
echo "4. Test PDF download - should work without security warnings!"
