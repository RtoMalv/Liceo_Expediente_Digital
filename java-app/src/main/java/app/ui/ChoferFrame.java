package app.ui;

import app.dao.ChoferDAO;

import javax.swing.*;
import java.awt.*;
import java.sql.ResultSet;

public class ChoferFrame extends JFrame {

    private JTextArea txtResultado;
    private final String usuarioChofer;

    public ChoferFrame(String usuarioChofer) {

        this.usuarioChofer = usuarioChofer;

        setTitle("Estudiantes asignados a mi ruta");
        setSize(500, 300);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        initUI();
        cargarEstudiantes();
    }

    private void initUI() {
        txtResultado = new JTextArea();
        txtResultado.setEditable(false);
        add(new JScrollPane(txtResultado), BorderLayout.CENTER);
    }

    private void cargarEstudiantes() {

        try {
            ChoferDAO dao = new ChoferDAO();
            ResultSet rs = dao.estudiantesPorChofer(usuarioChofer);

            StringBuilder sb = new StringBuilder();

            while (rs.next()) {
                sb.append("ID: ").append(rs.getInt("id_estudiante")).append("\n");
                sb.append("Nombre: ").append(rs.getString("nombre")).append(" ");
                sb.append(rs.getString("apellido_uno")).append("\n");
                sb.append("Ruta: ").append(rs.getString("ruta_comunidad")).append("\n");
                sb.append("---------------------------------\n");
            }

            txtResultado.setText(sb.toString());

        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Error al cargar estudiantes");
            e.printStackTrace();
        }
    }
}