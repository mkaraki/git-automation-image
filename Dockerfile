FROM ubuntu:noble

RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    software-properties-common \
    python3-pip \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN <<EOF
source /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update && apt-get install -y powershell && apt-get clean && rm -rf /var/lib/apt/lists/*
EOF

RUN pwsh -c "Install-Module -Name Sentry -Scope CurrentUser -Repository PSGallery -Force"

COPY requirements.txt /
RUN pip install -r /requirements.txt --break-system-packages && rm /requirements.txt
