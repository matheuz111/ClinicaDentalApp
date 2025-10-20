package com.dental.app.clinicadentalapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    // Lee las variables de entorno configuradas en Render
    private static final String URL = System.getenv("DB_URL");
    private static final String USER = System.getenv("DB_USER");
    private static final String PASSWORD = System.getenv("DB_PASSWORD"); 

    public static Connection getConnection() throws SQLException {
        try {
            // Verificar que las variables de entorno se cargaron
            if (URL == null || USER == null || PASSWORD == null) {
                throw new SQLException("Error: Faltan variables de entorno para la conexión a la base de datos.");
            }
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error: Driver JDBC de PostgreSQL no encontrado.", e);
        }
    }
}