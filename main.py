from body import BodyThread
import time
import struct
import global_vars
from sys import exit
from bodyParts import MainBody


mainBody = MainBody()
thread = BodyThread()
thread.start()

while True:
    print("Nose position x: ", BodyThread.mainBody.head.landmarks["nose"].x)
    time.sleep(5)

i = input()
print("Exiting…")        
global_vars.KILL_THREADS = True
time.sleep(0.5)
exit()