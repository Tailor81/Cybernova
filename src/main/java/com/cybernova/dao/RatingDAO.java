package com.cybernova.dao;

import com.cybernova.model.Rating;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class RatingDAO {

    public void saveNewRating(Rating rating) throws Exception {
        String insertQuery = "INSERT INTO rating (request_id, customer_name, rating_value, comment) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(insertQuery)) {

            if (rating.getRequestId() != null) {
                statement.setInt(1, rating.getRequestId());
            } else {
                statement.setNull(1, Types.INTEGER);
            }
            statement.setString(2, rating.getCustomerName());
            statement.setInt(3, rating.getRatingValue());
            statement.setString(4, rating.getComment());

            statement.executeUpdate();
        }
    }

    public List<Rating> findAllRatings() throws Exception {
        String selectQuery = "SELECT * FROM rating ORDER BY created_date DESC";
        List<Rating> allRatings = new ArrayList<>();

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet rows = statement.executeQuery(selectQuery)) {

            while (rows.next()) {
                allRatings.add(buildRatingFromRow(rows));
            }
        }
        return allRatings;
    }

    public double calculateAverageRating() throws Exception {
        String averageQuery = "SELECT AVG(rating_value) AS average FROM rating";

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet result = statement.executeQuery(averageQuery)) {

            if (result.next()) {
                return Math.round(result.getDouble("average") * 10.0) / 10.0;
            }
            return 0.0;
        }
    }

    public int countTotalRatings() throws Exception {
        String countQuery = "SELECT COUNT(*) AS total FROM rating";

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet result = statement.executeQuery(countQuery)) {

            if (result.next()) {
                return result.getInt("total");
            }
            return 0;
        }
    }

    private Rating buildRatingFromRow(ResultSet row) throws Exception {
        Rating rating = new Rating();
        rating.setRatingId(row.getInt("rating_id"));
        int linkedRequestId = row.getInt("request_id");
        rating.setRequestId(row.wasNull() ? null : linkedRequestId);
        rating.setCustomerName(row.getString("customer_name"));
        rating.setRatingValue(row.getInt("rating_value"));
        rating.setComment(row.getString("comment"));
        rating.setCreatedDate(row.getTimestamp("created_date"));
        return rating;
    }
}
