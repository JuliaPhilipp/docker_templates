#!/bin/bash
inotifywait -m /code/observed_dir -e create -e moved_to |
    while read dir action file; do
        # this will be displayed in the command line where docker container was started
        # more sophisticated logging possible
        #echo -e "The file '$file' appeared in directory '$dir' via '$action'" 
        echo "Little test"
        # do something with the file
        #/code/action.sh '$file' >> /code/file_log.txt
        # error handling? did action run successfully?
        echo "/code/action.sh was performed on '$file'"
    done
