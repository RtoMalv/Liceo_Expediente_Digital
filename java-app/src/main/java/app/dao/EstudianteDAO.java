package app.dao;

import app.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class EstudianteDAO {

    public ResultSet buscarPorId(int idEstudiante) throws Exception {

        String sql =
            "SELECT id_estudiante, nombre, apellido_uno, apellido_dos, alerta_medica " +
            "FROM estudiante " +
            "WHERE id_estudiante = ?";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, idEstudiante);

        return ps.executeQuery();
    }
}