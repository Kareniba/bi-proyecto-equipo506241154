-- 00_reiniciar_tablas.sql
-- Borra las tablas del data warehouse (si existen) para que el trabajo carga_completa.kjb
-- pueda ejecutarse varias veces sobre la misma base sin duplicar ni chocar con llaves.
-- Se ejecuta SIEMPRE antes de los scripts 02 a 09, que vuelven a crear las tablas.
-- Orden: primero las tablas de hechos y luego las dimensiones, por las llaves foráneas.

DROP TABLE IF EXISTS dw_siniestros.fact_siniestros;
DROP TABLE IF EXISTS dw_siniestros.fact_parque_automotor;
DROP TABLE IF EXISTS dw_siniestros.dim_tiempo;
DROP TABLE IF EXISTS dw_siniestros.dim_hora;
DROP TABLE IF EXISTS dw_siniestros.dim_ubicacion;
DROP TABLE IF EXISTS dw_siniestros.dim_tipo_siniestro;
DROP TABLE IF EXISTS dw_siniestros.dim_semaforo;
DROP TABLE IF EXISTS dw_siniestros.dim_vehiculo;
