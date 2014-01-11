#!/bin/bash
cd $(dirname $1)
filename=$(basename $1)
tempfile=/tmp/$(echo $filename|sed 's/_flymake//')
rm -f $tempfile
cp $filename $tempfile
cd /tmp/
/usr/bin/mmc -e $(basename $tempfile)
