<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalDate"%>
<%@page import="com.dental.app.clinicadentalapp.model.Cita"%>
<%@page import="com.dental.app.clinicadentalapp.dao.CitaDAO"%>
<%@page import="com.dental.app.clinicadentalapp.model.Paciente"%>
<%@page import="com.dental.app.clinicadentalapp.dao.PacienteDAO"%>
<%@page import="com.dental.app.clinicadentalapp.model.Odontologo"%>
<%@page import="com.dental.app.clinicadentalapp.dao.OdontologoDAO"%>

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

<%-- Mensajes de estado --%>
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
                    String statusClassBadge; // Para el badge de tiempo
                    
                    if (diasDiferencia < 0) {
                        tiempoRestante = "Pasada";
                        statusClassBadge = "status-past"; 
                    } else if (diasDiferencia == 0) {
                        tiempoRestante = "Hoy";
                        statusClassBadge = "status-soon"; 
                    } else if (diasDiferencia <= 7) {
                        tiempoRestante = "En " + diasDiferencia + " día(s)"; // Más claro
                        statusClassBadge = "status-soon"; 
                    } else {
                        long semanas = diasDiferencia / 7;
                        tiempoRestante = "En " + semanas + (semanas > 1 ? " sem." : " sem."); // Abreviado
                        statusClassBadge = "status-future";
                    }
                    
                    // CAMBIO: Lógica para el color del punto de estado
                    String estadoCita = c.getEstado();
                    String statusClassDot = "dot-gray"; // Gris por defecto
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
                    <%-- CAMBIO: Añadido el punto de estado --%>
                    <td>
                        <span class="status-dot <%= statusClassDot %>"></span>
                        <span><%= estadoCita %></span>
                    </td>
                    <td class="action-icons">
                        <%-- IDEA 3: Asegurar tooltips (title) --%>
                        <a href="#" class="edit-btn view-btn" title="Ver/Editar Cita" <%-- Combinado Ver/Editar si abre el mismo modal --%>
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
    <div class="modal-content">
        <button class="close-btn">&times;</button> <%-- Botón en lugar de span --%>
        <h2>Agendar Nueva Cita</h2>
        <form action="../cita" method="post">
            <input type="hidden" name="action" value="agendar">
            <div class="form-grid-modal">
                <div class="form-group full-width"><label for="agendarPacienteId">Paciente*</label>
                    <select id="agendarPacienteId" name="pacienteId" required>
                       <option value="" disabled selected>Seleccione un paciente</option>
                        <% for (Paciente p : listaPacientes) { %>
                            <option value="<%= p.getPacienteId() %>"><%= p.getNombreCompleto() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group full-width"><label for="agendarOdontologoId">Odontólogo*</label>
                    <select id="agendarOdontologoId" name="odontologoId" required>
                         <option value="" disabled selected>Seleccione un odontólogo</option>
                        <% for (Odontologo o : listaOdontologos) { %>
                            <option value="<%= o.getOdontologoId() %>"><%= o.getNombreCompleto() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group"><label for="agendarFecha">Fecha*</label><input type="date" id="agendarFecha" name="fecha" required></div>
                <div class="form-group"><label for="agendarHora">Hora*</label><input type="time" id="agendarHora" name="hora" required></div>
                <div class="form-group full-width"><label for="agendarMotivo">Motivo*</label><textarea id="agendarMotivo" name="motivo" required placeholder="Ej: Dolor de muela, limpieza dental..."></textarea></div>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-secondary cancel-btn">Cancelar</button>
                <button type="submit" class="btn-primary">Guardar Cita</button>
            </div>
        </form>
    </div>
</div>

<div id="editarModal" class="modal">
    <div class="modal-content">
        <button class="close-btn">&times;</button>
        <h2>Editar Cita</h2>
        <form id="editForm" action="../cita" method="post">
            <input type="hidden" name="action" value="editar">
            <input type="hidden" name="citaId" id="editCitaId">
            <div class="form-grid-modal">
                 <div class="form-group full-width"><label for="editPacienteId">Paciente*</label>
                     <select name="pacienteId" id="editPacienteId" required>
                        <% for (Paciente p : listaPacientes) { %><option value="<%= p.getPacienteId() %>"><%= p.getNombreCompleto() %></option><% } %>
                    </select>
                </div>
                 <div class="form-group full-width"><label for="editOdontologoId">Odontólogo*</label>
                    <select name="odontologoId" id="editOdontologoId" required>
                        <% for (Odontologo o : listaOdontologos) { %><option value="<%= o.getOdontologoId() %>"><%= o.getNombreCompleto() %></option><% } %>
                    </select>
                 </div>
                <div class="form-group"><label for="editFecha">Fecha*</label><input type="date" name="fecha" id="editFecha" required></div>
                <div class="form-group"><label for="editHora">Hora*</label><input type="time" name="hora" id="editHora" required></div>
                <div class="form-group full-width"><label for="editMotivo">Motivo*</label><textarea name="motivo" id="editMotivo" required></textarea></div>
            </div>
             <div class="modal-actions">
               <button type="button" class="btn-secondary cancel-btn">Cancelar</button>
                <button type="submit" class="btn-primary">Actualizar Cita</button>
            </div>
        </form>
    </div>
</div>

<div id="deleteModal" class="modal">
    <div class="modal-content text-center">
        <button class="close-btn">&times;</button>
        <h2>Confirmar Eliminación</h2>
        <p>¿Seguro que deseas eliminar la cita del paciente <strong id="deletePacienteNombre"></strong> para la fecha <strong id="deleteFecha"></strong>?</p>
        <div class="modal-actions">
            <button type="button" class="btn-secondary cancel-btn">Cancelar</button>
            <a id="confirmDeleteLink" href="#" class="btn-danger">Eliminar</a>
        </div>
    </div>
</div>


<style>
    .card-header { /* Asegurar que los estilos base se aplican si no están en global */
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px; 
    }
    .filter-group {
        display: flex;
        align-items: center;
        gap: 10px;
    }
    .filter-group label {
        font-weight: 500;
        font-size: 0.9rem;
    }
    .filter-group select {
        padding: 8px 12px; /* Ajustar padding */
        border-radius: 6px;
        border: 1px solid #ccc;
        font-family: inherit;
        background-color: #fff;
        font-size: 0.9rem;
    }
    /* Estilos para badges de tiempo restante */
     .status-badge { 
         padding: 3px 8px; /* Más pequeño */
         border-radius: 12px; 
         font-size: .75rem; /* Más pequeño */
         font-weight: 600; 
         color: #fff; 
         text-align: center;
         display: inline-block; /* Para que tome padding */
         line-height: 1.4; /* Ajuste línea */
     }
    .status-past { background-color: #6c757d; } /* Pasada en gris */
    .status-soon { background-color: #ffc107; color: #333; } /* Amarillo */
    .status-future { background-color: #198754; } /* Verde más oscuro */
</style>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const alert = document.querySelector('.alert');
    if(alert) setTimeout(() => alert.remove(), 5000);

    const agendarModal = document.getElementById('agendarModal');
    const editarModal = document.getElementById('editarModal');
    const deleteModal = document.getElementById('deleteModal');
    const modals = [agendarModal, editarModal, deleteModal];

    function openModal(modal) { if(modal) modal.classList.add('is-visible'); }
    function closeModal(modal) { if(modal) modal.classList.remove('is-visible'); }

    // Corregir: Asegurarse que el botón existe antes de añadir listener
    const agendarBtn = document.getElementById('agendarBtn');
    if(agendarBtn) agendarBtn.addEventListener('click', () => openModal(agendarModal));

    modals.forEach(modal => {
        if (!modal) return;
        // Usar querySelectorAll para botones de cerrar y cancelar
        modal.querySelectorAll('.close-btn, .cancel-btn').forEach(btn => {
             btn.addEventListener('click', () => closeModal(modal));
        });
        modal.addEventListener('click', e => { if (e.target === modal) closeModal(modal); });
    });

    document.querySelectorAll('.edit-btn').forEach(btn => {
        btn.addEventListener('click', e => {
            e.preventDefault();
            // Llenar el modal de edición
             document.getElementById('editCitaId').value = btn.dataset.citaId;
             document.getElementById('editPacienteId').value = btn.dataset.pacienteId;
             document.getElementById('editOdontologoId').value = btn.dataset.odontologoId;
             document.getElementById('editFecha').value = btn.dataset.fecha;
             document.getElementById('editHora').value = btn.dataset.hora;
             document.getElementById('editMotivo').value = btn.dataset.motivo;
            openModal(editarModal);
        });
    });
    
 document.querySelectorAll('.delete-btn').forEach(btn => {
        btn.addEventListener('click', e => {
            e.preventDefault();
             document.getElementById('deletePacienteNombre').textContent = btn.dataset.pacienteNombre;
             document.getElementById('deleteFecha').textContent = btn.dataset.fecha;
             document.getElementById('confirmDeleteLink').href = `../cita?action=eliminar&id=${btn.dataset.citaId}`;
            openModal(deleteModal);
        });
    });
    
    // --- FILTRO DE PACIENTES ---
    const filtroPaciente = document.getElementById('filtroPaciente');
    const citasTableBody = document.getElementById('citasTableBody');
    // Corregir: Asegurarse que la tabla existe
    if(filtroPaciente && citasTableBody) {
        const filasCitas = citasTableBody.getElementsByTagName('tr');
        
        filtroPaciente.addEventListener('change', function() {
            const pacienteIdSeleccionado = this.value;

            for (let i = 0; i < filasCitas.length; i++) {
                const fila = filasCitas[i];
                
                if (fila.dataset.pacienteId) {
                    const idPacienteFila = fila.dataset.pacienteId;

                    if (pacienteIdSeleccionado === "todos" || idPacienteFila === pacienteIdSeleccionado) {
                        fila.style.display = ""; 
                    } else {
                        fila.style.display = "none"; 
                    }
                } else if (pacienteIdSeleccionado === "todos") {
                     fila.style.display = ""; // Mostrar fila de "No hay citas"
                } else {
                     fila.style.display = "none"; // Ocultar fila de "No hay citas" si se filtra
                }
            }
        });
    }
});
</script>