#!/bin/bash
inotifywait -m /code/observed_dir -e create -e moved_to |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action'"
        # do something with the file
        bash /code/action.sh '$file'
        # error handling here?
        echo "/code/action.sh completed, waiting for new files"
    done