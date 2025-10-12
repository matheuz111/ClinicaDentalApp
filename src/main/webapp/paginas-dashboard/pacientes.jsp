<%--
    Este archivo ya NO tiene <html>, <head>, <body>, ni el <aside class="sidebar">.
    Solo contiene el contenido que se insertará dentro del <main> del layout principal.
--%>

<header class="header">
    <div class="search-bar">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" placeholder="Buscar pacientes por cédula, nombre o apellido">
    </div>
    <div class="header-actions">
        <a href="../logout" title="Cerrar Sesión" style="margin-right: 15px; color: var(--danger-red);"><i class="fa-solid fa-right-from-bracket"></i></a>
        <a href="#" title="Configuración"><i class="fa-solid fa-cog"></i></a>
    </div>
</header>

<section class="content-card">
    <h3>Lista de Pacientes activos</h3>
    <table>
        <thead>
            <tr>
                <th><input type="checkbox"></th>
                <th>Nombre completo</th>
                <th>ID</th>
                <th>Última cita</th>
                <th>Alergias</th>
                <th>Odontólogo principal</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><input type="checkbox"></td>
                <td>Matheus Coronado</td>
                <td>1</td>
                <td>08-09-2025</td>
                <td><span class="status-icon status-warning">??</span> Registradas</td>
                <td>Gabriel Huaman</td>
                <td class="action-icons">
                    <a href="#" title="Ver Detalles"><i class="fa-solid fa-eye"></i></a>
                    <a href="#" title="Editar"><i class="fa-solid fa-pencil"></i></a>
                    <a href="#" title="Eliminar"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
            <tr>
                <td><input type="checkbox"></td>
                <td>Jonathan Rujel</td>
                <td>2</td>
                <td>01-09-2025</td>
                <td><span class="status-icon status-ok">?</span> No</td>
                <td>Edu Quispe</td>
                <td class="action-icons">
                    <a href="#" title="Ver Detalles"><i class="fa-solid fa-eye"></i></a>
                    <a href="#" title="Editar"><i class="fa-solid fa-pencil"></i></a>
                    <a href="#" title="Eliminar"><i class="fa-solid fa-trash"></i></a>
                </td>
            </tr>
        </tbody>
    </table>
</section>

<section class="content-card">
    <h3>Registro rápido de paciente</h3>
    <form action="../registroPaciente" method="post" class="quick-register-form">
        <div class="form-grid">
            <div class="form-group">
                <label for="doc">Tipo de Documento</label>
                <input type="text" id="doc" name="documento" placeholder="Ej: 70022045" required>
            </div>
            <div class="form-group">
                <label for="nombres">Nombre(s)</label>
                <input type="text" id="nombres" name="nombres" placeholder="Ej: Pablo Escobar" required>
            </div>
            <div class="form-group">
                <label for="email">Correo Electrónico</label>
                <input type="email" id="email" name="email" placeholder="Ej: pabloescobar@gmail.com" required>
            </div>
            <div class="form-actions">
                <div class="checkbox-group">
                    <input type="checkbox" id="terms" name="terms" required>
                    <label for="terms">Acepto los términos y condiciones</label>
                </div>
                <button type="submit" class="btn-primary">Registrar</button>
            </div>
        </div>
    </form>
</section>