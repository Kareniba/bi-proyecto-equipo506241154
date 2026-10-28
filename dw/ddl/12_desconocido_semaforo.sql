-- 12_desconocido_semaforo.sql
-- Fila "Sin semáforo cercano" (sk = -1) de dim_semaforo.
-- Los siniestros sin intersección semaforizada cercana apuntan a esta fila. Se puede ejecutar más de una vez.

INSERT IGNORE INTO dw_siniestros.dim_semaforo
  (sk_semaforo, id_origen, direccion, localidad, tipo_interseccion, equipo,
   numero_fases, tiene_sonoro, tiene_brt, fecha_instalacion, operacion_actual,
   latitud, longitud)
VALUES (-1, NULL, 'SIN SEMÁFORO CERCANO', 'SIN SEMÁFORO CERCANO', 'SIN SEMÁFORO CERCANO',
        NULL, NULL, 0, 0, NULL, NULL, NULL, NULL);
