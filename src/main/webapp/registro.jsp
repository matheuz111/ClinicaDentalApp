<%-- 
    Document   : registro
    Created on : 5 oct. 2025, 14:14:12
    Author     : Matheus
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Clínica Dental - Crear Cuenta</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            background-image: url('https://images.unsplash.com/photo-1588776814546-da631a343412?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .registro-container {
            background: rgba(255, 255, 255, 0.9);
            padding: 2rem 3rem;
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(8.5px);
            -webkit-backdrop-filter: blur(8.5px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            text-align: center;
            max-width: 800px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 2rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }
        .form-group {
            text-align: left;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-top: 0.5rem;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            grid-column: span 2;
            padding: 15px;
            border: none;
            border-radius: 8px;
            background-image: linear-gradient(to right, #4CAF50, #2E7D32);
            color: white;
            font-size: 18px;
            cursor: pointer;
            transition: transform 0.2s;
        }
        input[type="submit"]:hover {
            transform: scale(1.05);
        }
        .form-footer {
            grid-column: span 2;
            margin-top: 1rem;
        }
        .checkbox-group {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .login-link {
            margin-top: 2rem;
            font-size: 14px;
        }
        .login-link a {
            color: #8E44AD;
            text-decoration: none;
            font-weight: 600;
        }
        .password-rules {
            font-size: 12px;
            color: #555;
            text-align: left;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="registro-container">
        <h1>Crear cuenta de Paciente</h1>
        <form action="registro" method="post" class="form-grid">
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
            <div class="form-footer checkbox-group">
                <div>
                    <input type="checkbox" id="recordarme">
                    <label for="recordarme">Recordarme</label>
                </div>
                <a href="#" style="color: #1E88E5;">¿Olvidaste tu contraseña?</a>
            </div>
        </form>
        <div class="login-link">
            ¿Ya tienes cuenta? <a href="index.jsp">Inicia sesión aquí</a>
        </div>
    </div>
</body>
</html>