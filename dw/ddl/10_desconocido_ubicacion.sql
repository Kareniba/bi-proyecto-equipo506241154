-- 10_desconocido_ubicacion.sql
-- Fila "Desconocido" (sk = -1) de dim_ubicacion.
-- Los siniestros sin ubicación válida apuntan a esta fila. Se puede ejecutar más de una vez.

INSERT IGNORE INTO dw_siniestros.dim_ubicacion
  (sk_ubicacion, direccion, localidad, civ, latitud, longitud)
VALUES (-1, 'DESCONOCIDA', 'DESCONOCIDA', NULL, NULL, NULL);
