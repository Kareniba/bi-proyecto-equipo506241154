-- conciliacion_dimensiones.sql
-- Consultas de conciliación: registros cargados por dimensión y totales de la tabla de hechos.

SELECT 'dim_ubicacion' AS dimension,
       COUNT(*) AS registros_cargados
FROM dw_siniestros.dim_ubicacion
WHERE sk_ubicacion <> -1

UNION ALL

SELECT 'dim_tipo_siniestro',
       COUNT(*)
FROM dw_siniestros.dim_tipo_siniestro
WHERE sk_tipo_siniestro <> -1

UNION ALL

SELECT 'dim_semaforo',
       COUNT(*)
FROM dw_siniestros.dim_semaforo
WHERE sk_semaforo <> -1

UNION ALL

SELECT 'dim_hora',
       COUNT(*)
FROM dw_siniestros.dim_hora

UNION ALL

SELECT 'dim_vehiculo',
       COUNT(*)
FROM dw_siniestros.dim_vehiculo
WHERE sk_vehiculo <> -1;

-- Conciliación de la tabla de hechos con la fuente F1 (50.000 siniestros).
-- Debe dar 50.000: todos los registros de F1 quedan en fact_siniestros.
SELECT COUNT(*) AS siniestros_en_hechos
FROM dw_siniestros.fact_siniestros;

-- Siniestros asociados a la fila «Desconocido» de ubicación (esperado: 1, el código 10497776).
SELECT COUNT(*) AS siniestros_con_ubicacion_desconocida
FROM dw_siniestros.fact_siniestros
WHERE sk_ubicacion = -1;
