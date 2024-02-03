import ScoringManagement.owas as owas

def LongTimeEval(data) -> str:
    '''Nimmt ein Array von Unix-Timestamps und MainBody-Objekten entgegen und gibt einen
    String mit der für das GUI vorbereiteten Nachricht mit den Ergebnissen der Langzeitanalyse zurück.'''
    #Erstelle neues Array welches an owas_risk_frequenzy übergeben wird
    #Durchlaufe gegebenes Array, rufe für jeden eintrag owas_posture_code auf
    #wenn ergebnis vom typ List, schreibe in erstelltes array (posture code gibt einen String mit einer Fehlermeldung heraus wenn es abbricht)

    #wenn Array länger als 0, rufe owas_risk_frequenzy mit diesem auf
    #wenn Länge = 0 gebe eine Fehlermeldung aus

    #Wandel das ergebnis in die zu übermittelnde nachricht um

    posture_codes = []
    n = 0

    while(n < len(data)):
        a = owas.owas_posture_code(data[n][1])
        if(isinstance(a,list)):
          posture_codes.append(a)
        n += 1

    if(len(posture_codes) < 1):
        return "Error|Error_msg: Keines der Aufgezeichneten Positionen konnte Ausgewertet werden."
        #Breche ab, da von den übergebenen Frames keines Ausgewertet werden konnte

    ergebnis = owas.owas_risk_frequenzy(posture_codes)

    # positions = [["Rücken ist gerade", "Rücken ist gebeugt", "Rücken ist gedreht oder zur Seite gebeugt", "Rücken ist gebeugt und gedreht oder gebeugt und zur Seite gebeugt"],
    #              ["beide Arme unter Schulterhöhe", "ein Arm auf oder über Schulterhöhe", "beide Arme auf oder über Schulterhöhe"],
    #              ["Sitzen, Beine unter Gesäßhöhe", "Stehen, Beine gerade", "Stehen auf einem Bein, gerade", "Stehen auf beiden Beinen, gebeugt", "Stehen auf einem Bein, gebeugt", "Knien, auf einem Knie oder beiden Knien", "Gehen oder sich weiterbewegen"]]
    positions = [["Back is straight", "Back is bent", "Back is twisted or bent to the side", "Back is bent and twisted or bent in multiple directions"],
             ["Both arms under shoulder height", "One arm at or above shoulder height", "Both arms at or above shoulder height"],
             ["Sitting, legs below rear", "Standing, legs straight", "Standing straight on one leg", "Standing on both legs, bent", "Standing on one leg, bent", "Kneeling on one or both legs", "Walking or moving"]]

    action = ["No measures necessary", "Measures to be taken soon", "Measures to be taken as soon as possible", "Measures to be taken urgently"]
    #Ausgabe Nachricht, erste Variante gibt die entsprechenend Codes zurück, Variante 2 gibt die dazugehörige variant zurück
    '''
    msg = "Langzeit|back_Position: " + str(ergebnis[0][0]) + "\nback_Action: " + str(ergebnis[0][1]) + \
          "\narms_Position: " + str(ergebnis[1][0]) + "\narms_Action: " + str(ergebnis[1][1]) + \
          "\nlegs_Position: " + str(ergebnis[2][0]) + "\nlegs_Action: " + str(ergebnis[2][1]) '''
    msg = "Langzeit|back_Position: " + positions[0][ergebnis[0][0]-1] + "\nback_Action: " + action[ergebnis[0][1]-1] + \
          "\narms_Position: " + positions[1][ergebnis[1][0]-1] + "\narms_Action: " + action[ergebnis[1][1]-1] +\
          "\nlegs_Position: " + positions[2][ergebnis[2][0]-1] + "\nlegs_Action : " + action[ergebnis[2][1]-1] +\
          "\nlegs_Position: " + positions[2][ergebnis[2][0]-1] + "\nlegs_Action: " + action[ergebnis[2][1]-1]

    return msg
