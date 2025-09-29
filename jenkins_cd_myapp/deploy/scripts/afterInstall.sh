#!/bin/bash
echo "-------------- Untar app files ------------------"
cd
rm -rf myapp_build
mkdir -p myapp_build
tar -xvf myapp_build.tar -C myapp_build
cd myapp_build
rm -rf /var/lib/tomcat8/webapps/*
cp -v  *.war /var/lib/tomcat8/webapps

echo "-------------- Remove unwanted files ------------------"
rm -rf /etc/apache2/sites-enabled/000-default.conf
rm -fv /etc/apache2/conf-enabled/other-vhosts-access-log.conf

echo "-------------- Run salt util sync ------------------"
rm -rf /var/cache/salt/*
ls -ltr
salt-call --local saltutil.sync_all
OUT=$?
if [ $OUT -ne 0 ];then
  echo "ERROR: Getting Error during salt-call saltutil.sync_all"
  exit 1
fi
echo "-------------- Run Salt state.highstate --------------"
rm -rf /var/cache/apt/archives/lock
rm -rf /var/lib/dpkg/lock
sudo salt-call --local state.highstate

echo "-------------- Splunk forwarder updates --------------"
aws s3 cp s3://splunk-forwarder-credentials-update/splunkclouduf.spl /tmp/splunkclouduf.spl
/opt/splunkforwarder/bin/splunk install app /tmp/splunkclouduf.spl -auth admin:password -update true
