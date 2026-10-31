-- 14_poblar_dim_tiempo.sql
-- Puebla la dimensión Tiempo del 2018-01-01 al 2020-12-31 (1.096 días, sin huecos),
-- que cubre todo el periodo de los hechos. Se puede ejecutar más de una vez.
-- Los días y meses se escriben en español sin depender de la configuración del servidor.
-- Miércoles y Sábado van como bytes UTF-8 (CONVERT(0x... USING utf8mb4)) para que no dependan
-- de la codificación con la que PDI lea este archivo.

INSERT IGNORE INTO dw_siniestros.dim_tiempo
  (sk_tiempo, fecha, dia, numero_dia_semana, dia_semana, mes, nombre_mes, trimestre, anio)
SELECT CAST(DATE_FORMAT(t.d, '%Y%m%d') AS UNSIGNED),
       t.d,
       DAY(t.d),
       WEEKDAY(t.d) + 1,
       ELT(WEEKDAY(t.d) + 1, 'Lunes','Martes',CONVERT(0x4D69C3A972636F6C6573 USING utf8mb4),'Jueves','Viernes',CONVERT(0x53C3A16261646F USING utf8mb4),'Domingo'),
       MONTH(t.d),
       ELT(MONTH(t.d), 'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                       'Agosto','Septiembre','Octubre','Noviembre','Diciembre'),
       QUARTER(t.d),
       YEAR(t.d)
FROM (
  SELECT DATE_ADD('2018-01-01', INTERVAL (u.n + 10 * d.n + 100 * c.n + 1000 * m.n) DAY) AS d
  FROM (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) u
  CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
  CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
  CROSS JOIN (SELECT 0 AS n UNION ALL SELECT 1) m
) t
WHERE t.d <= '2020-12-31';
