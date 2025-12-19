package app.dao;

import app.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ChoferDAO {

    public ResultSet estudiantesPorChofer(String usuarioChofer) throws Exception {

        String sql =
            "SELECT e.id_estudiante, e.nombre, e.apellido_uno, r.ruta_comunidad " +
            "FROM estudiante e " +
            "JOIN ruta r ON e.id_ruta = r.id_ruta " +
            "JOIN usuario u ON r.chofer_asignado = u.id_usuario " +
            "WHERE u.nombre_usuario = ?";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, usuarioChofer);

        return ps.executeQuery();
    }
}
