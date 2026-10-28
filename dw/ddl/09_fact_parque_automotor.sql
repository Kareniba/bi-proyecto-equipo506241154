-- 09_fact_parque_automotor.sql
-- Segunda tabla de hechos (constelación): parque automotor del RUNT.
-- Granularidad: una fila representa los vehículos registrados en el RUNT que comparten
-- la misma clase, carrocería, combustible y municipio de matrícula en un año de registro.
-- sk_tiempo apunta al 1 de enero del año de registro (nivel año).

CREATE TABLE IF NOT EXISTS dw_siniestros.fact_parque_automotor (
  sk_tiempo          INT NOT NULL,
  sk_vehiculo        INT NOT NULL,
  cantidad_vehiculos INT NOT NULL,
  PRIMARY KEY (sk_tiempo, sk_vehiculo),
  CONSTRAINT fk_fp_tiempo   FOREIGN KEY (sk_tiempo)   REFERENCES dw_siniestros.dim_tiempo (sk_tiempo),
  CONSTRAINT fk_fp_vehiculo FOREIGN KEY (sk_vehiculo) REFERENCES dw_siniestros.dim_vehiculo (sk_vehiculo)
) ENGINE=InnoDB;
