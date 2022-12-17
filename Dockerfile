FROM python:3.10

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

COPY . /app
WORKDIR /app

RUN apt-get update \
 # dependencies for building Python packages
 && apt-get install -y build-essential \
 # psycopg2 dependencies
 && apt-get install -y libpq-dev \
 # psql client
 && apt-get install -y postgresql-client  \
 # Translations dependencies
 && apt-get install -y gettext \
 # For sudo command available
 && apt-get install -y sudo \
 # Pipenv
 && pip install --upgrade pip \
 && pip install pipenv==2022.1.8 \
 && pipenv sync --system \
 && rm -rf Pipfile.lock Pipfile
