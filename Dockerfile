FROM ubuntu:noble

RUN apt-get update && apt-get install -y python3-pip git && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install sentry-cli==2.57.0
