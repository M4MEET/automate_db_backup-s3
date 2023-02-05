#!/bin/bash

# Define variables
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/path/to/backup/directory"
BACKUP_FILE="database_backup_$DATE.sql"
COMPRESSED_FILE="database_backup_$DATE.tar.gz"
DB_NAME="Niko_db"
DB_USER="database_user"
DB_PASSWORD="database_password"
EMAIL_ADDRESS="email@example.com"
S3_BUCKET="s3://your-bucket-name"

# Create backup of database
mysqldump -u $DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_DIR/$BACKUP_FILE

# Compress the backup file
tar -czvf $BACKUP_DIR/$COMPRESSED_FILE $BACKUP_DIR/$BACKUP_FILE

# Remove the uncompressed backup file
rm $BACKUP_DIR/$BACKUP_FILE

# Upload the backup file to Amazon S3
aws s3 cp $BACKUP_DIR/$COMPRESSED_FILE $S3_BUCKET/$COMPRESSED_FILE

# Remove the previous compressed backup file from Amazon S3
PREVIOUS_BACKUP_FILE=$(aws s3 ls $S3_BUCKET | awk '{if($4 ~ /database_backup_.*.tar.gz/) print 
$4}' | sort | head -n -1)
for file in $PREVIOUS_BACKUP_FILE; do
  aws s3 rm $S3_BUCKET/$file
done

# Schedule daily cron job at midnight
CRON_JOB="0 0 * * * $BACKUP_DIR/backup_script.sh"
(crontab -l; echo "$CRON_JOB") | crontab -

# Log the backup process and send information to email
LOG_FILE="backup.log"
echo "Backup process completed at $(date +%Y-%m-%d_%H-%M-%S). Backup file: $COMPRESSED_FILE" 
>> $BACKUP_DIR/$LOG_FILE
echo "Backup process completed at $(date +%Y-%m-%d_%H-%M-%S). Backup file uploaded to Amazon 
S3: $S3_BUCKET/$COMPRESSED_FILE" | mail -s "Database Backup Completed" $EMAIL_ADDRESS

