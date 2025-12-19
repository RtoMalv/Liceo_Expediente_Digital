package app.ui;

import app.dao.UsuarioDAO;

import javax.swing.*;
import java.awt.*;

public class LoginFrame extends JFrame {

    private JTextField txtUser;
    private JPasswordField txtPass;

    // DAO como atributo (buena práctica)
    private final UsuarioDAO usuarioDAO;

    public LoginFrame() {

        this.usuarioDAO = new UsuarioDAO();

        setTitle("Expediente Digital - Login");
        setSize(350, 220);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        initUI();
    }

    private void initUI() {

        JPanel panel = new JPanel(new GridLayout(3, 2, 10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(20, 20, 20, 20));

        // Usuario
        panel.add(new JLabel("Usuario:"));
        txtUser = new JTextField();
        panel.add(txtUser);

        // Contraseña
        panel.add(new JLabel("Contraseña:"));
        txtPass = new JPasswordField();
        panel.add(txtPass);

        // Botón Login
        JButton btnLogin = new JButton("Ingresar");
        btnLogin.addActionListener(e -> login());

        panel.add(new JLabel()); // espacio vacío
        panel.add(btnLogin);

        add(panel);
    }

    private void login() {

        String usuario = txtUser.getText().trim().toUpperCase();
        String password = new String(txtPass.getPassword());

        if (usuario.isEmpty() || password.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                    "Debe ingresar usuario y contraseña",
                    "Validación",
                    JOptionPane.WARNING_MESSAGE);
            return;
        }

        boolean ok = usuarioDAO.login(usuario, password);

        if (ok) {
            JOptionPane.showMessageDialog(this,
                    "Acceso correcto",
                    "Login",
                    JOptionPane.INFORMATION_MESSAGE);

            // Abrir menú principal pasando el usuario autenticado
            new MenuFrame(usuario).setVisible(true);
            dispose();

        } else {
            JOptionPane.showMessageDialog(this,
                    "Credenciales incorrectas",
                    "Login",
                    JOptionPane.ERROR_MESSAGE);
        }
    }
}