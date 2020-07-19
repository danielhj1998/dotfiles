#!/usr/bin/env bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# loop the paths.txt file
while read path; do
  filepath=$(eval echo $path)

  # Get name without .(the first character)
  dname=$(basename $filepath)
  dname="${dname:1}"
  dfilepath="$dir/$dname.dln"

  ln -sf $dfilepath $filepath 
done < "$dir/paths.txt"
