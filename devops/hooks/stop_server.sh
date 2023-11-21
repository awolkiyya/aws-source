#!/bin/bash
isExistHttps = `pgrep apache2`
if [[ -n  $isExistHttps ]]; then
  sudo  service apache2 stop
fi
