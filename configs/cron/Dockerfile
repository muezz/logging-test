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

# Set environment variables for AWS CLI
ENV AWS_PAGER=""
ENV AWS_CLI_AUTO_PROMPT=off

# Create crontab file with proper logging and environment
RUN echo "* * * * * root /usr/bin/env AWS_PAGER= AWS_CLI_AUTO_PROMPT=off /usr/local/bin/aws s3 sync s3://logging-test-cf-logs /logs/cloudfront --exact-timestamps --size-only >> /var/log/s3-sync.log 2>&1" > /etc/cron.d/s3-sync

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/s3-sync

# Create the log file
RUN touch /var/log/s3-sync.log

# Create the log files to be able to run tail
RUN touch /var/log/cron.log /var/log/s3-sync.log

# Start cron in foreground
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]