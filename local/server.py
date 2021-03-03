import sys
import inspect
import signal
import time
from evdev import UInput, ecodes as eco
from simple_websocket_server import WebSocket, WebSocketServer
from optparse import OptionParser

class WebKeyboard(WebSocket):
    k_alnum_lc = "qwertyuiopasdfghjklzxcvbnm1234567890"
    k_al_uc = "QWERTYUIOPASDFGHJKLZXCVBNM"
    k_rest = {
             " ": { "key": "KEY_SPACE" },
             "!": { "key": "KEY_1", "mod": "KEY_LEFTSHIFT" },
             "@": { "key": "KEY_2", "mod": "KEY_LEFTSHIFT" },
             "#": { "key": "KEY_3", "mod": "KEY_LEFTSHIFT" },
             "$": { "key": "KEY_4", "mod": "KEY_LEFTSHIFT" },
             "%": { "key": "KEY_5", "mod": "KEY_LEFTSHIFT" },
             "^": { "key": "KEY_6", "mod": "KEY_LEFTSHIFT" },
             "&": { "key": "KEY_7", "mod": "KEY_LEFTSHIFT" },
             "*": { "key": "KEY_8", "mod": "KEY_LEFTSHIFT" },
             "(": { "key": "KEY_9", "mod": "KEY_LEFTSHIFT" },
             ")": { "key": "KEY_0", "mod": "KEY_LEFTSHIFT" },
             "-": { "key": "KEY_MINUS" },
             "_": { "key": "KEY_MINUS", "mod": "KEY_LEFTSHIFT" },
             "=": { "key": "KEY_EQUAL" },
             "+": { "key": "KEY_EQUAL", "mod": "KEY_LEFTSHIFT" },
             "[": { "key": "KEY_LEFTBRACE" },
             "{": { "key": "KEY_LEFTBRACE", "mod": "KEY_LEFTSHIFT" },
             "]": { "key": "KEY_RIGHTBRACE" },
             "}": { "key": "KEY_RIGHTBRACE", "mod": "KEY_LEFTSHIFT" },
             ";": { "key": "KEY_SEMICOLON" },
             ":": { "key": "KEY_SEMICOLON", "mod": "KEY_LEFTSHIFT" },
             "'": { "key": "KEY_APOSTROPHE" },
             "\"": { "key": "KEY_APOSTROPHE", "mod": "KEY_LEFTSHIFT" },
             "\\": { "key": "KEY_BACKSLASH" },
             "|": { "key": "KEY_BACKSLASH", "mod": "KEY_LEFTSHIFT" },
             ",": { "key": "KEY_COMMA" },
             "<": { "key": "KEY_COMMA", "mod": "KEY_LEFTSHIFT" },
             ".": { "key": "KEY_DOT" },
             ">": { "key": "KEY_DOT", "mod": "KEY_LEFTSHIFT" },
             "/": { "key": "KEY_SLASH" },
             "?": { "key": "KEY_SLASH", "mod": "KEY_LEFTSHIFT" },
             "`": { "key": "KEY_GRAVE" },
             "~": { "key": "KEY_GRAVE", "mod": "KEY_LEFTSHIFT" },
             }

    def connected(self):
        print(self.address, "connected")
        self.ui = UInput()

    def handle(self):
        print(self.data)

        self.key = self.mod = None
	    # Set key value from valid KEY_s directly
        if "KEY_" in self.data:
            try:
                self.key = getattr(eco, self.data)
                self.key = self.data
            except (AttributeError):
                print("No such key " + self.data)
                pass
        # Set key value to alphanumeric lowercase
        elif self.data[0] in self.k_alnum_lc:
            self.key = "KEY_" + self.data[0].upper()
        # Set key value to alpha uppercase with modifier Shift key
        elif self.data[0] in self.k_al_uc:
            self.mod = "KEY_LEFTSHIFT"
            self.key = "KEY_" + self.data[0]
        # Set key value to one of k_rest with or without modifier Shift key
        elif self.data[0] in self.k_rest:
            self.key = self.k_rest[self.data[0]]["key"]
            if "mod" in self.k_rest[self.data[0]]:
                self.mod = self.k_rest[self.data[0]]["mod"]

        # Send recorded key to system along with modifier if available
        if self.key is not None:
            if self.mod is not None:
                self.ui.write(eco.EV_KEY, getattr(eco, self.mod), 1)
            self.ui.write(eco.EV_KEY, getattr(eco, self.key), 1)
            self.ui.write(eco.EV_KEY, getattr(eco, self.key), 0)
            self.ui.syn()
            if self.mod is not None:
                self.ui.write(eco.EV_KEY, getattr(eco, self.mod), 0)

        # Echo received data back to client
        self.send_message(self.data)

    def handle_close(self):
        print(self.address, "disconnected")
        self.ui.close()

if __name__ == '__main__':
    parser = OptionParser(usage='usage: %prog [options]')
    parser.add_option('--host', default='', type='string', action='store', dest='host', help='hostname (localhost)')
    parser.add_option('--port', default=9503, type='int', action='store', dest='port', help='port (9503)')
    (options, args) = parser.parse_args()

    sslopts = {}
    server = WebSocketServer(options.host, options.port, WebKeyboard, **sslopts)

    def close_sig_handler(signal, frame):
        server.close()
        sys.exit()

    signal.signal(signal.SIGINT, close_sig_handler)

    server.serve_forever()
