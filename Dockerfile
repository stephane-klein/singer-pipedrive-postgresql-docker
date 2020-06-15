FROM python:3.8-slim

ENV PYTHONUNBUFFERED=true
RUN apt-get -y update
RUN apt-get install -y \
    build-essential \
    libpq-dev \
    curl \
    cron

RUN curl -o /usr/local/bin/gomplate -sSL https://github.com/hairyhenderson/gomplate/releases/download/v3.7.0/gomplate_linux-amd64-slim
RUN chmod 755 /usr/local/bin/gomplate

WORKDIR /src/

RUN python3 -m venv /src/.venv/tap-pipedrive/
RUN /src/.venv/tap-pipedrive/bin/pip install https://github.com/stephane-klein/tap-pipedrive/archive/master.tar.gz

RUN python3 -m venv /src/.venv/target-postgres/
RUN /src/.venv/target-postgres/bin/pip install singer-target-postgres==0.2.4

ADD ./tap-pipedrive-config.json.tmpl /tap-pipedrive-config.json.tmpl
ADD ./target_postgres_config.json.tmpl /target_postgres_config.json.tmpl
ADD ./entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ADD ./pipedrive-catalog.json /pipedrive-catalog.json

ADD crontab.tmpl /crontab.tmpl
RUN chmod 0644 /etc/crontab
RUN touch /var/log/cron.log

ADD ./execute-singer.sh /execute-singer.sh
RUN chmod u+x /execute-singer.sh

ENV PIPEDRIVE_START_DATE="2020-01-01T00:00:00Z"
ENV PIPEDRIVE_API_TOKEN=secret
ENV POSTGRES_HOSTNAME=postgres
ENV POSTGRES_PORT=5432
ENV POSTGRES_DBNAME=postgres
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=password
ENV POSTGRES_SCHEMA=pipedrive
ENV CRON_STRINGS="0 * * * *"

ENTRYPOINT ["/entrypoint.sh"]