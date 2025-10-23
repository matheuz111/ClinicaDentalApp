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
                                    <span>Medicina General</span><%-- Placeholder --%>
                                </div>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                             <div class="timeline-card-body">
                                <span><i class="fa-regular fa-clock"></i> <%= c.getHoraCita().format(DateTimeFormatter.ofPattern("hh:mm a")) %></span>
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
                                    <span>Medicina General</span><%-- Placeholder --%>
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

<% if ("exito".equals(registroStatus)) { %><div class="alert alert-success">¡Cita agendada exitosamente!</div><% } %>
<% if ("error".equals(registroStatus)) { %><div class="alert alert-danger">Error: No se pudo agendar la cita. Verifique los datos.</div><% } %>
<% if ("error_horario".equals(registroStatus)) { %><div class="alert alert-danger">Error: El horario seleccionado ya está ocupado.</div><% } %>
<% if ("exito".equals(updateStatus)) { %><div class="alert alert-success">¡Cita actualizada exitosamente!</div><% } %>
<% if ("error".equals(updateStatus)) { %><div class="alert alert-danger">Error: No se pudo actualizar la cita.</div><% } %>
<% if ("exito".equals(deleteStatus)) { %><div class="alert alert-success">¡Cita eliminada exitosamente!</div><% } %>
<% if ("error".equals(deleteStatus)) { %><div class="alert alert-danger">Error: No se pudo eliminar la cita.</div><% } %>

<section class="content-card">
    
    <div class="card-header">
        <h3>Citas Programadas</h3>
        <div class="filter-group">
             <label for="filtroPaciente">Filtrar por Paciente:</label>
            <select id="filtroPaciente">
                <option value="todos">-- Mostrar Todos --</option>
                <% for (Paciente p : listaPacientes) { %>
                    <option value="<%= p.getPacienteId() %>"><%= p.getNombreCompleto() %></option>
                <% } %>
            </select>
        </div>
    </div>
    
    <table>
        <thead>
            <tr>
                <th>Paciente</th>
                <th>Odontólogo</th>
                <th>Fecha y Hora</th>
                <th>Tiempo Restante</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
         </thead>
        <tbody id="citasTableBody">
             <% if (listaCitas.isEmpty()) { %>
                <tr><td colspan="6" style="text-align: center;">No hay citas programadas.</td></tr>
            <% } else { for (Cita c : listaCitas) { %>
                 <%
                    LocalDate hoy = LocalDate.now();
                    LocalDate fechaCita = c.getFechaCita();
                    long diasDiferencia = ChronoUnit.DAYS.between(hoy, fechaCita);
                    String tiempoRestante;
                    String statusClassBadge;
                    
                    if (diasDiferencia < 0) {
                        tiempoRestante = "Pasada";
                        statusClassBadge = "status-past"; 
                    } else if (diasDiferencia == 0) {
                        tiempoRestante = "Hoy";
                        statusClassBadge = "status-soon"; 
                    } else if (diasDiferencia <= 7) {
                        tiempoRestante = "En " + diasDiferencia + " día(s)";
                        statusClassBadge = "status-soon";
                    } else {
                        long semanas = diasDiferencia / 7;
                        tiempoRestante = "En " + semanas + (semanas > 1 ? " sem." : " sem.");
                        statusClassBadge = "status-future";
                    }
                    
                    String estadoCita = c.getEstado();
                    String statusClassDot = "dot-gray";
                    if ("Programada".equalsIgnoreCase(estadoCita) || "Confirmada".equalsIgnoreCase(estadoCita)) {
                        statusClassDot = "dot-green";
                    } else if ("Pendiente".equalsIgnoreCase(estadoCita)) {
                        statusClassDot = "dot-yellow";
                    } else if ("Cancelada".equalsIgnoreCase(estadoCita)) {
                        statusClassDot = "dot-red";
                    }
                %>
                <tr data-paciente-id="<%= c.getPaciente().getPacienteId() %>">
                    <td><%= c.getPaciente().getNombreCompleto() %></td>
                    <td><%= c.getOdontologo().getNombreCompleto() %></td>
                    <td><%= c.getFechaCita().format(dateFormatter) %> a las <%= c.getHoraCita().format(timeFormatter) %></td>
                    <td><span class="status-badge <%= statusClassBadge %>"><%= tiempoRestante %></span></td>
                    <td>
                         <span class="status-dot <%= statusClassDot %>"></span>
                        <span><%= estadoCita %></span>
                    </td>
                    <td class="action-icons">
                        <a href="#" class="edit-btn view-btn" title="Ver/Editar Cita"
                           data-cita-id="<%= c.getCitaId() %>"
                           data-paciente-id="<%= c.getPaciente().getPacienteId() %>"
                           data-odontologo-id="<%= c.getOdontologo().getOdontologoId() %>"
                           data-fecha="<%= c.getFechaCita().toString() %>"
                           data-hora="<%= c.getHoraCita().toString() %>"
                           data-motivo="<%= c.getMotivo() %>">
                            <i class="fa-solid fa-pencil"></i>
                        </a>
                        <a href="#" class="delete-btn" title="Eliminar Cita"
                           data-cita-id="<%= c.getCitaId() %>"
                           data-paciente-nombre="<%= c.getPaciente().getNombreCompleto() %>"
                           data-fecha="<%= c.getFechaCita().format(dateFormatter) %>">
                           <i class="fa-solid fa-trash"></i>
                         </a>
                    </td>
                </tr>
            <% }} %>
        </tbody>
     </table>
</section>

<div id="agendarModal" class="modal">
    </div>
<div id="editarModal" class="modal">
    </div>
<div id="deleteModal" class="modal">
    </div>

<% } %>