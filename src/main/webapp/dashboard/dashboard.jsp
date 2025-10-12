<%@page import="com.dental.app.clinicadentalapp.model.Usuario"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // 1. PROTECCIÓN DE LA PÁGINA: Verifica si hay un usuario en la sesión.
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("../index.jsp");
        return;
    }

    // 2. LÓGICA DE NAVEGACIÓN: Determina qué página de contenido cargar.
    // Obtenemos el parámetro 'page' de la URL (ej: dashboard.jsp?page=citas)
    String pageToInclude = request.getParameter("page");

    // Si no se especifica ninguna página, cargamos 'pacientes' por defecto.
    if (pageToInclude == null || pageToInclude.trim().isEmpty()) {
        pageToInclude = "pacientes";
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
                <li class="<%= "dashboard".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=inicio"><i class="fa-solid fa-chart-pie"></i> inicio</a>
                </li>
                <li class="<%= "pacientes".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=pacientes"><i class="fa-solid fa-hospital-user"></i> Pacientes</a>
                </li>
                <li class="<%= "citas".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=citas"><i class="fa-solid fa-calendar-days"></i> Citas</a>
                </li>
                <li class="<%= "odontologos".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=odontologos"><i class="fa-solid fa-user-doctor"></i> Odontólogos</a>
                </li>
                <li class="<%= "recepcionistas".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=recepcionistas"><i class="fa-solid fa-user-nurse"></i> Recepcionistas</a>
                </li>
                <li class="<%= "configuracion".equals(pageToInclude) ? "active" : "" %>">
                    <a href="dashboard.jsp?page=configuracion"><i class="fa-solid fa-gear"></i> Configuración</a>
                </li>
            </ul>
        </nav>
    </aside>

    <main class="main-content">
        <%--
            ESTA ES LA LÍNEA MÁGICA:
            Aquí se insertará el contenido del archivo que determinamos antes
            (pacientes.jsp, citas.jsp, etc.)
        --%>
        <jsp:include page="<%= contentPage %>" />
    </main>

</body>
</html>