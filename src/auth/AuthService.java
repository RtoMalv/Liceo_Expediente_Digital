package auth;

import conexion.ConexionOracle;
import java.sql.*;

public class AuthService {
  public static final class Sesion {
    public final int idUsuario;
    public final String rol;
    public Sesion(int idUsuario, String rol){ this.idUsuario=idUsuario; this.rol=rol; }
  }

  public Sesion login(String user, String pass) throws SQLException {
    try (Connection c = ConexionOracle.get();
         CallableStatement cs = c.prepareCall("{ call api_expd.sp_login(?,?,?,?,?) }")) {

      // IN
      cs.setString(1, user);
      cs.setString(2, pass);

      // OUT: ok, rol, id
      cs.registerOutParameter(3, Types.NUMERIC);  // p_ok
      cs.registerOutParameter(4, Types.VARCHAR);  // p_rol
      cs.registerOutParameter(5, Types.NUMERIC);  // p_id

      cs.execute();

      int ok = cs.getInt(3);
      String rol = cs.getString(4);
      int idUsuario = cs.getInt(5);

      if (ok != 1 || rol == null) {
        throw new SQLException("Credenciales inválidas");
      }
      return new Sesion(idUsuario, rol);
    }
  }
}
