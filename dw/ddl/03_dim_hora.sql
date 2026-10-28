-- 03_dim_hora.sql
-- Dimensión Hora (24 filas, una por hora del día). Jerarquía: hora -> franja horaria.
-- sk_hora coincide con la hora del día (0 a 23).

CREATE TABLE IF NOT EXISTS dw_siniestros.dim_hora (
  sk_hora         TINYINT UNSIGNED NOT NULL,
  hora            CHAR(5)          NOT NULL COMMENT 'Formato HH:00',
  franja_horaria  VARCHAR(12)      NOT NULL COMMENT 'Madrugada, Mañana, Tarde o Noche',
  PRIMARY KEY (sk_hora)
) ENGINE=InnoDB;
