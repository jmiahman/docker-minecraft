FROM fedora
MAINTAINER http://fedoraproject.org/wiki/Cloud

RUN dnf -y update && dnf clean all
RUN dnf -y install tar wget lsof jq sudo java java-devel && dnf clean all

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-openjdk

# Define default command.
RUN useradd -M -s /bin/false --uid 1002 minecraft \
  && mkdir /home/minecraft \
  && mkdir /home/minecraft/mods \
  && mkdir /home/minecraft/plugins \
  && mkdir /home/minecraft/config \
  && touch /home/minecraft/config/banned-ips.json \
  && touch /home/minecraft/config/banned-players.json \
  && touch /home/minecraft/config/ops.json \
  && touch /home/minecraft/config/server.properties \
  && touch /home/minecraft/config/eula.txt \
  && ln -sf /home/minecraft/config/* /home/minecraft/ \
  && chown -R minecraft:minecraft /home/minecraft

EXPOSE 25565-25575
EXPOSE 2230-2250

COPY start.sh /usr/bin/start-server
COPY start-minecraft.sh /usr/bin/start-minecraft

RUN chmod +x /usr/bin/start-server
RUN chmod +x /usr/bin/start-minecraft

VOLUME ["/home/minecraft"]
VOLUME ["/home/minecraft/mods"]
VOLUME ["/home/minecraft/config"]
VOLUME ["/home/minecraft/plugins"]
COPY server.properties /tmp/server.properties
WORKDIR /home/minecraft

CMD [ "/usr/bin/start-server" ]

# Special marker ENV used by MCCY management tool
ENV MC_IMAGE=YES

ENV UID=1000 GID=1000
ENV MOTD A Sponge Minecraft Server Powered by Docker
ENV JVM_OPTS -Xmx1024M -Xms1024M
ENV TYPE=SPONGE VERSION=LATEST FORGEVERSION=RECOMMENDED LEVEL=world PVP=true DIFFICULTY=easy \
  LEVEL_TYPE=DEFAULT GENERATOR_SETTINGS= WORLD= MODPACK= EULA=TRUE

