FROM debian:trixie-slim

# renovate: suite=trixie depName=wget
ARG WGET_VERSION="1.25.0-2"

# renovate: suite=trixie depName=python3-pip
ARG PYTHON3_PIP_VERSION="25.1.1+dfsg-1"

# renovate: suite=trixie depName=git
ARG GIT_VERSION="1:2.47.3-0+deb13u1"

# renovate: suite=trixie depName=ca-certificates
ARG CA_CERTIFICATES_VERSION="20250419"

RUN apt-get update && apt-get install -y \
    wget="${WGET_VERSION}" \
    python3-pip="${PYTHON3_PIP_VERSION}" \
    git="${GIT_VERSION}" \
    ca-certificates="${CA_CERTIFICATES_VERSION}" \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

ARG POWERSHELL_VERSION="v7.5.4"

RUN <<EOF
wget -q https://github.com/PowerShell/PowerShell/releases/download/${POWERSHELL_VERSION}/powershell_${POWERSHELL_VERSION:1}-1.deb_amd64.deb -O powershell.deb
apt-get update && apt-get install -y ./powershell.deb && apt-get clean && rm -rf /var/lib/apt/lists/*
rm powershell.deb
EOF

RUN pwsh -c "Install-Module -Name Sentry -Scope CurrentUser -Repository PSGallery -Force"

COPY requirements.txt /
RUN pip install -r /requirements.txt --break-system-packages && rm /requirements.txt
