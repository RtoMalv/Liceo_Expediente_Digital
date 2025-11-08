package ui.guarda;

import servicios.PermisoService;
import servicios.EstudianteService;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.io.File;
import java.util.List;
import java.util.Map;

public class GuardaPanel extends JPanel {
    private final JTextField txtId = new JTextField(6);
    private final JButton btnBuscar = new JButton("Buscar");
    private final JTable tabla = new JTable();
    private final JLabel lblFoto = new JLabel();

    public GuardaPanel(String usuario) {
        setLayout(new BorderLayout(8, 8));

        var top = new JPanel();
        top.add(new JLabel("ID Estudiante:"));
        top.add(txtId);
        top.add(btnBuscar);
        add(top, BorderLayout.NORTH);

        // Tabla de permisos (solo lectura)
        tabla.setModel(emptyModel());
        add(new JScrollPane(tabla), BorderLayout.CENTER);

        // Lateral derecho con foto
        var right = new JPanel();
        lblFoto.setPreferredSize(new Dimension(140, 140));
        right.add(lblFoto);
        add(right, BorderLayout.EAST);

        btnBuscar.addActionListener(e -> buscar());
    }

    private void buscar() {
        try {
            int id = Integer.parseInt(txtId.getText().trim());

            // 1) Permisos -> convertir a TableModel
            List<Map<String, Object>> permisos = new PermisoService().permisosDe(id);
            tabla.setModel(toPermisosModel(permisos));

            // 2) Foto del estudiante (opcional, queda muy útil en portería)
            var est = new EstudianteService().obtener(id);
            if (est != null) {
                String fileName = (String) est.get("fotografia"); // ej: "est_1.jpg"
                mostrarFoto(fileName);
            } else {
                lblFoto.setIcon(null);
            }

        } catch (NumberFormatException nfe) {
            JOptionPane.showMessageDialog(this, "ID inválido.");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
        }
    }

    // ---------- Helpers ----------

    private DefaultTableModel emptyModel() {
        return new DefaultTableModel(new String[]{"Fecha/Hora", "Motivo", "Autorizado por"}, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
    }

    private DefaultTableModel toPermisosModel(List<Map<String, Object>> filas) {
        DefaultTableModel m = emptyModel();
        if (filas != null) {
            for (var row : filas) {
                Object fecha = row.get("fecha_salida");
                Object mot   = row.get("motivo");
                Object aut   = row.get("autorizado_por");
                m.addRow(new Object[]{fecha, mot, aut});
            }
        }
        return m;
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