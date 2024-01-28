# 
# Downloading Stage
# 
FROM cm2network/steamcmd as steam

# Prepare folders
USER root
RUN mkdir -p /srv/palworld
RUN chown steam /srv/palworld

# Download game
USER steam
RUN ./steamcmd.sh +force_install_dir /srv/palworld +login anonymous +app_update 2394010 validate +quit


# 
# Simplified Stage
# 
# FROM node:lts-alpine3.18
FROM node:latest

# RUN adduser -D pal
RUN useradd pal

COPY --from=steam /srv/palworld /srv/palworld
COPY --from=steam /home/steam/steamcmd/linux64 /home/pal/.steam/sdk64

RUN chown -R pal /home/pal/.steam
RUN chown -R pal /srv/palworld

USER pal

WORKDIR /srv/palworld
RUN timeout 5 ./PalServer.sh || echo "Setup done";

# COPY settings/PalWorldSettings.ini /srv/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

# expose server and rcon
EXPOSE 8211/udp
EXPOSE 25575/tcp 

CMD ./PalServer.sh