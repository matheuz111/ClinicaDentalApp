// El paquete debe coincidir con la ubicación del archivo en Test Packages
package com.dental.app.clinicadentalapp.dao;

// Importamos las clases que vamos a probar y las herramientas de JUnit
import com.dental.app.clinicadentalapp.model.Usuario;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Clase de pruebas para UsuarioDAO.
 * IMPORTANTE: Estas pruebas requieren que la base de datos esté accesible y
 * contenga los usuarios de prueba que hemos creado.
 */
public class UsuarioDAOTest {

    public UsuarioDAOTest() {
    }

    /**
     * Prueba el "camino feliz": un login exitoso con credenciales correctas.
     */
    @Test
    public void testValidarUsuarioExitoso() {
        System.out.println("Ejecutando test: Login Exitoso");
        UsuarioDAO dao = new UsuarioDAO();
        // Usamos las credenciales de la odontóloga que creamos
        String documento = "12345678";
        String password = "dralopez123";
        
        Usuario resultado = dao.validarUsuario(documento, password);
        
        // Verificación 1: El objeto Usuario NO debe ser nulo.
        assertNotNull(resultado, "El usuario no debería ser nulo para credenciales correctas.");
        
        // Verificación 2: El rol del usuario debe ser "Odontologo".
        assertEquals("Odontologo", resultado.getRol().getNombreRol(), "El rol del usuario no es el esperado.");
    }

    /**
     * Prueba un fallo de login debido a una contraseña incorrecta.
     */
    @Test
    public void testValidarUsuarioFallido_PasswordIncorrecto() {
        System.out.println("Ejecutando test: Contraseña Incorrecta");
        UsuarioDAO dao = new UsuarioDAO();
        // Usamos el documento correcto pero una contraseña incorrecta
        String documento = "12345678";
        String password = "password_equivocado";
        
        Usuario resultado = dao.validarUsuario(documento, password);
        
        // Verificación: El resultado DEBE ser nulo.
        assertNull(resultado, "El usuario debería ser nulo si la contraseña es incorrecta.");
    }
    
    /**
     * Prueba un fallo de login porque el usuario no existe en la base de datos.
     */
    @Test
    public void testValidarUsuarioFallido_UsuarioNoExiste() {
        System.out.println("Ejecutando test: Usuario No Existe");
        UsuarioDAO dao = new UsuarioDAO();
        // Usamos un documento que no hemos registrado
        String documento = "usuario_inventado";
        String password = "123";
        
        Usuario resultado = dao.validarUsuario(documento, password);
        
        // Verificación: El resultado DEBE ser nulo.
        assertNull(resultado, "El usuario debería ser nulo si no existe en la BD.");
    }
}