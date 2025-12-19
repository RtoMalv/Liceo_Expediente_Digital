package app.dao;

import app.config.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AuditoriaDAO {

    public ResultSet listarAuditoria() throws Exception {

        String sql =
            "SELECT id_auditoria, tabla_afectada, operacion, usuario_bd, fecha_evento, detalle " +
            "FROM auditoria_sistema " +
            "ORDER BY fecha_evento DESC";

        Connection conn = DBConnection.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);

        return ps.executeQuery();
    }
}