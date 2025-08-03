#!/bin/sh
# win2nix - convert Windows text files to UNIX format
# Copyright 2011-2012 Jonathan Debove

#set -x

ed_cmd='g/$/s/$//'
if [ "$1" = "-r" ] ; then
	ed_cmd='g/[^]$/s/$//'
	shift
fi

program=`basename "$0"`
if [ $# -eq 0 ] ; then
	cat <<USAGE
Usage:
        $program [-r] file1 [file2] ...

Option:
        -r  convert UNIX text files to DOS format (heresy!)
USAGE
	exit 1
fi

edit_file() {
	printf '%s\n' "$ed_cmd" w q | ed -s "$1" > /dev/null
	return $?
}

for i in "$@" ; do
	msg="'$i' is not a regular file."
	if [ `basename -- "$i"` = "$program" ] ; then
		msg="Sorry, won't modify myself, don't wanna live in DOS world!"
	elif [ ! -f "$i" ] ; then
		msg="'$i' is not a regular file."
	elif file "$i" | grep -qv text ; then
		msg="'$i' is not an ASCII text file."
	else
		msg="'$i' converted."
		if ! edit_file "$i" ; then
			echo "" >> "$i"
			edit_file "$i" || msg="File \`$i' broken."
		fi
	fi
	echo "$msg"
done

exit 0
