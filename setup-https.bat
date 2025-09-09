@echo off
echo Setting up HTTPS for A31 Factory...

REM Update APP_URL to HTTPS
if exist .env (
    powershell -Command "(gc .env) -replace 'APP_URL=http://quanly.a31', 'APP_URL=https://quanly.a31' | Out-File -encoding ASCII .env"
    echo ✅ Updated .env to use HTTPS
) else (
    echo ❌ .env file not found
)

REM Build and start nginx with SSL
echo 🔧 Building nginx container with SSL...
docker-compose build nginx

echo 🚀 Starting services...
docker-compose up -d nginx

echo.
echo 🎉 Setup complete!
echo.
echo 📋 Next steps:
echo 1. Add to your hosts file (C:\Windows\System32\drivers\etc\hosts):
echo    127.0.0.1 quanly.a31
echo.
echo 2. Access your site at: https://quanly.a31
echo    (You'll need to accept the self-signed certificate warning)
echo.
echo 3. To trust the certificate (optional):
echo    - Download the cert from https://quanly.a31
echo    - Install it in Windows Certificate Store
echo.
echo 4. Test PDF download - should work without security warnings!

pause
