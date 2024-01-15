import mediapipe as mp
from mediapipe.tasks import python
from mediapipe.tasks.python import components
from mediapipe.tasks.python.components import containers
from mediapipe.tasks.python.components.containers import Landmark
import TrackingManagement.tracking_vars


class Arm:
    landmarks = {
        "shoulder"  : Landmark(),
        "elbow"     : Landmark(),
        "wrist"     : Landmark(),
        "pinkie"    : Landmark(),
        "index"     : Landmark(),
        "thumb"     : Landmark()
    }
    '''Access like "landmarks["choice"]". Choices are shoulder, elbow, wrist, pinkie, index, thumb.'''

    def update(self, newMarks, side):
        self.landmarks["shoulder"]  = newMarks[11] if (side == 'L') else newMarks[12]
        self.landmarks["elbow"   ]  = newMarks[13] if (side == 'L') else newMarks[14]
        self.landmarks["wrist"   ]  = newMarks[15] if (side == 'L') else newMarks[16]
        self.landmarks["pinkie"  ]  = newMarks[17] if (side == 'L') else newMarks[18]
        self.landmarks["index"   ]  = newMarks[19] if (side == 'L') else newMarks[20]
        self.landmarks["thumb"   ]  = newMarks[21] if (side == 'L') else newMarks[22]


class Leg:
    landmarks = {
        "hip"       : Landmark(),
        "knee"      : Landmark(),
        "ankle"     : Landmark(),
        "heel"      : Landmark(),
        "toes"      : Landmark()
    }
    '''Access like "landmarks["choice"]". Choices are hip, knee, ankle, heel, toes.'''

    def update(self, newMarks, side):
        self.landmarks["hip"  ]   = newMarks[23] if (side == 'L') else newMarks[24]
        self.landmarks["knee" ]   = newMarks[25] if (side == 'L') else newMarks[26]
        self.landmarks["ankle"]   = newMarks[27] if (side == 'L') else newMarks[28]
        self.landmarks["heel" ]   = newMarks[29] if (side == 'L') else newMarks[30]
        self.landmarks["toes" ]   = newMarks[31] if (side == 'L') else newMarks[32]


class Head:
    landmarks = {
        "nose"      : Landmark(),
        "eyeL"      : Landmark(),
        "eyeR"      : Landmark(),
        "mouthL"    : Landmark(),
        "mouthR"    : Landmark()
    }
    '''Access like "landmarks["choice"]". Choices are nose, eyeL, eyeR, mouthL, mouthR.'''

    def update(self, newMarks):
        self.landmarks["nose"  ] = newMarks[0]  
        self.landmarks["eyeL"  ] = newMarks[2]  
        self.landmarks["eyeR"  ] = newMarks[5]  
        self.landmarks["mouthL"] = newMarks[9]
        self.landmarks["mouthR"] = newMarks[10]


class Torso:
    landmarks = {
        "shoulderL" : Landmark(),
        "shoulderR" : Landmark(),
        "hipL"      : Landmark(),
        "hipR"      : Landmark()
    }
    '''Access like "landmarks["choice"]". Choices are shoulderL, shoulderR, hipL, hipR.'''

    def update(self, newMarks):
        self.landmarks["shoulderL"] = newMarks[0]  
        self.landmarks["shoulderR"] = newMarks[2]  
        self.landmarks["hipL"     ] = newMarks[5]  
        self.landmarks["hipR"     ] = newMarks[9]


class MainBody:
    landmarks = []
    leftArm = Arm()
    rightArm = Arm()
    leftLeg = Leg()
    rightLeg = Leg()
    torso = Torso()
    head = Head()
    __inited = False

    smoothingSteps = TrackingManagement.tracking_vars.SMOOTHING_STEPS
    __smoothingProgress = 0
    __smoothingArray = []
    __MPResultTemplate = None
    def updateLandmarks(self, mediapipeResults):
        if (mediapipeResults.pose_world_landmarks != None):
            self.__inited = True
            self.__MPResultTemplate = mediapipeResults
            self.landmarks = mediapipeResults.pose_world_landmarks.landmark
            for landmark in self.landmarks:
                landmark.y *= -1
            self.leftArm.update(self.landmarks, 'L')
            self.rightArm.update(self.landmarks, 'R')
            self.leftLeg.update(self.landmarks, 'L')
            self.rightLeg.update(self.landmarks, 'R')
            self.torso.update(self.landmarks)
            self.head.update(self.landmarks)
        
        if (len(self.__smoothingArray) < self.smoothingSteps):
            self.__smoothingArray.append(mediapipeResults)
        else:
            self.__smoothingArray[self.__smoothingProgress % self.smoothingSteps] = mediapipeResults
        self.__smoothingProgress += 1

    def getSmoothed(self):
        if(len(self.__smoothingArray) > 0 and self.__inited):
            smoothed = MainBody
            tempListVal = []
            tempListNr = []
            for i in range(33):
                tempListVal.append(Landmark())
                tempListVal[i].x = 0.0
                tempListVal[i].y = 0.0
                tempListVal[i].z = 0.0
                tempListVal[i].visibility = 0.0
                tempListNr.append(0)
            for item in self.__smoothingArray:
                if (item.pose_world_landmarks != None):
                    landmarks = item.pose_world_landmarks.landmark
                    for index in range(len(landmarks)):
                        if (landmarks[index] != None):
                            tempListNr[index] += 1
                            tempListVal[index].x += landmarks[index].x
                            tempListVal[index].y += landmarks[index].y
                            tempListVal[index].z += landmarks[index].z
                            tempListVal[index].visibility += landmarks[index].visibility

            for index in range(len(tempListNr)):
                tempListVal[index].x = tempListVal[index].x / (tempListNr[index] + 0.0001)
                tempListVal[index].y = tempListVal[index].y / (tempListNr[index] + 0.0001)
                tempListVal[index].z = tempListVal[index].z / (tempListNr[index] + 0.0001)
                tempListVal[index].visibility = tempListVal[index].visibility / (tempListNr[index] + 0.0001)

            if (self.__MPResultTemplate != None and self.__MPResultTemplate.pose_world_landmarks != None):
                result = self.__MPResultTemplate
                for i in range(33):
                    result.pose_world_landmarks.landmark[i].x = tempListVal[i].x
                    result.pose_world_landmarks.landmark[i].y = tempListVal[i].y
                    result.pose_world_landmarks.landmark[i].z = tempListVal[i].z
                    result.pose_world_landmarks.landmark[i].visibility = tempListVal[i].visibility
                smoothed.updateLandmarks(self, result)
            return smoothed