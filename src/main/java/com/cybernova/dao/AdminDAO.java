package com.cybernova.dao;

import com.cybernova.model.Admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    public Admin findByUsername(String username) throws Exception {
        String selectQuery = "SELECT * FROM admin WHERE username = ?";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(selectQuery)) {

            statement.setString(1, username);
            ResultSet row = statement.executeQuery();

            if (row.next()) {
                Admin admin = new Admin();
                admin.setAdminId(row.getInt("admin_id"));
                admin.setUsername(row.getString("username"));
                admin.setPasswordHash(row.getString("password_hash"));
                return admin;
            }
            return null;
        }
    }

    public void createAdmin(String username, String passwordHash) throws Exception {
        String insertQuery = "INSERT INTO admin (username, password_hash) VALUES (?, ?)";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(insertQuery)) {

            statement.setString(1, username);
            statement.setString(2, passwordHash);
            statement.executeUpdate();
        }
    }
}
