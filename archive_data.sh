#! /bin/bash

CAPTURE_PREFIX=defcon
DATE_PREFIX=$(date '+%Y-%m-%d-%H-%M-%S')
DATA_DIR=/home/birdwainer/repos/wireless_harvester/data
STAGING_DIR=/home/birdwainer/repos/wireless_harvester/to_archive
ARCHIVE_DIR=/home/birdwainer/repos/wireless_harvester/archived
ARCHIVE_FILE="$CAPTURE_PREFIX"_"$DATE_PREFIX"
/usr/bin/rsync -axuv --exclude "$DATA_DIR/pcaps/kismet" --remove-source-files $DATA_DIR/**/* $STAGING_DIR
/usr/bin/tar czf $ARCHIVE_DIR/$ARCHIVE_FILE.tar.gz $STAGING_DIR/*a

/usr/local/bin/aws s3 sync --quiet $ARCHIVE_DIR s3://bw-conference-data

/usr/bin/rm -r $STAGING_DIR/*
/usr/bin/rm -r $ARCHIVE_DIR/*
