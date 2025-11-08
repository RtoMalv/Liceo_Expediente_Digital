package ui;

import auth.AuthService;

import javax.swing.*;
import java.awt.*;

public class LoginFrame extends JFrame {
    private final JTextField tfUser = new JTextField(14);
    private final JPasswordField pfPass = new JPasswordField(14);
    private final JButton btn = new JButton("Ingresar");

    public LoginFrame() {
        setTitle("Expediente Digital - Login");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        var grid = new JPanel(new GridLayout(3, 2, 8, 8));
        grid.add(new JLabel("Usuario:"));      grid.add(tfUser);
        grid.add(new JLabel("Contraseña:"));   grid.add(pfPass);
        grid.add(new JLabel());                grid.add(btn);

        setContentPane(grid);
        getRootPane().setDefaultButton(btn); // Enter = Ingresar
        pack();
        setLocationRelativeTo(null);

        btn.addActionListener(e -> doLogin());
        pfPass.addActionListener(e -> doLogin()); // Enter en el campo password
    }

    private void doLogin() {
        try {
            var svc = new AuthService();
            var sesion = svc.login(tfUser.getText().trim(), new String(pfPass.getPassword()));

            // Éxito: abre la ventana principal
            // Ajusta la firma de MainFrame según tu implementación:
            // Opción A (recomendada): pasar rol, usuario y idUsuario
            // new MainFrame(sesion.rol, tfUser.getText().trim(), sesion.idUsuario).setVisible(true);

            // Opción B (si tu MainFrame actual solo acepta rol y usuario):
            new MainFrame(sesion.rol, tfUser.getText().trim()).setVisible(true);

            dispose();
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Credenciales inválidas o error de conexión.\n" + ex.getMessage(),
                    "Login", JOptionPane.ERROR_MESSAGE);
        }
    }
}