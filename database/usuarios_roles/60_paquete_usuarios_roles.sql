
-- Archivo : /database/usuarios_roles/60_paquete_usuarios_roles.sql
-- Ejecutar: @usuarios_roles/60_paquete_usuarios_roles.sql
-- Objetivo: Paquete USUARIOS_PKG que agrupa procedimientos y funciones
-- Notas    :
--   - Mantiene también las versiones "standalone" creadas antes; no chocan.
--   - Desde la app puedes invocar USUARIOS_PKG.* si se prefiuere namespacing.


CREATE OR REPLACE PACKAGE usuarios_pkg AS
  -- Procedimientos (mapean a los standalone previos)
  PROCEDURE crear_usuario(
    p_username   IN  usuario_app.username%TYPE,
    p_pass_hash  IN  usuario_app.pass_hash%TYPE,
    p_nombre     IN  usuario_app.nombre%TYPE,
    p_email      IN  usuario_app.email%TYPE,
    p_id_out     OUT usuario_app.id_usuario%TYPE
  );

  PROCEDURE actualizar_usuario(
    p_id_usuario IN usuario_app.id_usuario%TYPE,
    p_nombre     IN usuario_app.nombre%TYPE   DEFAULT NULL,
    p_email      IN usuario_app.email%TYPE    DEFAULT NULL,
    p_estado     IN usuario_app.estado%TYPE   DEFAULT NULL
  );

  PROCEDURE eliminar_usuario(
    p_id_usuario IN usuario_app.id_usuario%TYPE
  );

  PROCEDURE obtener_usuario_por_id(
    p_id_usuario IN  usuario_app.id_usuario%TYPE,
    p_username   OUT usuario_app.username%TYPE,
    p_nombre     OUT usuario_app.nombre%TYPE,
    p_email      OUT usuario_app.email%TYPE,
    p_estado     OUT usuario_app.estado%TYPE,
    p_creado_en  OUT usuario_app.creado_en%TYPE
  );

  PROCEDURE listar_usuarios(
    p_estado   IN  usuario_app.estado%TYPE DEFAULT NULL,
    p_cursor   OUT SYS_REFCURSOR
  );

  -- Funciones
  FUNCTION obtener_id_usuario(p_username IN usuario_app.username%TYPE)
    RETURN usuario_app.id_usuario%TYPE;

  FUNCTION total_usuarios_por_estado(p_estado IN usuario_app.estado%TYPE)
    RETURN NUMBER;

  FUNCTION has_rol(
    p_id_usuario IN usuario_app.id_usuario%TYPE,
    p_rol_nombre IN rol.nombre%TYPE
  ) RETURN NUMBER;

  FUNCTION validar_credenciales(
    p_username  IN usuario_app.username%TYPE,
    p_pass_hash IN usuario_app.pass_hash%TYPE
  ) RETURN NUMBER;

END usuarios_pkg;
/
SHOW ERRORS

CREATE OR REPLACE PACKAGE BODY usuarios_pkg AS

  PROCEDURE crear_usuario(
    p_username   IN  usuario_app.username%TYPE,
    p_pass_hash  IN  usuario_app.pass_hash%TYPE,
    p_nombre     IN  usuario_app.nombre%TYPE,
    p_email      IN  usuario_app.email%TYPE,
    p_id_out     OUT usuario_app.id_usuario%TYPE
  ) IS
  BEGIN
    INSERT INTO usuario_app (username, pass_hash, nombre, email)
    VALUES (p_username, p_pass_hash, p_nombre, p_email)
    RETURNING id_usuario INTO p_id_out;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001, 'Username o email ya existe.');
  END crear_usuario;

  PROCEDURE actualizar_usuario(
    p_id_usuario IN usuario_app.id_usuario%TYPE,
    p_nombre     IN usuario_app.nombre%TYPE   DEFAULT NULL,
    p_email      IN usuario_app.email%TYPE    DEFAULT NULL,
    p_estado     IN usuario_app.estado%TYPE   DEFAULT NULL
  ) IS
  BEGIN
    UPDATE usuario_app
       SET nombre = COALESCE(p_nombre, nombre),
           email  = COALESCE(p_email,  email),
           estado = COALESCE(p_estado, estado),
           actualizado_en = SYSDATE
     WHERE id_usuario = p_id_usuario;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Usuario no encontrado.');
    END IF;
  END actualizar_usuario;

  PROCEDURE eliminar_usuario(
    p_id_usuario IN usuario_app.id_usuario%TYPE
  ) IS
  BEGIN
    DELETE FROM usuario_rol WHERE id_usuario = p_id_usuario;
    DELETE FROM usuario_app WHERE id_usuario = p_id_usuario;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Usuario no encontrado o ya eliminado.');
    END IF;
  END eliminar_usuario;

  PROCEDURE obtener_usuario_por_id(
    p_id_usuario IN  usuario_app.id_usuario%TYPE,
    p_username   OUT usuario_app.username%TYPE,
    p_nombre     OUT usuario_app.nombre%TYPE,
    p_email      OUT usuario_app.email%TYPE,
    p_estado     OUT usuario_app.estado%TYPE,
    p_creado_en  OUT usuario_app.creado_en%TYPE
  ) IS
  BEGIN
    SELECT username, nombre, email, estado, creado_en
      INTO p_username, p_nombre, p_email, p_estado, p_creado_en
      FROM usuario_app
     WHERE id_usuario = p_id_usuario;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20004, 'Usuario no encontrado.');
  END obtener_usuario_por_id;

  PROCEDURE listar_usuarios(
    p_estado   IN  usuario_app.estado%TYPE DEFAULT NULL,
    p_cursor   OUT SYS_REFCURSOR
  ) IS
  BEGIN
    IF p_estado IS NULL THEN
      OPEN p_cursor FOR
        SELECT id_usuario, username, nombre, email, estado, creado_en, actualizado_en
          FROM usuario_app
         ORDER BY creado_en DESC;
    ELSE
      OPEN p_cursor FOR
        SELECT id_usuario, username, nombre, email, estado, creado_en, actualizado_en
          FROM usuario_app
         WHERE estado = p_estado
         ORDER BY creado_en DESC;
    END IF;
  END listar_usuarios;

  FUNCTION obtener_id_usuario(p_username IN usuario_app.username%TYPE)
    RETURN usuario_app.id_usuario%TYPE
  IS
    v_id usuario_app.id_usuario%TYPE;
  BEGIN
    SELECT id_usuario INTO v_id
      FROM usuario_app
     WHERE username = LOWER(p_username);
    RETURN v_id;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN NULL;
  END obtener_id_usuario;

  FUNCTION total_usuarios_por_estado(p_estado IN usuario_app.estado%TYPE)
    RETURN NUMBER
  IS
    v_total NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_total
      FROM usuario_app
     WHERE estado = NVL(p_estado, estado);
    RETURN v_total;
  END total_usuarios_por_estado;

  FUNCTION has_rol(
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
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 0;
  END has_rol;

  FUNCTION validar_credenciales(
    p_username  IN usuario_app.username%TYPE,
    p_pass_hash IN usuario_app.pass_hash%TYPE
  ) RETURN NUMBER
  IS
    v_dummy NUMBER;
  BEGIN
    SELECT 1 INTO v_dummy
      FROM usuario_app
     WHERE username = LOWER(p_username)
       AND pass_hash = p_pass_hash
       AND estado = 'A'
       AND ROWNUM = 1;
    RETURN 1;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    RETURN 0;
  END validar_credenciales;

END usuarios_pkg;
/
SHOW ERRORS

