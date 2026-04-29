FROM debian:bookworm-slim

# Install dependencies.
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gpg \
    gosu \
    sudo \
    fonts-liberation \
    chromium \
  ; \
  \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | tee /etc/apt/trusted.gpg.d/nodesource.asc; \
  echo 'deb [signed-by=/etc/apt/trusted.gpg.d/nodesource.asc] https://deb.nodesource.com/node_22.x nodistro main' | tee /etc/apt/sources.list.d/nodesource.list; \
  \
	apt-get update; \
	apt-get install -y --no-install-recommends \
    nodejs=22.* \
	; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# Configure sudo in a manner similar to other ddev containers.
RUN mkdir /etc/sudoers.d; echo "ALL ALL=NOPASSWD: ALL" > /etc/sudoers.d/ddev && chmod 440 /etc/sudoers.d/ddev

# Puppeteer.
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

# Add user so we don't need --no-sandbox.
RUN addgroup ddev && adduser --ingroup ddev ddev \
    && mkdir -p /home/ddev/Downloads /app \
    && chown -R ddev:ddev /home/ddev \
    && chown -R ddev:ddev /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /home/ddev
