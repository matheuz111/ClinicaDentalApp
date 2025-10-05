<%-- 
    Document   : index
    Created on : 4 oct 2025, 23:02:15
    Author     : Karen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Clínica Dental - Iniciar Sesión</title>
        <style>
            body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f0f2f5; }
            .login-container { padding: 2rem 3rem; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); text-align: center; }
            h1 { color: #333; }
            input[type="text"], input[type="password"] { width: 100%; padding: 10px; margin-bottom: 1rem; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
            input[type="submit"] { width: 100%; padding: 10px; border: none; border-radius: 4px; background-color: #007bff; color: white; font-size: 16px; cursor: pointer; }
            input[type="submit"]:hover { background-color: #0056b3; }
            .error { color: #d93025; margin-top: 1rem; font-weight: bold; }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h1>Bienvenido a la Clínica Dental</h1>
            <hr>
            
            <%-- El formulario envía los datos al servlet 'login' usando el método POST --%>
            <form action="login" method="post">
                <label for="doc">Documento de Identidad:</label><br>
                <input type="text" id="doc" name="documento_identidad" required autofocus><br>
                
                <label for="pass">Contraseña:</label><br>
                <input type="password" id="pass" name="password" required><br>
                
                <input type="submit" value="Ingresar">
            </form>
            
            <div style="text-align: center; margin-top: 1rem;">
                <span>¿No tienes una cuenta? <a href="registro.jsp">Regístrate aquí</a></span>
            </div>
            
            <%-- Este bloque mostrará un mensaje de error si el login falla --%>
            <%
                String error = (String) request.getAttribute("mensajeError");
                if (error != null) {
            %>
            <p class="error"><%= error %></p>
            <%
                }
            %>

            <%
                String registroExitoso = request.getParameter("registro");
                if (registroExitoso != null && registroExitoso.equals("exitoso")) {
            %>
            <p style="color: green;">¡Registro exitoso! Por favor, inicia sesión.</p>
            <%
                }
            %>
        </div>
    </body>
</html>