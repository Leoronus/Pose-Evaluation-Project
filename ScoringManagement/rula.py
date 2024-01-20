from TrackingManagement.bodyParts import MainBody
from ScoringManagement.winkel import winkel

def rula_score(Body,gewicht = 1,statisch = False):
 '''Berechnet den Rula-Score vom übergebenen Body, gibt 2 Werte zurück: mit Linkem Arm und mit Rechtem Arm
 gewicht -> aufzubringende Körperkraft oder zu hebendes Gewicht
 statisch -> wird Körperhaltung länger als 1 Minute gehalten oder mehr als 4 mal die minute eingenommen'''

 #Nicht Implementiert: Berechnung Winkel der Hand; Berechnung Drehung des Arms
 #Verbesserungs möglichkeiten: Interpretation von Arm und Nacken hinter dem Körper (annahme das der Beobachtete immer zur kammera schaut ist nicht gut)

 def_vis = 0.5 #Gibt an welchen Visibility Score ein Punkt mindestens erreichen muss um in die Berechnungen mit einbezogen zu werden. In dem Falle das Punkte nicht erkann werden wird für diese Berechnung entweder ein Score von 1 erteilt, oder die funktion wird beendet und gibt eine Fehlermeldung Per String rückgebe aus
 #Arm (Links und Rechts unterschiedlich)
 #Koordinaten bestimmung
 huefteL = True if(Body.torso.landmarks["hipL"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 huefteL_X = Body.torso.landmarks["hipL"].x
 huefteL_Y = Body.torso.landmarks["hipL"].y
 huefteL_Z = Body.torso.landmarks["hipL"].z

 huefteR = True if(Body.torso.landmarks["hipR"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 huefteR_X = Body.torso.landmarks["hipR"].x
 huefteR_Y = Body.torso.landmarks["hipR"].y
 huefteR_Z = Body.torso.landmarks["hipR"].z

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

 schulterL= True if(Body.leftArm.landmarks["shoulder"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 schulterL_X = Body.leftArm.landmarks["shoulder"].x
 schulterL_Y = Body.leftArm.landmarks["shoulder"].y
 schulterL_Z = Body.leftArm.landmarks["shoulder"].z

 schulterR = True if(Body.rightArm.landmarks["shoulder"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 schulterR_X = Body.rightArm.landmarks["shoulder"].x
 schulterR_Y = Body.rightArm.landmarks["shoulder"].y
 schulterR_Z = Body.rightArm.landmarks["shoulder"].z

 elbogenL = True if(Body.leftArm.landmarks["elbow"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 elbogenL_X = Body.leftArm.landmarks["elbow"].x
 elbogenL_Y = Body.leftArm.landmarks["elbow"].y
 elbogenL_Z = Body.leftArm.landmarks["elbow"].z

 elbogenR = True if(Body.rightArm.landmarks["elbow"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 elbogenR_X = Body.rightArm.landmarks["elbow"].x
 elbogenR_Y = Body.rightArm.landmarks["elbow"].y
 elbogenR_Z = Body.rightArm.landmarks["elbow"].z

 handgelenkL = True if(Body.leftArm.landmarks["wrist"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 handgelenkL_X = Body.leftArm.landmarks["wrist"].x
 handgelenkL_Y = Body.leftArm.landmarks["wrist"].y
 handgelenkL_Z = Body.leftArm.landmarks["wrist"].z
 
 handgelenkR = True if(Body.rightArm.landmarks["wrist"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 handgelenkR_X = Body.rightArm.landmarks["wrist"].x
 handgelenkR_Y = Body.rightArm.landmarks["wrist"].y
 handgelenkR_Z = Body.rightArm.landmarks["wrist"].z

 zeigefingerR = True if(Body.rightArm.landmarks["index"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 zeigefingerR_X = Body.rightArm.landmarks["index"].x
 zeigefingerR_Y = Body.rightArm.landmarks["index"].y
 zeigefingerR_Z = Body.rightArm.landmarks["index"].z

 zeigefingerL = True if(Body.leftArm.landmarks["index"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 zeigefingerL_X = Body.leftArm.landmarks["index"].x
 zeigefingerL_Y = Body.leftArm.landmarks["index"].y
 zeigefingerL_Z = Body.leftArm.landmarks["index"].z

 daumenR= True if(Body.rightArm.landmarks["thumb"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 daumenR_X = Body.rightArm.landmarks["thumb"].x
 daumenR_Y = Body.rightArm.landmarks["thumb"].y
 daumenR_Z = Body.rightArm.landmarks["thumb"].z

 daumenL = True if(Body.leftArm.landmarks["thumb"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 daumenL_X = Body.leftArm.landmarks["thumb"].x
 daumenL_Y = Body.leftArm.landmarks["thumb"].y
 daumenL_Z = Body.leftArm.landmarks["thumb"].z

 nase = True if(Body.head.landmarks["nose"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 nase_X = Body.head.landmarks["nose"].x
 nase_Y = Body.head.landmarks["nose"].y
 nase_Z = Body.head.landmarks["nose"].z
 
 augeR = True if(Body.head.landmarks["eyeR"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 augeR_X = Body.head.landmarks["eyeR"].x
 augeR_Y = Body.head.landmarks["eyeR"].y
 augeR_Z = Body.head.landmarks["eyeR"].z

 augeL = True if(Body.head.landmarks["eyeL"].visibility > def_vis) else False #Prüfwert ob der Punkt als sichtbar angesehen wird.
 augeL_X = Body.head.landmarks["eyeL"].x
 augeL_Y = Body.head.landmarks["eyeL"].y
 augeL_Z = Body.head.landmarks["eyeL"].z
 #OberArm
  #Winkelbestimmung
  #Addieren
 if(not(elbogenR)): oberarm_wertR = 1
 else:
  oberarmR = winkel([elbogenR_X,elbogenR_Y,elbogenR_Z],[schulterR_X,schulterR_Y,schulterR_Z],[huefteR_X,huefteR_Y,huefteR_Z])
  #Bewertung Rechter Arm
  oberarm_wertR = 1
  if(oberarmR < 20):
   oberarm_wertR = 1
  elif(oberarmR > 20 and elbogenR_Z > huefteR_Z): #Arm ist nach hinten gestreckt
   oberarm_wertR = 2
  elif(oberarmR > 20 and oberarmR < 45) :
   oberarm_wertR = 2
  elif(oberarmR >= 45 and oberarmR < 90):
   oberarm_wertR = 3
  elif(oberarmR > 90):
   oberarm_wertR = 4


 if(not(elbogenL)):oberarm_wertL = 1
 else: 
  oberarmL = winkel([elbogenL_X,elbogenL_Y,elbogenL_Z],[schulterL_X,schulterL_Y,schulterL_Z],[huefteL_X,huefteL_Y,huefteL_Z])
  #Bewertung Linker Arm
  oberarm_wertL = 1
  if(oberarmL < 20):
   oberarm_wertL = 1
  elif(oberarmL > 20 and elbogenL_Z > huefteL_Z): #Arm ist nach hinten gestreckt
   oberarm_wertL = 2
  elif(oberarmL > 20 and oberarmL < 45) :
   oberarm_wertL = 2
  elif(oberarmL >= 45 and oberarmL < 90):
   oberarm_wertL = 3
  elif(oberarmL > 90):
   oberarm_wertL = 4

 #UnterArm
 if(not(handgelenkR) or not(elbogenR)): unterarm_wertR = 1
 else:
  #Winkelbestimmung
  unterarmR = winkel([handgelenkR_X,handgelenkR_Y,handgelenkR_Z],[elbogenR_X,elbogenR_Y,elbogenR_Z],[schulterR_X,schulterR_Y,schulterR_Z])
 
  #bewertung der abweichung von 180 Grad
  unterarm_wertR = 1
  if((180-unterarmR) < 60) :
   unterarm_wertR = 2
  elif(((180- unterarmR) >= 60) and ((180- unterarmR) <100)):
   unterarm_wertR = 1
  elif((180- unterarmR) >= 100) :
   unterarm_wertR =2

 if(not(handgelenkL) or not(elbogenL)): unterarm_wertL = 1
 else:
  unterarmL = winkel([handgelenkL_X,handgelenkL_Y,handgelenkL_Z],[elbogenL_X,elbogenL_Y,elbogenL_Z],[schulterL_X,schulterL_Y,schulterL_Z])
  unterarm_wertL = 1
  if((180-unterarmL) < 60) :
   unterarm_wertL = 2
  elif(((180- unterarmL) >= 60) and ((180- unterarmL) <100)):
   unterarm_wertL = 1
  elif((180- unterarmL) >= 100) :
   unterarm_wertL =2

 #Torsion vom unterarm berechznet mit handgelenk, elbogen, hüfte (2a auf rula sheet)
 #10 Grad Fehlertoleranz
 if(handgelenkL and elbogenL):
   unterarmL_torsion = winkel([handgelenkL_X,handgelenkL_Y,handgelenkL_Z],[elbogenL_X,elbogenL_Y,elbogenL_Z],[huefteL_X,huefteL_Y,huefteL_Z])
   if(unterarmL_torsion <80 or unterarmL_torsion > 100):
    unterarm_wertL = unterarm_wertL + 1

 if(handgelenkR and elbogenR):
  unterarmR_torsion = winkel([handgelenkR_X,handgelenkR_Y,handgelenkR_Z],[elbogenR_X,elbogenR_Y,elbogenR_Z],[huefteR_X,huefteR_Y,huefteR_Z])
  if(unterarmR_torsion <80 or unterarmR_torsion > 100):
   unterarm_wertR = unterarm_wertR + 1

 
  
 
 #Handgelenk
  #Winkelbestimmung - Nicht Implementiert
  #Addieren bei seitlicher krümmung
 handgelenk_wertL = 1
 handgelenk_wertR = 1

 #Arm Gedreht - Nicht Implementiert
 armgedreht_wertL = 1
 armgedreht_wertR = 1




 #Oberarm->unterarm->handgelenk->arm gedreht
 haltung_arm = [[[[1,2],[2,2],[2,3],[3,3]],
                 [[2,2],[2,2],[3,3],[3,3]],
                 [[2,3],[3,3],[3,3],[4,4]]],
                [[[2,3],[3,3],[3,4],[4,4]],
                 [[3,3],[3,3],[3,4],[4,4]],
                 [[3,4],[4,4],[4,4],[5,5]]],
                [[[3,3],[4,4],[4,4],[5,5]],
                 [[3,4],[4,4],[4,4],[5,5]],
                 [[4,4],[4,4],[4,5],[5,5]]],
                [[[4,4],[4,4],[4,5],[5,5]],
                 [[4,4],[4,4],[4,5],[5,5]],
                 [[4,4],[4,5],[5,5],[6,6]]],
                [[[5,5],[5,5],[5,6],[6,7]],
                 [[5,6],[6,6],[6,7],[7,7]],
                 [[6,6],[6,7],[7,7],[7,8]]],
                [[[7,7],[7,7],[7,8],[8,9]],
                 [[8,8],[8,8],[8,9],[9,9]],
                 [[9,9],[9,9],[9,9],[9,9]]]]

 armL = haltung_arm[oberarm_wertL-1][unterarm_wertL-1][handgelenk_wertL-1][armgedreht_wertL-1]
 armR = haltung_arm[oberarm_wertR-1][unterarm_wertR-1][handgelenk_wertR-1][armgedreht_wertR-1]

 #Zusätzliche modifiziereung des Arm gesamt wertes ( schritt 10 und 11 auf RULA Arbeitsbogen)
 if statisch :
  armL = armL+1
  armR = armR+1


 if gewicht > 10 :
  armL = armL +3
  armR = armR +3
 elif gewicht >= 2 and statisch:
  armL = armL +2
  armR = armR +2
 elif gewicht >= 2 :
  armL = armL +1
  armR = armR +1

 #Hals-, Oberkörper- und Beinhaltung

 #Hals
  #Bestimmung Winkel
 if(not(nase)):
  hals_wert = 1
  mitte = [(schulterL_X + schulterR_X) /2,(schulterL_Y + schulterR_Y) /2,(schulterL_Z + schulterR_Z) /2]
 else:
  #Es wird davon ausgegangen das die zu beobachtende Person die Kammere ansieht, ansonsten muss hier herausgefunden werden ob der Kopf nach Vorne oder Hinten gebeugt ist
  mitte = [(schulterL_X + schulterR_X) /2,(schulterL_Y + schulterR_Y) /2,(schulterL_Z + schulterR_Z) /2]
  hals = winkel([mitte[0],nase_Y,nase_Z],mitte, [mitte[0],mitte[1]-5,mitte[2]]) #winkel zwischen nase, einem punkt zwischen den schultern und diesem punkt um 5 nach unten verschoben, verwende x Koordinaten des mittelpunkts für die nase um links/rechst beugung auszuschließen
  #Grad als Abweichung von 180 Grad - Bei 0 Grad währe der Winkel des Kopfes 180 Grad
  if((180- hals) < 15) :
   hals_wert = 1
  elif(((180 -hals)>= 15) and ((180- hals) < 25)):
   hals_wert = 2
  elif((180 - hals) >= 25):
   hals_wert = 3

  if(nase_Z > mitte[2] ): #Kopf ist nach hinten gebeugt
   hals_wert = 4
   #Addieren

 #Berechnung eines neuen Hals Winkels für eine Bestimmung eines anderen Winkels
 hals_neigung = winkel([nase_X,nase_Y,nase_Z],mitte,[schulterL_X,schulterL_Y,schulterL_Z])

 if(hals_neigung > 95 or hals < 85):
  hals_wert = hals_wert+1

 #Berechne Drehung des Kopfes
 if(augeR and augeL):
  #Berechne Drehung durch Winkel Zwischen Auge, Punkt Zwischen beiden Augen und Auge mit Z Wert des Anderen Auges
  eyeM = [(augeR_X + augeL_X)/2,(augeR_Y+augeL_Y)/2,(augeR_Z+augeL_Z)/2]
  eye1 = winkel([augeL_X,augeL_Y,augeL_Z],eyeM,[augeL_X,augeL_Y,augeR_Z])
  eye2 = winkel([augeR_X,augeR_Y,augeR_Z],eyeM,[augeR_X,augeR_Y,augeL_Z])

  # 10 Grad als Fehler Tolleranz
  if(eye1 > 10 or eye2 > 10) :
   hals_wert = hals_wert + 1
  
 #Oberkörper, Rechte und Linke bewertung verwenden den Selben Rücken Wert
 if(not(schulterR) and not(schulterL)): return "Schultern nicht erkennbar"
 else:
  #Bestimmung Winkel
  rueckenL = winkel([knieL_X,knieL_Y,knieL_Z],
                 [huefteL_X,huefteL_Y,huefteL_Z],
                 [schulterL_X,schulterL_Y,schulterL_Z])

  rueckenR = winkel([knieR_X,knieR_Y,knieR_Z],
                 [huefteR_X,huefteR_Y,huefteR_Z],
                 [schulterR_X,schulterR_Y,schulterR_Z])
 
 
 #2 Punkte ziwschen 0 und 20 Grad ( 5 grad abweichung hier für ungenauigkeit)
 #nehme kein elif damit temp den höchsten wert bekommt der True ist
 oberkoerper_wert = 1
 if(rueckenL>5 or rueckenR > 5):
  oberkoerper_wert=2
 if ((rueckenL >= 20 and rueckenL < 60 ) or (rueckenR >= 20 and rueckenR < 60)):
  oberkoerper_wert = 3
 if (rueckenL> 60 or rueckenR > 60 ) :
  oberkoerper_wert = 4

 #weitere bedingung bei gedrehtem oberkörper
 mitte = [(huefteL_X + huefteR_X)/2,(huefteL_Y + huefteR_Y)/2, (huefteL_Z + huefteR_Z)/2] #mitte Punkt wischen den Beiden Hüft Punkten, verwendet für die Torsion des Oberkörpers durch den Winkel wzischen Hüfte Mittel und schulter(y wert auf wert der hüfte gesetzt)

 torsion = winkel([huefteL_X,huefteL_Y,huefteL_Z],
                  mitte,
                  [schulterL_X,huefteL_Y,schulterL_Z])

 if(torsion >= 20):
  oberkoerper_wert = oberkoerper_wert + 1

 #Wenn oberkörper zur seite gebeugt ist
 #Seitliche Beugung mittels Neigung Rücken, aber Z der schulter auf Z der Hüfte gesetzt
 beugungL = winkel([knieL_X,knieL_Y,knieL_Z],
                 [huefteL_X,huefteL_Y,huefteL_Z],
                 [schulterL_X,schulterL_Y,huefteL_Z])

 beugungR = winkel([knieR_X,knieR_Y,knieR_Z],
                 [huefteR_X,huefteR_Y,huefteR_Z],
                 [schulterR_X,schulterR_Y,huefteR_Z])
 if (beugungL < 175 or beugungR < 175) :
  oberkoerper_wert = oberkoerper_wert + 1



 #Beine
  #Bestimmen Beine: Belastung beide oder ein Bein
 if(not(fussgelenkL)and not(fussgelenkR)): bein_wert = 1
 else:

  beineL = winkel([huefteL_X,huefteL_Y,huefteL_Z],
                  [knieL_X,knieL_Y,knieL_Z],
                  [fussgelenkL_X,fussgelenkL_Y,fussgelenkL_Z])

  beineR = winkel([huefteR_X,huefteR_Y,huefteR_Z],
                  [knieR_X,knieR_Y,knieR_Z],
                  [fussgelenkR_X,fussgelenkR_Y,fussgelenkR_Z])
  #Winkel der beiden beine ungefähr gleich ( 5 grad abweichung hier gestattet) eventuell keine Prüfung auf 180 grad benötigt wenn es reicht das beide beine ungefähr den selben winkel haben sollen
  if((beineL >= beineR+5 or beineL <= beineR-5) and (beineL >= 170 and beineL <= 190) and (beineR >= 170 and beineR <= 190)) :
   bein_wert = 1
  else :
   bein_wert = 2


 #Hals->Oberkörper->Beine
 haltung_oberkoerper = [[[1,3],[2,3],[3,4],[5,5],[6,6],[7,7]],
                        [[2,3],[2,3],[4,5],[5,5],[6,7],[7,7]],
                        [[3,3],[3,4],[4,5],[5,6],[6,7],[7,7]],
                        [[5,5],[5,6],[6,7],[7,7],[7,7],[8,8]],
                        [[7,7],[7,7],[7,8],[8,8],[8,8],[8,8]],
                        [[8,8],[8,8],[8,8],[8,9],[9,9],[9,9]]]

 oberkoerper = haltung_oberkoerper[hals_wert-1][oberkoerper_wert-1][bein_wert-1]

 #Zusätzliche modifiziereung des Oberkörpers gesamt wertes ( schritt 10 und 11 auf RULA Arbeitsbogen)
 if statisch : oberkoerper = oberkoerper+1

 if gewicht > 10 : oberkoerper = oberkoerper +3
 elif gewicht >= 2 and statisch: oberkoerper = oberkoerper +2
 elif gewicht >= 2 : oberkoerper = oberkoerper +1

 gesamt_wert = [[1,2,3,3,4,5,5],
               [2,2,3,4,4,5,5],
               [3,3,3,4,4,5,6],
               [3,3,3,4,5,6,6],
               [4,4,4,5,6,7,7],
               [4,4,5,6,6,7,7],
               [5,5,6,6,7,7,7],
               [5,5,6,7,7,7,7]]

 #Bei Werten über 8 bei armen und 7 bei Oberkörper, kommt das gleiche ergebnis haus wie wenn diese jeweils 8 und 7 sind
 if armL > 8: armL = 8
 if armR > 8: armR = 8
 if oberkoerper > 7: oberkoerper = 7

 scoreL = gesamt_wert[armL-1][oberkoerper-1]
 scoreR = gesamt_wert[armR-1][oberkoerper-1]


 return scoreL , scoreR #gibt einen Wert zwischen 1 und 7 zurück, Erster Wert ist Linke seite, zweiter wert ist Rechte seite

def getRulaMessage(body: MainBody):
  '''Baut eine Nachricht mit RULA-Ergebnissen des übergebenen MainBody-Objektes, welche der Parser des GUI versteht, und gibt sie zurück.'''
  scoreL = 0
  scoreR = 0
  if (len(body.landmarks) != 0):
    scoreL, scoreR = rula_score(body)
  msg = "RULA|left: " + str(scoreL) + "\nright: " + str(scoreR)
  return msg
