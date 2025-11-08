
-- Archivo : /database/usuarios_roles/40_vistas_usuarios_roles.sql
-- Ejecutar: @usuarios_roles/40_vistas_usuarios_roles.sql
-- Objetivo: Vistas útiles del módulo Usuarios/Roles/Permisos
-- Notas   : Pensadas para reportes y para simplificar consultas desde la app.


-- 1) Usuarios + Roles (una fila por asignación)
CREATE OR REPLACE VIEW vista_usuarios_roles AS
SELECT
    u.id_usuario,
    u.username,
    u.nombre          AS nombre_usuario,
    u.email,
    u.estado          AS estado_usuario,
    r.id_rol,
    r.nombre          AS nombre_rol,
    r.descripcion     AS desc_rol
FROM usuario_app u
JOIN usuario_rol  ur ON ur.id_usuario = u.id_usuario
JOIN rol          r  ON r.id_rol     = ur.id_rol;
/

-- 2) Roles + Permisos (una fila por permiso asignado al rol)
CREATE OR REPLACE VIEW vista_roles_permisos AS
SELECT
    r.id_rol,
    r.nombre          AS nombre_rol,
    p.id_permiso,
    p.codigo          AS codigo_permiso,
    p.descripcion     AS desc_permiso
FROM rol r
JOIN rol_permiso rp ON rp.id_rol     = r.id_rol
JOIN permiso     p  ON p.id_permiso  = rp.id_permiso;
/

-- 3) Permisos por Usuario (expande usuario → rol → permiso)
CREATE OR REPLACE VIEW vista_permisos_por_usuario AS
SELECT
    u.id_usuario,
    u.username,
    u.nombre     AS nombre_usuario,
    r.nombre     AS nombre_rol,
    p.codigo     AS codigo_permiso
FROM usuario_app u
JOIN usuario_rol  ur ON ur.id_usuario = u.id_usuario
JOIN rol          r  ON r.id_rol     = ur.id_rol
JOIN rol_permiso  rp ON rp.id_rol    = r.id_rol
JOIN permiso      p  ON p.id_permiso = rp.id_permiso;
/

