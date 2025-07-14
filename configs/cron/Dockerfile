FROM alpine:3.18

# Install dependencies (much faster than Ubuntu)
RUN apk add --no-cache \
    curl \
    unzip \
    gzip \
    bash \
    dcron \
    && rm -rf /var/cache/apk/*

# Install AWS CLI v2
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws/

# Create directories and set environment variables
RUN mkdir -p /logs/cloudfront
ENV AWS_PAGER=""
ENV AWS_CLI_AUTO_PROMPT=off

# Copy script
COPY s3-sync-decompress.sh /usr/local/bin/s3-sync-decompress.sh
RUN chmod +x /usr/local/bin/s3-sync-decompress.sh

# Configure cron for Alpine (different from Ubuntu)
RUN echo "* * * * * /usr/local/bin/s3-sync-decompress.sh" > /etc/crontabs/root \
    && touch /var/log/cron.log /var/log/s3-sync.log

# Start cron in foreground (Alpine uses crond)
CMD ["sh", "-c", "crond -f -l 8"]