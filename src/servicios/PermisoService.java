package servicios;

import conexion.ConexionOracle;
import oracle.jdbc.OracleTypes;
import java.sql.*;
import java.util.*;



public class PermisoService {
  public List<Map<String,Object>> listarPorEstudiante(int idEst) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_list_permisos(?,?)}")) {
      cs.setInt(1, idEst);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      try (ResultSet rs = (ResultSet) cs.getObject(2)) {
        List<Map<String,Object>> out = new ArrayList<>();
        while (rs.next()) {
          Map<String,Object> row = new LinkedHashMap<>();
          row.put("fecha_salida", rs.getTimestamp("fecha_salida"));
          row.put("motivo", rs.getString("motivo"));
          row.put("autorizado_por", rs.getString("autorizado_por"));
          out.add(row);
        }
        return out;
      }
    }
  }

  public java.util.List<java.util.Map<String,Object>> permisosDe(int idEst) throws SQLException {
  return listarPorEstudiante(idEst);
}
}
