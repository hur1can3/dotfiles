#!/bin/bash

VOLGROP='alloc'                 # name of the volume group
ORIGVOL='/dev/sdb'                 # name of the logical volume to backup
SNAPVOL='mysnap'                 # name of the snapshot to create
SNAPSIZ='8G'                     # space to allocate for the snapshot in the volume group
FSAOPTS='-z7 -j3'                # options to pass to fsarchiver
BACKDIR='~/images/'              # where to put the backup
BACKNAM='aloc-back'     # name of the archive

# ----------------------------------------------------------------------------------------------

PATH="${PATH}:/usr/sbin:/sbin:/usr/bin:/bin"
TIMESTAMP="$(date +%Y%m%d-%Hh%M)"

# only run as root
if [ "$(id -u)" != '0' ]
then
        echo "this script has to be run as root"
        exit 1
fi

# check that the snapshot does not already exist
if [ -e "/dev/${VOLGROP}/${SNAPVOL}" ]
then
        echo "the lvm snapshot already exists, please destroy it by hand first"
        exit 1
fi

# create the lvm snapshot
if ! lvcreate -L${SNAPSIZ} -s -n ${SNAPVOL} /dev/${VOLGROP}/${ORIGVOL} >/dev/null 2>&1
then
        echo "creation of the lvm snapshot failed"
        exit 1
fi

# main command of the script that does the real stuff
if fsarchiver savefs ${FSAOPTS} ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.fsa /dev/${VOLGROP}/${SNAPVOL}
then
        md5sum ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.fsa > ${BACKDIR}/${BACKNAM}-${TIMESTAMP}.md5
        RES=0
else
        echo "fsarchiver failed"
        RES=1

##      exit (1);  # don't remove the snapshot just yet
                   # perhaps we will want to try again ?

fi

if [ "$RES" != '1' ]  # prevent removal if error occurred above.
then

  # remove the snapshot
  if ! lvremove -f /dev/${VOLGROP}/${SNAPVOL} >/dev/null 2>&1
  then
        echo "cannot remove the lvm snapshot"
        RES=1
  fi

fi

exit ${RES}