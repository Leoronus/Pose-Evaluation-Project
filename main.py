import TrackingManagement
from TrackingManagement.body import BodyThread
import time
import struct
import TrackingManagement.tracking_vars
from sys import exit
from TrackingManagement.bodyParts import MainBody


mainBody = MainBody()
thread = BodyThread()
thread.start()

while True:
    print("Nose position x: ", BodyThread.mainBody.head.landmarks["nose"].x)
    time.sleep(5)

i = input()
print("Exiting…")        
TrackingManagement.tracking_vars.KILL_THREADS = True
time.sleep(0.5)
exit()