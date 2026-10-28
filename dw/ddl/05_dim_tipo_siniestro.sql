-- 05_dim_tipo_siniestro.sql
-- Dimensión Tipo de siniestro (fuente F1): clase del siniestro y gravedad.

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_tipo_siniestro (
  sk_tipo_siniestro  INT         NOT NULL AUTO_INCREMENT,
  clase_acc          VARCHAR(40) NOT NULL,
  gravedad           VARCHAR(20) NOT NULL,
  PRIMARY KEY (sk_tipo_siniestro),
  UNIQUE KEY uq_dim_tipo_siniestro (clase_acc, gravedad)
) ENGINE=InnoDB;
