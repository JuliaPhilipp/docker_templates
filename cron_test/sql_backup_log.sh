#!/bin/bash

# not sure if this snippet is stricly necessary, see link below
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
# https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions

# error handler function
# https://stackoverflow.com/a/50265513

exit_if_error() {
  local exit_code=$1
  shift
  [[ $exit_code ]] &&               # do nothing if no error code passed
    ((exit_code != 0)) && {         # do nothing if error code is 0
      printf 'ERROR: %s\n' "$@" >&2 # we can use better logging here
      exit "$exit_code"             # we could also check to make sure
                                    # error code is numeric when passed
    }
}

DAYSTAMP=$(date +"%y%m%d")
TIMESTAMP=$(date +"%H%M%S")
BACKUP_CUTOFF=$(date -d "-180 days" +"%y%m%d")

BACKUP_ROOT="/home/ubuntu/backup"
BACKUP_DIR="${BACKUP_ROOT}/${DAYSTAMP}"
FILE_NAME_FMT="${DAYSTAMP}_${TIMESTAMP}"
DUMP_FILE="${BACKUP_DIR}/${FILE_NAME_FMT}.dump"
LOG_FILE="${BACKUP_DIR}/${FILE_NAME_FMT}.log.out"
ERR_FILE="${BACKUP_DIR}/${FILE_NAME_FMT}.log.err"

S3_BUCKET_NAME="DKFZ-DECODE"
S3_BACKUP_PATH="erc-project/decodedb_backup/${DAYSTAMP}"
S3_BACKUP_CUTOFF_PATH="erc-project/decodedb_backup/${BACKUP_CUTOFF}"

ENV_FILE="/home/ubuntu/decodedb-root/config/bash/decode_env.sh"
PGPASS_PATH="/home/ubuntu"
PGPASSFILE="${PGPASS_PATH}/.pgpass"
PSQL_HOST="localhost"

# exit the shell if any subcommand returns a non-zero exit status (see "help set")
set -e

# treat unset variables as an error ("unbound variable") when substituting
set -u

# import sensitive information from dedicated environment file
set -o allexport
source "$ENV_FILE"
set +o allexport

# make directory for day if it doesn't exist
mkdir -p "$BACKUP_DIR"

#exec 1>>"$LOG_FILE" 2>&1
# Everything below will go to $LOG_FILE
# alternatively keep stdout and stderr separate
exec 1>>$LOG_FILE 2>>$ERR_FILE


# make pgpassfile
echo "*:*:${DATABASE_NAME}:${DECODE_READER_NAME}:${DECODE_READER_PW}" > "$PGPASSFILE"
chmod 600 "$PGPASSFILE"
export PGPASSFILE="$PGPASSFILE"


#### removing backup from 180 days ago
# checking if backup files have to be removed from S3?
echo "checking for backup files older than 180 days"
rclone ls "${S3_BUCKET_NAME}:${S3_BACKUP_CUTOFF_PATH}"

# removing
echo "removing backup files from 180 days ago"
# rclone delete "${S3_BUCKET_NAME}:${S3_BACKUP_CUTOFF_PATH}"
# remove if exists?
# need for error handler here?
# not sure the script needs to be interrupted when deleting backup fails


#### making current days backup
# make directory for day if it doesn't exist
mkdir -p "$BACKUP_DIR"


# make pg_dump
echo "dumping sql content to .dump file"

# -Fc using custom-format archive file, compressed
# -U user to connect as
# https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html
# https://stackoverflow.com/questions/16786011/postgresql-pgpass-not-working
pg_dump -Fc "${DATABASE_NAME}" -U "${DECODE_READER_NAME}" -h "${PSQL_HOST}" > "$DUMP_FILE"

# check on pg_dump exit status
exit_if_error $? "pg_dump failed"

# upload to S3
# rclone to the right path basedb on daystamp and timestamp
echo "rcloning .dump file to S3"
rclone copy "$DUMP_FILE" "${S3_BUCKET_NAME}:${S3_BACKUP_PATH}"

# check on rclone copy exit status
exit_if_error $? "rclone copy of the dump file to the S3 storage failed"

# confirm that file is on S3?
echo 'confirming successful rcloning to S3'
rclone ls "${S3_BUCKET_NAME}:${S3_BACKUP_PATH}"
# this could be more sophisticated

# rm .dump file on VM?
echo "removing .dump file from working directory"
rm "$DUMP_FILE"

# remove .pgpass?
rm "$PGPASSFILE"

# end writing to log
exec 2>&4 1>&3

# send log via email
# this can be done via the cron job (if logs are sufficient)
#cat $LOG_FILE | mailx -v -s "backup ${DAYSTAMP} at ${TIMESTAMP}" decode@embl.de
# mailx needs to be installed and configured

# remove log and folder
#rm -r "$BACKUP_DIR"







