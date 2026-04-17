package com.cybernova.dao;

import com.cybernova.model.Admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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

    public List<Admin> findAll() throws Exception {
        String query = "SELECT admin_id, username FROM admin ORDER BY admin_id ASC";
        List<Admin> admins = new ArrayList<>();

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Admin admin = new Admin();
                admin.setAdminId(rs.getInt("admin_id"));
                admin.setUsername(rs.getString("username"));
                admins.add(admin);
            }
        }
        return admins;
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

    public void deleteById(int adminId) throws Exception {
        String query = "DELETE FROM admin WHERE admin_id = ?";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(query)) {

            statement.setInt(1, adminId);
            statement.executeUpdate();
        }
    }

    public int countAdmins() throws Exception {
        String query = "SELECT COUNT(*) FROM admin";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {

            if (rs.next()) return rs.getInt(1);
            return 0;
        }
    }
}

