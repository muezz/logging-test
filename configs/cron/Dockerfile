FROM amazonlinux:2

# Install cron and AWS CLI
RUN yum update -y && \
    yum install -y awscli cronie && \
    yum clean all

# Create a default log file and cloudfront directory
RUN mkdir -p /var/log && mkdir -p /logs/cloudfront

# Copy crontab into cron.d
COPY crontab /etc/cron.d/cloudfront-sync

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/cloudfront-sync && \
    crontab /etc/cron.d/cloudfront-sync

CMD ["crond", "-n", "-l", "2"]