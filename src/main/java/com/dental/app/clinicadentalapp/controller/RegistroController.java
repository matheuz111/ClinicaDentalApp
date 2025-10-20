/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.dental.app.clinicadentalapp.controller;

import com.dental.app.clinicadentalapp.dao.UsuarioDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroController", urlPatterns = {"/registro"})
public class RegistroController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String docIdentidad = request.getParameter("documento_identidad");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");

        // Validaciones del lado del servidor
        if (docIdentidad.length() != 8 || !docIdentidad.matches("\\d+")) {
            request.setAttribute("error", "El DNI debe tener 8 dígitos.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        if (!password.matches("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@_#$%^&+=!*?])(?=\\S+$).{8,}$")) {
            request.setAttribute("error", "La contraseña no cumple con los requisitos.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Las contraseñas no coinciden.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        if (usuarioDAO.registrarUsuario(docIdentidad, password)) {
            response.sendRedirect("index.jsp?registro=exitoso");
        } else {
            request.setAttribute("error", "Error al registrar el usuario. Inténtelo de nuevo.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        }
    }
}