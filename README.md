# docker_templates

## cron_test
* testing cron jobs and configuration

## mail_test
* testing mail notifications in combination with cron jobs

## inot_test
* testing using inotifywait to monitor directories for file changes

```bash
docker build -t inot_test .
docker run -t -i -v /host_dir/to/be/observed/:/code/observed_dir inot_test
```