# bi-proyecto-equipo506241154

# Proyecto final · Entrega 2: Data warehouse, ETL y tablero, Seguridad vial en Bogotá: siniestralidad y red semafórica

**Asignatura:** Business Intelligence  
**Docente:** Leandro Pájaro Fuentes

## Caso de estudio

Solución de Business Intelligence para la **Secretaría Distrital de Movilidad (SDM) de Bogotá D. C.**, enfocada en analizar la siniestralidad vial durante el periodo 2018–2020 y relacionarla con la infraestructura de la red semafórica y el parque automotor de vehículos eléctricos e híbridos registrado en el RUNT.

El propósito es integrar estas fuentes para facilitar la identificación de zonas e intersecciones críticas, analizar patrones de ocurrencia y gravedad de los siniestros y aportar información para priorizar acciones de seguridad vial, mantenimiento y gestión de la movilidad.

## Integrantes

| Integrante | Código |
| --- | --- |
| Alvarado Arias Kerly Mariangel | 506241154 |
| Ibañez Cala Karen Daniela | 506241701 |
| Moreno Roque Mari Liceth | 506241712 |

## Fuentes de datos

El proyecto trabaja con tres fuentes principales:

| Código | Fuente | Formato disponible en el repositorio | Contenido |
| --- | --- | --- | --- |
| F1 | Siniestros viales de Bogotá | JSON | Registros históricos de siniestros viales del periodo 2018–2020. |
| F2 | Red semafórica de Bogotá | CSV | Inventario de intersecciones y características de la infraestructura semafórica. |
| F3 | Vehículos eléctricos e híbridos (RUNT) | XLSX | Información del parque automotor por características del vehículo y ubicación de registro. |

Los archivos originales se encuentran en `datos/raw/`, las muestras en `datos/muestras/` y los diccionarios de datos en `datos/diccionarios/`.

Las fuentes, sus procedencias y las indicaciones para obtenerlas se documentan en [`datos/descarga.md`](datos/descarga.md).

## Arquitectura y herramientas

La solución implementa un flujo de integración y análisis con los siguientes componentes:

- **Fuentes:** archivos JSON, CSV y XLSX de siniestros, red semafórica y RUNT.
- **ETL:** Pentaho Data Integration (PDI / Spoon), mediante transformaciones `.ktr` y un trabajo de carga `.kjb`.
- **Data Warehouse:** MySQL 8.x o MariaDB 10.x, con el esquema `dw_siniestros`.
- **Tablero:** Power BI Desktop (`dashboard/Tablero_PowerBI_506241154.pbix`), conectado a `dw_siniestros`, con las páginas de las preguntas P0 a P3 y la página de predicciones de siniestros graves.
- **Modelo predictivo (Entrega 3):** cuaderno de Python en `modelo/modelo_siniestros_graves.ipynb`, que entrena dos algoritmos y deja las predicciones en la tabla `pred_siniestros_graves` del data warehouse.

> **Estado del repositorio:** incluye los scripts SQL del Data Warehouse, los archivos de Pentaho (sin contraseñas: la conexión usa variables), el tablero de Power BI en `dashboard/`, y el modelo predictivo de la Entrega 3 en `modelo/`. Los PDF de las entregas están en `docs/entregas/`.

El diagrama general de arquitectura está en [`docs/diagramas/diagrama_arquitectura.drawio.png`](docs/diagramas/diagrama_arquitectura.drawio.png), con su archivo editable `.drawio`. El modelo dimensional se encuentra en [`docs/diagramas/esquema_dimensional.png`](docs/diagramas/esquema_dimensional.png), también con su versión editable.

## Data Warehouse

El repositorio contiene los scripts de creación de la base de datos, dimensiones y tablas de hechos en `dw/ddl/`.

### Modelo dimensional

El esquema `dw_siniestros` contiene las siguientes dimensiones:

- `dim_tiempo`: fecha, día de la semana, mes, trimestre y año.
- `dim_hora`: hora del día y franja horaria.
- `dim_ubicacion`: dirección, localidad, CIV y coordenadas geográficas.
- `dim_tipo_siniestro`: clase y gravedad del siniestro.
- `dim_semaforo`: identificación, ubicación y características de las intersecciones semaforizadas.
- `dim_vehiculo`: clase, carrocería, combustible, municipio y departamento.

