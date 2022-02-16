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
      printf 'ERROR: %s\n' "$@" 'failed' >&2 # we can use better logging here
      exit "$exit_code"             # we could also check to make sure
                                    # error code is numeric when passed
    }
  printf 'no error with %s\n' "$@"
}

ENV_FILE="/code/metadb_env.sh"

# exit the shell if any subcommand returns a non-zero exit status (see "help set")
set -e

# treat unset variables as an error ("unbound variable") when substituting
set -u

# import sensitive information from dedicated environment file
set -o allexport
source "$ENV_FILE"
set +o allexport

# set the rest of the variables
# some of which depend on vars from env file
DAYSTAMP=$(date +"%y%m%d")
TIMESTAMP=$(date +"%H%M%S")
BACKUP_CUTOFF=$(date -d "-180 days" +"%y%m%d")

BACKUP_ROOT="/sql_backup"
BACKUP_DIR="${BACKUP_ROOT}/${DAYSTAMP}"
FILE_NAME_FMT="${DAYSTAMP}_${TIMESTAMP}"
DUMP_FILE="${BACKUP_DIR}/${FILE_NAME_FMT}.dump"

LOG_DIR="${BACKUP_ROOT}/log_out"
ERR_DIR="${BACKUP_ROOT}/log_err"
LOG_FILE="${LOG_DIR}/${FILE_NAME_FMT}.log.out"
ERR_FILE="${ERR_DIR}/${FILE_NAME_FMT}.log.err"

PIPEFILE_OUT="${BACKUP_DIR}/${FILE_NAME_FMT}.pipe_out"
PIPEFILE_ERR="${BACKUP_DIR}/${FILE_NAME_FMT}.pipe_err"

S3_BACKUP_PATH="${AWS_S3_BACKUP_ROOT}/${DAYSTAMP}"
S3_BACKUP_CUTOFF_PATH="${AWS_S3_BACKUP_ROOT}/${BACKUP_CUTOFF}"

PGPASS_PATH="/var/lib/postgresql"
PGPASSFILE="${PGPASS_PATH}/.pgpass"
PSQL_HOST="db"



# make directory for day if it doesn't exist

mkdir -p "$BACKUP_DIR"
mkdir -p "$LOG_DIR"
mkdir -p "$ERR_DIR"

#exec 1>>"$LOG_FILE" 2>&1
# Everything below will go to $LOG_FILE
# alternatively keep stdout and stderr separate

exec 1>>"$LOG_FILE" 2>>"$ERR_FILE"



# make pgpassfile for pg_dump
echo "*:*:${PSQL_DECODE_DB_NAME}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > "$PGPASSFILE"
chmod 600 "$PGPASSFILE"
export PGPASSFILE="$PGPASSFILE"


## removing backup from 180 days ago
# checking if backup files have to be removed from S3?
echo "checking for backup files older than 180 days"
#rclone ls "${S3_BUCKET_NAME}:${S3_BACKUP_CUTOFF_PATH}"

# removing
echo "removing backup files from 180 days ago"
# rclone delete "${S3_BUCKET_NAME}:${S3_BACKUP_CUTOFF_PATH}"
# remove if exists?
# need for error handler here?
# not sure the script needs to be interrupted when deleting backup fails


#### making current days backup



# make pg_dump
echo "dumping sql content to .dump file"

# -Fc using custom-format archive file, compressed
# -U user to connect as
# passwords saved in ~/.pgpass
# sudo chmod 600 ~/.pgpass
# https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html
# https://stackoverflow.com/questions/16786011/postgresql-pgpass-not-working
pg_dump -Fc "$PSQL_DECODE_DB_NAME" -U "$POSTGRES_USER" -h "$PSQL_HOST" > "$DUMP_FILE"

# check on pg_dump exit status
exit_if_error $? "pg_dump"

# upload to S3
# rclone to the right path basedb on daystamp and timestamp
echo "rcloning .dump file to S3"
#rclone copy "$DUMP_FILE" "${S3_BUCKET_NAME}:${S3_BACKUP_PATH}"

# check on rclone copy exit status
exit_if_error $? "rclone copy of the dump file to the S3 storage"

# confirm that file is on S3
echo 'confirming successful rcloning to S3'
#rclone ls "${S3_BUCKET_NAME}:${S3_BACKUP_PATH}"
# this could be more sophisticated

# rm local .dump file
echo "removing .dump file from working directory"
#rm "$DUMP_FILE"

# remove .pgpass for security
echo "removing pgpassfile"
rm "$PGPASSFILE"

# end writing to log
exec 2>&4 1>&3

# check file size of log.err and delete if empty
if [ -f $ERR_FILE ]
then
  if ! [ -s $ERR_FILE ]
  then
    rm -f $ERR_FILE
  fi
fi
