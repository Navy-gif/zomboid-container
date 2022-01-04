# Project Zomboid server docker image

Yes, there are a bunch of these already but I felt like making my own.

# Alternate image
I've also provided an alternate dockerfile for those who want to keep the game's files on a volume to avoid pulling a large image.  
This method assumes you have installed the game somewhere on the host machine, see the [wiki page on how to install](https://pzwiki.net/wiki/Dedicated_Server)  
```
docker run --name zomboid -d  \
-p 16261:16261/udp \
-e SERVER_NAME="servertest" \
-e ADMIN_PASS=12345 \
-v /path/to/ProjectZomboid64.json:/gameserver/PZServer/ProjectZomboid64.json \
-v /path/to/gamefiles:/gameserver/PZServer \
-v Zomboid:/gameserver/Zomboid \
navydotgif/zomboid:latest-alt
```

**Alternatively** you can build the image yourself and have the build process download the game files, but you'll have to modify the alternate dockerfile by uncommending line 12 with `RUN steamcmd ...`

**About JVM Args:**   
If you need to add more or change them, edit [ProjectZomboid64.json](./ProjectZomboid64.json) file. These are only arguments that are passed to the VM!  
If you need help with these, see the [PZ wiki page on it](https://pzwiki.net/wiki/Startup_parameters)  

# Read before starting the container  
By default the admin password is 12345 as defined in the env variables in the [Dockerfile](./Dockerfile) and the savefile is called servertest. You can change them in the Dockerfile but you'll have to rebuild the image yourself, alternatively you can pass `-e ADMIN_PASS=12345` and `-e SERVER_NAME="servertest"` arguments when starting the container, or modify them in portainer.  

To avoid rebuilding the image to change the JVM args you can bind the file with  
`-v /path/to/ProjectZomboid64.json:/gameserver/PZServer/ProjectZomboid64.json`.  

By default the container will create three persistent volumes that mount at  
`/gameserver/Zomboid/Saves`  
`/gameserver/Zomboid/Server`  
`/gameserver/Zomboid/db`  
which will house all the server saves, config and database files respectively.  
**Would highly recommend creating named volumes for these to avoid headaches when redeploying.**  

**If you would rather have all these in one volume/directory, you can do so by binding a directory or volume to `/gameserver/Zomboid` with `-v ZomboidVolume:/gameserver/Zomboid`**

Alternatively bind them to folders on your host machine with  
`-v /path/on/host:/gameserver/Zomboid/Saves`  
`-v /path/on/host:/gameserver/Zomboid/Server`  
`-v /path/on/host:/gameserver/Zomboid/db`  

For named volumes replace the `/path/on/host` part with the name of the volume name.  
Create persistent volumes with  
`docker volume create [volume name]`  

**!! IMPORTANT !!**  
Forgetting to do this will not let you connect!  
To bind the exposed ports to your host machine , pass `-p 16261:16261/udp`.

The command should look something like this now  
**With all options**
```
docker run --name zomboid -d  \
-p 16261:16261/udp \
-e SERVER_NAME="servertest" \
-e ADMIN_PASS=12345 \
-v /path/to/ProjectZomboid64.json:/gameserver/PZServer/ProjectZomboid64.json \
-v ZomboidSave:/gameserver/Zomboid/Saves \
-v ZomboidConfig:/gameserver/Zomboid/Server \
-v ZomboidDb:/gameserver/Zomboid/db \
navydotgif/zomboid:latest
```
**With 1 volume**
```
docker run --name zomboid -d  \
-p 16261:16261/udp \
-e SERVER_NAME="servertest" \
-e ADMIN_PASS=12345 \
-v /path/to/ProjectZomboid64.json:/gameserver/PZServer/ProjectZomboid64.json \
-v Zomboid:/gameserver/Zomboid \
navydotgif/zomboid:latest
```
**Least required**
```
docker run --name zomboid -d -p 16261:16261/udp navydotgif/zomboid:latest
```