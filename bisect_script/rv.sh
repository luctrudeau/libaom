#!/bin/bash
"$@"
rv=$?
if [ $rv -gt 127 ]; then
  exit 127
else
  exit $rv
fi
