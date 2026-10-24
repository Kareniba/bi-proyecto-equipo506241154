# Descarga de las fuentes

Fecha de descarga: 15/10/2026. Guardar cada archivo en `datos/raw/` con el nombre indicado.

| Fuente | Procedencia | Registros | Periodo | Licencia | Archivo en `datos/raw/` |
| --- | --- | --- | --- | --- | --- |
| F1 · Siniestros viales | https://datosabiertos.bogota.gov.co/dataset/historico-siniestros-viales-bogota-d-c | 50.000 | 2018–2020 | Abierta (CC BY 4.0) | `siniestross_bogota_2018_2020.json` |
| F2 · Red semafórica | https://datosabiertos.bogota.gov.co/dataset/red-semaforica-sdm-bogota-d-c | 106 | 2018–2020 | Abierta (CC BY 4.0) | `Red_Semaforica_2018_2020.csv` |
| F3 · Vehículos RUNT | https://www.runt.gov.co | 1.493 | 2018–2020 | Pública institucional | `runt_electricos_hibridoss_2018_2020.xlsx` |

## Pasos

1. Abrir el enlace de la fuente.
2. Descargar el recurso en formato CSV.
3. Renombrarlo como se indica en la última columna y copiarlo a `datos/raw/`.
4. Verificar que el número de filas coincide con la columna «Registros».

Los diccionarios de cada fuente están en `datos/diccionarios/`.
