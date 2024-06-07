
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



rclone copy DKFZ-DECODE:erc-project/raw_data/DM/DS-00131/drosophila_gut/017098_all_cellranger_output/matrix.mtx ~/Downloads/ --dry-run
rclone copy DKFZ-DECODE:erc-project/raw_data/DM/DS-00131/drosophila_gut/017098_all_cellranger_output/matrix.mtx Downloads

rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DS-00131/drosophila_gut/017098_all_cellranger_output/matrix.mtx 

## clean up TX22 and TX23 sequencing run data (there are additional copies of the fastqs saved there)
rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00009 --include '1LongGEXd*'
rclone delete DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00009 --include '1LongGEXd*'

rclone copy DKFZ-DECODE:erc-project/raw_data/DM/DS-000C5/objects/DS-000C5.rds ~/Downloads/

rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DS-00001

rclone copy DKFZ-DECODE:erc-project/raw_data/DM/DS-0017E/analysis/DS-0017E_filtered_srt_log_cluster.rds DKFZ-DECODE:erc-project/raw_data/DM/DS-00001/analysis/DS-0017E_filtered_srt_log_cluster.rds

rclone ls DKFZ-DECODE:erc-project/decodedb_backup/ --include '2112*'

rclone copy DKFZ-DECODE:erc-project/raw_data/DM/DS-00188/counts/outs --include 

rclone copy 230324_NB552290_0227_AH5WFVBGXT DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00022/230324_NB552290_0227_AH5WFVBGXT/ --dry-run 
rclone copy 230324_NB552290_0227_AH5WFVBGXT DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00022/230324_NB552290_0227_AH5WFVBGXT/ --progress 



 rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00030 --include 'SampleSheet*'

rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DSR-00022/


## clean up organoid data
rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DS-00221 
rclone purge DKFZ-DECODE:erc-project/raw_data/DM/DS-00221 --dry-run

rclone ls DKFZ-DECODE:erc-project/raw_data/DM/DS-00220
rclone delete DKFZ-DECODE:erc-project/raw_data/DM/DS-00220 

rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00027/

rclone delete DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00027/ --dry-run
rclone rmdir DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00027/ --dry-run

rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00028
rclone purge  DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-00028 --dry-run

rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002C
rclone purge  DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002C --dry-run

rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002A
rclone purge  DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002A --dry-run	

# clean lohmanlab data
rclone ls DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002B
rclone delete DKFZ-DECODE:erc-project/raw_data/seq_runs/DSR-0002B --dry-run


## find decode data

s3://erc-project/data_share/20240115_pb/

rclone ls DKFZ-DECODE:erc-project/data_share/20240115_pb/

rclone copy DKFZ-DECODE:erc-project/data_share/20240115_pb/ ~/Downloads/


