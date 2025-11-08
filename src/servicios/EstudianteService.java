package servicios;

import conexion.ConexionOracle;
import oracle.jdbc.OracleTypes;
import java.sql.*;
import java.util.*;

public class EstudianteService {

  public int crear(Map<String,Object> e) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_ins_estudiante(?,?,?,?,?,?,?,?,?,?,?)}")) {
      cs.setObject(1, e.get("id_localidad"));
      cs.setObject(2, e.get("id_ruta"));
      cs.setObject(3, e.get("id_encargado"));
      cs.setString(4, (String)e.get("nombre"));
      cs.setString(5, (String)e.get("ap1"));
      cs.setString(6, (String)e.get("ap2"));
      cs.setString(7, (String)e.get("telefono"));
      cs.setString(8, (String)e.get("fotografia"));
      cs.setString(9, (String)e.get("alerta"));
      cs.setString(10,(String)e.get("medicamento"));
      cs.registerOutParameter(11, Types.NUMERIC);
      cs.execute();
      return ((Number) cs.getObject(11)).intValue();
    }
  }

  public void actualizar(int id, Map<String,Object> e) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_upd_estudiante(?,?,?,?,?,?,?,?,?,?,?)}")) {
      cs.setInt(1, id);
      cs.setObject(2, e.get("id_localidad"));
      cs.setObject(3, e.get("id_ruta"));
      cs.setObject(4, e.get("id_encargado"));
      cs.setString(5, (String)e.get("nombre"));
      cs.setString(6, (String)e.get("ap1"));
      cs.setString(7, (String)e.get("ap2"));
      cs.setString(8, (String)e.get("telefono"));
      cs.setString(9, (String)e.get("fotografia"));
      cs.setString(10,(String)e.get("alerta"));
      cs.setString(11,(String)e.get("medicamento"));
      cs.execute();
    }
  }

  public void eliminar(int id) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_del_estudiante(?)}")) {
      cs.setInt(1, id);
      cs.execute();
    }
  }

  public Map<String,Object> obtener(int id) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_get_estudiante(?,?)}")) {
      cs.setInt(1, id);
      cs.registerOutParameter(2, OracleTypes.CURSOR);
      cs.execute();
      try (ResultSet rs = (ResultSet) cs.getObject(2)) {
        if (!rs.next()) return null;
        Map<String,Object> m = new LinkedHashMap<>();
        m.put("id", rs.getInt("id_estudiante"));
        m.put("nombre", rs.getString("nombre"));
        m.put("ap1", rs.getString("apellido_uno"));
        m.put("ap2", rs.getString("apellido_dos"));
        m.put("telefono", rs.getString("telefono"));
        m.put("fotografia", rs.getString("fotografia"));
        m.put("alerta", rs.getString("alerta_medica"));
        m.put("medicamento", rs.getString("medicamento_prescrito"));
        m.put("ruta", rs.getString("ruta_comunidad"));
        m.put("encargado", rs.getString("nombre_encargado"));
        m.put("tel_encargado", rs.getString("telefono_encargado"));
        return m;
      }
    }
  }

  public void actualizarFoto(int idEst, String fileName) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{call api_expd.sp_upd_foto(?,?)}")) {
      cs.setInt(1, idEst);
      cs.setString(2, fileName); // ej: "est_15.jpg"
      cs.execute();
    }
  }

  // Atajo para UI: crea un estudiante con parámetros sueltos
public int crearEstudiante(
    String nombre, String ap1, String ap2,
    String telefono, String fotografia,
    String alerta, String medicamento,
    Integer idLocalidad, Integer idRuta, Integer idEncargado
) throws SQLException {
  Map<String,Object> m = new LinkedHashMap<>();
  m.put("nombre", nombre);
  m.put("ap1", ap1);
  m.put("ap2", ap2);
  m.put("telefono", telefono);
  m.put("fotografia", fotografia);
  m.put("alerta", alerta);
  m.put("medicamento", medicamento);
  m.put("id_localidad", idLocalidad);
  m.put("id_ruta", idRuta);
  m.put("id_encargado", idEncargado);
  return crear(m);
}
}
