<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, java.util.stream.Collectors, java.time.format.DateTimeFormatter, java.time.temporal.ChronoUnit, java.time.LocalDate"%>
<%@page import="com.dental.app.clinicadentalapp.model.Usuario, com.dental.app.clinicadentalapp.model.Cita, com.dental.app.clinicadentalapp.model.Paciente, com.dental.app.clinicadentalapp.model.Odontologo"%>
<%@page import="com.dental.app.clinicadentalapp.dao.CitaDAO, com.dental.app.clinicadentalapp.dao.PacienteDAO, com.dental.app.clinicadentalapp.dao.OdontologoDAO"%>

<%
    // Obtener el rol del usuario para decidir qué vista mostrar
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String rol = (usuario != null && usuario.getRol() != null) ? usuario.getRol().getNombreRol() : "";
%>

<% if ("Paciente".equals(rol)) { %>
<%-- ============================================= --%>
<%-- ==   NUEVA VISTA PARA EL ROL DE PACIENTE   == --%>
<%-- ============================================= --%>
<%
    // --- LÓGICA DE DATOS PARA LA VISTA DE CITAS DEL PACIENTE ---
    CitaDAO citaDAO = new CitaDAO();
    List<Cita> todasLasCitas = citaDAO.listarCitas();
    LocalDate hoy = LocalDate.now();

    // Filtrar citas del paciente logueado
    List<Cita> misCitas = todasLasCitas.stream()
        .filter(c -> c.getPaciente().getUsuario().getDocumentoIdentidad().equals(usuario.getDocumentoIdentidad()))
        .collect(Collectors.toList());

    List<Cita> proximasCitas = misCitas.stream()
        .filter(c -> !c.getFechaCita().isBefore(hoy))
        .sorted((c1, c2) -> c1.getFechaCita().compareTo(c2.getFechaCita())) // Ordenar por fecha
        .collect(Collectors.toList());
        
    List<Cita> historialCitas = misCitas.stream()
        .filter(c -> c.getFechaCita().isBefore(hoy))
        .sorted((c1, c2) -> c2.getFechaCita().compareTo(c1.getFechaCita())) // Ordenar descendente
        .collect(Collectors.toList());
        
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
%>
<div class="mis-citas-container">
    <div class="citas-header">
        <h1>Mis Citas</h1>
        <a href="#" class="btn-primary-citas">+ Agendar Nueva Cita</a>
    </div>

    <section class="citas-section">
        <h2>Próximas Citas</h2>
        <div class="timeline">
            <% if (proximasCitas.isEmpty()) { %>
                <p class="no-citas-msg">No tienes ninguna cita programada.</p>
            <% } else { %>
                <% for (Cita c : proximasCitas) { %>
                    <div class="timeline-item active">
                        <div class="timeline-point"></div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="fecha-box">
                                    <span class="dia"><%= c.getFechaCita().getDayOfMonth() %></span>
                                    <span class="mes-ano"><%= c.getFechaCita().format(DateTimeFormatter.ofPattern("MMM yyyy")).toUpperCase() %></span>
                                </div>
                                <div class="info-doctor">
                                    <strong>Dr(a). <%= c.getOdontologo().getNombreCompleto() %></strong>
                                    <span>Medicina General</span>
                                </div>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="timeline-card-body">
                                <span><i class="fa-regular fa-clock"></i> <%= c.getHoraCita().format(timeFormatter) %></span>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>
    </section>

    <section class="citas-section">
        <h2>Historial</h2>
        <div class="timeline">
            <% if (historialCitas.isEmpty()) { %>
                 <p class="no-citas-msg">Aún no tienes un historial de citas.</p>
            <% } else { %>
                <% for (Cita c : historialCitas) { %>
                    <div class="timeline-item">
                        <div class="timeline-point"></div>
                        <div class="timeline-card">
                            <div class="timeline-card-header">
                                <div class="fecha-box">
                                     <span class="dia"><%= c.getFechaCita().getDayOfMonth() %></span>
                                    <span class="mes-ano"><%= c.getFechaCita().format(DateTimeFormatter.ofPattern("MMM yyyy")).toUpperCase() %></span>
                                </div>
                                <div class="info-doctor">
                                    <strong>Dr(a). <%= c.getOdontologo().getNombreCompleto() %></strong>
                                    <span>Medicina General</span>
                                </div>
                            </div>
                        </div>
                    </div>
                 <% } %>
            <% } %>
        </div>
    </section>
</div>

<% } else { %>
<%-- =================================================================== --%>
<%-- ==   VISTA ORIGINAL PARA ROLES DE ADMINISTRADOR Y RECEPCIONISTA  == --%>
<%-- =================================================================== --%>
<%
    CitaDAO citaDAO = new CitaDAO();
    PacienteDAO pacienteDAO = new PacienteDAO();
    OdontologoDAO odontoDAO = new OdontologoDAO();
    List<Cita> listaCitas = citaDAO.listarCitas();
    List<Paciente> listaPacientes = pacienteDAO.listarPacientes();
    List<Odontologo> listaOdontologos = odontoDAO.listarOdontologos();
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
    String registroStatus = request.getParameter("registro");
    String updateStatus = request.getParameter("update");
    String deleteStatus = request.getParameter("delete");
%>
<header class="header">
    <h1>Gestión de Citas</h1>
    <div class="header-actions">
        <a href="../logout" title="Cerrar Sesión"><i class="fa-solid fa-right-from-bracket"></i></a>
        <a href="dashboard.jsp?page=configuracion" title="Configuración"><i class="fa-solid fa-cog"></i></a>
        <button id="agendarBtn" class="btn-primary"><i class="fa-solid fa-plus"></i> Agendar Nueva Cita</button>
    </div>
</header>

<% if ("exito".equals(registroStatus)) { %><div class