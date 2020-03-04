#/bin/bash

set -x

function install_jenkins ()
{

  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
  apt-get update
  add-apt-repository universe
  apt-get install jenkins
  systemctl enable jenkins
  systemctl restart jenkins
  sleep 10
}

function wait_for_jenkins()
{
  while (( 1 )); do
      echo "waiting for Jenkins to launch on port [8080] ..."
      
      nc -zv 127.0.0.1 8080
      if (( $? == 0 )); then
          break
      fi

      sleep 10
  done

  echo "Jenkins launched"
}


install_jenkins

wait_for_jenkins

echo "Done"

exit 0