También contiene dos tablas de hechos:

- `fact_siniestros`: registra cada siniestro con sus llaves dimensionales y métricas de cantidad, fatalidad, presencia de heridos, daños e índice de gravedad.
- `fact_parque_automotor`: consolida la cantidad de vehículos por año y características del vehículo y municipio de matrícula.

La granularidad de `fact_siniestros` corresponde a un evento individual. La granularidad de `fact_parque_automotor` corresponde a la agrupación por año y combinación de características del vehículo y municipio.

Se contemplan registros especiales con llave `-1` para representar valores desconocidos o sin coincidencia, evitando perder registros durante la integración.

### Scripts SQL

Los scripts están organizados en `dw/ddl/`:

- `01_crear_base.sql`: crea la base de datos `dw_siniestros`.
- `02_dim_tiempo.sql` a `07_dim_vehiculo.sql`: crean las dimensiones.
- `08_fact_siniestros.sql` y `09_fact_parque_automotor.sql`: crean las tablas de hechos.
- `10_desconocido_*.sql` a `13_desconocido_*.sql`: insertan los registros especiales.
- `14_poblar_dim_tiempo.sql`: carga el calendario del periodo 2018–2020.
- `00_reiniciar_tablas.sql`: elimina las tablas para permitir reconstruir el Data Warehouse desde cero.

La consulta [`dw/conciliacion/conciliacion_dimensiones.sql`](dw/conciliacion/conciliacion_dimensiones.sql) permite consultar los registros cargados en las dimensiones.

## ETL

Los procesos ETL se implementan con Pentaho Data Integration. Los archivos se encuentran en `etl/`:

### Transformaciones

En `etl/transformaciones/` están las transformaciones para:

- `dim_hora.ktr`
- `dim_ubicacion.ktr`
- `dim_tipo_siniestro.ktr`
- `dim_semaforo.ktr`
- `dim_vehiculo.ktr`
- `fact_siniestros.ktr`
- `fact_parque_automotor.ktr`

Estas transformaciones leen las fuentes, seleccionan y normalizan campos, eliminan duplicados cuando corresponde, buscan las llaves sustitutas de las dimensiones y cargan las tablas de destino. En el proceso de siniestros se contempla la asociación con la intersección semaforizada más cercana dentro del umbral configurado en la transformación. También se contemplan salidas de registros rechazados cuando no se encuentra una llave de tiempo válida.

### Trabajo de carga

El archivo `etl/trabajos/carga_completa.kjb` coordina la ejecución de los scripts SQL y las transformaciones para realizar la carga completa del Data Warehouse.

La conexión del trabajo utiliza variables de entorno/parámetros de Pentaho:

| Variable | Uso |
| --- | --- |
| `DW_HOST` | Servidor de la base de datos. |
| `DW_PORT` | Puerto de conexión. |
| `DW_DB` | Base de datos. |
| `DW_USER` | Usuario de conexión. |
| `DW_PASSWORD` | Contraseña de conexión. |

La conexión configurada en el trabajo es de tipo MySQL. Se debe contar con el controlador JDBC correspondiente y configurar estas variables antes de ejecutar el proceso.

Para más información sobre el ETL y su ejecución, consulta [`etl/README.md`](etl/README.md).

## Modelo predictivo (Entrega 3)

**Pregunta de negocio:** ¿cuántos siniestros graves (con heridos o fallecidos) habrá en cada localidad el próximo mes, para decidir dónde reforzar control y señalización? Es un problema de regresión; la variable objetivo es `siniestros_graves` por localidad y mes.

**Resultado:** la regresión lineal obtuvo MAE 4,11 y RMSE 5,45 sobre julio–diciembre de 2020, frente a MAE 4,80 y RMSE 6,70 del bosque aleatorio. El criterio de éxito (MAE menor a 5 siniestros graves por localidad y mes) se alcanzó.

