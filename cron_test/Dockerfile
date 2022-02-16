FROM ubuntu:latest
MAINTAINER julia.philipp@embl.de

RUN apt-get update && apt-get -y install cron && apt-get install -y incron && apt-get install -y rsyslog && apt-get install -y nano && apt install -y inotify-tools && apt-get -y install util-linux && apt-get -y install systemd             

# initscripts might be replaced by either util-linux or sysvinit-utils
# inotify-tools contains inotifywait, currently used to detect file changes
# initscript contains functions for init.d scripts, namely daemon
# nano, self-explanatory
# incron, incron daemon doesnt work properly and no longer supported
# cron, used for regular backups, crontab -e
# rsyslog used for starting mail



# Install mail
RUN apt-get install -y bsd-mailx
#RUN apt-get install -y s-nail
# heirloom-mailx no longer availables


# Copy hello-cron file to the cron.d directory
COPY hello-cron /etc/cron.d/hello-cron
 
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/hello-cron

# Apply cron job
RUN crontab /etc/cron.d/hello-cron
 
# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# install ssmpt / ideally this would help deliver mail to external address
#RUN apt-get install -y ssmtp
#ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
#RUN chown root.mail /etc/ssmtp/ssmtp.conf
#RUN chmod 0640 /etc/ssmtp/ssmtp.conf


WORKDIR /code
COPY dummy.sh /code/dummy.sh
COPY action.sh /code/action.sh
#COPY inot_test.sh /code/inot_test.sh
COPY inot_test.sh /usr/local/bin/inot_test.sh
COPY observed_file.txt /code/observed_file.txt
#COPY init_inot.sh /etc/init.d/init_inot
COPY init_inot.service /etc/systemd/system/init_inot.service

RUN chmod +x /code/dummy.sh
RUN chmod +x /code/action.sh
#RUN chmod +x /code/inot_test.sh
RUN chmod +x /usr/local/bin/inot_test.sh
#RUN chmod +x /etc/init.d/init_inot
RUN chmod +x /etc/systemd/system/init_inot.service

RUN systemctl enable init_inot
RUN mkdir -p /code/observed_dir/


# Run the command on container startup
CMD cron && tail -f /var/log/cron.log && postfix start-fg
# start-fg = keep running in foreground (to send and receive mail)


# https://stackoverflow.com/questions/37458287/how-to-run-a-cron-job-inside-a-docker-container