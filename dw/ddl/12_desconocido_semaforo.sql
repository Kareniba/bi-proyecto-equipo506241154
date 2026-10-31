-- 12_desconocido_semaforo.sql
-- Fila "Sin semáforo cercano" (sk = -1) de dim_semaforo.
-- El texto con tilde va como bytes UTF-8 para no depender de la codificación del cliente.
-- Los siniestros sin intersección semaforizada cercana apuntan a esta fila. Se puede ejecutar más de una vez.

INSERT IGNORE INTO dw_siniestros.dim_semaforo
  (sk_semaforo, id_origen, direccion, localidad, tipo_interseccion, equipo,
   numero_fases, tiene_sonoro, tiene_brt, fecha_instalacion, operacion_actual,
   latitud, longitud)
VALUES (-1, NULL, CONVERT(0x53494E2053454DC381464F524F2043455243414E4F USING utf8mb4), CONVERT(0x53494E2053454DC381464F524F2043455243414E4F USING utf8mb4), CONVERT(0x53494E2053454DC381464F524F2043455243414E4F USING utf8mb4),
        NULL, NULL, 0, 0, NULL, NULL, NULL, NULL);
