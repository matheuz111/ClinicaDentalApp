package com.dental.app.clinicadentalapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {
    
    // CAMBIO 1: La URL ya NO tiene 'integratedSecurity=true'
    private static final String URL = "jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=ClinicaDental;encrypt=true;trustServerCertificate=true;";
    
    // CAMBIO 2: Ahora SÍ usamos el usuario y contraseña que acabamos de crear en SSMS
    private static final String USER = "clinic_app_user"; 
    private static final String PASSWORD = "123456"; // ¡PON AQUÍ LA CONTRASEÑA QUE ELEGIStE!

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            // CAMBIO 3: Volvemos a pasar el usuario y la contraseña al método de conexión
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error: Driver JDBC de SQL Server no encontrado.", e);
        }
    }
}