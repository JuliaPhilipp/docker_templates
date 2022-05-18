#!/bin/bash

# file monitoring script to be executed by cron tab

WATCH_FILE="/code/observed_dir/test_file.txt"

DESTINATION="/code/uploaded/"

TMP_FILE="/code/tmp"
LOG="/code/cron.log"

echo "checking files!"

# this checks if WATCH_FILE is newer than TMP_FILE
#if [ $WATCH_FILE -nt $TMP_FILE ]; then
if [ $WATCH_FOLDER -nt $TMP_FILE ]; then
 # update tmp file
 touch $TMP_FILE

 # do some stuff
 bash /code/action.sh $WATCH_FILE

fi

