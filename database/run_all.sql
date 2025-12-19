-- Archivo: /database/run_all.sql
-- Ejecutar con: @run_all.sql
-- Descripción: Crea todo el entorno de base de datos de Expediente Digital

PROMPT *** Creando esquema base ***
@script_creacion.sql

PROMPT *** Creando módulo Usuarios y Roles ***
@usuarios_roles/10_tablas_usuarios_roles.sql
@usuarios_roles/20_proc_usuarios_roles.sql
@usuarios_roles/30_func_usuarios_roles.sql
@usuarios_roles/40_vistas_usuarios_roles.sql
@usuarios_roles/50_triggers_usuarios_roles.sql
@usuarios_roles/60_paquete_usuarios_roles.sql

PROMPT *** Creando módulo Auditoría ***
@auditoria/auditoriaSistema.sql
@auditoria/auditoriaEstudiante.sql
@auditoria/auditoriaPermiso.sql
@auditoria/auditoriaConsulta.sql
@auditoria/indicesAuditoria.sql

PROMPT *** Creando vistas del expediente ***
@estudiantes/40_vistas_estudiantes.sql
@estudiantes/50_vistas_materializadas_estudiantes.sql

PROMPT *** Creando procedimientos del expediente ***
@60_procedimientos_expediente.sql

PROMPT *** Insertando datos de prueba ***
@datos_prueba.sql



PROMPT *** Fin del script maestro ***