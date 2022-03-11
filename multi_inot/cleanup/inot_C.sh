#!/bin/bash
inotifywait -m /code/observed_dir -e create -e moved_to |
    while read dir action file; do
        if [[ "$file" =~ .*log$ ]]; then
            echo "The file '$file' appeared in directory '$dir' via '$action' in container C"
            # do something with the file
            bash /code/action_C.sh '$file'
            # error handling here?
            echo "/code/action.sh completed, container C waiting for new files"
        fi
    done

# "include" workaround
# watch for specific file, here ".log"
#https://unix.stackexchange.com/questions/323901/how-to-use-inotifywait-to-watch-a-directory-for-creation-of-files-of-a-specific
