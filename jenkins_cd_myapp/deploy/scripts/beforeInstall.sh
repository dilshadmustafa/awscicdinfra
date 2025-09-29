#!/bin/bash
echo "-------------- Copying Salt Minion------------------"

echo "-------------- Cloning Salt ------------------"
cd /srv/
rm -rf salt-cm-master*
git clone --depth=1 https://myuserid:mytoken@github.com/myapprepo/salt-cm-master.git
if (! grep stag /etc/salt/minion); then
  rm -r /srv/salt-cm-master/salt/*stag*
fi
cd /srv/salt-cm-master/salt/myapp-prod
cp -rpv minion /etc/salt 

echo "-------------- Providing Permissions for salt ------------------"
cd /srv
sudo ln -s /srv/salt-cm-master/salt salt
cp -rf /srv/salt-cm-master/master/master /etc/salt/minion.d/masterless.conf
chmod -R 775 /etc/salt/

echo "-------------- stopping minion ------------------"
service salt-minion stop

rm -rf /etc/init.d/salt-minion
rm -rf /etc/init/salt-minion.conf

echo "-------------- setting up directories  ------------------"
mkdir -p /var/lib/tomcat8/webapps
mkdir -p /var/www/myapp/myapp-prod
cd /var/lib/
chown -R tomcat8:tomcat8 tomcat8
echo "Welcome!" > /var/www/html/index.html
