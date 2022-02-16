FROM ubuntu:latest
MAINTAINER julia.philipp@embl.de

RUN apt-get update && apt-get -y install cron && apt-get install -y nano && apt-get install -y postgresql-client                      

# Install mail
#RUN apt-get install -y bsd-mailx
#RUN apt-get install -y s-nail

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
RUN chmod +x /code/dummy.sh

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log


# https://stackoverflow.com/questions/37458287/how-to-run-a-cron-job-inside-a-docker-container