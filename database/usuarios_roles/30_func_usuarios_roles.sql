
-- Archivo : /database/usuarios_roles/30_func_usuarios_roles.sql
-- Ejecutar: @usuarios_roles/30_func_usuarios_roles.sql
-- Autor   : Tú (proyecto Expediente Digital)
-- Objetivo: Funciones del módulo Usuarios/Roles
-- Notas   :
--   - Todas retornan tipos simples (NUMBER/VARCHAR2) para usarlas desde app o SQL.


-- 1) obtener_id_usuario(p_username) -> devuelve el ID (o NULL si no existe)
CREATE OR REPLACE FUNCTION obtener_id_usuario(p_username IN usuario_app.username%TYPE)
RETURN usuario_app.id_usuario%TYPE
IS
    v_id usuario_app.id_usuario%TYPE;
BEGIN
    SELECT id_usuario INTO v_id
      FROM usuario_app
     WHERE username = p_username;
    RETURN v_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END;
/
SHOW ERRORS

-- 2) total_usuarios_por_estado(p_estado) -> cuenta usuarios por estado ('A'/'I')
CREATE OR REPLACE FUNCTION total_usuarios_por_estado(p_estado IN usuario_app.estado%TYPE)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total
      FROM usuario_app
     WHERE estado = NVL(p_estado, estado);  -- si p_estado es NULL, cuenta todos
    RETURN v_total;
END;
/
SHOW ERRORS

-- 3) has_rol(p_id_usuario, p_rol_nombre) -> 1 si el usuario tiene ese rol, 0 si no
CREATE OR REPLACE FUNCTION has_rol(
    p_id_usuario IN usuario_app.id_usuario%TYPE,
    p_rol_nombre IN rol.nombre%TYPE
) RETURN NUMBER
IS
    v_dummy NUMBER;
BEGIN
    SELECT 1 INTO v_dummy
      FROM usuario_rol ur
      JOIN rol r ON r.id_rol = ur.id_rol
     WHERE ur.id_usuario = p_id_usuario
       AND UPPER(r.nombre) = UPPER(p_rol_nombre)
       AND ROWNUM = 1;
    RETURN 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
SHOW ERRORS

-- 4) validar_credenciales(p_username, p_pass_hash) -> 1 ok / 0 fail
--    *La contraseña debe llegar YA cifrada/hasheada desde la app*
CREATE OR REPLACE FUNCTION validar_credenciales(
    p_username  IN usuario_app.username%TYPE,
    p_pass_hash IN usuario_app.pass_hash%TYPE
) RETURN NUMBER
IS
    v_dummy NUMBER;
BEGIN
    SELECT 1 INTO v_dummy
      FROM usuario_app
     WHERE username = p_username
       AND pass_hash = p_pass_hash
       AND estado = 'A'
       AND ROWNUM = 1;
    RETURN 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/
SHOW ERRORS

