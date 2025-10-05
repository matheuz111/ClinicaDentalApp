/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// El paquete debe ser el .dao
package com.dental.app.clinicadentalapp.dao;

import com.dental.app.clinicadentalapp.model.Rol;
import com.dental.app.clinicadentalapp.model.Usuario;
import com.dental.app.clinicadentalapp.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    private static final int MAX_INTENTOS_FALLIDOS = 3;

    public enum EstadoValidacion {
        LOGIN_EXITOSO,
        USUARIO_NO_ENCONTRADO,
        PASSWORD_INCORRECTO,
        CUENTA_BLOQUEADA
    }

    public Usuario validarUsuario(String docIdentidad, String passwordPlano, Usuario usuario) {
        System.out.println("UsuarioDAO: Iniciando validación para documento -> " + docIdentidad);
        String sql = "SELECT u.usuario_id, u.documento_identidad, u.contrasena_hash, u.intentos_fallidos, u.bloqueado, r.rol_id, r.nombre_rol " +
                     "FROM Usuarios u " +
                     "INNER JOIN Roles r ON u.rol_id = r.rol_id " +
                     "WHERE u.documento_identidad = ?";

        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("UsuarioDAO: [Paso 1 - Conexión] Conexión a la BD exitosa.");
            pstmt.setString(1, docIdentidad);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    System.out.println("UsuarioDAO: [Paso 2 - Búsqueda] Se ENCONTRÓ un usuario en la BD.");
                    if (rs.getBoolean("bloqueado")) {
                        System.out.println("UsuarioDAO: [Paso 3 - Verificación] El usuario está BLOQUEADO.");
                        usuario.setEstadoValidacion(EstadoValidacion.CUENTA_BLOQUEADA);
                        return null;
                    }

                    String passwordGuardado = rs.getString("contrasena_hash");
                    System.out.println("    -> Password del formulario: '" + passwordPlano + "'");
                    System.out.println("    -> Password de la BD: '" + passwordGuardado + "'");

                    if (BCrypt.checkpw(passwordPlano, passwordGuardado)) {
                        System.out.println("UsuarioDAO: [Paso 3 - Comparación] ¡Las contraseñas COINCIDEN!");
                        reiniciarIntentosFallidos(docIdentidad);
                        usuario.setUsuarioId(rs.getInt("usuario_id"));
                        usuario.setDocumentoIdentidad(rs.getString("documento_identidad"));
                        Rol rol = new Rol();
                        rol.setRolId(rs.getInt("rol_id"));
                        rol.setNombreRol(rs.getString("nombre_rol"));
                        usuario.setRol(rol);
                        usuario.setEstadoValidacion(EstadoValidacion.LOGIN_EXITOSO);
                        return usuario;
                    } else {
                        System.out.println("UsuarioDAO: [Paso 3 - Comparación] ERROR: ¡Las contraseñas NO coinciden!");
                        incrementarIntentosFallidos(docIdentidad);
                        usuario.setEstadoValidacion(EstadoValidacion.PASSWORD_INCORRECTO);
                        return null;
                    }
                } else {
                    System.out.println("UsuarioDAO: [Paso 2 - Búsqueda] ERROR: NO se encontró ningún usuario con ese documento.");
                    usuario.setEstadoValidacion(EstadoValidacion.USUARIO_NO_ENCONTRADO);
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println("UsuarioDAO: ERROR FATAL de SQL al intentar conectar o ejecutar la consulta.");
            e.printStackTrace();
        }
        return null;
    }

    private void incrementarIntentosFallidos(String docIdentidad) {
        String sqlSelect = "SELECT intentos_fallidos FROM Usuarios WHERE documento_identidad = ?";
        String sqlUpdate = "UPDATE Usuarios SET intentos_fallidos = ?, bloqueado = ? WHERE documento_identidad = ?";

        try (Connection conn = ConexionDB.getConnection()) {
            int intentos = 0;
            try (PreparedStatement pstmtSelect = conn.prepareStatement(sqlSelect)) {
                pstmtSelect.setString(1, docIdentidad);
                ResultSet rs = pstmtSelect.executeQuery();
                if (rs.next()) {
                    intentos = rs.getInt("intentos_fallidos");
                }
            }

            intentos++;
            boolean bloquear = intentos >= MAX_INTENTOS_FALLIDOS;

            try (PreparedStatement pstmtUpdate = conn.prepareStatement(sqlUpdate)) {
                pstmtUpdate.setInt(1, intentos);
                pstmtUpdate.setBoolean(2, bloquear);
                pstmtUpdate.setString(3, docIdentidad);
                pstmtUpdate.executeUpdate();
                if (bloquear) {
                    System.out.println("UsuarioDAO: El usuario con documento " + docIdentidad + " ha sido BLOQUEADO.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void reiniciarIntentosFallidos(String docIdentidad) {
        String sql = "UPDATE Usuarios SET intentos_fallidos = 0, bloqueado = 0 WHERE documento_identidad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, docIdentidad);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean registrarUsuario(String docIdentidad, String password) {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        String sql = "INSERT INTO Usuarios (documento_identidad, contrasena_hash, rol_id) VALUES (?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, docIdentidad);
            pstmt.setString(2, hashedPassword);
            pstmt.setInt(3, 4); // Asignar rol de "Paciente" por defecto
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}