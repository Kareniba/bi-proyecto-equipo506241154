-- 04_dim_ubicacion.sql
-- Dimensión Ubicación (fuente F1, siniestros viales). Jerarquía: localidad -> dirección.

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_ubicacion (
  sk_ubicacion  INT           NOT NULL AUTO_INCREMENT,
  direccion     VARCHAR(150)  NOT NULL,
  localidad     VARCHAR(60)   NOT NULL,
  civ           VARCHAR(20)   NULL COMMENT 'Código de identificación vial (fuente)',
  latitud       DECIMAL(10,7) NULL,
  longitud      DECIMAL(10,7) NULL,
  PRIMARY KEY (sk_ubicacion),
  KEY ix_dim_ubicacion_localidad (localidad)
) ENGINE=InnoDB;
