/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dental.app.clinicadentalapp.dao;

import com.dental.app.clinicadentalapp.model.Paciente;
import com.dental.app.clinicadentalapp.model.Usuario;
import com.dental.app.clinicadentalapp.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Matheus
 */
public class PacienteDAO {
    /**
     * Obtiene una lista de todos los pacientes de la base de datos.
     * @return Una lista de objetos Paciente.
     */
    public List<Paciente> listarPacientes() {
        List<Paciente> pacientes = new ArrayList<>();
        // Unimos Pacientes y Usuarios para obtener todos los datos necesarios
        String sql = "SELECT p.*, u.documento_identidad FROM Pacientes p " +
                     "JOIN Usuarios u ON p.usuario_id = u.usuario_id ORDER BY p.nombre, p.apellido";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Paciente paciente = new Paciente();
                paciente.setPacienteId(rs.getInt("paciente_id"));
                paciente.setNombre(rs.getString("nombre"));
                paciente.setApellido(rs.getString("apellido"));
                paciente.setEmail(rs.getString("email"));
                paciente.setAlergias(rs.getString("alergias"));
                // etc. (puedes agregar los demás campos si los necesitas en la tabla)

                Usuario usuario = new Usuario();
                usuario.setUsuarioId(rs.getInt("usuario_id"));
                usuario.setDocumentoIdentidad(rs.getString("documento_identidad"));
                
                paciente.setUsuario(usuario);
                pacientes.add(paciente);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pacientes;
    }
    
