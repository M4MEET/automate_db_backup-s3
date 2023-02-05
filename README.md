# automate_db_backup-s3
automatic database backup script to s3 bucket

To run this program, follow these steps:

Copy the script to a file with the extension .sh. For example, backup_script.sh.

Open a terminal and navigate to the directory where the script is saved.

Make the script executable with the following command: chmod +x backup_script.sh.

Run the script with the following command: ./backup_script.sh.

If everything is set up correctly, the script will create a backup of the Niko_db database, 
compress it, upload it to Amazon S3, and remove the previous compressed backup file from the 
S3 bucket. It will also schedule a daily cron job that runs the script at midnight and log the 
backup process.

Note: Before running the script, make sure that you have installed the required dependencies, 
such as mysqldump, tar, awscli, and mail. Also, replace the placeholder values in the script 
with the actual values for your setup, such as the backup directory, database credentials, 
email address, and S3 bucket name.
