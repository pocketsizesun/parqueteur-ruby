#!/bin/sh

if [ $(dpkg-query -W -f='${Status}' apache-arrow-apt-source 2>/dev/null | grep -c "ok installed") -eq 1 ]
then
  exit 0
fi

LSB_RELEASE_CODENAME_SHORT=$(lsb_release --codename --short)

apt-get update
apt-get install -y -V ca-certificates lsb-release wget
wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
apt-get install -y -V ./apache-arrow-apt-source-latest-${LSB_RELEASE_CODENAME_SHORT}.deb
rm ./apache-arrow-apt-source-latest-${LSB_RELEASE_CODENAME_SHORT}.deb
apt-get update
apt-get install -y libgirepository1.0-dev libarrow-dev libarrow-glib-dev libparquet-dev libparquet-glib-dev

exit 0
