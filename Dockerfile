FROM debian:bookworm-slim

# renovate: suite=bookworm depName=wget
ARG WGET_VERSION="1.21.3-1+deb12u1"

# renovate: suite=bookworm depName=apt-transport-https
ARG APT_TRANSPORT_HTTPS_VERSION="2.6.1"

# renovate: suite=bookworm depName=software-properties-common
ARG SOFTWARE_PROPERTIES_COMMON_VERSION="0.99.30-4.1~deb12u1"

# renovate: suite=bookworm depName=python3-pip
ARG PYTHON3_PIP_VERSION="23.0.1+dfsg-1"

# renovate: suite=bookworm depName=git
ARG GIT_VERSION="1:2.39.5-0+deb12u2"

# renovate: suite=bookworm depName=ca-certificates
ARG CA_CERTIFICATES_VERSION="20230311+deb12u1"

RUN apt-get update && apt-get install -y \
    wget="${WGET_VERSION}" \
    apt-transport-https="${APT_TRANSPORT_HTTPS_VERSION}" \
    software-properties-common="${SOFTWARE_PROPERTIES_COMMON_VERSION}" \
    python3-pip="${PYTHON3_PIP_VERSION}" \
    git="${GIT_VERSION}" \
    ca-certificates="${CA_CERTIFICATES_VERSION}" \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

# NOTE: suite is not working because hardcoded into `renovate.json`.
# renovate: depName=bind9-dnsutils
ARG POWERSHELL_VERSION="7.5.4-1"

RUN <<EOF
source /etc/os-release
wget -q https://packages.microsoft.com/config/debian/$VERSION_ID/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
apt-get update && apt-get install -y powershell && apt-get clean && rm -rf /var/lib/apt/lists/*
EOF

RUN pwsh -c "Install-Module -Name Sentry -Scope CurrentUser -Repository PSGallery -Force"

COPY requirements.txt /
RUN pip install -r /requirements.txt --break-system-packages && rm /requirements.txt
