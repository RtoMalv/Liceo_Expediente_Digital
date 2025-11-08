-- Procedimientos y funciones para cubrir RF01–RF06

-- Login
CREATE OR REPLACE PROCEDURE sp_login(p_usuario IN VARCHAR2, p_contra IN VARCHAR2,
                                     p_ok OUT NUMBER, p_rol OUT VARCHAR2) AS
BEGIN
  SELECT COUNT(*), MAX(rol) INTO p_ok, p_rol
  FROM USUARIO WHERE nombre_usuario=p_usuario AND contrasenia=p_contra;
END;
/
-- Insert estudiante
CREATE OR REPLACE PROCEDURE sp_estudiante_insert(
  p_nombre IN VARCHAR2, p_ap1 IN VARCHAR2, p_ap2 IN VARCHAR2,
  p_id_localidad IN NUMBER, p_id_ruta IN NUMBER, p_id_encargado IN NUMBER,
  p_telefono IN VARCHAR2, p_alerta IN VARCHAR2, p_med IN VARCHAR2,
  p_id_usuario IN NUMBER, p_id_new OUT NUMBER
) AS
BEGIN
  INSERT INTO ESTUDIANTE(nombre,apellido_uno,apellido_dos,id_localidad,id_ruta,
                         id_encargado,telefono,alerta_medica,medicamento_prescrito)
  VALUES(p_nombre,p_ap1,p_ap2,p_id_localidad,p_id_ruta,p_id_encargado,
         p_telefono,p_alerta,p_med)
  RETURNING id_estudiante INTO p_id_new;

  INSERT INTO CONSULTA(id_usuario,id_estudiante,fecha_consulta,accion)
  VALUES(p_id_usuario,p_id_new,SYSTIMESTAMP,'INSERT');
END;
/
-- Update estudiante
CREATE OR REPLACE PROCEDURE sp_estudiante_update(
  p_id IN NUMBER, p_nombre IN VARCHAR2, p_ap1 IN VARCHAR2, p_ap2 IN VARCHAR2,
  p_id_localidad IN NUMBER, p_id_ruta IN NUMBER, p_id_encargado IN NUMBER,
  p_telefono IN VARCHAR2, p_alerta IN VARCHAR2, p_med IN VARCHAR2,
  p_id_usuario IN NUMBER
) AS
BEGIN
  UPDATE ESTUDIANTE
  SET nombre=p_nombre, apellido_uno=p_ap1, apellido_dos=p_ap2,
      id_localidad=p_id_localidad, id_ruta=p_id_ruta, id_encargado=p_id_encargado,
      telefono=p_telefono, alerta_medica=p_alerta, medicamento_prescrito=p_med
  WHERE id_estudiante=p_id;

  INSERT INTO CONSULTA(id_usuario,id_estudiante,fecha_consulta,accion)
  VALUES(p_id_usuario,p_id,SYSTIMESTAMP,'UPDATE');
END;
/
-- Get estudiante (datos básicos)
CREATE OR REPLACE PROCEDURE sp_estudiante_get(
  p_id IN NUMBER,
  p_nombre OUT VARCHAR2, p_ap1 OUT VARCHAR2, p_ap2 OUT VARCHAR2,
  p_foto OUT VARCHAR2, p_alerta OUT VARCHAR2, p_med OUT VARCHAR2
) AS
BEGIN
  SELECT nombre,apellido_uno,apellido_dos,fotografia,alerta_medica,medicamento_prescrito
  INTO p_nombre,p_ap1,p_ap2,p_foto,p_alerta,p_med
  FROM ESTUDIANTE WHERE id_estudiante=p_id;
END;
/
-- Actualizar foto
CREATE OR REPLACE PROCEDURE sp_estudiante_actualizar_foto(
  p_id_estudiante IN NUMBER, p_ruta_foto IN VARCHAR2, p_id_usuario IN NUMBER
) AS
BEGIN
  UPDATE ESTUDIANTE SET fotografia=p_ruta_foto WHERE id_estudiante=p_id_estudiante;
  INSERT INTO CONSULTA(id_usuario,id_estudiante,fecha_consulta,accion)
  VALUES(p_id_usuario,p_id_estudiante,SYSTIMESTAMP,'UPDATE');
END;
/
-- Permisos por estudiante
CREATE OR REPLACE PROCEDURE sp_permisos_por_estudiante(
  p_id_estudiante IN NUMBER, p_cursor OUT SYS_REFCURSOR
) AS
BEGIN
  OPEN p_cursor FOR
  SELECT id_permiso, fecha_salida, motivo, autorizado_por
  FROM PERMISO_SALIDA WHERE id_estudiante=p_id_estudiante ORDER BY fecha_salida DESC;
END;
/
-- Ruta por estudiante
CREATE OR REPLACE PROCEDURE sp_ruta_por_estudiante(
  p_id_estudiante IN NUMBER, p_ruta OUT VARCHAR2
) AS
BEGIN
  SELECT r.ruta_comunidad INTO p_ruta
  FROM ESTUDIANTE e JOIN RUTA r ON e.id_ruta=r.id_ruta
  WHERE e.id_estudiante=p_id_estudiante;
END;
/
