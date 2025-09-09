FROM nginx:alpine

# Install OpenSSL for certificate generation
RUN apk add --no-cache openssl

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create SSL directories
RUN mkdir -p /etc/ssl/certs /etc/ssl/private

# Generate SSL certificate directly in Dockerfile
RUN openssl genrsa -out /etc/ssl/private/quanly.a31.key 2048 && \
    openssl req -new -key /etc/ssl/private/quanly.a31.key -out /etc/ssl/certs/quanly.a31.csr \
    -subj "/C=VN/ST=HCM/L=HCM/O=A31 Factory/OU=IT/CN=quanly.a31" && \
    openssl x509 -req -days 365 -in /etc/ssl/certs/quanly.a31.csr \
    -signkey /etc/ssl/private/quanly.a31.key -out /etc/ssl/certs/quanly.a31.crt && \
    chmod 600 /etc/ssl/private/quanly.a31.key && \
    chmod 644 /etc/ssl/certs/quanly.a31.crt && \
    rm /etc/ssl/certs/quanly.a31.csr

# Expose ports
EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
