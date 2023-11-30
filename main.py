import TrackingManagement
from TrackingManagement.body import BodyThread
import time
import struct
import TrackingManagement.tracking_vars
from sys import exit
from TrackingManagement.bodyParts import MainBody


mainBody = MainBody()
bodyThread = BodyThread()
bodyThread.start()

'''while True:
    print("Nose position x: ", bodyThread.getRawBody().head.landmarks["nose"].x)
    smoothed = bodyThread.getSmoothedBody()
    if (smoothed != None): print("Nose position x (smoothed): ", smoothed.head.landmarks["nose"].x)
    time.sleep(2)'''
time.sleep(15)
bodyThread.StartRecording(10, True)
print("recording...")
time.sleep(5)
record = bodyThread.StopRecording()
print (len(record))

i = input()
print("Exiting…")        
TrackingManagement.tracking_vars.KILL_THREADS = True
time.sleep(0.5)
exit()