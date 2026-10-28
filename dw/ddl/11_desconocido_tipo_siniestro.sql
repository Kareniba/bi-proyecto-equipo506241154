-- 11_desconocido_tipo_siniestro.sql
-- Fila "Desconocido" (sk = -1) de dim_tipo_siniestro.
-- Se puede ejecutar más de una vez.

INSERT IGNORE INTO dw_siniestros.dim_tipo_siniestro
  (sk_tipo_siniestro, clase_acc, gravedad)
VALUES (-1, 'DESCONOCIDO', 'DESCONOCIDO');
