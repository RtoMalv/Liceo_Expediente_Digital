package ui;

import ui.asistente.EstudiantePanel;
import ui.guarda.GuardaPanel;
import ui.chofer.ChoferPanel;
import javax.swing.*;

public class MainFrame extends JFrame {
    public MainFrame(String rol, String usuario) {
        setTitle("Expediente Digital - " + rol + " - " + usuario);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        switch (rol) {
            case "ASISTENTE" -> setContentPane(new EstudiantePanel(usuario));
            case "GUARDA"    -> setContentPane(new GuardaPanel(usuario));
            case "CHOFER"    -> setContentPane(new ChoferPanel(usuario));
            default -> setContentPane(new JLabel("Rol no reconocido: " + rol));
        }
        pack(); setLocationRelativeTo(null);
    }
}
