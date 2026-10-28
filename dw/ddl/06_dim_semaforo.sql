-- 06_dim_semaforo.sql
-- Dimensión Semáforo (fuente F2, red semafórica). Jerarquía: localidad -> intersección.
-- id_origen conserva el ID de la fuente. latitud y longitud se usan para asignar a cada
-- siniestro la intersección semaforizada más cercana.

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_semaforo (
  sk_semaforo        INT           NOT NULL AUTO_INCREMENT,
  id_origen          INT           NULL COMMENT 'ID de la intersección en la fuente',
  direccion          VARCHAR(150)  NOT NULL,
  localidad          VARCHAR(60)   NOT NULL,
  tipo_interseccion  VARCHAR(60)   NOT NULL,
  equipo             VARCHAR(20)   NULL,
  numero_fases       SMALLINT      NULL,
  tiene_sonoro       TINYINT(1)    NOT NULL DEFAULT 0,
  tiene_brt          TINYINT(1)    NOT NULL DEFAULT 0,
  fecha_instalacion  DATE          NULL,
  operacion_actual   VARCHAR(30)   NULL,
  latitud            DECIMAL(10,7) NULL,
  longitud           DECIMAL(10,7) NULL,
  PRIMARY KEY (sk_semaforo),
  KEY ix_dim_semaforo_id_origen (id_origen),
  KEY ix_dim_semaforo_localidad (localidad)
) ENGINE=InnoDB;
