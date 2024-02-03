import owas

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

    positions = [["Rücken ist gerade", "Rücken ist gebeugt", "Rücken ist gedreht oder zur Seite gebeugt", "Rücken ist gebeugt und gedreht oder gebeugt und zur Seite gebeugt"],
                 ["beide Arme unter Schulterhöhe", "ein Arm auf oder über Schulterhöhe", "beide Arme auf oder über Schulterhöhe"],
                 ["Sitzen, Beine unter Gesäßhöhe", "Stehen, Beine gerade", "Stehen auf einem Bein, gerade", "Stehen auf beiden Beinen, gebeugt", "Stehen auf einem Bein, gebeugt", "Knien, auf einem Knie oder beiden Knien", "Gehen oder sich weiterbewegen"]]

    action = ["Keine Maßnahmen erforderlich", "Maßnahmen sollten in naher Zukunft ergriffen werden", "Maßnahmen sollten so schnell wie möglich ergriffen werden", "Maßnahmen sollten sofort ergriffen werden"]
    #Ausgabe Nachricht, erste Variante gibt die entsprechenend Codes zurück, Variante 2 gibt die dazugehörige variant zurück
    '''
    msg = "Langzeit|back_Position: " + str(ergebnis[0][0]) + "\nback_Action: " + str(ergebnis[0][1]) + \
          "\narms_Position: " + str(ergebnis[1][0]) + "\narms_Action: " + str(ergebnis[1][1]) + \
          "\nlegs_Position: " + str(ergebnis[2][0]) + "\nlegs_Action :" + str(ergebnis[2][1]) '''
    msg = "Langzeit|back_Position: " + positions[0][ergebnis[0][0]-1] + "\nback_Action: " + action[ergebnis[0][1]-1] + \
          "\narms_Position: " + positions[1][ergebnis[1][0]-1] + "\narms_Action: " + action[ergebnis[1][1]-1] +\
          "\nlegs_Position: " + positions[2][ergebnis[2][0]-1] + "\nlegs_Action : " + action[ergebnis[2][1]-1]
    return msg
