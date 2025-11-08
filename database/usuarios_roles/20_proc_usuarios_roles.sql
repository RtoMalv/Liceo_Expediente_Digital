
-- Archivo: /sql/20_proc_usuarios_roles.sql
-- Ejecutar como: USUARIO DE PROYECTO (ej. EXPEDIENTE_DIGITAL)
-- Objetivo: 5 procedimientos del módulo Usuarios/Roles
--            1) crear_usuario
--            2) actualizar_usuario
--            3) eliminar_usuario
--            4) obtener_usuario_por_id  (usa OUT params)
--            5) listar_usuarios         (devuelve SYS_REFCURSOR)  -> cuenta como cursor


-- 1) CREAR USUARIO (username único; pass_hash viene ya cifrado desde la app)
CREATE OR REPLACE PROCEDURE crear_usuario(
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
END;
/
SHOW ERRORS

-- 2) ACTUALIZAR USUARIO (parcial; si viene NULL, no cambia ese campo)
CREATE OR REPLACE PROCEDURE actualizar_usuario(
  p_id_usuario IN usuario_app.id_usuario%TYPE,
  p_nombre     IN usuario_app.nombre%TYPE   DEFAULT NULL,
  p_email      IN usuario_app.email%TYPE    DEFAULT NULL,
  p_estado     IN usuario_app.estado%TYPE   DEFAULT NULL
) IS
BEGIN
  UPDATE usuario_app
     SET nombre = COALESCE(p_nombre, nombre),
         email  = COALESCE(p_email,  email),
         estado = COALESCE(p_estado, estado)
   WHERE id_usuario = p_id_usuario;

  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Usuario no encontrado.');
  END IF;
END;
/
SHOW ERRORS

-- 3) ELIMINAR USUARIO (borra asignaciones de rol primero)
CREATE OR REPLACE PROCEDURE eliminar_usuario(
  p_id_usuario IN usuario_app.id_usuario%TYPE
) IS
BEGIN
  DELETE FROM usuario_rol WHERE id_usuario = p_id_usuario;
  DELETE FROM usuario_app WHERE id_usuario = p_id_usuario;

  IF SQL%ROWCOUNT = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Usuario no encontrado o ya eliminado.');
  END IF;
END;
/
SHOW ERRORS

-- 4) OBTENER USUARIO POR ID (OUT params)
CREATE OR REPLACE PROCEDURE obtener_usuario_por_id(
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
END;
/
SHOW ERRORS

-- 5) LISTAR USUARIOS (devuelve cursor)  -> 1 de los 15 cursores
CREATE OR REPLACE PROCEDURE listar_usuarios(
  p_estado   IN  usuario_app.estado%TYPE DEFAULT NULL,
  p_cursor   OUT SYS_REFCURSOR
) IS
BEGIN
  IF p_estado IS NULL THEN
    OPEN p_cursor FOR
      SELECT id_usuario, username, nombre, email, estado, creado_en
        FROM usuario_app
       ORDER BY creado_en DESC;
  ELSE
    OPEN p_cursor FOR
      SELECT id_usuario, username, nombre, email, estado, creado_en
        FROM usuario_app
       WHERE estado = p_estado
       ORDER BY creado_en DESC;
  END IF;
END;
/
SHOW ERRORS