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



