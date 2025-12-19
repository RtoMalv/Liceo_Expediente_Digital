package app.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBConnection {

    private static final String URL =
        "jdbc:oracle:thin:@//172.16.19.128:1521/ORCLPDB";
    private static final String USER = "EXPEDIENTE_DIGITAL";
    private static final String PASS = "admin123";

    public static Connection getConnection() {

        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            System.out.println("✅ Conexión exitosa a Oracle ORCLPDB");

            // 🔍 Verificar usuario y esquema real de la sesión
            try (Statement st = conn.createStatement();
                 ResultSet rs = st.executeQuery(
                     "SELECT USER, SYS_CONTEXT('USERENV','CURRENT_SCHEMA') FROM dual")) {

                if (rs.next()) {
                    System.out.println("DB USER    = " + rs.getString(1));
                    System.out.println("SCHEMA USE = " + rs.getString(2));
                }
            }

            // 🛠️ Forzar esquema correcto (seguro y recomendado)
            try (Statement st = conn.createStatement()) {
                st.execute("ALTER SESSION SET CURRENT_SCHEMA = EXPEDIENTE_DIGITAL");
            }

            return conn;

        } catch (SQLException e) {
            System.err.println("❌ Error al conectar con Oracle");
            e.printStackTrace();
            return null;
        }
    }
}