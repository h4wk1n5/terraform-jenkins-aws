#/bin/bash

set -x

function install_packages ()
{

  apt-get update
  apt-get purge java*
  apt-get install nc git java-1.8.0-openjdk unzip vim tree
  sleep 10
}

install_packages

echo "Done"

exit 0
