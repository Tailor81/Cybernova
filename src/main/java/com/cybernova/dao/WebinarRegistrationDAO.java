package com.cybernova.dao;

import com.cybernova.model.WebinarRegistration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class WebinarRegistrationDAO {

    public int save(WebinarRegistration reg) throws Exception {
        String query = "INSERT INTO webinar_registration (webinar_id, full_name, email, organisation, phone) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setInt(1, reg.getWebinarId());
            stmt.setString(2, reg.getFullName());
            stmt.setString(3, reg.getEmail());
            stmt.setString(4, reg.getOrganisation());
            stmt.setString(5, reg.getPhone());
            stmt.executeUpdate();

            ResultSet keys = stmt.getGeneratedKeys();
            if (keys.next()) {
                return keys.getInt(1);
            }
            return -1;
        }
    }

    public List<WebinarRegistration> findByWebinarId(int webinarId) throws Exception {
        String query = "SELECT * FROM webinar_registration WHERE webinar_id = ? ORDER BY registration_date DESC";
        List<WebinarRegistration> list = new ArrayList<>();

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, webinarId);
            ResultSet rows = stmt.executeQuery();
            while (rows.next()) {
                list.add(mapRow(rows));
            }
        }
        return list;
    }

    public boolean hasAlreadyRegistered(int webinarId, String email) throws Exception {
        String query = "SELECT COUNT(*) FROM webinar_registration WHERE webinar_id = ? AND LOWER(email) = LOWER(?)";

        try (Connection db = DatabaseConnection.openConnection();
             PreparedStatement stmt = db.prepareStatement(query)) {

            stmt.setInt(1, webinarId);
            stmt.setString(2, email);
            ResultSet row = stmt.executeQuery();
            if (row.next()) {
                return row.getInt(1) > 0;
            }
            return false;
        }
    }

    private WebinarRegistration mapRow(ResultSet row) throws Exception {
        WebinarRegistration r = new WebinarRegistration();
        r.setRegistrationId(row.getInt("registration_id"));
        r.setWebinarId(row.getInt("webinar_id"));
        r.setFullName(row.getString("full_name"));
        r.setEmail(row.getString("email"));
        r.setOrganisation(row.getString("organisation"));
        r.setPhone(row.getString("phone"));
        r.setRegistrationDate(row.getTimestamp("registration_date"));
        return r;
    }
}
