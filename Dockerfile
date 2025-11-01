FROM ubuntu:noble

RUN apt-get update && apt-get install -y python3-pip git && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /
RUN pip install -r /requirements.txt --break-system-packages && rm /requirements.txt
