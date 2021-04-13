#!/bin/bash

FILE=shp.txt

while IFS= read -r cmd; do
    v1=`echo "${cmd}" | cut -f 1 -d ";"`
    v2=`echo "${cmd}" | cut -f 2 -d ";"`

    if [ "a$v1" == "a" ]
    then
        continue
    fi
    if [ -f ${v1}.zip ]
    then
        echo "$v1 already exists"
        continue
    fi
    echo $v1
    echo "$v2"

    pgsql2shp -f ${v1} -h localhost -u postgres -P jr gis "${v2}"
    zip -m ${v1}.zip ${v1}.*
done < "$FILE"
