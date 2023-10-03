# Use an Nginx image as the base
FROM nginx

# Copy Nginx configuration files
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificate and key from Terraform output
COPY nginx/ssl/nginx.pem /etc/nginx/ssl/
COPY nginx/ssl/nginx.key /etc/nginx/ssl/

# Copy static web assets
COPY app /usr/share/nginx/html

# Expose HTTP and HTTPS ports
EXPOSE 80
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
