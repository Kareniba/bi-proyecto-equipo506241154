-- 07_dim_vehiculo.sql
-- Dimensión Vehículo (fuente F3, RUNT). Jerarquía: departamento -> municipio.

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_vehiculo (
  sk_vehiculo   INT          NOT NULL AUTO_INCREMENT,
  clase         VARCHAR(40)  NOT NULL,
  carroceria    VARCHAR(60)  NOT NULL,
  combustible   VARCHAR(30)  NOT NULL,
  municipio     VARCHAR(60)  NOT NULL,
  departamento  VARCHAR(60)  NOT NULL,
  PRIMARY KEY (sk_vehiculo),
  UNIQUE KEY uq_dim_vehiculo (clase, carroceria, combustible, municipio, departamento)
) ENGINE=InnoDB;
