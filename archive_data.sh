#! /bin/bash

CAPTURE_PREFIX=defcon
DATE_PREFIX=$(date '+%Y-%m-%d-%H-%M-%S')
DATA_DIR=data
HACKRF_FILE=$DATA_DIR/hackrf/"$CAPTURE_PREFIX"_sweep.tsv
HACKRF_STAGED=$DATA_DIR/hackrf/sweep-"$DATE_PREFIX".tsv
STAGING_DIR=to_archive
ARCHIVE_DIR=archived
ARCHIVE_FILE="$CAPTURE_PREFIX"_"$DATE_PREFIX"
EXCLUDE_FILE="dont_sync"
sudo lsof -Fn +D 'data' | grep -e "^n" | cut -c2- | sed "s/^data\//- /g" > $EXCLUDE_FILE
/usr/bin/cp $HACKRF_FILE $HACKRF_STAGED
/usr/bin/truncate -s 0 $HACKRF_FILE
/usr/bin/rsync -axuv --exclude-from $EXCLUDE_FILE --remove-source-files $DATA_DIR/ $STAGING_DIR/
cd $STAGING_DIR && /usr/bin/tar czf ../$ARCHIVE_DIR/$ARCHIVE_FILE.tar.gz . && cd -

/usr/local/bin/aws s3 sync --quiet $ARCHIVE_DIR s3://bw-conference-data

/usr/bin/rm -r $STAGING_DIR/*
/usr/bin/rm -r $ARCHIVE_DIR/*
