package com.dental.app.clinicadentalapp.dao;

import com.dental.app.clinicadentalapp.model.Usuario;
import com.dental.app.clinicadentalapp.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class UsuarioDAOTest {

    // Datos del usuario que se usará para la prueba de registro
    private static final String TEST_DNI = "98765432";

    /**
     * Este método se ejecuta ANTES de cada prueba.
     * Su función es eliminar cualquier rastro del usuario de prueba para asegurar
     * que la base de datos esté en un estado limpio y predecible.
     */
    @BeforeEach
    @AfterEach // También lo ejecutamos después para una limpieza completa
    public void cleanupDatabase() {
        System.out.println("--- LIMPIANDO USUARIO DE PRUEBA (" + TEST_DNI + ") ---");
        String sql = "DELETE FROM Usuarios WHERE documento_identidad = ?";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, TEST_DNI);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error limpiando la base de datos: " + e.getMessage());
        }
    }

    @Test
    public void testValidarUsuarioExitoso() {
        // ... (código sin cambios)
    }

    @Test
    public void testValidarUsuarioFallido_PasswordIncorrecto() {
        // ... (código sin cambios)
    }

    @Test
    public void testValidarUsuarioFallido_UsuarioNoExiste() {
        // ... (código sin cambios)
    }

    /**
     * Prueba el registro de un nuevo usuario. Gracias a cleanupDatabase(),
     * esta prueba siempre se ejecutará como si fuera la primera vez.
     */
    @Test
    public void testRegistrarUsuarioExitoso() {
        System.out.println("Ejecutando test: Registrar Usuario con Contraseña Válida");
        UsuarioDAO dao = new UsuarioDAO();
        
        String password = "Seguro123#";
        
        boolean resultado = dao.registrarUsuario(TEST_DNI, password);
        
        assertTrue(resultado, "El registro del usuario con contraseña válida debería ser exitoso.");
    }
}