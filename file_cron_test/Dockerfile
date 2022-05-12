FROM ubuntu:latest
MAINTAINER julia.philipp@embl.de

RUN apt-get update && apt-get -y install cron && apt-get install -y nano && apt-get -y install util-linux && apt-get -y install systemd             

# initscripts might be replaced by either util-linux or sysvinit-utils
# inotify-tools contains inotifywait, currently used to detect file changes
# initscript contains functions for init.d scripts, namely daemon
# nano, self-explanatory


# Copy hello-cron file to the cron.d directory
COPY hello-cron /etc/cron.d/hello-cron
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron
 
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

WORKDIR /code
COPY action.sh /code/action.sh
COPY file_monitor.sh /code/file_monitor.sh


RUN chmod +x /code/action.sh
RUN chmod +x /code/file_monitor.sh

RUN mkdir -p /code/observed_dir/

CMD cron && tail -f /var/log/cron.log