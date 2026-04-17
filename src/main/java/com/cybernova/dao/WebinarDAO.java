package com.cybernova.dao;

import com.cybernova.model.Webinar;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class WebinarDAO {

    public List<Webinar> findAllWebinars() throws Exception {
        String query = "SELECT * FROM webinar ORDER BY webinar_date ASC";
        List<Webinar> webinars = new ArrayList<>();

        try (Connection db = DatabaseConnection.openConnection();
             Statement stmt = db.createStatement();
             ResultSet rows = stmt.executeQuery(query)) {

            while (rows.next()) {
                webinars.add(mapRow(rows));
            }
        }
        return webinars;
    }

    public Webinar findById(int webinarId) throws Exception {
        String query = "SELECT * FROM webinar WHERE webinar_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, webinarId);
            ResultSet row = stmt.executeQuery();
            if (row.next()) {
                return mapRow(row);
            }
            return null;
        }
    }

    public int save(Webinar webinar) throws Exception {
        String query = "INSERT INTO webinar (title, description, webinar_date, webinar_time, platform, speaker) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, webinar.getTitle());
            stmt.setString(2, webinar.getDescription());
            stmt.setDate(3, webinar.getWebinarDate());
            stmt.setString(4, webinar.getWebinarTime());
            stmt.setString(5, webinar.getPlatform());
            stmt.setString(6, webinar.getSpeaker());
            stmt.executeUpdate();

            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
            return -1;
        }
    }

    public void delete(int webinarId) throws Exception {
        String query = "DELETE FROM webinar WHERE webinar_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, webinarId);
            stmt.executeUpdate();
        }
    }

    public int countRegistrations(int webinarId) throws Exception {
        String query = "SELECT COUNT(*) FROM webinar_registration WHERE webinar_id = ?";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, webinarId);
            ResultSet row = stmt.executeQuery();
            if (row.next()) {
                return row.getInt(1);
            }
            return 0;
        }
    }

    private Webinar mapRow(ResultSet row) throws Exception {
        Webinar w = new Webinar();
        w.setWebinarId(row.getInt("webinar_id"));
        w.setTitle(row.getString("title"));
        w.setDescription(row.getString("description"));
        w.setWebinarDate(row.getDate("webinar_date"));
        w.setWebinarTime(row.getString("webinar_time"));
        w.setPlatform(row.getString("platform"));
        w.setSpeaker(row.getString("speaker"));
        w.setCreatedDate(row.getTimestamp("created_date"));
        return w;
    }
}
