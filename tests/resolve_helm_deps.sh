#!/usr/bin/env bash
resolve-helm-chart-dependencies () {
  if [ -z $1 ]; then
    echo "No chart directory provided"
    startdir=$(pwd)
  else
    startdir=$1
  fi
  pushd $startdir
  helm dep build .
  if [ -d ./charts ]; then
    for chartzip in `find charts -maxdepth 1 -name '*.tgz' -type f`; do
      chartzipdir=$(tar -tzf $chartzip | head -n 1 | cut -f 1 -d '/')
      tar xfvz $chartzip -C charts
      echo; echo; echo "Resolving dependencies for $chartzipdir"; echo; echo
      resolve-helm-chart-dependencies charts/$chartzipdir
    done
  else 
    echo; echo; echo "${startdir}: No dependencies found."; echo; echo
  fi
  popd
}