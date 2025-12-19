--------------------------------------------------------------------------------
-- Archivo: 50_vistas_materializadas_estudiantes.sql
-- Descripción: Vistas materializadas para optimización del expediente
-- Motor: Oracle Database 19c
--------------------------------------------------------------------------------

PROMPT *** Creando vistas materializadas del expediente ***

--------------------------------------------------------------------------------
-- VISTA MATERIALIZADA: Expediente consolidado
--------------------------------------------------------------------------------
CREATE MATERIALIZED VIEW MV_EXPEDIENTE_CONSOLIDADO
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido_uno,
    e.apellido_dos,
    e.telefono,
    l.provincia,
    l.canton,
    l.distrito,
    r.ruta_comunidad,
    enc.nombre_encargado,
    enc.apellido_encargado,
    enc.telefono_encargado
FROM ESTUDIANTE e
LEFT JOIN LOCALIDAD l  ON e.id_localidad = l.id_localidad
LEFT JOIN RUTA r       ON e.id_ruta = r.id_ruta
LEFT JOIN ENCARGADO enc ON e.id_encargado = enc.id_encargado;

--------------------------------------------------------------------------------
-- ÍNDICE PARA OPTIMIZAR CONSULTAS SOBRE LA VISTA MATERIALIZADA
--------------------------------------------------------------------------------
CREATE INDEX IDX_MV_EXPEDIENTE_EST
ON MV_EXPEDIENTE_CONSOLIDADO(id_estudiante);

--------------------------------------------------------------------------------
-- EJEMPLO DE REFRESCO MANUAL
-- (se usa desde procedimientos o mantenimiento)
--------------------------------------------------------------------------------
-- BEGIN
--   DBMS_MVIEW.REFRESH('MV_EXPEDIENTE_CONSOLIDADO');
-- END;
-- /

PROMPT *** Vista materializada creada ***