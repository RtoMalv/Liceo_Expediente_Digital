package app.ui;

import javax.swing.*;
import java.awt.*;

public class MenuFrame extends JFrame {

    private final String usuario;

    public MenuFrame(String usuario) {

        this.usuario = usuario;

        setTitle("Expediente Digital - Menú Principal");
        setSize(420, 320);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        initUI();
    }

    private void initUI() {

        JPanel panel = new JPanel(new GridLayout(5, 1, 12, 12));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 40, 20, 40));

        JLabel lblUsuario = new JLabel("Usuario: " + usuario, SwingConstants.CENTER);
        lblUsuario.setFont(new Font("Arial", Font.BOLD, 14));

        JButton btnEstudiantes = new JButton("Consultar Estudiantes");
        JButton btnPermisos = new JButton("Permisos de Salida");
        JButton btnChofer = new JButton("Mi Ruta (Chofer)");
        JButton btnAuditoria = new JButton("Auditoría del Sistema");
        JButton btnSalir = new JButton("Cerrar sesión");

        // ---- ACCIONES ----

        btnEstudiantes.addActionListener(e ->
            new EstudianteFrame().setVisible(true)
        );

        btnPermisos.addActionListener(e ->
            new PermisoSalidaFrame().setVisible(true)
        );

        btnChofer.addActionListener(e ->
            new ChoferFrame(usuario).setVisible(true)
        );

        btnAuditoria.addActionListener(e ->
            new AuditoriaFrame().setVisible(true)
        );

        btnSalir.addActionListener(e -> {
            dispose();
            new LoginFrame().setVisible(true);
        });

        // ---- CONTROL POR ROL (simple y defendible) ----
        // ADMIN: todo
        // Otros usuarios: solo chofer

        if (!usuario.equals("ADMIN")) {
            btnEstudiantes.setEnabled(false);
            btnAuditoria.setEnabled(false);
        }

        // ---- AGREGAR AL PANEL ----
        panel.add(lblUsuario);
        panel.add(btnEstudiantes);
        panel.add(btnPermisos);
        panel.add(btnChofer);
        panel.add(btnAuditoria);
        panel.add(btnSalir);

        add(panel);
    }
}