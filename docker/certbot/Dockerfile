FROM certbot/certbot:latest

# Install additional tools
RUN apk add --no-cache \
    bash \
    curl \
    openssl

# Create directories for certificates
RUN mkdir -p /etc/letsencrypt/live/quanly.a31

# Copy renewal script
COPY renew-cert.sh /usr/local/bin/renew-cert.sh
RUN chmod +x /usr/local/bin/renew-cert.sh

# Default command
CMD ["/bin/bash"]
