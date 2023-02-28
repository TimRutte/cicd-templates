#!/usr/bin/env bash

error=false
while test $# -gt 0; do
  current=$1
  shift

  if [ ! -d "${current}" ] && [ ! -f "${current}" ] ; then
    echo "Invalid directory or file: ${current}"
    error=true
    continue
  fi

  find "${current}" ! -name "$(printf "*\n*")" -type f -name "*.php" -not -path "${current/\//*$//:?}/vendor/*" > lint_files.tmp

  while IFS= read -r file
  do
    RESULTS=$(php -l "${file}")
    if [ "$RESULTS" != "No syntax errors detected in $file" ] ; then
      echo "${RESULTS}"
      error=true
    else
      echo "${file} is ok"
    fi
  done < lint_files.tmp
done

if [ "$error" = true ] ; then
  exit 1
else
  exit 0
fi
