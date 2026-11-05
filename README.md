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
- **Tablero:** Power BI, previsto para la exploración visual de los indicadores del caso.

> **Nota sobre el estado del repositorio:** están incluidos los scripts SQL del Data Warehouse y los archivos de Pentaho para las dimensiones y tablas de hechos. La carpeta `dashboard/` todavía no contiene un archivo `.pbix` ni un enlace publicado; por eso, el tablero se documenta como componente de la entrega y no se afirma que ya esté disponible en este repositorio.

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

## Estructura del repositorio

```text
bi-proyecto-equipo506241154/
├── dashboard/              # Espacio destinado al tablero de Power BI
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
├── modelo/                 # Espacio destinado al modelo analítico/predictivo
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
4. Las etapas de DW, ETL, dashboard y modelo se agregan en las Entregas 2 y 3.


