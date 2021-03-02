#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Run 'sudo ./uninstall.sh'"
   exit 1
fi

echo "# Stopping and disabling services"
systemctl disable wsk-php.service
systemctl disable wsk-python3.service
systemctl disable wsk-stunnel.service
systemctl stop wsk-php.service
systemctl stop wsk-python3.service
systemctl stop wsk-stunnel.service

echo "# Removing services and configuration files"
rm -f /etc/systemd/system/wsk-php.service
rm -f /etc/systemd/system/wsk-python3.service
rm -f /etc/systemd/system/wsk-stunnel.service
systemctl daemon-reload

echo "# Removing SSL certificate"
rm -rf /opt/ws-keyboard/ssl/*

echo "# Checking service ports"
if [[ `netstat -ntap |grep stunnel |grep -c :9500` -eq 1 ]]; then
   echo "! Error: Service wsk-stunnel is still using port 9500"
else
   echo "Port 9500 free"
fi
if [[ `netstat -ntap |grep php |grep -c :9501` -eq 1 ]]; then
   echo "! Error: Service wsk-php is still using port 9501"
else
   echo "Port 9501 free"
fi
if [[ `netstat -ntap |grep stunnel |grep -c :9502` -eq 1 ]]; then
   echo "! Error: Service wsk-stunnel is still using port 9502"
else
   echo "Port 9502 free"
fi
if [[ `netstat -ntap |grep python3 |grep -c :9503` -eq 1 ]]; then
   echo "! Error: Service wsk-python3 is still using port 9503"
else
   echo "Port 9503 free"
fi

echo "DONE:"
echo "- If there is a port from the above still being used, you will have to manually kill the service process using that port;"
echo "- All remaining files are in '/opt/ws-keyboard/'."
