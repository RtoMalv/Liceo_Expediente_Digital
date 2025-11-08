package conexion;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionOracle {
    // Ajusta tu servicio (ej: ORCLPDB o XEPDB1)
    private static final String URL  = "jdbc:oracle:thin:@//172.16.19.130:1521/ORCLPDB";
    private static final String USER = "expediente_digital";
    private static final String PASS = "admin123";

    public static Connection get() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
