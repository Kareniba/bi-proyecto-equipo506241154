-- 13_desconocido_vehiculo.sql
-- Fila "Desconocido" (sk = -1) de dim_vehiculo.
-- Se puede ejecutar más de una vez.

INSERT IGNORE INTO dw_siniestros.dim_vehiculo
  (sk_vehiculo, clase, carroceria, combustible, municipio, departamento)
VALUES (-1, 'DESCONOCIDO', 'DESCONOCIDO', 'DESCONOCIDO', 'DESCONOCIDO', 'DESCONOCIDO');
