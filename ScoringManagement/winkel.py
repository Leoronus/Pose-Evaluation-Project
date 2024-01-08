import numpy as np

def winkel(P1, P2, P3):
 '''Berechnet den Winkel zwischen den Geraden P1P2 und P3P2, gibt diesen als Winkel aus, Der Ausgegbene Winkel ist immer Positiv
 Punkte als array der größe 3 erwartet'''

 #vektoren berechnen
 vector1 = [P2[0]-P1[0],P2[1]-P1[1],P2[2]-P1[2]];
 vector2 = [P2[0]-P3[0],P2[1]-P3[1],P2[2]-P3[2]];


  #ab hier https://stackoverflow.com/a/61043203

 unit_vector1= vector1 / np.linalg.norm(vector1)
 unit_vector2= vector2 / np.linalg.norm(vector2)

 dot_product = np.dot(unit_vector1, unit_vector2)

 angle = np.arccos(dot_product) #angle in radian

 return angle/(np.pi/180)# umrechen von Bogenmaß nach Winkel
