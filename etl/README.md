
# ETL — Data Warehouse de siniestralidad vial

## 1. Descripción general

El proceso ETL (Extract, Transform, Load) tiene como objetivo integrar, transformar y cargar la información de las fuentes de datos del proyecto de Business Intelligence sobre seguridad vial en Bogotá D. C.

El proceso permite consolidar la información de siniestros viales, infraestructura semafórica y parque automotor eléctrico e híbrido en el Data Warehouse `dw_siniestros`, facilitando posteriormente su análisis mediante herramientas de Business Intelligence.

La implementación se realiza con **Pentaho Data Integration (PDI / Spoon)**, utilizando transformaciones `.ktr` y un trabajo de orquestación `.kjb`.

## 2. Herramientas utilizadas

| Herramienta | Función |
| --- | --- |
| Pentaho Data Integration (PDI / Spoon) | Desarrollo y ejecución de los procesos ETL. |
| MySQL 8.x / MariaDB 10.x | Almacenamiento del Data Warehouse. |
| JDBC MySQL | Conexión entre Pentaho y la base de datos. |
| Power BI | Visualización y análisis de los datos integrados. |

## 3. Fuentes de datos

El proceso ETL integra tres fuentes principales:

| Fuente | Formato | Descripción |
| --- | --- | --- |
| Siniestros viales de Bogotá | JSON | Registros históricos de siniestros viales del periodo 2018–2020. |
| Red semafórica de Bogotá | CSV | Información de las intersecciones y la infraestructura semafórica. |
| Vehículos eléctricos e híbridos del RUNT | XLSX | Información del parque automotor por características del vehículo y municipio de matrícula. |

Los archivos originales se encuentran en:

```text
datos/raw/
```

Las instrucciones de descarga y procedencia de las fuentes están documentadas en [`../datos/descarga.md`](../datos/descarga.md).

## 4. Arquitectura del proceso ETL

El proceso se desarrolla en tres etapas:

### 4.1. Extracción

Se leen los registros de las fuentes originales en formatos JSON, CSV y XLSX.

Los datos se obtienen desde los archivos disponibles en el repositorio y se procesan mediante las transformaciones de Pentaho.

### 4.2. Transformación

Se realizan las operaciones necesarias para preparar los datos:

- Selección de los campos relevantes.
- Normalización de los datos.
- Conversión de tipos de datos.
- Preparación de los registros para su integración.
- Búsqueda de llaves sustitutas de las dimensiones.
- Identificación de registros desconocidos o sin coincidencia.
- Asociación de los siniestros con ubicaciones e infraestructura semafórica.

### 4.3. Carga

Los registros transformados se almacenan en las dimensiones y tablas de hechos del Data Warehouse `dw_siniestros`.

La carga se realiza mediante las transformaciones `.ktr`, coordinadas por el trabajo `carga_completa.kjb`.

## 5. Transformaciones implementadas

Los archivos de Pentaho se encuentran organizados en:

```text
etl/
├── transformaciones/
└── trabajos/
```

### 5.1. Carga de dimensiones

Las transformaciones disponibles son:

| Transformación | Tabla destino | Descripción |
| --- | --- | --- |
| `dim_hora.ktr` | `dim_hora` | Prepara y carga la dimensión de hora. |
| `dim_ubicacion.ktr` | `dim_ubicacion` | Integra la información de ubicación geográfica. |
| `dim_tipo_siniestro.ktr` | `dim_tipo_siniestro` | Prepara la clasificación de los siniestros. |
| `dim_semaforo.ktr` | `dim_semaforo` | Carga información de la red semafórica. |
| `dim_vehiculo.ktr` | `dim_vehiculo` | Integra las características del parque automotor. |

### 5.2. Carga de tablas de hechos

| Transformación | Tabla destino | Descripción |
| --- | --- | --- |
| `fact_siniestros.ktr` | `fact_siniestros` | Integra los registros de siniestros viales y sus llaves dimensionales. |
| `fact_parque_automotor.ktr` | `fact_parque_automotor` | Consolida la información del parque automotor por año y características del vehículo. |

La transformación `fact_siniestros.ktr` contempla la búsqueda de la ubicación correspondiente y la asociación con el semáforo más cercano, mediante un cálculo de distancia geográfica.

## 6. Trabajo de orquestación

El archivo encargado de coordinar el proceso es:

```text
etl/trabajos/carga_completa.kjb
```

Este trabajo ejecuta las transformaciones correspondientes a las dimensiones y las tablas de hechos.

El orden general del proceso es:

1. Preparación de las tablas del Data Warehouse.
2. Carga de la dimensión de hora.
3. Carga de la dimensión de ubicación.
4. Carga de la dimensión de tipo de siniestro.
5. Carga de la dimensión de semáforo.
6. Carga de la dimensión de vehículo.
7. Carga de la tabla de hechos de siniestros.
8. Carga de la tabla de hechos del parque automotor.

