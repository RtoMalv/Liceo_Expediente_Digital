package servicios;

import java.sql.SQLException;

public class FotoService {

  /**
   * Actualiza la foto del estudiante y registra auditoría.
   * @param idEstudiante  ID del estudiante
   * @param fileName      nombre del archivo (ej: "est_15.jpg")
   * @param idUsuario     usuario que realiza el cambio
   */
  public void actualizarFoto(int idEstudiante, String fileName, int idUsuario) throws SQLException {
    // Actualiza la columna FOTOGRAFIA
    new EstudianteService().actualizarFoto(idEstudiante, fileName);

    // Auditoría / registro de acceso/modificación
    new LogService().registrarConsulta(idUsuario, idEstudiante, "FOTO_ACTUALIZADA");
  }
}
