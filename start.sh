#!/bin/sh

set -e
usermod --uid $UID minecraft
groupmod --gid $GID minecraft

chown -R minecraft:minecraft /home/minecraft /usr/bin/start-minecraft
chmod -R g+wX /home/minecraft /usr/bin/start-minecraft

while lsof -- /usr/bin/start-minecraft; do
  echo -n "."
  sleep 1
done

mkdir -p /home/minecraft
chown minecraft: /home/minecraft

echo "Switching to user 'minecraft'"
exec sudo -E -u minecraft /usr/bin/start-minecraft
