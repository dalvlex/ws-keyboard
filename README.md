# WebSocket Keyboard

### Description
WebSocket Keyboard is a client-server tool for sending keyboard events from a HTTPS page on your desktop/mobile to a linux server running Ubuntu 18.04 or something similar.  
This package was put together to allow me to control content on my Raspberry Pi 4 display from my Android mobile phone without using a physical keyboard. And for this purpose it works without any issue on 'Raspbian GNU/Linux 10 (buster)' - it also works for Kodi on top of RetroPie.

### Install
ws-keyboard may only be installed in /opt/ws-keyboard
```
sudo git clone https://github.com/dalvlex/ws-keyboard /opt/ws-keyboard
sudo /opt/ws-keyboard/install.sh
```

### Usage
Visit both `https://<YOUR_SERVER_IP>:9500/` and `https://<YOUR_SERVER_IP>:9502/` and add browser exceptions for the self-signed SSL certificate.  
Access `https://<YOUR_SERVER_IP>:9500/`, click 'Connect' and start sending keyboard events to the linux active console.

### Uninstall
```
sudo /opt/ws-keyboard/uninstall.sh
sudo rm -rf /opt/ws-keyboard
```

### Mentions
This was inspired by [Ralf Meermeier](https://github.com/threebrooks) Android application [UniversalController](https://github.com/threebrooks/UniversalController) and the code examples of [simple-websocket-server](https://pypi.org/project/simple-websocket-server/) Python module.
