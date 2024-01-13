from websocket_server import WebsocketServer
import threading
import time

class WebsocketServerThread(threading.Thread):
    # Flag to indicate whether a client has connected
    _clientConnected = False
    _clientConnectedLock = threading.Lock()

    def newClient(self, client, server):
        with self._clientConnectedLock:
            self._clientConnected = True
        print(f"New client connected and was given id {client['id']}")
        server.send_message_to_all("Hey all, a new client has joined us")

    def clientLeft(self, client, server):
        print(f"Client({client['id']}) disconnected")

    def _sendToClient(self, server, message):
        with self._clientConnectedLock:
            if self._clientConnected:
                server.send_message_to_all(message)
            else:
                if not self._clientConnected:
                    print("No client connected yet. Waiting...")
                    time.sleep(1)

    def messageReceived(self, client, server, message):
        if len(message) > 200:
            message = message[:200] + '..'
        print(f"Client({client['id']}) said: {message}")

    def run(self):
        PORT = 9001
        self.server = WebsocketServer(port=PORT)

        self.server.set_fn_new_client(self.newClient)
        self.server.set_fn_client_left(self.clientLeft)
        self.server.set_fn_message_received(self.messageReceived)

        # Start a thread to send a starting message to all connected clients
        sendThread = threading.Thread(target=lambda: self._sendToClient(self.server, "starting"), daemon=True)
        sendThread.start()

        print(f"Server started, listening on ws://localhost:{PORT}")
        self.server.run_forever()

    def sendThis(self, message):
        self._sendToClient(self.server, message)

    def getConnected(self):
        with self._clientConnectedLock:
            return self._clientConnected