    /**
     * Registra un nuevo paciente. Esto implica dos pasos:
     * 1. Crear un registro en la tabla Usuarios.
     * 2. Crear un registro en la tabla Pacientes con el ID del nuevo usuario.
     * @param paciente El objeto paciente con los datos a registrar.
     * @return true si el registro fue exitoso, false en caso contrario.
     */
    public boolean registrarPaciente(Paciente paciente) {
        // La contraseña por defecto será el DNI. El paciente deberá cambiarla después.
        String defaultPassword = paciente.getUsuario().getDocumentoIdentidad();
        String hashedPassword = BCrypt.hashpw(defaultPassword, BCrypt.gensalt());
        
        // Rol de Paciente es 4, según tu script de BD
        int rolPaciente = 4; 
        
        // MODIFICADO: Añadido el campo 'genero' a la consulta SQL
        String sqlUsuario = "INSERT INTO Usuarios (documento_identidad, contrasena_hash, rol_id) VALUES (?, ?, ?) RETURNING usuario_id";
        String sqlPaciente = "INSERT INTO Pacientes (usuario_id, nombre, apellido, email, genero) VALUES (?, ?, ?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false);
            
            int nuevoUsuarioId = 0;
            
            // 1. Insertar en Usuarios y obtener el ID generado
            try (PreparedStatement pstmtUsuario = conn.prepareStatement(sqlUsuario)) {
                pstmtUsuario.setString(1, paciente.getUsuario().getDocumentoIdentidad());
                pstmtUsuario.setString(2, hashedPassword);
                pstmtUsuario.setInt(3, rolPaciente);
                
                ResultSet rs = pstmtUsuario.executeQuery();
                if (rs.next()) {
                    nuevoUsuarioId = rs.getInt(1);
                } else {
                    throw new SQLException("No se pudo obtener el ID del nuevo usuario.");
                }
            }
            
            // 2. Insertar en Pacientes usando el ID obtenido
            try (PreparedStatement pstmtPaciente = conn.prepareStatement(sqlPaciente)) {
                pstmtPaciente.setInt(1, nuevoUsuarioId);
                pstmtPaciente.setString(2, paciente.getNombre());
                pstmtPaciente.setString(3, paciente.getApellido());
                pstmtPaciente.setString(4, paciente.getEmail());
                // MODIFICADO: Añadido el valor para el campo genero
                pstmtPaciente.setString(5, paciente.getGenero()); 
                pstmtPaciente.executeUpdate();
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // ==================================================================
    // ================ NUEVOS MÉTODOS AÑADIDOS AQUÍ ====================
    // ==================================================================

    /**
     * Busca y devuelve un único paciente basado en su ID.
     * @param pacienteId El ID del paciente a buscar.
     * @return Un objeto Paciente con todos sus datos, o null si no se encuentra.
     */
    public Paciente obtenerPacientePorId(int pacienteId) {
        Paciente paciente = null;
        String sql = "SELECT p.*, u.documento_identidad FROM Pacientes p " +
                     "JOIN Usuarios u ON p.usuario_id = u.usuario_id WHERE p.paciente_id = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, pacienteId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    paciente = new Paciente();
                    paciente.setPacienteId(rs.getInt("paciente_id"));
                    paciente.setNombre(rs.getString("nombre"));
                    paciente.setApellido(rs.getString("apellido"));
                    paciente.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    paciente.setGenero(rs.getString("genero"));
                    paciente.setTelefono(rs.getString("telefono"));
                    paciente.setEmail(rs.getString("email"));
                    paciente.setDireccion(rs.getString("direccion"));
                    paciente.setAlergias(rs.getString("alergias"));

                    Usuario usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt("usuario_id"));
                    usuario.setDocumentoIdentidad(rs.getString("documento_identidad"));
                    paciente.setUsuario(usuario);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paciente;
    }

    /**
     * Actualiza los datos de un paciente en la base de datos.
     * @param paciente El objeto Paciente con la información actualizada.
     * @return true si la actualización fue exitosa, false en caso contrario.
     */
    public boolean actualizarPaciente(Paciente paciente) {
        String sql = "UPDATE Pacientes SET nombre = ?, apellido = ?, fecha_nacimiento = ?, " +
                     "genero = ?, telefono = ?, email = ?, direccion = ?, alergias = ? " +
                     "WHERE paciente_id = ?";
        
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, paciente.getNombre());
            pstmt.setString(2, paciente.getApellido());
            // java.util.Date a java.sql.Date
            if (paciente.getFechaNacimiento() != null) {
                pstmt.setDate(3, new java.sql.Date(paciente.getFechaNacimiento().getTime()));
            } else {
                pstmt.setNull(3, java.sql.Types.DATE);
            }
            pstmt.setString(4, paciente.getGenero());
            pstmt.setString(5, paciente.getTelefono());
            pstmt.setString(6, paciente.getEmail());
            pstmt.setString(7, paciente.getDireccion());
            pstmt.setString(8, paciente.getAlergias());
            pstmt.setInt(9, paciente.getPacienteId());
            
            return pstmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Elimina un paciente de la base de datos.
     * Esto debe hacerse como una transacción para borrar primero el registro
     * del paciente y luego el registro del usuario asociado.
     * @param pacienteId El ID del paciente a eliminar.
     * @return true si la eliminación fue exitosa, false en caso contrario.
     */
    public boolean eliminarPaciente(int pacienteId) {
        String sqlSelectUsuarioId = "SELECT usuario_id FROM Pacientes WHERE paciente_id = ?";
        String sqlDeletePaciente = "DELETE FROM Pacientes WHERE paciente_id = ?";
        String sqlDeleteUsuario = "DELETE FROM Usuarios WHERE usuario_id = ?";
        
        Connection conn = null;
        try {
            conn = ConexionDB.getConnection();
            conn.setAutoCommit(false); // Iniciar transacción

            int usuarioId = -1;

            // 1. Obtener el usuario_id asociado al paciente
            try (PreparedStatement pstmt = conn.prepareStatement(sqlSelectUsuarioId)) {
                pstmt.setInt(1, pacienteId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    usuarioId = rs.getInt("usuario_id");
                } else {
                    throw new SQLException("Paciente no encontrado, no se puede eliminar.");
                }
            }

            // 2. Eliminar de la tabla Pacientes
            try (PreparedStatement pstmt = conn.prepareStatement(sqlDeletePaciente)) {
                pstmt.setInt(1, pacienteId);
                pstmt.executeUpdate();
            }

            // 3. Eliminar de la tabla Usuarios
            try (PreparedStatement pstmt = conn.prepareStatement(sqlDeleteUsuario)) {
                pstmt.setInt(1, usuarioId);
                pstmt.executeUpdate();
            }

            conn.commit(); // Confirmar transacción
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Revertir en caso de error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}