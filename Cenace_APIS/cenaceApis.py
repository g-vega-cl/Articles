import pandas as pd
import os
os.chdir("C:/Users/tu_usuario/La_carpeta_donde_quieres_descargar_el_archivo")

Sistema = "SIN"
Mercado = "MDA"
Nodo = "06MTY-115"
anio = "2020"
mes = "08" ## Tiene que tener dos digitos, zero antes del número si es menor a 10.
dia = "30"
anio_final = "2020"
mes_final = "09" 
dia_final = "04"


url = "https://ws01.cenace.gob.mx:8082/SWPML/SIM/{}/{}/{}/{}/{}/{}/{}/{}/{}/JSON".format(Sistema,Mercado,Nodo,anio,mes,dia,anio_final,mes_final,dia_final)

url = "https://ws01.cenace.gob.mx:8082/SWPML/SIM/SIN/MDA/06MTY-115/2020/08/30/2020/09/04/JSON"

datos = pd.read_json(url) #Leer los datos de CENACE
datos = datos["Resultados"][0]["Valores"] # Tomar los valores de los resultados
tabla_de_datos = pd.DataFrame(datos) # Pasar los valores a una tabla
tabla_de_datos.to_csv("tabla_de_datos.csv",index = False) #Descargar los datos a un csv

