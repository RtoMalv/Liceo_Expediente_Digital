-- =========================================================
-- API del Expediente Digital (Package)
-- Ejecutar con el usuario: EXPEDIENTE_DIGITAL
-- =========================================================

------------------------------------------------------------------------
-- 20_api_expd.sql
-- Paquete de API para "Expediente Digital" (Liceo de Tarrazú)
-- Esquema: expediente_digital   |   Motor: Oracle
-- Autor: Mauricio Alvarado      |   Fecha: 2025-11
--
-- Contiene:
--  - sp_login                : Autenticación por usuario/clave (DEMO texto plano)
--  - sp_get_ruta_de_est      : Ruta asignada a un estudiante (para CHOFER)
--  - sp_list_permisos        : Permisos de salida de un estudiante (para GUARDA)
--  - sp_ins_estudiante       : Crear estudiante y devolver ID (para ASISTENTE)
--  - sp_upd_estudiante       : Actualizar datos de estudiante (para ASISTENTE)
--  - sp_del_estudiante       : Eliminar estudiante (para ASISTENTE)
--  - sp_get_estudiante       : Consultar ficha completa del estudiante
--  - sp_upd_foto             : Actualizar archivo de fotografía del estudiante
------------------------------------------------------------------------

-- Limpieza  por si quedó algo inválido
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE BODY api_expd'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP PACKAGE api_expd';       EXCEPTION WHEN OTHERS THEN NULL; END;
/

------------------------------------------------------------------------
-- ESPECIFICACIÓN DEL PAQUETE
------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE api_expd AS
  ----------------------------------------------------------------------
  -- sp_login
  -- Propósito : Autenticar usuario.
  -- IN        : p_user (usuario), p_pass (contraseña - DEMO en texto plano)
  -- OUT       : p_ok (1=éxito, 0=fallo), p_rol (ASISTENTE/GUARDA/CHOFER), p_id (id_usuario)
  ----------------------------------------------------------------------
  PROCEDURE sp_login(
    p_user IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_ok   OUT NUMBER,
    p_rol  OUT VARCHAR2,
    p_id   OUT NUMBER
  );

  ----------------------------------------------------------------------
  -- sp_get_ruta_de_est
  -- Propósito : Devolver la ruta asignada a un estudiante (para panel CHOFER).
  -- IN        : p_id_est (id_estudiante)
  -- OUT       : p_cur SYS_REFCURSOR con columnas:
  --             id_ruta | ruta_comunidad | chofer
  ----------------------------------------------------------------------
  PROCEDURE sp_get_ruta_de_est(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  );

  ----------------------------------------------------------------------
  -- sp_list_permisos
  -- Propósito : Listar permisos de salida de un estudiante (para panel GUARDA).
  -- IN        : p_id_est (id_estudiante)
  -- OUT       : p_cur SYS_REFCURSOR con columnas:
  --             fecha_salida | motivo | autorizado_por
  ----------------------------------------------------------------------
  PROCEDURE sp_list_permisos(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  );

  ----------------------------------------------------------------------
  -- sp_ins_estudiante
  -- Propósito : Insertar estudiante; devuelve el nuevo ID.
  -- OUT       : p_new_id (id_estudiante generado)
  ----------------------------------------------------------------------
  PROCEDURE sp_ins_estudiante(
    p_id_localidad IN NUMBER,
    p_id_ruta      IN NUMBER,
    p_id_encargado IN NUMBER,
    p_nombre       IN VARCHAR2,
    p_ap1          IN VARCHAR2,
    p_ap2          IN VARCHAR2,
    p_telefono     IN VARCHAR2,
    p_fotografia   IN VARCHAR2,
    p_alerta       IN VARCHAR2,
    p_medicamento  IN VARCHAR2,
    p_new_id       OUT NUMBER
  );

  ----------------------------------------------------------------------
  -- sp_upd_estudiante
  -- Propósito : Actualizar información de un estudiante existente.
  ----------------------------------------------------------------------
  PROCEDURE sp_upd_estudiante(
    p_id_est       IN NUMBER,
    p_id_localidad IN NUMBER,
    p_id_ruta      IN NUMBER,
    p_id_encargado IN NUMBER,
    p_nombre       IN VARCHAR2,
    p_ap1          IN VARCHAR2,
    p_ap2          IN VARCHAR2,
    p_telefono     IN VARCHAR2,
    p_fotografia   IN VARCHAR2,
    p_alerta       IN VARCHAR2,
    p_medicamento  IN VARCHAR2
  );

  ----------------------------------------------------------------------
  -- sp_del_estudiante
  -- Propósito : Eliminar un estudiante por ID.
  ----------------------------------------------------------------------
  PROCEDURE sp_del_estudiante(p_id_est IN NUMBER);

  ----------------------------------------------------------------------
  -- sp_get_estudiante
  -- Propósito : Consultar ficha completa del estudiante.
  -- OUT       : p_cur SYS_REFCURSOR con columnas:
  --             id_estudiante | nombre | apellido_uno | apellido_dos
  --             telefono | fotografia | alerta_medica | medicamento_prescrito
  --             ruta_comunidad | nombre_encargado | telefono_encargado
  ----------------------------------------------------------------------
  PROCEDURE sp_get_estudiante(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  );

  ----------------------------------------------------------------------
  -- sp_upd_foto
  -- Propósito : Actualizar el nombre de archivo de la fotografía del estudiante.
  ----------------------------------------------------------------------
  PROCEDURE sp_upd_foto(
    p_id_est  IN NUMBER,
    p_file    IN VARCHAR2
  );
