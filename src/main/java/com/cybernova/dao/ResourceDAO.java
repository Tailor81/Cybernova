package com.cybernova.dao;

import com.cybernova.model.Resource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResourceDAO {

    public List<Resource> findAll() throws Exception {
        String query = "SELECT resource_id, title, description, category, file_name, file_type, file_size, uploaded_date "
                + "FROM resource ORDER BY uploaded_date DESC";
        List<Resource> resources = new ArrayList<>();

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Resource r = new Resource();
                r.setResourceId(rs.getInt("resource_id"));
                r.setTitle(rs.getString("title"));
                r.setDescription(rs.getString("description"));
                r.setCategory(rs.getString("category"));
                r.setFileName(rs.getString("file_name"));
                r.setFileType(rs.getString("file_type"));
                r.setFileSize(rs.getLong("file_size"));
                r.setUploadedDate(rs.getTimestamp("uploaded_date"));
                resources.add(r);
            }
        }
        return resources;
    }

    public void save(String title, String description, String category,
                     String fileName, String fileType, byte[] fileData) throws Exception {
        String query = "INSERT INTO resource (title, description, category, file_name, file_type, file_size, file_data) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setString(1, title);
            stmt.setString(2, description);
            stmt.setString(3, category);
            stmt.setString(4, fileName);
            stmt.setString(5, fileType);
            stmt.setLong(6, fileData.length);
            stmt.setBytes(7, fileData);
            stmt.executeUpdate();
        }
    }

    public void delete(int resourceId) throws Exception {
        String query = "DELETE FROM resource WHERE resource_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, resourceId);
            stmt.executeUpdate();
        }
    }

    public Resource findById(int resourceId) throws Exception {
        String query = "SELECT * FROM resource WHERE resource_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, resourceId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Resource r = new Resource();
                r.setResourceId(rs.getInt("resource_id"));
                r.setTitle(rs.getString("title"));
                r.setFileName(rs.getString("file_name"));
                r.setFileType(rs.getString("file_type"));
                r.setFileSize(rs.getLong("file_size"));
                return r;
            }
            return null;
        }
    }

    public byte[] getFileData(int resourceId) throws Exception {
        String query = "SELECT file_data FROM resource WHERE resource_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, resourceId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getBytes("file_data");
            }
            return null;
        }
    }
}
