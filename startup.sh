#!/bin/bash

echo "🚀 Starting A31 Factory HRMS System..."

# Check if we're in the right directory
if [ ! -f "artisan" ]; then
    echo "❌ Error: Please run this script from the Laravel project root directory"
    exit 1
fi

# Run startup checks
echo "🔍 Running startup checks..."
php artisan app:startup-check

if [ $? -eq 0 ]; then
    echo "✅ System is ready!"
    echo "🌐 Starting Laravel server..."
    echo "📱 Access the application at: http://127.0.0.1:8000"
    echo "🔐 Login with existing accounts (e.g., pdgiang, htthuy75, cahung)"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    # Start the server
    php artisan serve --host=127.0.0.1 --port=8000
else
    echo "❌ Startup checks failed. Please fix the issues above."
    exit 1
fi
