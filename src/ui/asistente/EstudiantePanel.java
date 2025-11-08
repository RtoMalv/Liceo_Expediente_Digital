package ui.asistente;

import servicios.EstudianteService;
import servicios.FotoService;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class EstudiantePanel extends JPanel {
    private final JTextField txtId = new JTextField(6);
    private final JTextField txtNombre = new JTextField(16);
    private final JTextField txtAp1 = new JTextField(16);
    private final JTextField txtAp2 = new JTextField(16);
    private final JButton btnGuardar = new JButton("Guardar");
    private final JButton btnFoto = new JButton("Actualizar foto");
    private final JLabel lblFoto = new JLabel();
    private final String usuario;

    public EstudiantePanel(String usuario) {
        this.usuario = usuario;
        setLayout(new BorderLayout(8, 8));

        var form = new JPanel(new GridLayout(0, 2, 6, 6));
        form.add(new JLabel("ID:"));        form.add(txtId);
        form.add(new JLabel("Nombre:"));    form.add(txtNombre);
        form.add(new JLabel("Apellido 1:"));form.add(txtAp1);
        form.add(new JLabel("Apellido 2:"));form.add(txtAp2);

        var botones = new JPanel();
        botones.add(btnGuardar);
        botones.add(btnFoto);

        var left = new JPanel(new BorderLayout());
        left.add(form, BorderLayout.CENTER);
        left.add(botones, BorderLayout.SOUTH);

        var imgPanel = new JPanel();
        lblFoto.setPreferredSize(new Dimension(140, 140));
        imgPanel.add(lblFoto);

        add(left, BorderLayout.CENTER);
        add(imgPanel, BorderLayout.EAST);

        btnGuardar.addActionListener(e -> guardar());
        btnFoto.addActionListener(e -> actualizarFoto());
    }

    private int getIdUsuarioActual() { // demo
        return 1;
    }

    private void guardar() {
        try {
            int nuevoId = new EstudianteService().crearEstudiante(
                    txtNombre.getText(), txtAp1.getText(), txtAp2.getText(),
                    null, null, null, null,
                    null, null,           // id_localidad, id_ruta
                    getIdUsuarioActual()  // id_encargado (solo para pruebas)
            );
            txtId.setText(String.valueOf(nuevoId));
            JOptionPane.showMessageDialog(this, "Guardado. ID=" + nuevoId);
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error al guardar: " + ex.getMessage());
        }
    }

    private void actualizarFoto() {
        // Validar que exista ID
        if (txtId.getText().isBlank()) {
            JOptionPane.showMessageDialog(this, "Primero guarda el estudiante para obtener un ID.");
            return;
        }

        var fc = new JFileChooser();
        if (fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            try {
                int idEst = Integer.parseInt(txtId.getText().trim());
                File origen = fc.getSelectedFile();

                // Estándar: est_<id>.<ext>
                String ext = "";
                String name = origen.getName();
                int dot = name.lastIndexOf('.');
                if (dot >= 0) ext = name.substring(dot); // incluye el punto

                String fileName = "est_" + idEst + ext;      // <- lo que guardaremos en BD
                File destino = new File("photos", fileName); // carpeta local del proyecto
                destino.getParentFile().mkdirs();

                // Copia física
                Files.copy(origen.toPath(), destino.toPath(), StandardCopyOption.REPLACE_EXISTING);

                // Actualiza en BD (solo el nombre del archivo)
                new FotoService().actualizarFoto(idEst, fileName, getIdUsuarioActual());

                // Render en UI (escalado)
                ImageIcon icon = new ImageIcon(destino.getAbsolutePath());
                Image img = icon.getImage().getScaledInstance(140, 140, Image.SCALE_SMOOTH);
                lblFoto.setIcon(new ImageIcon(img));

                JOptionPane.showMessageDialog(this, "Fotografía actualizada.");
            } catch (NumberFormatException nfe) {
                JOptionPane.showMessageDialog(this, "ID inválido.");
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Error al actualizar la foto: " + ex.getMessage());
            }
        }
    }
}