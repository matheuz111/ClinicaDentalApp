<%-- 
    Document   : dashboard
    Created on : 4 oct 2025, 23:02:43
    Author     : Karen
--%>

<%@page import="com.dental.app.clinicadentalapp.model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // =================================================================
    // ESTA ES LA PROTECCIÓN DE LA PÁGINA
    // 1. Obtenemos el objeto 'usuario' de la sesión.
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    // 2. Si el objeto es NULO, significa que nadie ha iniciado sesión.
    if (usuario == null) {
        // 3. Lo redirigimos a la página de login y detenemos la carga de esta página.
        response.sendRedirect("index.jsp");
        return;
    }
    // Si el objeto NO es nulo, el resto de la página se carga normalmente.
    // =================================================================
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard - Clínica Dental</title>
        <style>
            body { font-family: sans-serif; margin: 0; background-color: #f8f9fa; }
            .navbar { background-color: #343a40; padding: 1rem; color: white; display: flex; justify-content: space-between; align-items: center; }
            .navbar a { color: white; text-decoration: none; padding: 0.5rem; background-color: #dc3545; border-radius: 4px; }
            .container { padding: 2rem; }
        </style>
    </head>
    <body>

        <div class="navbar">
            <span>Usuario: <strong><%= usuario.getDocumentoIdentidad() %></strong> | Rol: <strong><%= usuario.getRol().getNombreRol() %></strong></span>
            <a href="logout">Cerrar Sesión</a>
        </div>
        
        <div class="container">
            <h1>Dashboard Principal</h1>
            <hr>
            
            <%-- Aquí podemos mostrar contenido diferente según el rol del usuario --%>
            <% if (usuario.getRol().getNombreRol().equals("Administrador")) { %>
                <h3>Menú de Administrador</h3>
                <ul>
                    <li>Gestionar Usuarios</li>
                    <li>Ver Reportes Globales de la Clínica</li>
                    <li>Configuraciones del Sistema</li>
                </ul>
            <% } else if (usuario.getRol().getNombreRol().equals("Odontologo")) { %>
                <h3>Menú de Odontólogo</h3>
                <ul>
                    <li>Ver mis Citas de Hoy</li>
                    <li>Consultar Historial de Pacientes</li>
                    <li>Solicitar Insumos</li>
                </ul>
            <% } else if (usuario.getRol().getNombreRol().equals("Recepcionista")) { %>
                <h3>Menú de Recepcionista</h3>
                <ul>
                    <li>Agendar Nueva Cita</li>
                    <li>Gestionar Pacientes</li>
                    <li>Ver Pagos</li>
                </ul>
            <% } else { %>
                 <h3>Portal del Paciente</h3>
                 <ul>
                    <li>Ver mis Próximas Citas</li>
                    <li>Consultar mi Historial de Tratamientos</li>
                </ul>
            <% } %>
        </div>

    </body>
</html>