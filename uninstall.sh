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
rm -rf /var/www/ws-keyboard/ssl/*

echo "DONE: Now all remaining files should be only in /var/www/ws-keyboard/."
