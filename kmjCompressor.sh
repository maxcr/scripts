#!/bin/sh

fileName=""
currPath=""

fluffy | \
while read events path; do \
    if echo $events | grep -qie "CLOSE_WRITE"; then \
      currPath="`echo ${path} | sed s:/[^/]*$:: | cat`"; \
      fileName="`echo ${path} | sed s:.*/:: | cat`"; \
      if [ -f "${currPath}/${fileName}.gz" ]; then \
        if [ `find "${currPath}" -iname "${fileName}.gz" -mmin +1` ]; then \
          echo "${fileName}.gz found! Creating new optimized version.";\
          rm "${currPath}/${fileName}.gz" ;\
          zopfli "${currPath}/${fileName}" ;\
        fi
      else
        if [ ! -f "${currPath}/${fileName}.gz" ] && [ `find "${fileName}" -maxdepth 1 ! -iname "*.gz"` ]; then \
          echo "${fileName}.gz not found! Creating optimized version." ;\
          zopfli "${currPath}/${fileName}" ;\
          # chmod -R html:html $currPath
        fi
      fi
      # echo "${currPath}/${fileName}.gz";\
    fi \
done
