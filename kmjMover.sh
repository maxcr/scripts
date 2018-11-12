#!/bin/sh

fileName=""
currPath=""

fluffy | \
while read events path; do \
    if echo $events | grep -qie "CLOSE_WRITE"; then \
      currPath="`echo ${path} | sed s:/[^/]*$:: | cat`"; \
      fileName="`echo ${path} | sed s:.*/:: | cat`"; \
      if echo $fileName | grep -qE "\w*.min.\w+"; then \
        unMinName="`echo ${fileName} | sed s:.min::`"
        echo "Copying ${fileName} as ${unMinName}"
        cp ${currPath}/${fileName} /var/www/staticFiles/${unMinName}; \
      fi
    fi \
done