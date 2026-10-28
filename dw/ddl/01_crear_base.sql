-- 01_crear_base.sql
-- Crea la base de datos del data warehouse (esquema dw_siniestros).
-- Motor: MySQL 8.x o MariaDB 10.x. Ejecutar primero.

CREATE DATABASE IF NOT EXISTS dw_siniestros
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

