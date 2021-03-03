/*
  Conventions:
  - All id, name, class are camelCase;
  - All elements have identical 'id' and 'name' attributes;
  - Javascript events are added with addEventListener, not as HTML element inline attribute;
  - Javascript must be in strict mode;
  - No jQuery or other frameworks!
*/
"use strict"
var websocket;
var wskForm;
var kspecial = {
                8: "KEY_BACKSPACE",
                9: "KEY_TAB",
                13: "KEY_ENTER",
                27: "KEY_ESC",
                46: "KEY_DELETE",
                38: "KEY_UP",
                40: "KEY_DOWN",
                37: "KEY_LEFT",
                39: "KEY_RIGHT",
                112: "KEY_F1",
                113: "KEY_F2",
                114: "KEY_F3",
                115: "KEY_F4",
                116: "KEY_F5",
                117: "KEY_F6",
                118: "KEY_F7",
                119: "KEY_F8",
                120: "KEY_F9",
                121: "KEY_F10",
                122: "KEY_F11",
                123: "KEY_F12"
                };

function init(){
  wskForm = document.wskForm;

  //wskForm.wsURL.value = "wss://192.168.0.100:9502/";
  wskForm.inputText.value = "";
  wskForm.btnDisconnect.disabled = true;
  wskForm.inputText.focus();
  wskForm.inputText.click();

  // Add event listeners for wskForm elements
  wskForm.querySelector('#btnConnect').addEventListener('click', doConnect, false);
  wskForm.querySelector('#btnDisconnect').addEventListener('click', doDisconnect, false);
  wskForm.querySelector('#inputText').addEventListener('keyup', sendAndClear, false);
  wskForm.querySelector('#inputText').addEventListener('keydown', sendAndClear, false);
  [...wskForm.querySelectorAll('.btnKey')].forEach(function(item){
    item.addEventListener('click', doKey, false);
  });
}
// Init form events upon page load
window.addEventListener("load", init, false);

function doConnect(evt){
  websocket = new WebSocket(wskForm.wsURL.value);
  websocket.onopen = function(evt) { onOpen(evt) };
  websocket.onclose = function(evt) { onClose(evt) };
  websocket.onmessage = function(evt) { onMessage(evt) };
  websocket.onerror = function(evt) { onError(evt) };
}

function onOpen(evt){
  writeOutput("connected\n");
  wskForm.btnConnect.disabled = true;
  wskForm.btnDisconnect.disabled = false;
}

function onClose(evt){
  writeOutput("disconnected\n");
  wskForm.btnConnect.disabled = false;
  wskForm.btnDisconnect.disabled = true;
}

function onMessage(evt){
  writeOutput("response: " + evt.data + '\n');
}

function onError(evt){
  writeOutput('error: ' + evt.data + '\n');

  websocket.close();

  wskForm.btnConnect.disabled = false;
  wskForm.btnDisconnect.disabled = true;
}

function doSend(message){
  websocket.send(message);
  writeOutput("sent: " + message + '\n'); 
}

function writeOutput(message){
  wskForm.outputText.value += message
  wskForm.outputText.scrollTop = wskForm.outputText.scrollHeight;
}

function sendAndClear(evt) {
  let kcode = evt.keyCode || evt.charCode;

  // send special events on keydown
  if (typeof kspecial[kcode] !== typeof undefined){
    evt.preventDefault();
    if (evt.type == "keydown") {
      doSend( kspecial[kcode] );
    }
  }
  // send keys for desktops on keydown since keyup is skipping keys
  else if (evt.key.length == 1 && evt.type == "keydown") {
    doSend( evt.key );
  }
  // send keys for mobiles on keyup since keydown is not writing to the input element at the press time
  else if (evt.key.length > 1 && wskForm.inputText.value.length > 0 && evt.type == "keyup"){
    doSend( wskForm.inputText.value.slice(-1) );
  }

  wskForm.inputText.value = '';
}

function doKey(evt){
  doSend( evt.target.dataset.key );
  wskForm.inputText.focus();
}

function doDisconnect(evt) {
  websocket.close();
}