
-- Archivo: /database/run_all.sql
-- Ejecutar con: @run_all.sql  (desde SQL Developer o SQLcl)
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

PROMPT *** Insertando datos de prueba ***
@datos_prueba.sql

PROMPT *** Fin del script maestro ***