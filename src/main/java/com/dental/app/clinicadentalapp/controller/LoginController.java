// Asegúrate de que el paquete sea .controller
package com.dental.app.clinicadentalapp.controller;

// Importamos nuestras clases y las de Jakarta EE (para Tomcat 10+)
import com.dental.app.clinicadentalapp.dao.UsuarioDAO;
import com.dental.app.clinicadentalapp.model.Usuario;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     * Este método se activa cuando el usuario envía el formulario de login.
     */
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String docIdentidad = request.getParameter("documento_identidad");
    String pass = request.getParameter("password");

    // --- Nuestros espías en el Controller ---
    System.out.println("\n==============================================");
    System.out.println("--- INICIO INTENTO DE LOGIN ---");
    System.out.println("LoginController: Recibido documento -> " + docIdentidad);
    System.out.println("LoginController: Recibida password -> " + pass);
    // ------------------------------------

    UsuarioDAO usuarioDAO = new UsuarioDAO();
    Usuario usuario = usuarioDAO.validarUsuario(docIdentidad, pass);

    if (usuario != null) {
        System.out.println("LoginController: El DAO devolvió un usuario. ¡LOGIN EXITOSO!");
        HttpSession session = request.getSession();
        session.setAttribute("usuario", usuario);
        response.sendRedirect("dashboard.jsp");
    } else {
        System.out.println("LoginController: El DAO devolvió null. ¡LOGIN FALLIDO!");
        request.setAttribute("mensajeError", "Documento o contraseña incorrectos.");
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
    System.out.println("--- FIN INTENTO DE LOGIN ---");
    System.out.println("==============================================\n");
}
}