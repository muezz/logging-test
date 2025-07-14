#!/bin/bash

# Set AWS environment variables
export AWS_PAGER=""
export AWS_CLI_AUTO_PROMPT=off

# Log start time
echo "$(date): Starting S3 sync and decompress process" >> /var/log/s3-sync.log

# Sync files from S3
/usr/local/bin/aws s3 sync s3://logging-test-cf-logs /logs/cloudfront --exact-timestamps --size-only >> /var/log/s3-sync.log 2>&1

# Check if sync was successful
if [ $? -eq 0 ]; then
    echo "$(date): S3 sync completed successfully" >> /var/log/s3-sync.log
    
    # Find and decompress all .gz files
    find /logs/cloudfront -name "*.gz" -type f | while read -r file; do
        # Get the output filename (remove .gz extension)
        output_file="${file%.gz}"
        
        # Only decompress if the uncompressed file doesn't exist or is older than the gz file
        if [ ! -f "$output_file" ] || [ "$file" -nt "$output_file" ]; then
            echo "$(date): Decompressing $file" >> /var/log/s3-sync.log
            
            # Decompress the file
            if gzip -d -c "$file" > "$output_file"; then
                echo "$(date): Successfully decompressed $file to $output_file" >> /var/log/s3-sync.log
            else
                echo "$(date): Failed to decompress $file" >> /var/log/s3-sync.log
            fi
        else
            echo "$(date): Skipping $file (already decompressed or up to date)" >> /var/log/s3-sync.log
        fi
    done
    
    echo "$(date): Decompression process completed" >> /var/log/s3-sync.log
else
    echo "$(date): S3 sync failed" >> /var/log/s3-sync.log
fi

echo "$(date): Process finished" >> /var/log/s3-sync.log