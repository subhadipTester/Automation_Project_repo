#!/bin/bash
sudo apt update -y
REQUIRED_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUiIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get install $REQUIRED_PKG;
fi
sudo systemctl start apache2.service
servstat=$(service apache2 status)
if [[ $servstat == *"active (running)"* ]]; then
  echo "process is running"
  sudo systemctl is-enabled apache2.service
  sudo systemctl is-active apache2.service
else echo "process is not running"
  sudo systemctl start apache2.service
  sudo systemctl status apache2.service
fi
myname="Subhadip"
timestamp=$(date '+%d%m%Y-%H%M%S')
sudo tar -cvf "${myname}--httpd-logs-${timestamp}.tar" /var/log/apache2/
cp *.tar /tmp/
sudo apt-get update
sudo apt-get install awscli -y
aws --version
s3_bucket="upgrad-subhadip"
aws s3 cp /tmp/${myname}--httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}--httpd-logs-${timestamp}.tar
aws s3 ls s3://${s3_bucket}
Log_type="httpd-logs"
Type="tar"
FILE=/var/www/html/inventory.html
fsize=`du -hs /tmp/${myname}--httpd-logs-${timestamp}.tar | awk '{ print $1 }'`
if [[ -f "$FILE" ]]; then
   echo "$FILE exists."
else
   cd /var/www/html
   touch inventory.html
   echo -e '<b>Log Type &emsp; Date Created &emsp; Type &emsp; Size</b>' >> /var/www/html/inventory.html
   echo "Inventory File Created"
fi
echo -e "<br>${Log_type} &emsp; ${timestamp} &ensp; ${Type} &ensp; ${fsize}</br>" >> /var/www/html/inventory.html
echo "Metadata copied to inventory.html"
dpkg -l cron
apt-get install cron
systemctl status cron
sudo touch /etc/cron.d/automation
sudo echo "30 23 */1 * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
sudo chmod 600 /etc/cron.d/automation
echo "Cron job scheduled"
