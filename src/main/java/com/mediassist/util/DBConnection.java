package com.mediassist.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL;
    private static final String USER;
    private static final String PASS;

    static {
        String envUrl = System.getenv("DB_URL");
        String envUser = System.getenv("DB_USER");
        String envPass = System.getenv("DB_PASS");

        if (envUrl != null && !envUrl.isEmpty()) {
            URL = envUrl;
            USER = envUser;
            PASS = envPass;
        } else {
            // Local development fallback
            URL = "jdbc:mysql://localhost:3306/mediassist?useSSL=false&serverTimezone=UTC";
            USER = "root";
            PASS = "Dish@7890";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("JDBC Driver not found: " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}