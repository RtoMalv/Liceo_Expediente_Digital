package app.ui;

import app.dao.PermisoSalidaDAO;

import javax.swing.*;
import java.awt.*;

public class PermisoSalidaFrame extends JFrame {

    private JTextField txtIdEstudiante;
    private JTextField txtMotivo;
    private JTextField txtAutorizado;

    public PermisoSalidaFrame() {

        setTitle("Registro de Permiso de Salida");
        setSize(400, 260);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        initUI();
    }

    private void initUI() {

        JPanel panel = new JPanel(new GridLayout(4, 2, 10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));

        panel.add(new JLabel("ID Estudiante:"));
        txtIdEstudiante = new JTextField();
        panel.add(txtIdEstudiante);

        panel.add(new JLabel("Motivo:"));
        txtMotivo = new JTextField();
        panel.add(txtMotivo);

        panel.add(new JLabel("Autorizado por:"));
        txtAutorizado = new JTextField();
        panel.add(txtAutorizado);

        JButton btnGuardar = new JButton("Registrar Permiso");
        JButton btnCancelar = new JButton("Cerrar");

        btnGuardar.addActionListener(e -> guardarPermiso());
        btnCancelar.addActionListener(e -> dispose());

        panel.add(btnCancelar);
        panel.add(btnGuardar);

        add(panel);
    }

    private void guardarPermiso() {

        try {
            int idEstudiante = Integer.parseInt(txtIdEstudiante.getText());
            String motivo = txtMotivo.getText();
            String autorizado = txtAutorizado.getText();

            PermisoSalidaDAO dao = new PermisoSalidaDAO();
            dao.registrarPermiso(idEstudiante, motivo, autorizado);

            JOptionPane.showMessageDialog(this, "Permiso registrado correctamente");
            dispose();

        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al registrar permiso");
            ex.printStackTrace();
        }
    }
}