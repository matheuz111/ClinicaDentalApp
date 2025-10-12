<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Crear Cuenta - Clínica Dental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/autenticacion/registro-styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body>

    <div class="registro-page-container">

        <div class="branding-section">
            <div class="branding-logo">
                <i class="fa-solid fa-tooth"></i>
                <h1>Sonrisa Plena</h1>
                <p>Cuidamos tu sonrisa con la mejor tecnología y un equipo de profesionales apasionados.</p>
            </div>
        </div>

        <div class="form-section-wrapper">
            <div class="registro-box">
                <h2>Crear cuenta de Paciente</h2>
                
                <form action="registro" method="post" class="form-grid">
            
                    <%-- Bloque para mostrar mensajes de error del servidor --%>
                    <%
                        String error = (String) request.getAttribute("error");
                        if (error != null) {
                    %>
                    <div class="error-message"><%= error %></div>
                    <%
                        }
                    %>
        
                    <div class="form-group">
                        <label for="doc">Número de documento:</label>
                        <input type="text" id="doc" name="documento_identidad" required maxlength="8" pattern="\d{8}" title="El DNI debe tener 8 dígitos.">
                    </div>
        
                    <div class="form-group">
                        <label for="pass">Contraseña:</label>
                        <input type="password" id="pass" name="password" required>
                        <div class="password-rules">
                            Mínimo 8 caracteres, una mayúscula, un número y un caracter especial (@#$%^&+=).
                        </div>
                    </div>
        
                    <div class="form-group">
                        <label for="confirm_pass">Confirmar contraseña:</label>
                        <input type="password" id="confirm_pass" name="confirm_password" required>
                    </div>
                    
                    <input type="submit" value="Registrarme">
        
                    <div class="form-footer">
                        <div>
                            <input type="checkbox" id="recordarme">
                            <label for="recordarme">Recordarme</label>
                        </div>
                        <a href="#">¿Olvidaste tu contraseña?</a>
                    </div>
        
                    <div class="login-link">
                        <span>¿Ya tienes cuenta? <a href="index.jsp">Inicia sesión aquí</a></span>
                    </div>
                </form>
            </div>
        </div>

    </div>

</body>
</html>