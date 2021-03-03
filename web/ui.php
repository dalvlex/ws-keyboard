<?php
$local_ip_address = @reset(explode(':', $_SERVER['HTTP_HOST']));
?>
<!DOCTYPE html>
<head>
  <meta charset="utf-8" />
  <link rel="shortcut icon" href="data:image/x-icon;," type="image/x-icon"> 
  <meta name="mobile-web-app-capable" content="yes">
  <title>WebSocket Keyboard</title>
</head>
<body>
  <div id="output"></div>
  <form name="wskForm">
    <p><textarea id="outputText" name="outputText"></textarea></p>
    <p>
      <input id="inputText" name="inputText" maxlength="1" type="password" autocomplete="off" data-lpignore="true" placeholder="click and type here to send" />
      <input type="button" class="btnKey" id="btnEnter" name="btnEnter" value="Enter" data-key="KEY_ENTER" />
    </p>
    <p>
      <input type="button" class="btnKey" id="btnTab" name="btnTab" value="Tab" data-key="KEY_TAB" />
      <input type="button" class="btnKey" id="btnEsc" name="btnEsc" value="Esc" data-key="KEY_ESC" />
      <input type="button" class="btnKey" id="btnDelete" name="btnDelete" value="Delete" data-key="KEY_DELETE" />
      <input type="button" class="btnKey" id="btnBackspace" name="btnBackspace" value="Backspace" data-key="KEY_BACKSPACE" />
      <input type="button" class="btnKey" id="btnLeft" name="btnLeft" value="LEFT" data-key="KEY_LEFT" />
      <input type="button" class="btnKey" id="btnUp" name="btnUp" value="UP" data-key="KEY_UP" />
      <input type="button" class="btnKey" id="btnDown" name="btnDown" value="DOWN" data-key="KEY_DOWN" />
      <input type="button" class="btnKey" id="btnRight" name="btnRight" value="RIGHT" data-key="KEY_RIGHT" />
    </p>
    <p>
      <input type="button" class="btnKey" id="btnF1" name="btnF1" value="F1" data-key="KEY_F1" />
      <input type="button" class="btnKey" id="btnF2" name="btnF2" value="F2" data-key="KEY_F2" />
      <input type="button" class="btnKey" id="btnF3" name="btnF3" value="F3" data-key="KEY_F3" />
      <input type="button" class="btnKey" id="btnF4" name="btnF4" value="F4" data-key="KEY_F4" />
      <input type="button" class="btnKey" id="btnF5" name="btnF5" value="F5" data-key="KEY_F5" />
      <input type="button" class="btnKey" id="btnF6" name="btnF6" value="F6" data-key="KEY_F6" />
      <input type="button" class="btnKey" id="btnF7" name="btnF7" value="F7" data-key="KEY_F7" />
      <input type="button" class="btnKey" id="btnF8" name="btnF8" value="F8" data-key="KEY_F8" />
      <input type="button" class="btnKey" id="btnF9" name="btnF9" value="F9" data-key="KEY_F9" />
      <input type="button" class="btnKey" id="btnF10" name="btnF10" value="F10" data-key="KEY_F10" />
      <input type="button" class="btnKey" id="btnF11" name="btnF11" value="F11" data-key="KEY_F11" />
      <input type="button" class="btnKey" id="btnF12" name="btnF12" value="F12" data-key="KEY_F12" />
    </p>
    <p>
      <input type="button" class="btnKey" id="btnAlt1" name="btnAlt1" value="Alt 1" data-key="KEY_LEFTALT" data-mod="once" />
      <input type="button" class="btnKey" id="btnCtrl1" name="btnCtrl1" value="Ctrl 1" data-key="KEY_LEFTCTRL" data-mod="once" />
      <input type="button" class="btnKey" id="btnShift1" name="btnShift1" value="Shift 1" data-key="KEY_LEFTSHIFT" data-mod="once" />
      <input type="button" class="btnKey" id="btnAltX" name="btnAltX" value="Alt X" data-key="KEY_LEFTALT" data-mod="sticky" />
      <input type="button" class="btnKey" id="btnCtrlX" name="btnCtrlX" value="Ctrl X" data-key="KEY_LEFTCTRL" data-mod="sticky" />
      <input type="button" class="btnKey" id="btnShiftX" name="btnShiftX" value="Shift X" data-key="KEY_LEFTSHIFT" data-mod="sticky" />
    </p>
    <p>
      <input id="wsURL" name="wsURL" value="wss://<?php echo $local_ip_address ?>:9502/"></textarea>
    </p>
    <p>
      <input type="button" class="btnDisconnect" id="btnDisconnect" name="btnDisconnect" value="Disconnect" />
      <input type="button" class="btnConnect" id="btnConnect" name="btnConnect" value="Connect" />
    </p>
  </form>
  <footer>
    <script src="/js/ui.js"></script> 
    <link rel="stylesheet" href="/css/ui.css">
  </footer>
</body>
</html> 
