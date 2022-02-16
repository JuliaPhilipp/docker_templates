# dummy stdout/stderr script

#!/bin/sh
#cd /Users/jphilipp/Documents/cron_test/

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3

#exec 1>> /Users/jphilipp/Documents/cron_test/log.out 2>>/Users/jphilipp/Documents/cron_test/log.err


#mkdir -p /code/cron_test/
#exec 1>>/code/cron_test/log.out 2>>/code/cron_test/log.err

#exec 3>&2 2> /dev/stdout

echo "test - this should go into file"

echo "Error" >&2

exec 2>&4 1>&3

echo "test2 - this should go in console"

echo "test error in console" >&2


