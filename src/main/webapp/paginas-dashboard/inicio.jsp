<%@page import="java.util.Random"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.util.ArrayList, java.util.Map, java.util.LinkedHashMap, java.time.LocalDate, java.time.format.DateTimeFormatter, java.time.temporal.ChronoUnit"%>
<%@page import="com.dental.app.clinicadentalapp.model.Usuario, com.dental.app.clinicadentalapp.model.Cita, com.dental.app.clinicadentalapp.model.Paciente, com.dental.app.clinicadentalapp.model.Odontologo"%>
<%@page import="com.dental.app.clinicadentalapp.dao.CitaDAO, com.dental.app.clinicadentalapp.dao.PacienteDAO, com.dental.app.clinicadentalapp.dao.OdontologoDAO"%>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    String rol = (usuario != null && usuario.getRol() != null) ? usuario.getRol().getNombreRol() : "";
%>

<% if ("Paciente".equals(rol)) { %>
<%
    CitaDAO citaDAOPaciente = new CitaDAO();
    List<Cita> todasLasCitas = citaDAOPaciente.listarCitas();
    Cita proximaCita = null;
    
    for (Cita c : todasLasCitas) {
        if (c.getPaciente().getUsuario().getDocumentoIdentidad().equals(usuario.getDocumentoIdentidad()) && !c.getFechaCita().isBefore(LocalDate.now())) {
            if (proximaCita == null || c.getFechaCita().isBefore(proximaCita.getFechaCita())) {
                proximaCita = c;
            }
        }
    }
    
    String[] consejos = {
        "Recuerda beber al menos 2 litros de agua al día para mantenerte hidratado y lleno de energía.",
        "Una caminata de 30 minutos puede mejorar tu estado de ánimo y fortalecer tu corazón. ¡Muévete!",
        "Llama o visita a un ser querido. Las conexiones sociales son vitales para la salud mental.",
        "Intenta dormir entre 7 y 9 horas cada noche. Un buen descanso repara tu cuerpo y mente.",
        "Asegúrate de incluir frutas y verduras en cada comida. Tu cuerpo te lo agradecerá.",
        "No olvides realizar tus chequeos médicos anuales. La prevención es la mejor medicina.",
        "Dedica 15 minutos al día a una actividad que disfrutes, como leer o escuchar música, para reducir el estrés.",
        "Limita el consumo de alimentos procesados y azúcares. Opta por opciones más naturales y saludables."
    };
    String consejoDelDia = consejos[new Random().nextInt(consejos.length)];
%>
<div class="patient-dashboard-container">
    <h1 class="welcome-title">Tu Resumen de Bienestar</h1>
    <p class="welcome-subtitle">Hola Gloria, bienvenido a tu centro de control personal.</p>

    <div class="patient-dashboard-grid">
        
        <div class="ascenso-card card-shadow">
            <h3>Tu Ascenso de Hoy</h3>
            <div class="progreso-container">
                <div id="progreso-circular" class="progreso-circular" style="--progreso: 25;">
                     <div class="inner-circle">
                        <span id="progreso-texto">25%</span>
                    </div>
                </div>
                <div class="tareas-list">
                    <p>Progreso Diario</p>
                    <div class="tarea-item" data-value="25">
                        <i class="fa-regular fa-circle"></i>
                        Tomar vitamina D
                        <div class="tarea-icons"><i class="fa-solid fa-pills"></i></div>
                    </div>
                    <div class="tarea-item" data-value="25">
                        <i class="fa-regular fa-circle"></i>
                        Caminata de 30 minutos
                        <div class="tarea-icons"><i class="fa-solid fa-person-walking"></i></div>
                    </div>
                    <div class="tarea-item" data-value="25">
                        <i class="fa-regular fa-circle"></i>
                        Beber 2L de agua
                        <div class="tarea-icons"><i class="fa-solid fa-glass-water"></i></div>
                    </div>
                     <div class="tarea-item" data-value="25">
                        <i class="fa-regular fa-circle"></i>
                        Leer 15 minutos
                        <div class="tarea-icons"><i class="fa-solid fa-book-open-reader"></i></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="right-column">
            <div class="proxima-cita-card card-shadow">
                <h4>Próximo Campamento Base</h4>
                <% if (proximaCita != null) { %>
                    <div class="cita-details">
                        <div class="cita-fecha">
                            <span><%= proximaCita.getFechaCita().getDayOfMonth() %></span><%= proximaCita.getFechaCita().format(DateTimeFormatter.ofPattern("MMM")).toUpperCase() %>
                        </div>
                        <div class="cita-info">
                            <strong>Medicina General</strong>
                            <span>con Dr(a). <%= proximaCita.getOdontologo().getNombreCompleto() %></span>
                        </div>
                        <a href="dashboard.jsp?page=citas" class="arrow-link"><i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                <% } else { %>
                    <p style="text-align: center; color: var(--patient-light-text);">No tienes próximas citas agendadas.</p>
                <% } %>
            </div>
            <div class="stats-card-grid">
                <div class="stat-card"><div class="stat-icon verde"><i class="fa-solid fa-flask-vial"></i></div><strong>1</strong><span>Resultados</span></div>
                <div class="stat-card"><div class="stat-icon rojo"><i class="fa-solid fa-prescription-bottle"></i></div><strong>3</strong><span>Recetas</span></div>
                <div class="stat-card"><div class="stat-icon azul"><i class="fa-solid fa-comment-medical"></i></div><strong>2</strong><span>Mensajes</span></div>
            </div>
        </div>

        <div class="conexion-social-card card-shadow">
            <i class="fa-solid fa-people-group"></i>
            <h4>Conexión Social</h4>
            <p><%= consejoDelDia %></p>
        </div>

        <div class="accesos-rapidos-card card-shadow">
             <h4>Accesos Rápidos</h4>
             <div class="accesos-grid">
                 <a href="#" class="acceso-item"><i class="fa-solid fa-calendar-plus"></i> Agendar Cita</a>
                 <a href="#" class="acceso-item"><i class="fa-solid fa-file-invoice"></i> Ver Mi Historial</a>
                 <a href="#" class="acceso-item"><i class="fa-solid fa-user-gear"></i> Actualizar Mi Perfil</a>
                 <a href="#" class="acceso-item"><i class="fa-solid fa-stethoscope"></i> Buscar Médicos</a>
             </div>
        </div>

    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const tareas = document.querySelectorAll('.tarea-item');
    const progresoCircular = document.getElementById('progreso-circular');
    const progresoTexto = document.getElementById('progreso-texto');
    let progresoActual = 0;

    // Función para actualizar el gráfico
    function actualizarProgreso() {
        progresoCircular.style.setProperty('--progreso', progresoActual);
        progresoTexto.textContent = progresoActual + '%';
    }

    // Cargar estado inicial y establecer progreso
    tareas.forEach(tarea => {
        const tareaId = tarea.textContent.trim();
        if (localStorage.getItem(tareaId) === 'done') {
            tarea.classList.add('done');
            tarea.querySelector('i').className = 'fa-solid fa-check-circle';
            progresoActual += parseInt(tarea.dataset.value, 10);
        }

        tarea.addEventListener('click', function() {
            const valorTarea = parseInt(this.dataset.value, 10);
            const id = this.textContent.trim();
            
            this.classList.toggle('done');
            
            if (this.classList.contains('done')) {
                // Tarea completada
                this.querySelector('i').className = 'fa-solid fa-check-circle';
                progresoActual += valorTarea;
                localStorage.setItem(id, 'done');
            } else {
                // Tarea desmarcada
                this.querySelector('i').className = 'fa-regular fa-circle';
                progresoActual -= valorTarea;
                localStorage.removeItem(id);
            }
            
            actualizarProgreso();
        });
    });

    // Actualizar el gráfico al cargar la página
    actualizarProgreso();
});
</script>


