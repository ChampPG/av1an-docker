## Usage
[Docker Hub](https://hub.docker.com/r/champpg/av1an-docker)

Credit: [46620](https://github.com/46620/Scripts/tree/master/encoding) - Thank you for the permission to modify and use your av1an encoder scripts and use them for this container!

### Cron settings
If you would like to run once set CRON in the media.env file to "false"
```
CRON="false"
```

If you would like to run the av1an encoder on a schedule (Following runs at 01:00 AM, on day 1 of the month, only in January, May, and September)
```
CRON='0 0 1 1 JAN,MAY,SEP * *' 
```

### Docker
```
docker run champpg/av1an-docker:latest -v /external/path/media:/media -v /external/path/db:/db -v /external/path/tmp:/temp -v /external/path/env:/app/media.env -e PUID=1000 -e PGID=1000
```

### Docker Compose
```
services:
  autoremove:
    image: champpg/av1an-docker:latest
    container_name: av1an-docker
    restart: unless-stopped
    volumes:
      - /path/to/media:/media 
      - /path/to/db:/db
      - /path/to/temp:/temp
      - /path/to/media.env:/app/media.env
    environment:
      - PUID=1000
      - PGID=1000
```

### media.env
```
# Modify for cron value (Modify this value to set cron time)
CRON="*/50 * * * *"

# Vars for every script (DON'T CHANGE THE FOLLOWING UNLESS YOU KNOW WHAT YOU'RE DOING)
ulimit -n 20000
MEDIA_ROOT=/media # Parent folder
DB_PATH=/db # Where DATABASE_NAME.db is storoed
DATABASE_NAME=media # Name of the database.db file
TMP_DIR=/temp # Temp directory location

# DB creation script (DON'T CHANGE THE FOLLOWING UNLESS YOU KNOW WHAT YOU'RE DOING)
ENCTABLE_NAME=encode

# Encoder Script
AV1AN_SPLIT_METHOD=av-scenechange # Valid options: av-scenechange (recommended), none
AV1AN_CHUNK_METHOD=lsmash # Valid options: segment, select, ffms2, lsmash (recommended), dgdecnv, bestsource, hybrid
AV1AN_CONCAT=mkvmerge # Valid options: ffmpeg, mkvmerge (recommended), ivf
AV1AN_ENC=svt-av1 # Valid options: svt-av1, rav1e, aomec
AV1AN_VENC_OPTS="" # Video encoding options
AV1AN_ENC_PIX=yuv420p # This is marked apparently as the most sane default so leave as is I guess??
AV1AN_AENC_OPTS="-c:a libopus -af aformat=channel_layouts=7.1|5.1|stereo -mapping_family 1 -b:a 64k -sn" # Audio encoding options
AV1AN_FFMPEG_OPTS="-map 0 -map -v -map V -c:s copy -strict -2" # I have no clue what I have done here

# Lockfiles (DON'T CHANGE THE FOLLOWING UNLESS YOU KNOW WHAT YOU'RE DOING)
readonly LOCKDIR=/tmp/locks
readonly DB_LOCKFILE=media_db
readonly ENCODER_LOCKFILE=encoder

```