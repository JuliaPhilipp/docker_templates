# dummy3.sh
set -o pipefail

PIPEFILE_OUT="pipe"
PIPEFILE_ERR="pipe_err"

LOGFILE_OUT="log.out"
LOGFILE_ERR="log.err"


mkfifo $PIPEFILE_OUT
mkfifo $PIPEFILE_ERR

# Start tee writing to a logfile, but pulling its input from our named pipe.
tee $LOGFILE_OUT < $PIPEFILE_OUT &
tee $LOGFILE_ERR < $PIPEFILE_ERR &

# capture tee's process ID for the wait command.
TEEPID=$!

# redirect the rest of the stderr and stdout to our named pipe.
exec > $PIPEFILE_OUT
exec 2> $PIPEFILE_ERR

echo "Make your commands here"
echo "All their standard out will get teed."
echo "So will their standard error" >&2

exit_if_error() {
  local exit_code=$1
  shift
  [[ $exit_code ]] &&               # do nothing if no error code passed
    ((exit_code != 0)) && {         # do nothing if error code is 0
      printf 'ERROR: %s\n' "$@" >&2 # we can use better logging here
      exit "$exit_code"             # we could also check to make sure
                                    # error code is numeric when passed
    }
}

cd /to/madeup/dir



# close the stderr and stdout file descriptors.
exec 1>&- 2>&-

# Wait for tee to finish since now that other end of the pipe has closed.
wait $TEEPID

rm $PIPEFILE_OUT
rm $PIPEFILE_ERR

exit_if_error $? "changing the directory failed"
