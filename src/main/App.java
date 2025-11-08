package main;

import com.formdev.flatlaf.FlatLightLaf;
import javax.swing.SwingUtilities;
import ui.LoginFrame;

public class App {
    public static void main(String[] args) {
        // Aplica el estilo moderno FlatLaf
        try {
            FlatLightLaf.setup(); // Tema claro (puedes cambiar a FlatDarkLaf si prefieres)
        } catch (Exception ex) {
            System.err.println("⚠️ No se pudo cargar FlatLaf: " + ex.getMessage());
        }

        // Inicia la aplicación en el hilo de interfaz gráfica
        SwingUtilities.invokeLater(() -> {
            new LoginFrame().setVisible(true);
        });
    }
}