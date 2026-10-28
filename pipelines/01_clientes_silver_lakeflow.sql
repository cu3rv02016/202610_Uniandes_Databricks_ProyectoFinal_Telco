-- ==================================================
-- PROYECTO: Telecom Customer Intelligence Platform
-- CAPA: SILVER
-- ORIGEN: workspace.telco_bronze.clientes_raw
-- DESTINO: workspace.telco_silver.clientes
-- MOTOR: Lakeflow Declarative Pipelines
-- ==================================================

CREATE OR REFRESH MATERIALIZED VIEW clientes (

    CONSTRAINT cliente_id_valido
    EXPECT (cliente_id IS NOT NULL)
    ON VIOLATION DROP ROW,

    CONSTRAINT fecha_alta_valida
    EXPECT (fecha_alta IS NOT NULL)
    ON VIOLATION DROP ROW

)
COMMENT 'Clientes normalizados y validados de telecomunicaciones'

AS

WITH clientes_normalizados AS (

    SELECT
        UPPER(TRIM(cliente_id)) AS cliente_id,
        INITCAP(TRIM(ciudad)) AS ciudad,
        INITCAP(TRIM(segmento)) AS segmento,
        TRY_CAST(fecha_alta_raw AS DATE) AS fecha_alta,
        UPPER(TRIM(estado_raw)) AS estado,
        _fuente,
        _fecha_ingesta

    FROM workspace.telco_bronze.clientes_raw

),

clientes_deduplicados AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cliente_id
            ORDER BY _fecha_ingesta DESC
        ) AS rn

    FROM clientes_normalizados

)

SELECT
    cliente_id,
    ciudad,
    segmento,
    fecha_alta,
    estado,
    _fuente,
    _fecha_ingesta

FROM clientes_deduplicados

WHERE rn = 1;