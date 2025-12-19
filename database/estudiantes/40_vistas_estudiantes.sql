--------------------------------------------------------------------------------
-- Archivo: 40_vistas_estudiantes.sql
-- Descripción: Vistas de consulta del expediente estudiantil
-- Motor: Oracle Database 19c
--------------------------------------------------------------------------------

PROMPT *** Creando vistas del expediente estudiantil ***

--------------------------------------------------------------------------------
-- VISTA 1: Información básica del estudiante (SIN datos médicos)
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ESTUDIANTE_BASICO AS
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido_uno,
    e.apellido_dos,
    e.telefono,
    l.provincia,
    l.canton,
    l.distrito,
    r.ruta_comunidad
FROM ESTUDIANTE e
LEFT JOIN LOCALIDAD l ON e.id_localidad = l.id_localidad
LEFT JOIN RUTA r      ON e.id_ruta = r.id_ruta;

--------------------------------------------------------------------------------
-- VISTA 2: Expediente completo del estudiante (USO ADMINISTRATIVO)
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_EXPEDIENTE_COMPLETO AS
SELECT
    e.id_estudiante,
    e.nombre,
    e.apellido_uno,
    e.apellido_dos,
    e.telefono,
    e.alerta_medica,
    e.medicamento_prescrito,
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
-- VISTA 3: Historial de permisos de salida
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_PERMISOS_SALIDA AS
SELECT
    p.id_permiso,
    p.id_estudiante,
    e.nombre || ' ' || e.apellido_uno AS estudiante,
    p.fecha_salida,
    p.motivo,
    p.autorizado_por
FROM PERMISO_SALIDA p
JOIN ESTUDIANTE e ON p.id_estudiante = e.id_estudiante;

PROMPT *** Vistas de estudiantes creadas ***