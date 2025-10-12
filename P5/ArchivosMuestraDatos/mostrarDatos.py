import pandas as pd
import matplotlib.pyplot as plt

csv_100 = pd.read_csv("datos_temp_100.txt", names=["Tiempo", "Temperatura", "Potencia"])
csv_200 = pd.read_csv("datos_temp_200.txt", names=["Tiempo", "Temperatura", "Potencia"])

plt.plot(csv_100["Tiempo"], csv_100["Temperatura"], label="Temperatura = 100", color='blue')
plt.plot(csv_200["Tiempo"], csv_200["Temperatura"], label="Temperatura = 200", color='red')

plt.xlabel("Tiempo (s)")
plt.ylabel("Temperatura (°C)")
plt.title("Comparación de Temperaturas PID (100 vs 200)")

plt.grid(True)
plt.legend()

plt.show()

