FROM steamcmd/steamcmd:latest
WORKDIR /gameserver

# Volume for the saves, config and database files
VOLUME ["/gameserver/Zomboid"]

# Install steam dependency
RUN apt-get update && apt-get -y install libsdl2-2.0
# Install game server from steam
RUN steamcmd +force_install_dir /gameserver/PZServer +login anonymous +app_update 380870 validate +quit

# Has the JVM start args for easier customisation -- Only thing I've modified is the Duser.home argument to house it in the /gameserver directory
# Could also bind this with -v /path/to/ProjectZomboid64.json:/gameserver/PZServer/ProjectZomboid64.json instead of copying
COPY ProjectZomboid64.json /gameserver/
# A slightly modified starter script to enabled passing password and server name via env variables
COPY start-server.sh /gameserver/

# The wiki tells us that 8766/udp is needed, but I've managed to run the server without it, potentially has to do with steam stuff, expose if you need it
# EXPOSE 8766/udp
EXPOSE 16261/udp

# Change these by passing environment variables with -e ADMIN_PASS=12345 -e SERVERNAME="servertest", or set them in portainer if you use that
ENV ADMIN_PASS=12345
ENV SERVER_NAME="servertest"
ENV IMAGE="latest"

# Need to overwrite this from the steamcmd base image
ENTRYPOINT ["/bin/bash"]
CMD ["/gameserver/start-server.sh"]