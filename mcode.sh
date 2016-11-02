#!/bin/bash -
#
# SCRIPT: mcode
# AUTHOR: Luciano D. Cecere
# DATE: 11/27/2015-02:04:34 PM
########################################################################
#
# mcode - Text to Morse Code
# Copyright (C) 2015 Luciano D. Cecere <ldante86@aol.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
########################################################################

export PATH=/bin:/usr/bin
unalias -a

########################## DEFINE GLOBALS ##############################

PROGRAM="${0##*/}"
X="dit"
Y="daw"
declare -u str

MORSE=(
        "$X $Y" "$Y $X $X $X" "$Y $X $Y $X" "$Y $X $X" "$X"
        "$X $X $Y $X" "$Y $Y $X" "$X $X $X $X" "$X $X"
        "$X $Y $Y $Y" "$Y $X $Y" "$X $Y $X $X" "$Y $Y" "$Y $X"
        "$Y $Y $Y" "$X $Y $Y $X" "$Y $Y $X $Y" "$X $Y $X"
        "$X $X $X" "$Y" "$X $X $Y" "$X $X $X $Y" "$X $Y $Y"
        "$Y $X $X $Y" "$Y $X $Y $Y" "$Y $Y $X $X"

	"$Y $Y $Y $Y $Y" "$X $Y $Y $Y $Y" "$X $X $Y $Y $Y"
	"$X $X $X $Y $Y" "$X $X $X $X $Y" "$X $X $X $X $X"
	"$Y $X $X $X $X" "$Y $Y $X $X $X" "$Y $Y $Y $X $X"
	"$Y $Y $Y $Y $X"

	"$Y $Y $X $X $Y $Y" "$X $Y $X $Y $X $Y" "$X $Y $X $Y $X"
	"$Y $X $X $X $Y" "$Y $X $X $X $X $Y" "$Y $X $Y $Y $X"
	"$Y $X $Y $Y $X $Y" "$Y $Y $Y $X $X $X" "$X $X $Y $Y $X $X"
	"$X $Y $Y $Y $Y $X" "$X $Y $X $X $Y $X"
)

END=" $X $X $X $Y $X $Y"

CHARS=( {A..Z} {0..9} , . + = - \( \) \: ? \' \" )

USAGE="\
PROGRAM: $PROGRAM
DESCRIPTION: Text to Morse Code
AUTHOR: Luciano D. Cecere
LICENSE: GPLv2

USAGE:
 $PROGRAM string
 $PROGRAM -h
 $PROGRAM -d file
 $PROGRAM -s string

FLAGS:
 -d --decode file    Decode from file. File must contain -s
                     flag output.
 -h --help           Show this help and exit.
 -s                  Use '.' and '-'.

NOTE:
 Default output uses 'dit' and 'daw'.\
"

########################## DEFINE FUNCTIONS ############################

_encode()
{
    str="$@"

    for ((l=0; l<${#str}; l++))
    do
      for ((i=0; i<${#MORSE[@]}; i++))
      do
        if [ "${str:l:1}" = "${CHARS[i]}" ]; then
          echo " ${MORSE[i]}"
          break
        elif [ "${str:l:1}" = " " ]; then
          echo
          break
        fi
      done
    done
}

_decode()
{
    if [ -z "$1" ]; then
      echo "Missing filename"
      exit 1
    elif [ ! -e "$1" ]; then
      echo "Cannot read $1"
      exit 1
    fi

    while read
    do
      if [ -z "${REPLY}" ]; then
        echo -n " "
        continue
      elif [[ $REPLY != *[$X$Y]* ]]; then
        continue
      fi

      for ((i=0; i<${#CHARS[@]}; i++))
      do
        if [ "${REPLY:1}" = "${MORSE[i]}" ]; then
          echo -n "${CHARS[i]}"
          break
        fi
      done
    done < "$1"
    echo
    exit
}

########################## END OF FUNCTIONS ############################

########################## PROGRAM START ###############################

case $1 in
  -[Dd]|--decode|-[Ss])
    X="."
    Y="-"
        MORSE=(
                $X$Y $Y$X$X$X $Y$X$Y$X $Y$X$X $X $X$X$Y$X $Y$Y$X
                $X$X$X$X $X$X $X$Y$Y$Y $Y$X$Y $X$Y$X$X $Y$Y $Y$X
                $Y$Y$Y $X$Y$Y$X $Y$Y$X$Y $X$Y$X $X$X$X $Y $X$X$Y
                $X$X$X$Y $X$Y$Y $Y$X$X$Y $Y$X$Y$Y $Y$Y$X$X

                $Y$Y$Y$Y$Y $X$Y$Y$Y$Y $X$X$Y$Y$Y $X$X$X$Y$Y
                $X$X$X$X$Y $X$X$X$X$X $Y$X$X$X$X $Y$Y$X$X$X
                $Y$Y$Y$X$X $Y$Y$Y$Y$X

                $Y$Y$X$X$Y$Y $X$Y$X$Y$X$Y $X$Y$X$Y$X $Y$X$X$X$Y
                $Y$X$X$X$X$Y $Y$X$Y$Y$X $Y$X$Y$Y$X$Y $Y$Y$Y$X$X$X
                $X$X$Y$Y$X$X $X$Y$Y$Y$Y$X $X$Y$X$X$Y$X
	)
    ;;
esac

case $1 in
  -[Dd]|--decode)
    shift
    _decode "$@"
    ;;

  -[Hh]|--help)
    echo "$USAGE"
    exit
    ;;

  -s)
    shift
    END=" $X$X$X$Y$X$Y"
     ;;
esac

if [ $# -eq 0 ]; then
  trap 'echo; echo $END; exit' INT
  while read
  do
    _encode "$REPLY"
  done
else
  _encode "$@"
  echo
  echo "$END"
fi

################################ EOF ###################################
