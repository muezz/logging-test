FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    cron \
    gzip \
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

# Copy the sync and decompress script
COPY s3-sync-decompress.sh /usr/local/bin/s3-sync-decompress.sh

# Make the script executable
RUN chmod +x /usr/local/bin/s3-sync-decompress.sh

# Create crontab file with the new script
RUN echo "* * * * * root /usr/local/bin/s3-sync-decompress.sh" > /etc/cron.d/s3-sync

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/s3-sync

# Create the log file
RUN touch /var/log/s3-sync.log

# Create the log files to be able to run tail
RUN touch /var/log/cron.log /var/log/s3-sync.log

# Start cron in foreground
CMD ["sh", "-c", "cron && tail -f /var/log/cron.log"]