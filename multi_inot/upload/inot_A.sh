#!/bin/bash
inotifywait -m /code/observed_dir -e create -e moved_to --exclude "\.log" |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action' in container A"
        # do something with the file
        bash /code/action_A.sh $file
        # error handling here?
        echo "/code/action.sh completed, container A waiting for new files"
    done

# inotifywait exclude regex
#https://stackoverflow.com/questions/7943528/inotifywait-exclude-regex-pattern-formatting