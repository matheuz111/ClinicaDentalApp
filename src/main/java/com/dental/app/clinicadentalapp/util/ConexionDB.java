package com.dental.app.clinicadentalapp.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionDB {

    private static final String URL = "jdbc:postgresql://dpg-d3rb1s3uibrs73fqhr5g-a.virginia-postgres.render.com:5432/clinicadental_w71y"; 

    private static final String USER = "clinic_user"; 
    private static final String PASSWORD = "yrVkdRxr7U9kWjcxfWwJ9g9ztMWxdBKL"; 

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
            // Esta línea usa los nuevos datos de arriba para conectarse.
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("Error: Driver JDBC de PostgreSQL no encontrado.", e);
        }
    }

}