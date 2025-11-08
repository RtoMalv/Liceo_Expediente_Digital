package servicios;

import conexion.ConexionOracle;
import java.sql.CallableStatement;
import java.sql.Connection;

public class LogService {

  /** Registra una acción en la tabla CONSULTA vía api_expd.sp_log_consulta */
  public void registrarConsulta(int idUsuario, int idEstudiante, String accion) {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_log_consulta(?,?,?)}")) {
      cs.setInt(1, idUsuario);
      cs.setInt(2, idEstudiante);
      cs.setString(3, accion);
      cs.execute();
    } catch (Exception ignore) {
      // No rompas el flujo por un fallo de auditoría; si quieres, imprime a consola
      // ignore.printStackTrace();
    }
  }
}