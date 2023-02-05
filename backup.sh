#!/bin/bash

# Define database name and current date
db_name="Niko_db"
date=$(date +%Y-%m-%d_%H-%M-%S)

# Backup database
mysqldump "$db_name" > "$db_name-$date.sql"

# Compress file
tar -czvf "$db_name-$date.tar.gz" "$db_name-$date.sql"

# Upload file to S3
aws s3 cp "$db_name-$date.tar.gz" s3://<BUCKET_NAME>/

# Remove previous backup from S3
prev_backup=$(aws s3 ls s3://<BUCKET_NAME>/ | sort | awk '{ print $4 }' | head -n 1)
aws s3 rm s3://<BUCKET_NAME>/"$prev_backup"

# Log process
echo "Database backup completed successfully: $db_name-$date.tar.gz" | mail -s "Database 
Backup Log" <YOUR_EMAIL_ADDRESS>

