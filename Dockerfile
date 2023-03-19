FROM python:3.10 AS python39-jdk-11

# Installing openjdk
RUN apt-get update && apt-get install -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*

# Installing python dependencies
RUN python3 -m pip --no-cache-dir install --upgrade pip && \
    python3 --version && \
    pip3 --version

COPY . /app
WORKDIR /app

FROM python39-jdk-11 AS python39-jdk-11-dev
COPY ./Pipfile ./Pipfile.lock ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pipenv==2023.2.18 \
    && pipenv sync --dev --system \
    && rm -rf Pipfile.lock Pipfile

FROM python39-jdk-11 AS python39-jdk-11-prod
COPY ./Pipfile ./Pipfile.lock ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir pipenv==2023.2.18 \
    && pipenv sync --system \
    && rm -rf Pipfile.lock Pipfile
