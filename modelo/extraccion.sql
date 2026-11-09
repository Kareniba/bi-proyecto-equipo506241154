-- modelo/extraccion.sql
-- Conjunto de datos para el modelo predictivo (Entrega 3).
-- Una fila por localidad y mes (2018-01 a 2020-12), con ceros en los meses
-- sin siniestros. Variable objetivo: siniestros_graves (con heridos o fallecidos).
--
-- Une: fact_siniestros + dim_tiempo (mes y año) + dim_ubicacion (localidad).
-- Filtra: sk_ubicacion > 0 (excluye la fila "Desconocido").

SELECT
  l.localidad,
  m.anio,
  m.mes,
  COALESCE(a.siniestros_total, 0)  AS siniestros_total,
  COALESCE(a.siniestros_graves, 0) AS siniestros_graves,
  COALESCE(a.fatales, 0)           AS fatales
FROM (SELECT DISTINCT localidad
        FROM dw_siniestros.dim_ubicacion
       WHERE sk_ubicacion > 0) AS l
CROSS JOIN (SELECT DISTINCT anio, mes
              FROM dw_siniestros.dim_tiempo) AS m
LEFT JOIN (
  SELECT u.localidad, t.anio, t.mes,
         COUNT(*)                           AS siniestros_total,
         SUM(f.es_fatal + f.es_con_heridos) AS siniestros_graves,
         SUM(f.es_fatal)                    AS fatales
    FROM dw_siniestros.fact_siniestros f
    JOIN dw_siniestros.dim_tiempo    t ON t.sk_tiempo    = f.sk_tiempo
    JOIN dw_siniestros.dim_ubicacion u ON u.sk_ubicacion = f.sk_ubicacion
   WHERE f.sk_ubicacion > 0
   GROUP BY u.localidad, t.anio, t.mes
) AS a ON a.localidad = l.localidad AND a.anio = m.anio AND a.mes = m.mes
ORDER BY l.localidad, m.anio, m.mes;
