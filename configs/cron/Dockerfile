FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws/

# Create logs directory
RUN mkdir -p /logs/cloudfront

# Create crontab file
RUN echo "* * * * * aws s3 sync s3://logging-test-cf-logs /logs/cloudfront --exact-timestamps --size-only" > /etc/cron.d/s3-sync

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/s3-sync

# Apply cron job
RUN crontab /etc/cron.d/s3-sync

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Start cron in foreground
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]