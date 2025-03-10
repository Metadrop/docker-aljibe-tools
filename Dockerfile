FROM debian:bookworm-slim

# Install dependencies.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    ca-certificates=20230311 \
    curl=7.88.* \
    gpg=2.2.* \
  ; \
  \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | tee /etc/apt/trusted.gpg.d/nodesource.asc; \
  echo 'deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.asc] https://deb.nodesource.com/node_22.x nodistro main' | tee /etc/apt/sources.list.d/nodesource.list; \
  \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    nodejs=22.* \
    chromium \
	; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# Puppeteer.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Add user so we don't need --no-sandbox.
RUN addgroup aljibe && adduser --ingroup aljibe aljibe \
    && mkdir -p /home/aljibe/Downloads /app \
    && chown -R aljibe:aljibe /home/aljibe \
    && chown -R aljibe:aljibe /app

USER aljibe
WORKDIR /home/aljibe
