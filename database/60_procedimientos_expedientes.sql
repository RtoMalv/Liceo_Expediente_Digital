--------------------------------------------------------------------------------
-- PROCEDIMIENTO: LOGIN DE USUARIO
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_login_usuario (
    p_username   IN  VARCHAR2,
    p_password   IN  VARCHAR2,
    p_resultado  OUT VARCHAR2
) AS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM usuario_app
    WHERE username = p_username
      AND pass_hash = fn_hash_password(p_password)
      AND estado = 'A';

    IF v_count = 1 THEN
        p_resultado := 'OK';
    ELSE
        p_resultado := 'ERROR';
    END IF;
END;
/

--------------------------------------------------------------------------------
-- PROCEDIMIENTO: REGISTRAR CONSULTA DE EXPEDIENTE
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_registrar_consulta (
    p_id_usuario    IN NUMBER,
    p_id_estudiante IN NUMBER,
    p_accion        IN VARCHAR2
) AS
BEGIN
    INSERT INTO CONSULTA (
        id_usuario,
        id_estudiante,
        accion
    ) VALUES (
        p_id_usuario,
        p_id_estudiante,
        p_accion
    );
END;
/

--------------------------------------------------------------------------------
-- PROCEDIMIENTO: REGISTRAR PERMISO DE SALIDA
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_registrar_permiso_salida (
    p_id_estudiante   IN NUMBER,
    p_motivo          IN VARCHAR2,
    p_autorizado_por  IN VARCHAR2
) AS
BEGIN
    INSERT INTO PERMISO_SALIDA (
        id_estudiante,
        motivo,
        autorizado_por
    ) VALUES (
        p_id_estudiante,
        p_motivo,
        p_autorizado_por
    );
END;
/

--------------------------------------------------------------------------------
-- PROCEDIMIENTO: OBTENER EXPEDIENTE CONSOLIDADO
--------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_obtener_expediente (
    p_id_estudiante IN  NUMBER,
    p_cursor        OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN p_cursor FOR
        SELECT *
        FROM MV_EXPEDIENTE_CONSOLIDADO
        WHERE id_estudiante = p_id_estudiante;
END;
/

