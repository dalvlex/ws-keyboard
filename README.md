WebSocket Keyboard

WebSocket based client / server for sending keyboard events from a HTTPS page to a linux server.

Install

cd /var/www/
sudo git clone https://github.com/dalvlex/ws-keyboard
cd ws-keyboard/
sudo ./install.sh

Usage

Visit both https://<YOUR_SERVER_IP>:9500/ and https://<YOUR_SERVER_IP>:9502/ and add browser exceptions for the self-signed SSL certificate.
Access https://<YOUR_SERVER_IP>:9500/, Connect and start sending keyboard events to the linux active console.

Uninstall

cd /var/www/ws-keyboard/
sudo ./uninstall.sh
cd /var/www/
sudo rm -rf /var/www/ws-keyboard
