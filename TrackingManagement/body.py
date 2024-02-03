import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import vision
import cv2
import threading
import time
import TrackingManagement.tracking_vars
from TrackingManagement.bodyParts import MainBody
from TrackingManagement.recording import RecorderThread



# Thread für Videoaufnahme
class CaptureThread(threading.Thread):
    cap = None
    ret = None
    frame = None
    isRunning = False
    counter = 0
    timer = 0.0

    def run(self):
        self.cap = cv2.VideoCapture(0)
        if (TrackingManagement.tracking_vars.USE_CUSTOM_CAM_SETTINGS):
            self.cap.set(cv2.CAP_PROP_FPS, TrackingManagement.tracking_vars.FPS)
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, TrackingManagement.tracking_vars.WIDTH)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, TrackingManagement.tracking_vars.HEIGHT)

        time.sleep(1)

        print("Opened capture at %i fps" % self.cap.get(cv2.CAP_PROP_FPS))
        while (not TrackingManagement.tracking_vars.KILL_THREADS):
            self.ret, self.frame = self.cap.read()
            self.isRunning = True
            if (TrackingManagement.tracking_vars.DEBUG):
                self.timer += 1
                if (time.time() - self.timer >= 5):
                    print("capture fps: ", self.counter / (time.time() - self.timer))
                    self.counter = 0
                    self.timer = time.time()


# Thread für Mediapipe, weitgehend implementiert nach https://github.com/ganeshsar/UnityPythonMediaPipeBodyPose
class BodyThread(threading.Thread):
    __timeSinceStats = 0
    __recorder = RecorderThread()

    # Objekt, in dem die Daten aus Mediapipe gespeichert werden
    mainBody = MainBody()
    
    def run(self):
        mpDrawing = mp.solutions.drawing_utils
        mpPose = mp.solutions.pose
        capture = CaptureThread()
        capture.start()

        with mpPose.Pose(min_detection_confidence=0.8, min_tracking_confidence=0.5, model_complexity = TrackingManagement.tracking_vars.MODEL_COMPLEXITY,static_image_mode = False,enable_segmentation = True) as pose:
            while (not TrackingManagement.tracking_vars.KILL_THREADS and capture.isRunning == False):
                print("Waiting for camera and capture thread.")
                time.sleep(0.5)
            print("Beginning capture")

            while (not TrackingManagement.tracking_vars.KILL_THREADS and capture.cap.isOpened()):
                ti = time.time()
                image = capture.frame
                image = cv2.flip(image, 1)
                image.flags.writeable = TrackingManagement.tracking_vars.DEBUG

                results = pose.process(image)
                tf = time.time()

                if (TrackingManagement.tracking_vars.DEBUG):
                    if (time.time() - self.__timeSinceStats >= 1):
                        print("Theoretical Maximum FPS: %f"%(1/(tf-ti)))
                        self.timeSincePostStatistics = time.time()
                        
                    if results.pose_landmarks:
                        mpDrawing.draw_landmarks(image, results.pose_landmarks, mpPose.POSE_CONNECTIONS, 
                                                mpDrawing.DrawingSpec(color=(255, 100, 0), thickness=2, circle_radius=4),
                                                mpDrawing.DrawingSpec(color=(255, 255, 255), thickness=2, circle_radius=2),
                                                )
                    cv2.imshow('Body Tracking', image)
                    cv2.waitKey(3)
                
                if (results != None):
                    self.mainBody.updateLandmarks(results)
                    if (TrackingManagement.tracking_vars.DEBUG):
                        print("Nose position: ", self.mainBody.head.landmarks["nose"].x)

    def getRawBody(self):
        '''Gibt das MainBody-Objekt ohne Smoothing zurück.''' # Methodenkommentare anders notiert für Tooltips, weil Python eine tolle Sprache ist
        if (self.mainBody != None):
            return self.mainBody
        
    def getSmoothedBody(self): # KAPUTT
        '''Gibt ein Mainbody-Objekt mit Smoothing zurück (Koordinaten gemittelt über X Schritte). Smoothing-Stärke kann in tracking_vars.py angepasst werden.'''
        if (self.mainBody != None):
            return self.mainBody.getSmoothed()
        
    def StartRecording(self, captureRate: int, smoothed: bool):
        '''Startet eine Aufnahme der Mediapipe-Daten.'''
        self.__recorder.recording = True
        self.__recorder.bodyThread = self
        self.__recorder.captureRate = captureRate
        self.__recorder.captureSmoothed = smoothed
        self.__recorder.start()

    def StopRecording(self):
        '''Beendet die Aufnahme und gibt Aufnahmeergebnis zurück als 2D-Array im Format [[timeStamp: float, body: MainBody], [...]]'''
        self.__recorder.recording = False
        record = self.__recorder.record
        return record
        
    def getBodyMessage(self, body: MainBody):
        '''Baut eine Nachricht aus Landmark-Daten des übergebenen MainBody-Objektes, welche der Parser des GUI versteht, und gibt sie zurück.'''
        msg = "Body"
        if (len(body.landmarks) != 0):
            for node in body.landmarks:
                msg += "|" + str(node)
        return msg