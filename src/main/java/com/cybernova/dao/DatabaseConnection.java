package com.cybernova.dao;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class DatabaseConnection {

    private static final Map<String, String> dotEnv = new HashMap<>();

    static {
        try (InputStream configStream = DatabaseConnection.class
                .getClassLoader()
                .getResourceAsStream("db.properties")) {
            Properties driverConfig = new Properties();
            driverConfig.load(configStream);
            Class.forName(driverConfig.getProperty("db.driver", "org.postgresql.Driver"));
        } catch (Exception e) {
            throw new RuntimeException("Database driver could not be loaded", e);
        }

        try (InputStream envStream = DatabaseConnection.class
                .getClassLoader()
                .getResourceAsStream(".env")) {
            if (envStream != null) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(envStream));
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#")) continue;
                    int idx = line.indexOf('=');
                    if (idx > 0) {
                        String key = line.substring(0, idx).trim();
                        String value = line.substring(idx + 1).trim();
                        if ((value.startsWith("\"") && value.endsWith("\""))
                                || (value.startsWith("'") && value.endsWith("'"))) {
                            value = value.substring(1, value.length() - 1);
                        }
                        dotEnv.put(key, value);
                    }
                }
            }
        } catch (Exception ignored) {
        }
    }

    private static String resolve(String key) {
        String envValue = System.getenv(key);
        return (envValue != null && !envValue.isEmpty()) ? envValue : dotEnv.get(key);
    }

    public static Connection openConnection() throws Exception {
        return DriverManager.getConnection(resolve("DB_URL"), resolve("DB_USER"), resolve("DB_PASSWORD"));
    }
}
