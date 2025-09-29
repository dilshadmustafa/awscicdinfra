#!/bin/bash
/opt/splunkforwarder/bin/splunk stop
sudo service apache2 stop
sudo service tomcat8 stop
sudo service chrony stop
sudo service postfix stop