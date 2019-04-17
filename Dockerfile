FROM nginx

ENV HOST example.com
ENV PROXY_HOST www.google.com
ENV PROXY_FILTER_HOST google.com
ENV PROXY_URL https://www.google.com

# Copy nginx template
COPY nginx.template /etc/nginx/conf.d/default.template

# Use envsubst to generate nginx configuration from template
CMD envsubst '\$HOST \$PROXY_HOST \$PROXY_FILTER_HOST \$PROXY_URL' < /etc/nginx/conf.d/default.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'
