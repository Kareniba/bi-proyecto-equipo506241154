# bi-proyecto-equipo506241154

Proyecto final de Business Intelligence · Entrega 1 (estrategia y diagnóstico).
Docente: Leandro Pájaro Fuentes.

## Caso

Solución de BI para la Secretaría Distrital de Movilidad (SDM) de Bogotá D.C.: analizar la siniestralidad vial (2018–2020) en relación con la red semafórica y el parque automotor registrado en el RUNT, para priorizar intersecciones y puntos críticos.

## Integrantes

| Integrante | Código |
| --- | --- |
| Alvarado Arias Kerly Mariangel | 506241154 |
| Ibañez Cala Karen Daniela | 506241701 |
| Moreno Roque Mari Liceth | 506241712 |

## Fuentes de datos

| Fuente | Contenido | Registros |
| --- | --- | --- |
| F1 | Siniestros viales de Bogotá (datos abiertos) | 88.804 |
| F2 | Red semafórica de Bogotá (datos abiertos) | 106 |
| F3 | Vehículos eléctricos e híbridos (RUNT) | 1.493 |

URL, fecha y pasos de descarga: [`datos/descarga.md`](datos/descarga.md).

## Herramientas (según la arquitectura de la Entrega 1)

Python (Pandas), PostgreSQL como Data Warehouse dimensional y Power BI para el dashboard. Las herramientas de integración (ETL) se detallan en [`etl/README.md`](etl/README.md).

## Estructura del repositorio

```
docs/entregas/      PDF (y Word) de cada entrega
docs/diagramas/     arquitectura y esquema dimensional (PNG + draw.io)
datos/raw/          fuentes originales
datos/muestras/     20 filas por fuente, en CSV
datos/diccionarios/ un diccionario por fuente
datos/descarga.md   URL, fecha y pasos para obtener cada fuente
dw/ddl/             scripts CREATE TABLE de dimensiones y hechos
dw/conciliacion/    consultas de conteo y totales por fuente
etl/                transformaciones, trabajos y orden de ejecución
dashboard/          archivo .pbix o enlace publicado, y capturas
modelo/             notebooks del modelo predictivo
```

## Cómo reproducir

1. Clonar el repositorio.
2. Descargar las tres fuentes siguiendo `datos/descarga.md` y guardarlas en `datos/raw/`.
3. Revisar el modelo dimensional en `docs/diagramas/esquema_dimensional.png` (editable: `esquema_dimensional.drawio`).
4. Las etapas de DW, ETL, dashboard y modelo se agregan en las Entregas 2 y 3.
