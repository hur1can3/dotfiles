#!/bin/sh
#
# plosetup -- helper to set up loop devices for partitions in a disk image
#
# Copyright Â© martin f. krafft <madduck@madduck.net>
# Released under the terms of the Artistic Licence 2.0
#
# EDIT: some modifications to make it run for me. downloaded from
# http://madduck.net/blog/2006.10.20:loop-mounting-partitions-from-a-disk-image/
#
# this version can be found at
# http://zwizwa.be/darcs/pool/bin/plosetup
#
set -eu

ME="${0##*/}"

about()
{
  echo "$ME -- helper to set up loop devices for partitions in a disk image"
  echo "Copyright Â© martin f. krafft <madduck@debian.org>"
  echo "Released under the terms of the Artistic Licence 2.0"
}

usage()
{
  about
  echo
  echo "Usage: $ME image_file [dest_dir] [partition_types ...]"
  echo "       $ME -c dest_dir"
  echo
  echo "Valid options are:"
  cat <<-_eof | column -s\& -t
	-h|--help & show this output.
	-V|--version & show version information.
	-c|--cleanup & clean up loop device links in the destination directory
	_eof
  echo
  echo "If a destination directory is given, $ME will create symlinks to the"
  echo "loop devices in there, using meaningful names."
  echo
  echo "Unless a (space-separated) list of partition types to filter is given,"
  echo "or the keyword 'all', $ME will only setup loop devices for partitions"
  echo "of types 0x83 (standard Linux) and 0xfd (RAID autodetect)."
}

for i in $@; do
  case "$i" in
    -V|--version) about; exit 0;;
    -h|--help) usage; exit 0;;
    -c|--cleanup) cleanup=1;;
    [0-9a-fA-F]|[0-9a-fA-F][0-9a-fA-F]) TYPES="${TYPES:+$TYPES }$i";;
    *)
      [ -f "$i" ] && [ -r "$i" ] && [ -z "${IMG:-}" ] && IMG="$i" && continue
      [ -d "$i" ] && DEST="$i" && continue

      echo "E: $ME: unknown argument: $i" >&2
      echo >&2; usage >&2
      exit 1
      ;;
  esac
done

if [ ${cleanup:-0} -eq 1 ]; then
  if [ -z "${DEST:-}" ]; then
    echo "E: $ME: no directory given." >&2
    echo >&2; usage >&2
    exit 2
  fi

  cd $DEST
  for i in *; do
    test -L $i && losetup -d $i 2>/dev/null && rm $i && continue
    echo "W: $ME: skipping file: $i" >&2
  done
  exit 0
fi

if [ -z "${IMG:-}" ]; then
  echo "E: $ME: no image file given."
  echo >&2; usage >&2
  exit 2
fi

case "$(file -b $IMG)" in
  (x86\ boot\ sector*) :;;
  *)
    echo "E: $ME: $IMG does not have a msdos partition table"
    exit 3
    ;;
esac

[ -z "${TYPES:-}" ] && TYPES="83 fd"

PARTS="$(/sbin/fdisk -lu $IMG 2>/dev/null)"

UNITS="$(echo "$PARTS" | sed -rne 's,^Units = .*= ([[:digit:]]+) bytes$,\1,p')"
MATCHER="^${IMG}p?([[:digit:]]+)[*[:space:]]*([[:digit:]]+).*[[:space:]]+([[:digit:]]+)[[:space:]].*"
PARTS="$(echo "$PARTS" | sed -rne "s,$MATCHER,\3:\1@\2,p")"

setup_loop_device()
{
  local devnode; devnode="$(/sbin/losetup -f 2>/dev/null)"
  if [ -z "${devnode:-}" ]; then
    echo "E: $ME: no more loop devices available (increase max_loop parameter!)." >&2
    exit 4
  fi

  if [ -n "${4:-}" ]; then
    local link; link="${4}/${1##*/}_p${2}"
    echo "I: $ME: partition $2 of $IMG will become $link ($devnode)..." >&2
  else
    echo "I: $ME: partition $2 of $IMG will become $devnode..." >&2
  fi
  /sbin/losetup "$devnode" "$1" -o "$3"

  [ -z "${link:-}" ] && return 0
  if [ -e "$link" ]; then
    echo "W: $ME: $link already exists, skipping symlink creation..."
  else
    ln -s $devnode $link
  fi
}


for i in $PARTS; do
  type="${i%%:*}"
  index="${i##*:}"; index="${index%%@*}"
  offset="${i##*@}"

  case "$TYPES" in
    *${type}*) :;;
    *)
      echo "I: $ME: skipping partition $index of type $type..." >&2
      continue
      ;;
  esac

  bytes="$(perl -e "print $UNITS * $offset")"
  setup_loop_device "$IMG" "$index" "$bytes" "${DEST:-}" || break
done
