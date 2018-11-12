#!/bin/sh

fluffy | \
while read events path; do \
    if echo $events | grep -qie "CLOSE_WRITE"; then \
      rsync -avz --info=progress2 ./ root@192.168.1.126:/var/www/; \
    fi \
done
