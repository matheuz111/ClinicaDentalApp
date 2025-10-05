/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
// El paquete debe ser el .dao
package com.dental.app.clinicadentalapp.dao;

// Importamos todas las clases que vamos a necesitar
import com.dental.app.clinicadentalapp.model.Rol;
import com.dental.app.clinicadentalapp.model.Usuario;
import com.dental.app.clinicadentalapp.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;

public class UsuarioDAO {

    /**
     * Valida un usuario por su documento y contraseña contra la base de datos.
     * @param docIdentidad El documento de identidad ingresado en el formulario.
     * @param passwordPlano La contraseña en texto plano ingresada en el formulario.
     * @return Un objeto Usuario completamente populado si las credenciales son correctas, de lo contrario devuelve null.
     */
    public Usuario validarUsuario(String docIdentidad, String passwordPlano) {
    System.out.println("UsuarioDAO: Iniciando validación para documento -> " + docIdentidad);
    Usuario usuario = null;
    String sql = "SELECT u.usuario_id, u.documento_identidad, u.contrasena_hash, r.rol_id, r.nombre_rol " +
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
                String passwordGuardado = rs.getString("contrasena_hash");
                
                // Ponemos las contraseñas entre comillas para detectar espacios en blanco
                System.out.println("    -> Password del formulario: '" + passwordPlano + "'");
                System.out.println("    -> Password de la BD: '" + passwordGuardado + "'");

                if (passwordPlano.equals(passwordGuardado)) {
                    System.out.println("UsuarioDAO: [Paso 3 - Comparación] ¡Las contraseñas COINCIDEN!");
                    usuario = new Usuario();
                    usuario.setUsuarioId(rs.getInt("usuario_id"));
                    usuario.setDocumentoIdentidad(rs.getString("documento_identidad"));
                    
                    Rol rol = new Rol();
                    rol.setRolId(rs.getInt("rol_id"));
                    rol.setNombreRol(rs.getString("nombre_rol"));
                    
                    usuario.setRol(rol);
                } else {
                    System.out.println("UsuarioDAO: [Paso 3 - Comparación] ERROR: ¡Las contraseñas NO coinciden!");
                }
            } else {
                System.out.println("UsuarioDAO: [Paso 2 - Búsqueda] ERROR: NO se encontró ningún usuario con ese documento.");
            }
        }
    } catch (SQLException e) {
        System.out.println("UsuarioDAO: ERROR FATAL de SQL al intentar conectar o ejecutar la consulta.");
        e.printStackTrace(); 
    }
    
    return usuario;
}
}