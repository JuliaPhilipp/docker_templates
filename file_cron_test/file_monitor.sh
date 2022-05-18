#!/bin/bash

# file monitoring script to be executed by cron tab

WATCH_FILE="/code/observed_dir/test_file.txt"
WATCH_FOLDER="/code/observed_dir/"

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


 ## check if files have not been modified for 3 mins
 
 # definitely specify the files in observed_dir more
 # the problem of combining this with the -nt test is that files that are not done 3 mins before cron job,
 # won't kick off the script again and will only process when a NEW file is added
 # potential to only use this time filter?
 for f in $(find /code/observed_dir/*.* -type f -mmin +3)
  do
   mv $f to $DESTINATION
   echo $f >> /code/upload_log.txt
  done

 #test the use of md5sums

fi

