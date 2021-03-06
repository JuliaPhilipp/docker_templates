#!/bin/bash
# chkconfig: 2345 20 80
# description: Description comes here....

# Source function library.
. /lib/lsb/init-functions

start() {
    # code to start app comes here 
    # example: daemon program_name &
    start_daemon /code/inot_test.sh &
}

stop() {
    # code to stop app comes here 
    # example: killproc program_name
    killproc /code/inot_test.sh
}

case "$1" in 
    start)
       start
       ;;
    stop)
       stop
       ;;
    restart)
       stop
       start
       ;;
    status)
       # code to check status of app comes here 
       # example: status program_name
       status /code/inot_test.sh
       ;;
    *)
       echo "Usage: $0 {start|stop|status|restart}"
esac

exit 0 