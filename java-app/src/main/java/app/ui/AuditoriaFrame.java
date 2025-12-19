package app.ui;

import app.dao.AuditoriaDAO;

import javax.swing.*;
import java.awt.*;
import java.sql.ResultSet;

public class AuditoriaFrame extends JFrame {

    private JTextArea txtAuditoria;

    public AuditoriaFrame() {

        setTitle("Auditoría del Sistema");
        setSize(600, 350);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        initUI();
        cargarAuditoria();
    }

    private void initUI() {

        txtAuditoria = new JTextArea();
        txtAuditoria.setEditable(false);

        add(new JScrollPane(txtAuditoria), BorderLayout.CENTER);
    }

    private void cargarAuditoria() {

        try {
            AuditoriaDAO dao = new AuditoriaDAO();
            ResultSet rs = dao.listarAuditoria();

            StringBuilder sb = new StringBuilder();

            while (rs.next()) {
                sb.append("ID: ").append(rs.getInt("id_auditoria")).append("\n");
                sb.append("Tabla: ").append(rs.getString("tabla_afectada")).append("\n");
                sb.append("Operación: ").append(rs.getString("operacion")).append("\n");
                sb.append("Usuario BD: ").append(rs.getString("usuario_bd")).append("\n");
                sb.append("Fecha: ").append(rs.getTimestamp("fecha_evento")).append("\n");
                sb.append("Detalle: ").append(rs.getString("detalle")).append("\n");
                sb.append("-------------------------------------\n");
            }

            txtAuditoria.setText(sb.toString());

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error al cargar auditoría");
            e.printStackTrace();
        }
    }
}