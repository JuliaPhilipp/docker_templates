FROM ubuntu:latest
MAINTAINER julia.philipp@embl.de

RUN apt-get update && apt-get install -y nano && apt install -y inotify-tools && apt-get -y install util-linux              

# initscripts might be replaced by either util-linux or sysvinit-utils
# inotify-tools contains inotifywait, currently used to detect file changes
# initscript contains functions for init.d scripts, namely daemon
# nano, self-explanatory


WORKDIR /code
COPY action_A.sh /code/action_A.sh
COPY inot_A.sh /code/inot_A.sh

RUN chmod +x /code/action_A.sh
RUN chmod +x /code/inot_A.sh

RUN mkdir -p /code/observed_dir/


# Run the inotifywait script on container startup
# forever the question: cmd or entrypoint?
CMD bash /code/inot_A.sh 
