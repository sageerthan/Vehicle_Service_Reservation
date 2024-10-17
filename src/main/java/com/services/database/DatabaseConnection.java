package com.services.database;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseConnection {

    private static final Properties PROPERTIES = new Properties();

    static {
        // Load properties when the class is loaded
        loadProperties();
    }

    private DatabaseConnection() {
        // Private constructor to prevent instantiation
    }

    private static void loadProperties() {
        try (InputStream input = DatabaseConnection.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (input != null) {
                PROPERTIES.load(input);
            } else {
                throw new IOException("Property file 'application.properties' not found in the classpath.");
            }
        } catch (IOException e) {
            System.err.println("Failed to load database properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static Connection getConnection() {
        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the connection using loaded properties
            return DriverManager.getConnection(
                    PROPERTIES.getProperty("db.url"),
                    PROPERTIES.getProperty("db.username"),
                    PROPERTIES.getProperty("db.password")
            );
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Failed to establish database connection: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                System.err.println("Failed to close database connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }
}
