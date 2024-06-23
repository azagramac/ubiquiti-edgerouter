#!/bin/bash

# Script written by Juan, https://github.com/juanico10

NETGROUP="SPAMHAUS_DROP"
TMPFILE=/tmp/spamhaus-block-$$.tmp
TMPFILE2=/tmp/temp-spamhaus-block-$$.tmp

clean_up ()
{
     /sbin/ipset --destroy $NEWGROUP
     /bin/rm $TMPFILE $TMPFILE2
}

>$TMPFILE>$TMPFILE2
/usr/bin/curl -s http://www.spamhaus.org/drop/drop.txt >> $TMPFILE2
/usr/bin/curl -s http://www.spamhaus.org/drop/edrop.txt >> $TMPFILE2

# Filter out comments and remove empty lines and duplicates
/bin/grep '^[0-9]' $TMPFILE2 | /bin/sed -e 's/;.*//' -e 's/#.*//' -e 's/[ \t]*$//' | /usr/bin/sort -u > $TMPFILE


/sbin/ipset -L $NETGROUP > /dev/null 2>&1
if [ "$?" != 0 ]; then
   logger -i -s -- "firewall network group $NETGROUP doesn't exist yet"
   clean_up
   exit 1
fi

NEWGROUP=$NETGROUP-$$
/sbin/ipset --create $NEWGROUP hash:net maxelem 500000
if [ "$?" != 0 ]; then
  clean_up
  logger -i -s -- "There was an error trying to create temporary set"
  exit 1
fi

count=0;
for i in `cat $TMPFILE`;
do
  /sbin/ipset -exist -quiet -A $NEWGROUP $i
  if [ "$?" != 0 ]; then
     logger -i -s -- "There was an error trying to add $i"
     clean_up
     exit 1
  fi
  let "count++"
done

/sbin/ipset --swap $NEWGROUP $NETGROUP
if [ "$?" != 0 ]; then
  logger -i -s -- "There was an error trying to swap temporary set"
  clean_up
  exit 1
fi

# Clean up temporary files and temp iptables group
clean_up

logger -i -s -- "added $count entries to $NETGROUP"
exit 0