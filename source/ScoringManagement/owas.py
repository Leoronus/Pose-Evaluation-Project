from TrackingManagement.bodyParts import MainBody
from ScoringManagement.winkel import winkel


def owas_posture_code(Body, weight=1):
    '''Berechnet den Posture Code des übergebenen Bodys anhand der spezifikationen der OWAS Methode, dieser wird verwendet um die Bewertungen mit der OWAS Methode durchzuführen.
    weight = gehobenes Gewicht oder aufgebrauchte Körperkraft, default < 10 kg'''

    def_vis = 0.5   # Gibt an welchen Visibility Score ein Punkt mindestens erreichen muss um in die Berechnungen mit einbezogen zu werden. In dem Falle das Punkte nicht erkann werden wird für diese Berechnung entweder ein Score von 1 erteilt, oder die funktion wird beendet und gibt eine Fehlermeldung Per String rückgebe aus

    posture_code = [0,0,0,0]

    #Koordinaten bestimmung
    knieL = True if(Body.leftLeg.landmarks["knee"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    knieL_X = Body.leftLeg.landmarks["knee"].x
    knieL_Y = Body.leftLeg.landmarks["knee"].y
    knieL_Z = Body.leftLeg.landmarks["knee"].z

    knieR = True if(Body.rightLeg.landmarks["knee"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    knieR_X = Body.rightLeg.landmarks["knee"].x
    knieR_Y = Body.rightLeg.landmarks["knee"].y
    knieR_Z = Body.rightLeg.landmarks["knee"].z

    fussgelenkL = True if(Body.leftLeg.landmarks["ankle"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    fussgelenkL_X = Body.leftLeg.landmarks["ankle"].x
    fussgelenkL_Y = Body.leftLeg.landmarks["ankle"].y
    fussgelenkL_Z = Body.leftLeg.landmarks["ankle"].z

    fussgelenkR = True if(Body.rightLeg.landmarks["ankle"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    fussgelenkR_X = Body.rightLeg.landmarks["ankle"].x
    fussgelenkR_Y = Body.rightLeg.landmarks["ankle"].y
    fussgelenkR_Z = Body.rightLeg.landmarks["ankle"].z

    huefteL = True if(Body.torso.landmarks["hipL"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    huefteL_X = Body.torso.landmarks["hipL"].x
    huefteL_Y = Body.torso.landmarks["hipL"].y
    huefteL_Z = Body.torso.landmarks["hipL"].z

    huefteR = True if(Body.torso.landmarks["hipR"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    huefteR_X = Body.torso.landmarks["hipR"].x
    huefteR_Y = Body.torso.landmarks["hipR"].y
    huefteR_Z = Body.torso.landmarks["hipR"].z

    schulterL = True if(Body.leftArm.landmarks["shoulder"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    schulterL_X = Body.leftArm.landmarks["shoulder"].x
    schulterL_Y = Body.leftArm.landmarks["shoulder"].y
    schulterL_Z = Body.leftArm.landmarks["shoulder"].z

    schulterR = True if(Body.rightArm.landmarks["shoulder"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    schulterR_X = Body.rightArm.landmarks["shoulder"].x
    schulterR_Y = Body.rightArm.landmarks["shoulder"].y
    schulterR_Z = Body.rightArm.landmarks["shoulder"].z

    handgelenkL = True if(Body.leftArm.landmarks["wrist"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    handgelenkL_X = Body.leftArm.landmarks["wrist"].x
    handgelenkL_Y = Body.leftArm.landmarks["wrist"].y
    handgelenkL_Z = Body.leftArm.landmarks["wrist"].z

    handgelenkR = True if(Body.rightArm.landmarks["wrist"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
    handgelenkR_X = Body.rightArm.landmarks["wrist"].x
    handgelenkR_Y = Body.rightArm.landmarks["wrist"].y
    handgelenkR_Z = Body.rightArm.landmarks["wrist"].z


    temp=1
    #Berechne Winkel Rücken
    #Berechnet durch winkel Schulter -> hüfte -> hüfte mit y achse der schulter
    if not schulterR or not schulterL: return "Schultern sind nicht sichtbar"
    elif schulterR and schulterL:
        ruckenL = winkel([schulterL_X,schulterL_Y,schulterL_Z],
                 [huefteL_X,huefteL_Y,huefteL_Z],
                 [huefteL_X,schulterL_Y,huefteL_Z])

        rueckenR = winkel([schulterR_X,schulterR_Y,schulterR_Z],
                 [huefteR_X,huefteR_Y,huefteR_Z],
                 [huefteR_X,schulterR_Y,huefteR_Z])

        if ruckenL >= 80 or rueckenR >= 80:
            temp = 2
        else:
            temp = 1

        mitte = [(huefteL_X + huefteR_X)/2,(huefteL_Y + huefteR_Y)/2, (huefteL_Z + huefteR_Z)/2] #mitte Punkt wischen den Beiden Hüft Punkten, verwendet für die Torsion des Oberkörpers durch den Winkel wzischen Hüfte Mittel und schulter(y wert auf wert der hüfte gesetzt)

        torsion = winkel([huefteL_X,huefteL_Y,huefteL_Z],
                  mitte,
                  [schulterL_X,huefteL_Y,schulterL_Z])

        if torsion >= 120:
            if ruckenL >= 80 or rueckenR >= 80:
                if torsion >= 127:
                    temp = temp + 2
            else:
                temp = temp + 2


    #posture_code[0] = ruckenL
    posture_code[0] = temp  #rücken

    temp = 1
    #Berechne Winkel Arme
    '''
 if(not(handgelenkL) and not(handgelenkR)): temp = 1
 else:
  armeL = winkel([handgelenkL_X,handgelenkL_Y,handgelenkL_Z],
                [schulterL_X,schulterL_Y,schulterL_Z],
                [huefteL_X,huefteL_Y,huefteL_Z])

  armeR = winkel([handgelenkR_X,handgelenkR_Y,handgelenkR_Z],
                [schulterR_X,schulterR_Y,schulterR_Z],
                [huefteR_X,huefteR_Y,huefteR_Z])

  if (armeL >= 90 and armeR >= 90):
   temp = 1
  elif((armeL >= 90 and not(armeR >= 90))or (armeR >= 90 and not(armeL >= 90))):
   temp = 2
  elif( armeL < 90 and armeR < 90):
   temp = 3
'''
    if((handgelenkL_Y>= schulterL_Y) and (handgelenkR_Y>= schulterR_Y)):
        temp = 3
    if((handgelenkL_Y>= schulterL_Y) and (handgelenkR_Y < schulterR_Y)):
        temp = 2
    if((handgelenkL_Y< schulterL_Y) and (handgelenkR_Y>= schulterR_Y)):
        temp = 2
    if((handgelenkL_Y< schulterL_Y) and (handgelenkR_Y< schulterR_Y)):
        temp = 1
    #else: temp = 0

    posture_code[1]= temp#arme

    temp = 0

    #Berechne Winkel Beine
    if False:
        temp = 2 #wert für stehend, Prüfung raus genommen da beine fasst nie zu sehen sind
            #(not(huefteL) or not(huefteR) or not(knieL) or not(knieR) or not(fussgelenkL) or not(fussgelenkR)): temp = 1
    else:
        beineL = winkel([huefteL_X,huefteL_Y,huefteL_Z],
                  [knieL_X,knieL_Y,knieL_Z],
                  [fussgelenkL_X,fussgelenkL_Y,fussgelenkL_Z])

        beineR = winkel([huefteR_X,huefteR_Y,huefteR_Z],
                  [knieR_X,knieR_Y,knieR_Z],
                  [fussgelenkR_X,fussgelenkR_Y,fussgelenkR_Z])

        ruecken = (ruckenL + rueckenR) / 2 #durschnitt der beiden rückenwerte aus vorheriger berechnung

        #Bewertung der Beine
        #Sitzend -> rücken = 90, beine ungefähr 90
        if((beineL >= 70 and beineL <= 100) and (beineR >= 70 and beineR <= 100)):
            temp = 1
        #Stehend -> rücken = 180, beine ungefähr 180
        elif((beineL >= 160 and beineL <= 190) and (beineR >= 160 and beineR <= 190)):
            temp = 2
        #stehen auf 1 bein -> stehend aber nur 1 bein 180 grad ( 1 bein kleinerer oder größerer winkel)
        elif((((beineL >= 160 and beineL <= 190) and not(beineR >= 160 and beineR <= 190)) or (not(beineL >= 160 and beineL <= 190) and (beineR >= 160 and beineR <= 190)))):
            temp = 3
        #squatting -> rücken = >0 < 90 (beide beine ungefähr gleich)
        elif((beineL < 100 and beineL > 20 ) and ( beineR < 100 and beineR > 20)):
            #squatting auf 1 bein -> squatting aber 1 bein größerer oder kleinerer winkel
            if((beineL - beineR)> 10 or (beineR - beineL) > 10):
                temp = 5
            else:
                temp = 4

        #kniehen -> beine > 90
        elif(beineL <= 20 and beineR <= 20):
            temp = 6
        # gehen -> beine ungefähr 180 rücken über 90
        elif((ruecken > 135)and (beineL >= 160 and beineL <= 200) and (beineR >= 160 and beineR <= 200)):
            temp = 7
        else:
            temp = 7 #Höhste zu gebende wert, wenn alle anderen nicht True sind

    posture_code[2] = temp  #beine
    #posture_code[0] = posture_code[2]
    temp = 0
    #Berechne Gewicht
    if weight < 10:
        temp = 1
    if weight >= 10 and weight <=20:
        temp = 2
    if weight > 20:
        temp = 3
    posture_code[3] = temp  #gewicht


    return posture_code  #posture code wird in einem 4 stelligen Array zurückgegeben [1,2,3,4]


def owas_risk_category(posture_code):
    '''Führt den Risk Assesment zum übergebenen Owas Psoture Code durch. Erwartet ein Array mit 4 einträgen'''
    #posture_code - 1 als array position
    back =posture_code[0]-1
    arms =posture_code[1]-1
    legs =posture_code[2]-1
    weight =posture_code[3]-1
    #Back -> Arms -> Legs -> Load
    categorys = [[[[1,1,1],[1,1,1],[1,1,1],[2,2,2],[2,2,2],[1,1,1],[1,1,1]],
               [[1,1,1],[1,1,1],[1,1,1],[2,2,2],[2,2,2],[1,1,1],[1,1,1]],
               [[1,1,1],[1,1,1],[1,1,1],[2,2,3],[2,2,3],[1,1,1],[1,1,2]]],
              [[[2,2,3],[2,2,3],[2,2,3],[3,3,3],[3,3,3],[2,2,2],[2,3,3]],
               [[2,2,3],[2,2,3],[2,3,3],[3,4,4],[3,4,3],[3,3,4],[2,3,4]],
               [[3,3,4],[2,2,3],[3,3,3],[3,4,4],[4,4,4],[4,4,4],[2,3,4]]],
              [[[1,1,1],[1,1,1],[1,1,2],[3,3,3],[4,4,4],[1,1,1],[1,1,1]],
               [[2,2,3],[1,1,1],[1,1,2],[4,4,4],[4,4,4],[3,3,3],[1,1,1]],
               [[2,2,3],[1,1,1],[2,3,3],[4,4,4],[4,4,4],[4,4,4],[1,1,1]]],
              [[[2,3,3],[2,2,3],[2,2,3],[4,4,4],[4,4,4],[4,4,4],[2,3,4]],
               [[3,3,4],[2,3,4],[3,3,4],[4,4,4],[4,4,4],[4,4,4],[2,3,4]],
               [[4,4,4],[2,3,4],[3,3,4],[4,4,4],[4,4,4],[4,4,4],[2,3,4]]]]

    risk_category = categorys[back][arms][legs][weight]

    return risk_category #gibt einen Wert zwischen 1 und 4 zurück


def owas_risk_frequenzy(posture_codes,short = True):
    '''nimmt ein Array von Posture Codes An, Berechnet die relative häufigkeit der Positionen
    Entweder gibt für jedes Körperteil die Position mit der höchsten Frequenz und die dazugehörige risiko Category zurück
    Oder gibt für jedes Körperteil alle risiko Categorien und die häufigkeit ihrer Position zurück'''
    #Posture codes: Back, Arms, Legs, Gewicht ( hier nicht beachtet)
    #posture_code -1 als array position
    #Prozent / 10 -1 als array position
    backs = [[1,1,1,1,1,1,1,1,1,1],
            [1,1,1,2,2,2,2,2,3,3],
            [1,1,2,2,2,3,3,3,3,3],
            [1,2,2,3,3,3,3,4,4,4]]

    arms = [[1,1,1,1,1,1,1,1,1,1],
            [1,1,1,2,2,2,2,2,3,3],
            [1,1,2,2,2,2,2,3,3,3]]

    legs = [[1,1,1,1,1,1,1,1,1,2],
            [1,1,1,1,1,1,1,1,2,2],
            [1,1,1,2,2,2,2,2,3,3],
            [1,2,2,3,3,3,3,4,4,4],
            [1,2,2,3,3,3,3,4,4,4],
            [1,1,2,2,2,3,3,3,3,3],
            [1,1,1,1,1,1,1,1,2,2]]

    #back = posture_codes[0]-1
    #arm = posture_codes[1]-1
    #leg = posture_codes[2]-1

    #für die berechnung der Frequenzy der einzelnen positionen
    fre_back = [0,0,0,0]
    fre_arms = [0,0,0]
    fre_legs = [0,0,0,0,0,0,0]


    i = 0
    while i<len(posture_codes):
        fre_back[posture_codes[i][0]-1] +=1
        fre_arms[posture_codes[i][1]-1] +=1
        fre_legs[posture_codes[i][2]-1] +=1
        i+=1


    #Nun Berechne die Frequenz in anteil * 10, werte von 0 bis 10
    x= 0
    while x < len(fre_back):
        fre_back[x] = (fre_back[x]/len(posture_codes))*10
        x+=1
    x= 0
    while x < len(fre_arms):
        fre_arms[x] = (fre_arms[x]/len(posture_codes))*10
        x+=1
    x= 0
    while x < len(fre_legs):
        fre_legs[x] = (fre_legs[x]/len(posture_codes))*10
        x+=1



    if(not(short)) :
        back = []
        arm = []
        leg = []

        x=0
        while x < len(fre_back):
            if((int(fre_back[x]))==0): #Wenn die Frequenz 0 ist muss dies hier besonders gehandhabt werden da sonst auf eine falsche stelle im array zugegriffen wird
                back.append(backs[x][int(fre_back[x])])
            else:
                back.append(backs[x][int(fre_back[x])-1])

            x+=1
        x=0
        while x < len(fre_arms):
            if((int(fre_arms[x]))==0):#Wenn die Frequenz 0 ist muss dies hier besonders gehandhabt werden da sonst auf eine falsche stelle im array zugegriffen wird
                arm.append(arms[x][int(fre_arms[x])])
            else:
                arm.append(arms[x][int(fre_arms[x])-1])
            x+=1
        x=0
        while x < len(fre_legs):
            if((int(fre_legs[x]))==0):#Wenn die Frequenz 0 ist muss dies hier besonders gehandhabt werden da sonst auf eine falsche stelle im array zugegriffen wird
                leg.append(legs[x][int(fre_legs[x])])
            else:
                leg.append(legs[x][int(fre_legs[x])-1])
            x+=1

        #Return Statement Aufbau:
        #gibt zurück 3 Tuple, in jedem Tuple sind 2 Arrays enthalten, im ersten die bewertung der Haltung im Zweiten die Frequenz der Haltung (Frequenz als Double im Bereich 0 - 10 ; mit 10.0 = 100%)
        return [back,fre_back],[arm,fre_arms],[leg,fre_legs]
    #Verkürzute ausgabe welche nur die ID der Position mit der Höchsten Frequenz als auch die Bewertung dieser Position ausgibt
    elif(short):
        most_back = 0
        most_arms = 0
        most_legs = 0

        #Hole welche Position den größten anteil hat
        x= 1
        while x < len(fre_back):
            if fre_back[x] > fre_back[most_back]:
                most_back = x
            x+=1
        x= 1
        while x < len(fre_arms):
            if fre_arms[x] > fre_arms[most_arms]:
                most_arms = x
            x+=1
        x= 1
        while x < len(fre_legs):
            if fre_legs[x] > fre_legs[most_legs]:
                most_legs = x
            x+=1

        #Return Statement Aufbau:
        #[id Position,Bewertung der Position] x3 (Position die am häufigsten vorkommt)
        return [[most_back+1,backs[most_back][int(fre_back[most_back])-1]],[most_arms+1,arms[most_arms][int(fre_arms[most_arms])-1] ],[most_legs+1,legs[most_legs][int(fre_legs[most_legs])-1]]]
    return "Error:short is not TRUE or FALSE"


def GetOwasMessage(body: MainBody):
    '''Baut eine Nachricht mit OWAS-Ergebnissen des übergebenen MainBody-Objektes, welche der Parser des GUI versteht, und gibt sie zurück.'''
    val = [0,0,0,0]
    if (len(body.landmarks) != 0):
        val = owas_posture_code(body)
    msg = "OWAS|back: " + str(val[0]) + "\narms: " + str(val[1]) + "\nlegs: " + str(val[2]) + "\nweight: " + str(val[3])
    return msg