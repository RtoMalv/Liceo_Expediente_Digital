package app.ui;

import app.dao.EstudianteDAO;

import javax.swing.*;
import java.awt.*;
import java.sql.ResultSet;

public class EstudianteFrame extends JFrame {

    private JTextField txtId;
    private JTextArea txtResultado;

    public EstudianteFrame() {

        setTitle("Consulta de Estudiante");
        setSize(450, 300);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        initUI();
    }

    private void initUI() {

        JPanel panelTop = new JPanel(new FlowLayout());
        panelTop.add(new JLabel("ID Estudiante:"));
        txtId = new JTextField(10);
        panelTop.add(txtId);

        JButton btnBuscar = new JButton("Buscar");
        panelTop.add(btnBuscar);

        txtResultado = new JTextArea();
        txtResultado.setEditable(false);

        btnBuscar.addActionListener(e -> buscar());

        add(panelTop, BorderLayout.NORTH);
        add(new JScrollPane(txtResultado), BorderLayout.CENTER);
    }

    private void buscar() {

        try {
            int id = Integer.parseInt(txtId.getText());
            EstudianteDAO dao = new EstudianteDAO();
            ResultSet rs = dao.buscarPorId(id);

            if (rs.next()) {
                txtResultado.setText(
                    "ID: " + rs.getInt("id_estudiante") + "\n" +
                    "Nombre: " + rs.getString("nombre") + "\n" +
                    "Apellido 1: " + rs.getString("apellido_uno") + "\n" +
                    "Apellido 2: " + rs.getString("apellido_dos") + "\n" +
                    "Alerta médica: " + rs.getString("alerta_medica")
                );
            } else {
                txtResultado.setText("No se encontró el estudiante.");
            }

        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al consultar estudiante");
            ex.printStackTrace();
        }
    }
}