
-- ============================================================
-- PROYECTO: Telecom Customer Intelligence Platform
-- CAPA: GOLD
-- ORIGEN: workspace.telco_silver.clientes
-- MOTOR: Lakeflow Declarative Pipelines
-- ============================================================


-- ============================================================
-- GOLD 01: KPI DE CLIENTES POR CIUDAD Y SEGMENTO
-- ============================================================

CREATE OR REFRESH MATERIALIZED VIEW
    workspace.telco_gold.kpi_clientes_ciudad_segmento

COMMENT 'Indicadores de clientes por ciudad y segmento comercial'

AS
SELECT
    ciudad,
    segmento,

    COUNT(*) AS total_clientes,

    SUM(
        CASE
            WHEN estado = 'ACTIVO' THEN 1
            ELSE 0
        END
    ) AS clientes_activos,

    SUM(
        CASE
            WHEN estado = 'INACTIVO' THEN 1
            ELSE 0
        END
    ) AS clientes_inactivos,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN estado = 'ACTIVO' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS porcentaje_activos

FROM workspace.telco_silver.clientes

GROUP BY
    ciudad,
    segmento;


-- ============================================================
-- GOLD 02: KPI DE ALTAS MENSUALES DE CLIENTES
-- ============================================================

CREATE OR REFRESH MATERIALIZED VIEW
    workspace.telco_gold.kpi_altas_mensuales

COMMENT 'Cantidad de clientes agrupados por mes de alta, ciudad y segmento'

AS
SELECT
    CAST(
        DATE_TRUNC('MONTH', fecha_alta)
        AS DATE
    ) AS mes_alta,

    ciudad,
    segmento,

    COUNT(*) AS total_altas

FROM workspace.telco_silver.clientes

WHERE fecha_alta IS NOT NULL

GROUP BY
    CAST(DATE_TRUNC('MONTH', fecha_alta) AS DATE),
    ciudad,
    segmento;
