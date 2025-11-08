package servicios;

import conexion.ConexionOracle;
import oracle.jdbc.OracleTypes;
import java.sql.*;
import java.util.*;

public class RutaService {
  public Map<String,Object> rutaDeEstudiante(int idEst) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_get_ruta_de_est(?,?)}")) {
      cs.setInt(1, idEst);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      try (ResultSet rs = (ResultSet) cs.getObject(2)) {
        if (!rs.next()) return null;
        Map<String,Object> m = new LinkedHashMap<>();
        m.put("id_ruta", rs.getInt("id_ruta"));
        m.put("ruta_comunidad", rs.getString("ruta_comunidad"));
        m.put("chofer", rs.getString("chofer"));
        return m;
      }
    }
  }
  public Map<String,Object> rutaDe(int idEst) throws SQLException {
  return rutaDeEstudiante(idEst);
}
}