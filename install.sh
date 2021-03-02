#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Run 'sudo ./install.sh'"
   exit 1
fi

echo "##### Installing system dependencies"
echo "# Updating repositories"
apt update
echo "# Installing PHP, Python3 Pip, Stunnel & OpenSSL"
apt install php python3 python3-pip stunnel4 openssl -y
echo "# Installing Python3 evdev module"
yes | pip3 install evdev
echo "# Installing Python3 python-uinput module"
yes | pip3 install python-uinput

echo "##### Install configuration files"
echo "# Generating self-signed SSL certificate and key for Stunnel"
openssl req -new -x509 -nodes -out /var/www/ws-keyboard/ssl/cert.pem -keyout /var/www/ws-keyboard/ssl/key.pem -days 3650 -subj "/C=RO/ST=Bucharest/L=Bucharest/O=WssKeyboard.none/CN=WssKeyboard.none"

echo "# Creating wsk-php service for client UI"
tee /etc/systemd/system/wsk-php.service >/dev/null <<'EOF'
[Unit]
Description=WebSocket Keyboard PHP Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/php -S 127.0.0.1:9501 -t /var/www/ws-keyboard/web
StandardOutput=inherit
StandardInput=inherit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "# Creating wsk-python3 service for WebSocket and relaying keyboard events"
tee /etc/systemd/system/wsk-python3.service >/dev/null <<'EOF'
[Unit]
Description=WebSocket Keyboard Python3 Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 /var/www/ws-keyboard/local/ws-keyboard-server.py --host 127.0.0.1 --port 9503
StandardOutput=inherit
StandardInput=inherit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "# Creating wsk-stunnel service for SSL connections"
tee /etc/systemd/system/wsk-stunnel.service >/dev/null <<'EOF'
[Unit]
Description=WebSocket Keyboard Stunnel Server
After=network.target

[Service]
Type=forking
ExecStart=/usr/bin/stunnel /var/www/ws-keyboard/local/ws-keyboard-stunnel.conf
StandardOutput=inherit
StandardInput=inherit
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "# Creating wsk-stunnel configuration file"
tee /var/www/ws-keyboard/local/ws-keyboard-stunnel.conf >/dev/null <<'EOF'
; Certificate/key is needed in server mode and optional in client mode
cert = /var/www/ws-keyboard/ssl/cert.pem
key = /var/www/ws-keyboard/ssl/key.pem

; Protocol version (all, SSLv2, SSLv3, TLSv1)
sslVersion = all

; PID is created inside the chroot jail
pid = /run/wsk-stunnel.pid

; Some performance tunings
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

; Some debugging stuff useful for troubleshooting
;debug = 7
output = /var/log/wsk-stunnel.log

; Service-level configuration
[wsPhpServer]
accept = 0.0.0.0:9500
connect = 127.0.0.1:9501

[wsPythonServer]
accept = 0.0.0.0:9502
connect = 127.0.0.1:9503
EOF

echo "#### Adding evdev and uinput modules to /etc/modules"
if grep -q "uinput" /etc/modules; then
   echo
else
   echo "uinput" >> /etc/modules
fi
if grep -q "evdev" /etc/modules; then
   echo
else
   echo "evdev" >> /etc/modules
fi

echo "##### Enabling and starting services"
systemctl daemon-reload
systemctl enable wsk-php.service
systemctl enable wsk-python3.service
systemctl enable wsk-stunnel.service
systemctl start wsk-php.service
systemctl start wsk-python3.service
systemctl start wsk-stunnel.service
echo "# Sleeping for 5 seconds while waiting for services"
sleep 5

echo "##### Checking service ports"
if [[ `netstat -ntap |grep stunnel |grep -c :9500` -eq 1 ]]; then
   echo "- Service wsk-stunnel confirmed on port 9500"
else
   echo "! Error: could not find service wsk-stunnel on port 9500"
fi
if [[ `netstat -ntap |grep stunnel |grep -c :9502` -eq 1 ]]; then
   echo "- Service wsk-stunnel confirmed on port 9502"
else
   echo "! Error: could not find service wsk-stunnel on port 9502"
fi
if [[ `netstat -ntap |grep php |grep -c :9501` -eq 1 ]]; then
   echo "- Service wsk-php confirmed on port 9501"
else
   echo "! Error: could not find service wsk-php on port 9501"
fi
if [[ `netstat -ntap |grep python3 |grep -c :9503` -eq 1 ]]; then
   echo "- Service wsk-python3 confirmed on port 9503"
else
   echo "! Error: could not find service wsk-python3 on port 9503"
fi

LOCAL_IP_ADDRESS=$(ip -4 route |grep default |head -n1 |awk -F 'src ' '{print $NF}' |awk '{print $1}')
echo ""
echo "DONE: If all service ports above have been confirmed, installation was successfully completed!"
echo "* Be sure to visit both https://${LOCAL_IP_ADDRESS}:9500/ and https://${LOCAL_IP_ADDRESS}:9502/ and add exceptions for the self-signed SSL certificate in your current browser."
echo "* WebSocket Keyboard may be accessed at https://${LOCAL_IP_ADDRESS}:9500/"
