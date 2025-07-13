FROM amazon/aws-cli:latest

RUN echo '* * * * * aws s3 sync s3://logging-test-cf-logs /logs/cloudfront --exact-timestamps --size-only' >> /etc/crontabs/root

# Create a default log file and cloudfront directory
RUN mkdir -p /var/log && mkdir -p /logs/cloudfront

CMD ["crond", "-f", "-l", "2"]