package ui.chofer;

import servicios.RutaService;
import servicios.EstudianteService;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.util.Map;

public class ChoferPanel extends JPanel {
    private final JTextField txtId = new JTextField(6);
    private final JButton btnBuscar = new JButton("Buscar");
    private final JTextArea taRuta = new JTextArea(5, 20);
    private final JLabel lblFoto = new JLabel();

    public ChoferPanel(String usuario) {
        setLayout(new BorderLayout(8, 8));

        var top = new JPanel();
        top.add(new JLabel("ID Estudiante:"));
        top.add(txtId);
        top.add(btnBuscar);
        add(top, BorderLayout.NORTH);

        taRuta.setEditable(false);
        add(new JScrollPane(taRuta), BorderLayout.CENTER);

        var right = new JPanel();
        lblFoto.setPreferredSize(new Dimension(140, 140));
        right.add(lblFoto);
        add(right, BorderLayout.EAST);

        btnBuscar.addActionListener(e -> buscar());
    }

    private void buscar() {
        try {
            int id = Integer.parseInt(txtId.getText().trim());

            // --- Ruta (Map) ---
            Map<String, Object> data = new RutaService().rutaDe(id); // alias que llama a rutaDeEstudiante
            if (data == null) {
                taRuta.setText("Sin ruta asignada.");
            } else {
                String ruta = (String) data.get("ruta_comunidad");
                String chofer = (String) data.get("chofer");
                taRuta.setText("Ruta asignada: " + (ruta != null ? ruta : "N/D")
                        + (chofer != null ? "\nChofer: " + chofer : ""));
            }

            // --- Foto del estudiante (opcional, queda bonito) ---
            var est = new EstudianteService().obtener(id);
            if (est != null) {
                String foto = (String) est.get("fotografia"); // ej: "est_1.jpg"
                mostrarFoto(foto);
            } else {
                lblFoto.setIcon(null);
            }

        } catch (NumberFormatException nfe) {
            JOptionPane.showMessageDialog(this, "ID inválido.");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    private void mostrarFoto(String fileName) {
        if (fileName == null || fileName.isBlank()) {
            lblFoto.setIcon(null);
            return;
        }
        File f = new File("photos", fileName);
        if (!f.exists()) {
            lblFoto.setIcon(null);
            return;
        }
        ImageIcon icon = new ImageIcon(f.getAbsolutePath());
        Image img = icon.getImage().getScaledInstance(
                lblFoto.getWidth(), lblFoto.getHeight(), Image.SCALE_SMOOTH);
        lblFoto.setIcon(new ImageIcon(img));
    }
}