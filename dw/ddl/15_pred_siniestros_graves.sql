-- 15_pred_siniestros_graves.sql
-- Tabla de predicciones de la Entrega 3 (modelo predictivo de siniestros graves).
-- Granularidad: una fila por localidad y mes del periodo de prueba (jul-dic 2020).
-- Llaves: sk_tiempo apunta al primer dia del mes en dim_tiempo (formato AAAAMMDD);
--         localidad coincide con dim_ubicacion.localidad (atributo, no llave unica de esa dimension).
-- No se declara llave foranea a dim_tiempo a proposito: asi carga_completa.kjb puede borrar y recrear
-- las dimensiones sin tocar las predicciones. La union con dim_tiempo se hace por sk_tiempo (en SQL y en Power BI).

CREATE TABLE IF NOT EXISTS dw_siniestros.pred_siniestros_graves (
  sk_tiempo       INT           NOT NULL COMMENT 'Llave a dim_tiempo (primer dia del mes, AAAAMMDD)',
  localidad       VARCHAR(60)   NOT NULL COMMENT 'Localidad; igual a dim_ubicacion.localidad',
  valor_real      INT           NOT NULL COMMENT 'Siniestros graves observados en el mes',
  valor_predicho  DECIMAL(8,2)  NOT NULL COMMENT 'Siniestros graves predichos por el modelo elegido',
  modelo          VARCHAR(40)   NOT NULL COMMENT 'Algoritmo que genero la prediccion',
  PRIMARY KEY (sk_tiempo, localidad),
  KEY ix_pred_localidad (localidad),
  KEY ix_pred_tiempo (sk_tiempo)
) ENGINE=InnoDB;
