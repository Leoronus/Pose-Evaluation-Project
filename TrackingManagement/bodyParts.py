class InitMark:
    x = 0.0
    y = 0.0
    z = 0.0


class Arm:
    landmarks = {
        "shoulder"  : InitMark(),
        "elbow"     : InitMark(),
        "wrist"     : InitMark(),
        "pinkie"    : InitMark(),
        "index"     : InitMark(),
        "thumb"     : InitMark()
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
        "hip"       : InitMark(),
        "knee"      : InitMark(),
        "ankle"     : InitMark(),
        "heel"      : InitMark(),
        "toes"      : InitMark()
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
        "nose"      : InitMark(),
        "eyeL"      : InitMark(),
        "eyeR"      : InitMark(),
        "mouthL"    : InitMark(),
        "mouthR"    : InitMark()
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
        "shoulderL" : InitMark(),
        "shoulderR" : InitMark(),
        "hipL"      : InitMark(),
        "hipR"      : InitMark()
    }
    '''Access like "landmarks["choice"]". Choices are shoulderL, shoulderR, hipL, hipR.'''

    def update(self, newMarks):
        self.landmarks["shoulderL"] = newMarks[0]  
        self.landmarks["shoulderR"] = newMarks[2]  
        self.landmarks["hipL"     ] = newMarks[5]  
        self.landmarks["hipR"     ] = newMarks[9]


class MainBody:
    landmarks = None
    leftArm = Arm()
    rightArm = Arm()
    leftLeg = Leg()
    rightLeg = Leg()
    torso = Torso()
    head = Head()

    def updateLandmarks(self, mediapipeResults):
        if (mediapipeResults.pose_world_landmarks != None):
            self.landmarks = mediapipeResults.pose_world_landmarks.landmark
            self.leftArm.update(self.landmarks, 'L')
            self.rightArm.update(self.landmarks, 'R')
            self.leftLeg.update(self.landmarks, 'L')
            self.rightLeg.update(self.landmarks, 'R')
            self.torso.update(self.landmarks)
            self.head.update(self.landmarks)