#!/bin/bash

wget \
     --recursive \
     --no-clobber \
     --page-requisites \
     --html-extension \
     --adjust-extension \
     --convert-links \
     --restrict-file-names=windows \
     --span-hosts \
     --domains=db.everkinetic.com,img.everkinetic.com \
     --user-agent="Mozilla" \
     --no-parent \
         http://db.everkinetic.com/