import TrackingManagement.body
import threading
import time

# Zuständig ausschließlich für die Aufnahme von Daten aus bodyThread
class RecorderThread(threading.Thread):
    recording = False
    bodyThread = None
    captureRate = 10
    captureSmoothed = True
    record = []

    def run(self) -> None:
        while(self.recording):
            self.record.append([time.time(), self.bodyThread.getSmoothedBody()])
            time.sleep(1 / self.captureRate)
