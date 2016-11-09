#!/bin/bash

PGSHELL_CONFDIR="$1"

# Load the psql connection option parameters.
source $PGSHELL_CONFDIR/pgsql_funcs.conf

result=$(/usr/local/postgres/bin/psql -A -t -h $PGHOST -p $PGPORT -U $PGROLE $DBNAME -c "select (NOT(pg_is_in_recovery()))::int" 2>&1)
echo "$result"