# scrap for rclone stuff
rclone ls DKFZ-DECODE:erc-project/decodedb_backup/211001

rclone ls DKFZ-DECODE:erc-project/raw_data
rclone delete DKFZ-DECODE:erc-project/raw_data

rclone purge DKFZ-DECODE:erc-project/s3test/

pg_restore -c -d testdb 211001_040001.dump --if-exists


pg_dump -Fc "${DATABASE_NAME}" -U "${DECODE_READER_NAME}" -h "${PSQL_HOST}" > "$DUMP_FILE"

pg_dump -Fc "$PSQL_DECODE_DB_NAME" -U "$POSTGRES_USER" -h "$PSQL_HOST" > "test.dmp"

PSQL_HOST="metadb-docker_db_1"
PSQL_HOST="db"

# copy/ move files




rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00011/211119_NB552290_0153_AHL5MLBGXK/211119_NB552290_0153_AHL5MLBGXK/Alignment_1/20211120_120450/Fastq/
rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DS-00151

rclone copy DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00011/211119_NB552290_0153_AHL5MLBGXK/211119_NB552290_0153_AHL5MLBGXK/Alignment_1/20211120_120450/Fastq/SEQ366TX271ctrl_S1_L001_R2_001.fastq.gz DKFZ-DECODE:erc-project/raw_data/DM/DS-00151
