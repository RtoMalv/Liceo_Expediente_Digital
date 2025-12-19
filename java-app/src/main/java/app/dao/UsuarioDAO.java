package app.dao;

import app.config.DBConnection;
import app.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UsuarioDAO {

    public boolean login(String username, String password) {

        String sql =
            "SELECT 1 " +
            "FROM usuario_app " +
            "WHERE UPPER(username) = ? " +
            "AND pass_hash = ? " +
            "AND estado = 'A'";

        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)
        ) {

            ps.setString(1, username.trim().toUpperCase());
            ps.setString(2, PasswordUtil.sha256(password));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}