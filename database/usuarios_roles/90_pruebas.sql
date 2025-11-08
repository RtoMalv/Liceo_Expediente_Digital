-- ============================================================================
-- Archivo: /sql/90_pruebas.sql
-- Ejecutar como: USUARIO DE PROYECTO
-- Objetivo: probar los 5 procedimientos
-- ============================================================================

-- 1) crear_usuario
VAR v_id NUMBER;
EXEC crear_usuario(p_username=>'mauricio', p_pass_hash=>'hash_demo', p_nombre=>'Mauricio Alvarado', p_email=>'malv@gmail.com', p_id_out=>:v_id);
PRINT v_id;

-- 2) actualizar_usuario
EXEC actualizar_usuario(p_id_usuario=>:v_id, p_nombre=>'Mauricio A.', p_estado=>'A');

-- 3) obtener_usuario_por_id
VAR v_user VARCHAR2(50);
VAR v_nom  VARCHAR2(100);
VAR v_mail VARCHAR2(120);
VAR v_est  CHAR(1);
VAR v_cre  DATE;
EXEC obtener_usuario_por_id(:v_id, :v_user, :v_nom, :v_mail, :v_est, :v_cre);
--PRINT v_user v_nom v_mail v_est v_cre;

-- 4) listar_usuarios (cursor)
VAR c REFCURSOR;
EXEC listar_usuarios(NULL, :c);
PRINT c;

-- 5) eliminar_usuario
EXEC eliminar_usuario(:v_id);