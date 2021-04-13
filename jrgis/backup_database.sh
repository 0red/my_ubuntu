#!/bin/bash
echo -n 1
# go to the directory You want to store the local backup 
cd /tmp/


function do_backup {
    echo -n $1 1
    echo -n 2
    ip='192.168.2.235'   # backup postgres server ip
    pg_dump -C -s -h 127.0.0.1 -U postgres $1 >db.$1.sql
    pg_dump -C -h 127.0.0.1 -U postgres $1 | bzip2 -c >$1.bz2
    echo -n 3
    export PGPASSWORD='<your password>'
    echo -n 4
    dropdb -h $ip -U postgres $1
    echo -n 5
    createdb -h $ip -U postgres $1
    echo -n 6
    bzcat $1.bz2 | psql -h $ip -U postgres $1
    echo " done"
}

#do_backup "database1"
do_backup "database2" #database to backup
