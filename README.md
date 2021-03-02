# WebSocket Keyboard

### Description
WebSocket Keyboard is a client-server tool for sending keyboard events from a HTTPS page on your desktop/mobile to a linux server running Ubuntu 18.04 or something similar.
This package was put together to allow me to type and control my Raspberry Pi 4 from my Android mobile phone without using a keyboard. It works on Raspian, RetroPie, Kodi etc.

### Install
cd /var/www/  
sudo git clone https://github.com/dalvlex/ws-keyboard  
cd ws-keyboard/  
sudo ./install.sh  

### Usage
Visit both https://<YOUR_SERVER_IP>:9500/ and https://<YOUR_SERVER_IP>:9502/ and add browser exceptions for the self-signed SSL certificate.  
Access https://<YOUR_SERVER_IP>:9500/, Connect and start sending keyboard events to the linux active console.

### Uninstall
sudo /var/www/ws-keyboard/uninstall.sh  
cd /var/www/  
sudo rm -rf /var/www/ws-keyboard  

### Mentions
This was inspired by [Ralf Meermeier](https://github.com/threebrooks) Android application [UniversalController](https://github.com/threebrooks/UniversalController) and the code examples of [simple-websocket-server](https://pypi.org/project/simple-websocket-server/) Python module.
