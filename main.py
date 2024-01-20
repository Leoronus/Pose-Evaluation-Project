import TrackingManagement
from TrackingManagement.body import BodyThread
import time
import struct
import TrackingManagement.tracking_vars
from sys import exit
from TrackingManagement.bodyParts import MainBody
import websocketServer
import ScoringManagement.rula as RULA
import ScoringManagement.owas as OWAS



# Objekt für die Daten, die mediapipe liefert
mainBody = MainBody()

# Separater Thread, der mediapipe verwaltet
bodyThread = BodyThread()
bodyThread.start()   

# Separater Thread für Kommunikation mit GUI
serverThread = websocketServer.WebsocketServerThread()
serverThread.start()
socketConnected = False


# Auf GUI-Verbindung warten
while not socketConnected:
    socketConnected = serverThread.getConnected()
    print("connecting")
    time.sleep(1)

while True:
    # Daten an GUI senden
    mainBody = bodyThread.getSmoothedBody()
    if (mainBody != None):
        # Alle Daten werden nach dem Format "<Tag: String>|<Datensatz1>|<Datensatz2>|[...]" versendet.
        # Der Parser des GUI entscheidet die Verarbeitung einer Nachricht anhand des Tags.
        # Datensätze können einen oder mehrere Einträge enthalten.
        # Datensätze folgen dem Format "<Eintrag1>\n<Eintrag2>\n[...]".
        # Ein Eintrag enthält eine Bezeichnung und einen Wert nach dem Format "<Bezeichnung: String>: <Wert: any>".
        serverThread.sendThis(bodyThread.getBodyMessage(mainBody))
        serverThread.sendThis(RULA.getRulaMessage(mainBody))
        serverThread.sendThis(OWAS.GetOwasMessage(mainBody))

    # Datenübertragung auf 30Hz begrenzt
    time.sleep(0.0333)                                              
