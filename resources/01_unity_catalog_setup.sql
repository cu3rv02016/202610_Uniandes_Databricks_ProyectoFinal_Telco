-- =====================================================
-- PROYECTO: Telecom Customer Intelligence Platform
-- COMPONENTE: Unity Catalog
-- ARQUITECTURA: Medallion (Bronze, Silver, Gold)
-- =====================================================

-- BRONZE: Datos originales
CREATE SCHEMA IF NOT EXISTS workspace.telco_bronze
COMMENT 'Capa Bronze: datos originales de telecomunicaciones';

-- SILVER: Datos depurados
CREATE SCHEMA IF NOT EXISTS workspace.telco_silver
COMMENT 'Capa Silver: datos limpios, validados y transformados';

-- GOLD: Datos analiticos y Machine Learning
CREATE SCHEMA IF NOT EXISTS workspace.telco_gold
COMMENT 'Capa Gold: modelos analiticos y datos para Machine Learning';