| Archivo | Qué contiene |
| --- | --- |
| `modelo/extraccion.sql` | Consulta que extrae del data warehouse una fila por localidad y mes. |
| `modelo/datos_modelo.csv` | Resultado de la consulta (756 filas). |
| `modelo/modelo_siniestros_graves.ipynb` | Exploración, preparación, entrenamiento, evaluación y generación de predicciones. |
| `modelo/requirements.txt` | Librerías y versiones del cuaderno. |
| `modelo/predicciones.csv` | Predicciones del periodo de prueba (120 filas). |
| `modelo/pronostico_2021_01.csv` | Pronóstico de enero de 2021 por localidad. |
| `modelo/figuras/` | Gráficos generados por el cuaderno. |
| `dw/ddl/15_pred_siniestros_graves.sql` | Crea la tabla `pred_siniestros_graves`. |
| `dw/ddl/16_cargar_pred_siniestros_graves.sql` | Carga las predicciones en esa tabla. |

**Cómo ejecutar el cuaderno**

- En Google Colab: subir `modelo_siniestros_graves.ipynb` y `datos_modelo.csv`, y elegir *Entorno de ejecución → Reiniciar sesión y ejecutar todo*. No requiere instalar nada.
- En local: `pip install -r modelo/requirements.txt`, abrir el cuaderno en la carpeta `modelo/` y ejecutar todas las celdas.
- Por defecto el cuaderno lee `datos_modelo.csv`. Si se definen `USAR_DW=1`, `DW_USER` y `DW_PASSWORD` (y opcionalmente `DW_HOST`, `DW_PORT`, `DW_DB`), ejecuta la consulta directamente contra el data warehouse; con `CARGAR_PRED_DW=1` carga las predicciones en `pred_siniestros_graves`. Las contraseñas nunca se guardan en el repositorio.

**Tabla de predicciones:** ejecutar `15_pred_siniestros_graves.sql` y después `16_cargar_pred_siniestros_graves.sql`; `SELECT COUNT(*) FROM dw_siniestros.pred_siniestros_graves;` debe dar 120. La tabla se une con `dim_tiempo` por `sk_tiempo` y con la ubicación por `localidad`.

**Página de predicciones:** está en el tablero (`dashboard/Tablero_PowerBI_506241154.pbix`) y muestra los valores reales y predichos con filtros por localidad y mes.

## Estructura del repositorio

```text
bi-proyecto-equipo506241154/
├── dashboard/              # Tablero de Power BI (.pbix)
├── datos/
│   ├── raw/                # Fuentes originales
│   ├── muestras/           # Muestras de las fuentes
│   ├── diccionarios/       # Diccionarios de datos
│   └── descarga.md         # Procedencia e instrucciones de descarga
├── docs/
│   ├── diagramas/          # Arquitectura y modelo dimensional
│   └── entregas/           # Documentos de las entregas
├── dw/
│   ├── ddl/                # Scripts SQL del Data Warehouse
│   └── conciliacion/       # Consultas de verificación
├── etl/
│   ├── transformaciones/   # Transformaciones Pentaho (.ktr)
│   ├── trabajos/           # Orquestación de la carga (.kjb)
│   └── README.md           # Documentación del ETL
├── modelo/                 # Modelo predictivo: cuaderno, consulta de extracción, datos y requirements.txt
└── README.md
```

## Requisitos para reproducir el proceso

- MySQL 8.x o MariaDB 10.x.
- Pentaho Data Integration (Spoon) compatible con los archivos `.ktr` y `.kjb`.
- Controlador JDBC de MySQL disponible para Pentaho.
- Los archivos fuente ubicados en `datos/raw/` y con los nombres definidos en `datos/descarga.md`.
## Cómo reproducir

1. Clonar el repositorio.
2. Descargar las tres fuentes siguiendo `datos/descarga.md` y guardarlas en `datos/raw/`.
3. Revisar el modelo dimensional en `docs/diagramas/esquema_dimensional.png` (editable: `esquema_dimensional.drawio`).
4. Crear el data warehouse y cargarlo con `etl/trabajos/carga_completa.kjb` (ver `etl/README.md`).
5. Para el modelo predictivo, seguir la sección «Modelo predictivo (Entrega 3)».