El orden de ejecución se encuentra definido en el trabajo de Pentaho.

## 7. Configuración de la conexión

Las transformaciones utilizan una conexión de tipo MySQL denominada:

```text
DW_LOCAL
```

La conexión se configura mediante los siguientes parámetros:

| Variable | Descripción | Ejemplo |
| --- | --- | --- |
| `DW_HOST` | Servidor de la base de datos. | `localhost` |
| `DW_PORT` | Puerto de conexión. | `3306` |
| `DW_DB` | Nombre de la base de datos. | `dw_siniestros` |
| `DW_USER` | Usuario de conexión. | `root` |
| `DW_PASSWORD` | Contraseña de conexión. | Contraseña local |

Los valores deben configurarse de acuerdo con el entorno de ejecución.

**Importante:** no se deben publicar contraseñas reales ni credenciales de acceso en el repositorio.

## 8. Configuración de las rutas de las fuentes

Las transformaciones que requieren archivos externos utilizan la variable:

```text
RUTA_FUENTES
```

Esta variable debe apuntar a la ubicación de los archivos fuente.

Ejemplo:

```text
RUTA_FUENTES=../datos/raw
```

La ruta debe ajustarse según la ubicación desde la cual se ejecute Pentaho.

Antes de ejecutar el proceso, se debe verificar que los archivos fuente estén disponibles y que sus nombres coincidan con los definidos en las transformaciones.

## 9. Requisitos de ejecución

Para ejecutar el proceso ETL se requiere:

- MySQL 8.x o MariaDB 10.x.
- Pentaho Data Integration (Spoon).
- Controlador JDBC de MySQL.
- Archivos fuente disponibles en el repositorio.
- Acceso a la base de datos `dw_siniestros`.
- Variables de conexión y rutas configuradas.

## 10. Ejecución del proceso

### Paso 1. Preparar la base de datos

Ejecutar los scripts SQL ubicados en:

```text
dw/ddl/
```

El script inicial para crear la base de datos es:

```text
dw/ddl/01_crear_base.sql
```

### Paso 2. Configurar la conexión

Verificar que la conexión `DW_LOCAL` esté configurada correctamente en Pentaho.

Comprobar que el servidor, puerto, base de datos y credenciales sean válidos.

### Paso 3. Configurar las rutas

Establecer la variable `RUTA_FUENTES` con la ubicación de los archivos originales.

### Paso 4. Abrir el trabajo

Desde Spoon, abrir:

```text
etl/trabajos/carga_completa.kjb
```

### Paso 5. Ejecutar la carga

Ejecutar el trabajo completo y revisar el resultado de cada transformación.

Se recomienda verificar los registros procesados, escritos y rechazados, así como los errores reportados durante la ejecución.

### Paso 6. Verificar los datos

Una vez finalizada la carga, consultar las tablas del Data Warehouse para comprobar que los registros hayan sido almacenados correctamente.

Se puede utilizar el script:

```text
dw/conciliacion/conciliacion_dimensiones.sql
```

## 11. Validación de resultados

Para comprobar el funcionamiento del proceso ETL se recomienda:

- Verificar que las dimensiones contengan registros.
- Comprobar que las tablas de hechos tengan información.
- Revisar la integridad de las llaves dimensionales.
- Identificar registros desconocidos o sin coincidencia.
- Comparar los registros procesados con los registros cargados.
- Revisar los errores y rechazos reportados por Pentaho.

La validación permite comprobar que la información se encuentre correctamente integrada antes de su utilización en el tablero de Power BI.

## 12. Estructura de los archivos ETL

```text
etl/
├── README.md
├── transformaciones/
│   ├── dim_hora.ktr
│   ├── dim_ubicacion.ktr
│   ├── dim_tipo_siniestro.ktr
│   ├── dim_semaforo.ktr
│   ├── dim_vehiculo.ktr
│   ├── fact_siniestros.ktr
│   └── fact_parque_automotor.ktr
└── trabajos/
    └── carga_completa.kjb
```

## 13. Documentación relacionada

- [README principal del proyecto](../README.md)
- [Scripts SQL del Data Warehouse](../dw/ddl/)
- [Consulta de conciliación de dimensiones](../dw/conciliacion/conciliacion_dimensiones.sql)
- [Diccionarios de datos](../datos/diccionarios/)
- [Procedencia y descarga de las fuentes](../datos/descarga.md)
- [Diagrama de arquitectura](../docs/diagramas/diagrama_arquitectura.drawio.png)
- [Modelo dimensional](../docs/diagramas/esquema_dimensional.png)

