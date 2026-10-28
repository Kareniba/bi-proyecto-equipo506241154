-- 08_fact_siniestros.sql
-- Tabla de hechos de siniestros.
-- Granularidad: una fila representa un siniestro vial registrado en Bogotá,
-- en una ubicación y en una fecha y hora específicas.
-- codigo_accidente y formulario son dimensiones degeneradas.

CREATE TABLE IF NOT EXISTS dw_siniestros.fact_siniestros (
  codigo_accidente     BIGINT           NOT NULL,
  formulario           VARCHAR(20)      NULL,
  sk_tiempo            INT              NOT NULL,
  sk_hora              TINYINT UNSIGNED NOT NULL,
  sk_ubicacion         INT              NOT NULL,
  sk_tipo_siniestro    INT              NOT NULL,
  sk_semaforo          INT              NOT NULL,
  cantidad_siniestros  TINYINT          NOT NULL DEFAULT 1,
  es_fatal             TINYINT(1)       NOT NULL DEFAULT 0,
  es_con_heridos       TINYINT(1)       NOT NULL DEFAULT 0,
  es_solo_danos        TINYINT(1)       NOT NULL DEFAULT 0,
  indice_gravedad      DECIMAL(4,2)     NOT NULL COMMENT '3*es_fatal + 2*es_con_heridos + 1*es_solo_danos',
  PRIMARY KEY (codigo_accidente),
  CONSTRAINT fk_fs_tiempo   FOREIGN KEY (sk_tiempo)         REFERENCES dw_siniestros.dim_tiempo (sk_tiempo),
  CONSTRAINT fk_fs_hora     FOREIGN KEY (sk_hora)           REFERENCES dw_siniestros.dim_hora (sk_hora),
  CONSTRAINT fk_fs_ubic     FOREIGN KEY (sk_ubicacion)      REFERENCES dw_siniestros.dim_ubicacion (sk_ubicacion),
  CONSTRAINT fk_fs_tipo     FOREIGN KEY (sk_tipo_siniestro) REFERENCES dw_siniestros.dim_tipo_siniestro (sk_tipo_siniestro),
  CONSTRAINT fk_fs_semaforo FOREIGN KEY (sk_semaforo)       REFERENCES dw_siniestros.dim_semaforo (sk_semaforo)
) ENGINE=InnoDB;
