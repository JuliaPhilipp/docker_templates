#!/bin/bash
inotifywait -m /code/observed_dir -e create -e moved_to |
    while read dir action file; do
        echo "The file '$file' appeared in directory '$dir' via '$action' in container B"
        # do something with the file
        bash /code/action_B.sh '$file'
        # error handling here?
        echo "/code/action.sh completed, container B waiting for new files"
    done