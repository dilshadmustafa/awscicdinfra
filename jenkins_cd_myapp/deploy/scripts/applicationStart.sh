#!/bin/bash
rm -fv ~/.netrc
rm -rf /var/log/salt/*
rm -rf /var/log/apache2/*
rm -rf /var/log/tomcat8/*
rm -rf /var/log/chrony/*
rm -rf /var/log/audit.log.*

sudo /opt/splunkforwarder/bin/splunk restart
sudo service apache2 restart
sudo service tomcat8 restart
sudo service chrony restart
sudo service postfix restart

unlink /usr/local/ssl
ln -s /etc/ssl /usr/local