<% } else { %>
<%-- =================================================================== --%>
<%-- ==   VISTA ORIGINAL PARA ROLES DE ADMINISTRADOR Y RECEPCIONISTA  == --%>
<%-- =================================================================== --%>
<%
    PacienteDAO pacienteDAO = new PacienteDAO();
    OdontologoDAO odontoDAO = new OdontologoDAO();
    CitaDAO citaDAO = new CitaDAO();
    List<Paciente> listaPacientes = pacienteDAO.listarPacientes();
    List<Odontologo> listaOdontologos = odontoDAO.listarOdontologos();
    List<Cita> listaCitas = citaDAO.listarCitas();
    int totalPacientes = listaPacientes.size();
    int totalOdontologos = listaOdontologos.size();
    LocalDate hoy = LocalDate.now();
    int citasHoyCount = 0;
    int citasPendientesCount = 0;
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("hh:mm a");
    DateTimeFormatter chartLabelFormatter = DateTimeFormatter.ofPattern("EEE dd");
    List<Cita> proximas5Citas = new ArrayList<>();
    Map<LocalDate, Integer> citasPorDia = new LinkedHashMap<>();
    LocalDate fechaLimite = hoy.plusDays(7);
    for (long i = 0; i < 7; i++) {
        citasPorDia.put(hoy.plusDays(i), 0);
    }
    for (Cita c : listaCitas) {
        LocalDate fechaCita = c.getFechaCita();
        if (!fechaCita.isBefore(hoy)) {
            citasPendientesCount++;
            if (fechaCita.equals(hoy)) {
                citasHoyCount++;
            }
            if (proximas5Citas.size() < 5) {
                proximas5Citas.add(c);
            }
        }
        if (!fechaCita.isBefore(hoy) && fechaCita.isBefore(fechaLimite)) {
            citasPorDia.put(fechaCita, citasPorDia.getOrDefault(fechaCita, 0) + 1);
        }
    }
    StringBuilder labels = new StringBuilder("[");
    StringBuilder data = new StringBuilder("[");
    boolean first = true;
    for (Map.Entry<LocalDate, Integer> entry : citasPorDia.entrySet()) {
        if (!first) {
            labels.append(", ");
            data.append(", ");
        }
        labels.append("'").append(entry.getKey().format(chartLabelFormatter)).append("'");
        data.append(entry.getValue());
        first = false;
    }
    labels.append("]");
    data.append("]");
    String chartLabels = labels.toString();
    String chartData = data.toString();
    int totalPac = listaPacientes.size();
    List<Paciente> ultimos5Pacientes = listaPacientes.subList(Math.max(0, totalPac - 5), totalPac);
%>
    <header class="header">
        <h1>Dashboard Principal</h1>
        <div class="header-actions">
            <a href="../logout" title="Cerrar Sesión"><i class="fa-solid fa-right-from-bracket"></i></a>
            <a href="dashboard.jsp?page=configuracion" title="Configuración"><i class="fa-solid fa-cog"></i></a>
        </div>
    </header>

    <div class="dashboard-grid">
        <div class="kpi-card fade-in">
            <div class="kpi-card-icon icon-pacientes"> <i class="fa-solid fa-hospital-user"></i> </div>
            <div class="kpi-card-info"> <h2><%= totalPacientes %></h2> <p>Pacientes Totales</p> </div>
        </div>
        <div class="kpi-card fade-in">
            <div class="kpi-card-icon icon-citas"> <i class="fa-solid fa-calendar-check"></i> </div>
            <div class="kpi-card-info"> <h2><%= citasPendientesCount %></h2> <p>Citas Pendientes</p> </div>
        </div>
        <div class="kpi-card fade-in">
             <div class="kpi-card-icon icon-hoy"> <i class="fa-solid fa-calendar-day"></i> </div>
            <div class="kpi-card-info"> <h2><%= citasHoyCount %></h2> <p>Citas para Hoy</p> </div>
        </div>
        <div class="kpi-card fade-in">
            <div class="kpi-card-icon icon-odontologos"> <i class="fa-solid fa-user-doctor"></i> </div>
            <div class="kpi-card-info"> <h2><%= totalOdontologos %></h2> <p>Odontólogos Activos</p> </div>
        </div>
    </div>
    <div class="dashboard-main-area">
        <section class="content-card chart-container fade-in">
             <h3>Citas Próximos 7 Días</h3>
             <canvas id="citasChart"></canvas>
        </section>
         <div class="list-container">
            <section class="content-card list-card fade-in">
                <h3>Próximas 5 Citas</h3>
                <% if (proximas5Citas.isEmpty()) { %>
                    <div class="list-card-item"> <div class="list-card-item-info"> <span>No hay citas próximas.</span> </div> </div>
                <% } else { for (Cita c : proximas5Citas) { %>
                        <div class="list-card-item">
                            <div class="list-card-item-info">
                                 <strong><%= c.getPaciente().getNombreCompleto() %></strong>
                                <span>Dr(a). <%= c.getOdontologo().getApellido() %> - <%= c.getMotivo() %></span>
                            </div>
                            <div class="list-card-item-extra">
                                <% if(c.getFechaCita().equals(hoy)) { %> <strong style="color: var(--warning-orange);">HOY</strong>
                                <% } else { %> <%= c.getFechaCita().format(dateFormatter) %> <% } %>
                                <br> <span><%= c.getHoraCita().format(timeFormatter) %></span>
                          </div>
                        </div>
                <% }} %>
            </section>
             <section class="content-card list-card fade-in">
                <h3>Últimos Pacientes</h3>
                <% if (ultimos5Pacientes.isEmpty()) { %>
                     <div class="list-card-item"> <div class="list-card-item-info"> <span>No hay pacientes recientes.</span> </div> </div>
                <% } else { for (int i = ultimos5Pacientes.size() - 1; i >= 0; i--) { Paciente p = ultimos5Pacientes.get(i); %>
                        <div class="list-card-item">
                            <div class="list-card-item-info">
                                <strong><%= p.getNombreCompleto() %></strong>
                                 <span><%= p.getEmail() != null && !p.getEmail().isEmpty() ? p.getEmail() : "Sin email" %></span>
                            </div>
                            <div class="list-card-item-extra paciente"> DNI: <%= p.getUsuario().getDocumentoIdentidad() %> </div>
                        </div>
                   <% }} %>
            </section>
        </div>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.fade-in');
             elements.forEach((el, index) => {
                setTimeout(() => { el.classList.add('visible'); }, 50 * index); 
            });
             const ctx = document.getElementById('citasChart');
               if (ctx) { 
                 const chartLabels = <%= chartLabels %>; 
                 const chartData = <%= chartData %>;     
                 const data = {
                      labels: chartLabels,
                     datasets: [{
                         label: 'Número de Citas',
                         data: chartData,
                         backgroundColor: 'rgba(42, 121, 238, 0.6)', 
                         borderColor: 'rgba(42, 121, 238, 1)',     
                         borderWidth: 1,
                         borderRadius: 4, 
                         hoverBackgroundColor: 'rgba(42, 121, 238, 0.8)' 
                     }]
                 };
                 const config = {
                     type: 'bar',
                     data: data,
                     options: {
                         responsive: true, 
                        maintainAspectRatio: false, 
                         plugins: {
                             legend: { display: false },
                             title: { display: false },
                             tooltip: { 
                                   backgroundColor: '#333', titleColor: '#fff', bodyColor: '#fff',
                                     padding: 10, cornerRadius: 4, displayColors: false 
                                  }
                         },
                         scales: {
                      y: {
                                 beginAtZero: true, 
                                 ticks: { stepSize: 1 },
                                 grid: { color: '#eee' }
                             },
                                 x: {
                                 grid: { display: false }
                             }
                         }
                     }
                 };
                 new Chart(ctx, config);
             }
        });
    </script>
<% } %>