<%@page import="com.dental.app.clinicadentalapp.model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. PROTECCIÓN DE LA PÁGINA: Verifica si hay un usuario en la sesión.
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // --- Lógica de Control de Roles (CP-005) ---
    String rol = usuario.getRol().getNombreRol();
    String defaultPage = "inicio"; // Todos los roles ven el dashboard de inicio
    
    // 2. LÓGICA DE NAVEGACIÓN: Determina qué página de contenido cargar.
    String pageToInclude = request.getParameter("page");
    
    if (pageToInclude == null || pageToInclude.trim().isEmpty()) {
        pageToInclude = defaultPage;
    }

    // --- Verificación de permisos para la página solicitada ---
    boolean tienePermiso = false;
    switch (pageToInclude) {
        case "inicio":
        case "citas":
        case "configuracion":
            tienePermiso = true; // Todos los roles pueden ver estas páginas
            break;
        case "pacientes":
            if (rol.equals("Administrador") || rol.equals("Recepcionista")) {
                tienePermiso = true;
            }
            break;
        case "odontologos":
        // CAMBIO 1: Se eliminó "recepcionistas" de este case
        case "usuarios": 
            if (rol.equals("Administrador")) {
                tienePermiso = true;
            }
            break;
    }

    // Si el rol NO TIENE PERMISO para la página que pidió, lo mandamos al inicio.
    if (!tienePermiso) {
        pageToInclude = defaultPage;
    }
    
    // Construimos la ruta al archivo de contenido.
    String contentPage = "../paginas-dashboard/" + pageToInclude + ".jsp";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sonrisa Plena</title>
    <link rel="stylesheet" href="dashboard-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <img src="https://i.imgur.com/x5A5p2B.png" alt="Logo Sonrisa Plena" class="logo-icon">
            <h2>SONRISA PLENA</h2>
        </div>
        <nav class="sidebar-nav">
      
           <ul>
               <%-- --- Menú dinámico basado en Roles --- --%>
               
                <%-- INICIO (Todos) --%>
                <li class="<%= "inicio".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=inicio"><i class="fa-solid fa-chart-pie"></i> inicio</a>
                </li>
                
                <%-- PACIENTES (Admin y Recepcionista) --%>
                <% if (rol.equals("Administrador") || rol.equals("Recepcionista")) { %>
                    <li class="<%= "pacientes".equals(pageToInclude) ? "active" : "" %>">
                        <a href="dashboard.jsp?page=pacientes"><i class="fa-solid fa-hospital-user"></i> Pacientes</a>
                    </li>
                <% } %>

                <%-- CITAS (Todos) --%>
                <li class="<%= "citas".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=citas"><i class="fa-solid fa-calendar-days"></i> Citas</a>
                </li>
                
                <%-- ODONTÓLOGOS (Solo Admin) --%>
                <% if (rol.equals("Administrador")) { %>
                    <li class="<%= "odontologos".equals(pageToInclude) ? "active" : "" %>">
                        <a href="dashboard.jsp?page=odontologos"><i class="fa-solid fa-user-doctor"></i> Odontólogos</a>
                    </li>
                <% } %>
                
                <%-- CAMBIO 2: Se eliminó el <li> de Recepcionistas --%>
                
                <%-- USUARIOS (Solo Admin) --%>
                <% if (rol.equals("Administrador")) { %>
                    <li class="<%= "usuarios".equals(pageToInclude) ? "active" : "" %>">
                        <a href="dashboard.jsp?page=usuarios"><i class="fa-solid fa-users-cog"></i> Usuarios</a>
                    </li>
                <% } %>

                <%-- CAMBIO 3: Se eliminó el <li> de Configuración --%>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <%--
            Aquí se insertará el contenido del archivo que determinamos antes
            (pacientes.jsp, citas.jsp, etc.)
        --%>
        <jsp:include page="<%= contentPage %>" />
    </main>

</body>
</html>