END api_expd;
/
------------------------------------------------------------------------
-- CUERPO DEL PAQUETE
------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY api_expd AS

  ----------------------------------------------------------------------
  -- sp_login
  -- DEMO: compara contraseña en texto plano contra tabla USUARIO.
  -- Para producción: sustituir por verificación con hash.
  ----------------------------------------------------------------------
  PROCEDURE sp_login(
    p_user IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_ok   OUT NUMBER,
    p_rol  OUT VARCHAR2,
    p_id   OUT NUMBER
  ) IS
  BEGIN
    p_ok := 0; p_rol := NULL; p_id := NULL;

    SELECT 1, rol, id_usuario
      INTO  p_ok, p_rol, p_id
      FROM  usuario
     WHERE  nombre_usuario = p_user
       AND  contrasenia    = p_pass;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_ok := 0; p_rol := NULL; p_id := NULL;
  END sp_login;

  ----------------------------------------------------------------------
  -- sp_get_ruta_de_est
  -- Devuelve ruta y chofer asociado a un estudiante.
  ----------------------------------------------------------------------
  PROCEDURE sp_get_ruta_de_est(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cur FOR
      SELECT
        r.id_ruta,
        r.ruta_comunidad,
        u.nombre_usuario AS chofer
      FROM estudiante e
      LEFT JOIN ruta    r ON r.id_ruta     = e.id_ruta
      LEFT JOIN usuario u ON u.id_usuario  = r.chofer_asignado
      WHERE e.id_estudiante = p_id_est;
  END sp_get_ruta_de_est;

  ----------------------------------------------------------------------
  -- sp_list_permisos
  -- Lista permisos de salida de un estudiante, más recientes primero.
  ----------------------------------------------------------------------
  PROCEDURE sp_list_permisos(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cur FOR
      SELECT
        p.fecha_salida,
        p.motivo,
        p.autorizado_por
      FROM permiso_salida p
      WHERE p.id_estudiante = p_id_est
      ORDER BY p.fecha_salida DESC;
  END sp_list_permisos;

  ----------------------------------------------------------------------
  -- sp_ins_estudiante
  -- Inserta estudiante y retorna el nuevo ID.
  ----------------------------------------------------------------------
  PROCEDURE sp_ins_estudiante(
    p_id_localidad IN NUMBER,
    p_id_ruta      IN NUMBER,
    p_id_encargado IN NUMBER,
    p_nombre       IN VARCHAR2,
    p_ap1          IN VARCHAR2,
    p_ap2          IN VARCHAR2,
    p_telefono     IN VARCHAR2,
    p_fotografia   IN VARCHAR2,
    p_alerta       IN VARCHAR2,
    p_medicamento  IN VARCHAR2,
    p_new_id       OUT NUMBER
  ) IS
  BEGIN
    INSERT INTO estudiante(
      id_localidad, id_ruta, id_encargado,
      nombre, apellido_uno, apellido_dos,
      telefono, fotografia, alerta_medica, medicamento_prescrito
    ) VALUES (
      p_id_localidad, p_id_ruta, p_id_encargado,
      p_nombre, p_ap1, p_ap2,
      p_telefono, p_fotografia, p_alerta, p_medicamento
    )
    RETURNING id_estudiante INTO p_new_id;
  END sp_ins_estudiante;

  ----------------------------------------------------------------------
  -- sp_upd_estudiante
  -- Actualiza la fila del estudiante.
  ----------------------------------------------------------------------
  PROCEDURE sp_upd_estudiante(
    p_id_est       IN NUMBER,
    p_id_localidad IN NUMBER,
    p_id_ruta      IN NUMBER,
    p_id_encargado IN NUMBER,
    p_nombre       IN VARCHAR2,
    p_ap1          IN VARCHAR2,
    p_ap2          IN VARCHAR2,
    p_telefono     IN VARCHAR2,
    p_fotografia   IN VARCHAR2,
    p_alerta       IN VARCHAR2,
    p_medicamento  IN VARCHAR2
  ) IS
  BEGIN
    UPDATE estudiante
       SET id_localidad = p_id_localidad,
           id_ruta      = p_id_ruta,
           id_encargado = p_id_encargado,
           nombre       = p_nombre,
           apellido_uno = p_ap1,
           apellido_dos = p_ap2,
           telefono     = p_telefono,
           fotografia   = p_fotografia,
           alerta_medica= p_alerta,
           medicamento_prescrito = p_medicamento
     WHERE id_estudiante = p_id_est;
  END sp_upd_estudiante;

  ----------------------------------------------------------------------
  -- sp_del_estudiante
  -- Elimina estudiante por ID.
  ----------------------------------------------------------------------
  PROCEDURE sp_del_estudiante(p_id_est IN NUMBER) IS
  BEGIN
    DELETE FROM estudiante WHERE id_estudiante = p_id_est;
  END sp_del_estudiante;

  ----------------------------------------------------------------------
  -- sp_get_estudiante
  -- Devuelve ficha completa del estudiante con ruta y encargado.
  ----------------------------------------------------------------------
  PROCEDURE sp_get_estudiante(
    p_id_est IN NUMBER,
    p_cur    OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN p_cur FOR
      SELECT
        e.id_estudiante,
        e.nombre,
        e.apellido_uno,
        e.apellido_dos,
        e.telefono,
        e.fotografia,
        e.alerta_medica,
        e.medicamento_prescrito,
        r.ruta_comunidad,
        n.nombre_encargado,
        n.telefono_encargado
      FROM estudiante e
      LEFT JOIN ruta      r ON r.id_ruta      = e.id_ruta
      LEFT JOIN encargado n ON n.id_encargado = e.id_encargado
      WHERE e.id_estudiante = p_id_est;
  END sp_get_estudiante;

  ----------------------------------------------------------------------
  -- sp_upd_foto
  -- Actualiza el nombre del archivo de la fotografía.
  ----------------------------------------------------------------------
  PROCEDURE sp_upd_foto(
    p_id_est  IN NUMBER,
    p_file    IN VARCHAR2
  ) IS
  BEGIN
    UPDATE estudiante
       SET fotografia = p_file
     WHERE id_estudiante = p_id_est;
  END sp_upd_foto;

END api_expd;
/
------------------------------------------------------------------------
-- Verificación rápida (opcional)
------------------------------------------------------------------------
SHOW ERRORS PACKAGE api_expd;


------------------------------------------------------------------------