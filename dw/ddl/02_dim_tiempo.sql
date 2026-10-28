-- 02_dim_tiempo.sql
-- Dimensión Tiempo (nivel día). Jerarquía: día -> mes -> trimestre -> año.
-- sk_tiempo tiene formato AAAAMMDD (ej. 20200315) y se genera al poblar la dimensión.

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_tiempo (
  sk_tiempo          INT          NOT NULL,
  fecha              DATE         NOT NULL,
  dia                TINYINT      NOT NULL,
  numero_dia_semana  TINYINT      NOT NULL COMMENT '1 = lunes ... 7 = domingo',
  dia_semana         VARCHAR(10)  NOT NULL,
  mes                TINYINT      NOT NULL,
  nombre_mes         VARCHAR(12)  NOT NULL,
  trimestre          TINYINT      NOT NULL,
  anio               SMALLINT     NOT NULL,
  PRIMARY KEY (sk_tiempo),
  UNIQUE KEY uq_dim_tiempo_fecha (fecha)
) ENGINE=InnoDB;
