package app.dao;

import app.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PermisoSalidaDAO {

    public void registrarPermiso(int idEstudiante, String motivo, String autorizadoPor)
            throws Exception {

        String sql =
            "INSERT INTO permiso_salida (id_estudiante, motivo, autorizado_por) " +
            "VALUES (?, ?, ?)";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, idEstudiante);
            ps.setString(2, motivo);
            ps.setString(3, autorizadoPor);

            ps.executeUpdate();
        }
    }
}