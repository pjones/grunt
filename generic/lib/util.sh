#!/bin/sh

################################################################################
# $1 The element
# $* The Array
grunt_array_includes_element () {
  grunt_ary_element=$1
  shift

  for grunt_e in $*; do
    [ "$grunt_ary_element" = "$grunt_e" ] && return 0
  done

  return 1
}
