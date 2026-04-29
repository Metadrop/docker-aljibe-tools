#!/bin/bash
set -e

if [ -n "$DDEV_UID" ] && [ -n "$DDEV_GID" ]; then
  CURRENT_UID=$(id -u ddev)
  CURRENT_GID=$(id -g ddev)
  if [ "$CURRENT_GID" != "$DDEV_GID" ]; then
    groupmod -g "$DDEV_GID" ddev
    find /home/ddev -group "$CURRENT_GID" -exec chgrp -h "$DDEV_GID" {} \; 2>/dev/null || true
  fi
  if [ "$CURRENT_UID" != "$DDEV_UID" ]; then
    usermod -u "$DDEV_UID" ddev
    find /home/ddev -user "$CURRENT_UID" -exec chown -h "$DDEV_UID" {} \; 2>/dev/null || true
  fi
fi

exec gosu ddev "$@"
