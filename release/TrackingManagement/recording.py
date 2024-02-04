import TrackingManagement.body
import threading
import time
import copy

# Zuständig ausschließlich für die Aufnahme von Daten aus bodyThread
class RecorderThread(threading.Thread):
    recording = False
    bodyThread = None
    captureRate = 10
    captureSmoothed = False
    record = []

    def run(self) -> None:
        while(self.recording):
            self.record.append([time.time(), copy.deepcopy(self.bodyThread.getSmoothedBody()) if self.captureSmoothed else copy.deepcopy(self.bodyThread.getRawBody())])
            time.sleep(1 / self.captureRate)
