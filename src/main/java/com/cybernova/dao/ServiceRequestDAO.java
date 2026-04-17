package com.cybernova.dao;

import com.cybernova.model.ServiceRequest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ServiceRequestDAO {

    public int saveNewRequest(ServiceRequest request) throws Exception {
        String insertQuery = "INSERT INTO service_request "
                + "(full_name, email, phone_number, organisation_name, country, "
                + "job_title, industry_sector, service_type, description) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS)) {

            statement.setString(1, request.getFullName());
            statement.setString(2, request.getEmail());
            statement.setString(3, request.getPhoneNumber());
            statement.setString(4, request.getOrganisationName());
            statement.setString(5, request.getCountry());
            statement.setString(6, request.getJobTitle());
            statement.setString(7, request.getIndustrySector());
            statement.setString(8, request.getServiceType());
            statement.setString(9, request.getDescription());

            statement.executeUpdate();
            ResultSet generatedKeys = statement.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1);
            }
            return -1;
        }
    }

    public List<ServiceRequest> findAllRequests() throws Exception {
        String selectQuery = "SELECT * FROM service_request ORDER BY submission_date DESC";
        List<ServiceRequest> allRequests = new ArrayList<>();

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet rows = statement.executeQuery(selectQuery)) {

            while (rows.next()) {
                allRequests.add(buildRequestFromRow(rows));
            }
        }
        return allRequests;
    }

    public ServiceRequest findRequestById(int requestId) throws Exception {
        String selectQuery = "SELECT * FROM service_request WHERE request_id = ?";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(selectQuery)) {

            statement.setInt(1, requestId);
            ResultSet row = statement.executeQuery();

            if (row.next()) {
                return buildRequestFromRow(row);
            }
            return null;
        }
    }

    public List<ServiceRequest> searchRequests(String searchTerm) throws Exception {
        String searchQuery = "SELECT * FROM service_request WHERE "
                + "LOWER(full_name) LIKE LOWER(?) OR "
                + "LOWER(email) LIKE LOWER(?) OR "
                + "LOWER(organisation_name) LIKE LOWER(?) OR "
                + "LOWER(service_type) LIKE LOWER(?) OR "
                + "LOWER(country) LIKE LOWER(?) "
                + "ORDER BY submission_date DESC";

        String wildcardTerm = "%" + searchTerm + "%";
        List<ServiceRequest> matchingRequests = new ArrayList<>();

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(searchQuery)) {

            for (int paramIndex = 1; paramIndex <= 5; paramIndex++) {
                statement.setString(paramIndex, wildcardTerm);
            }

            ResultSet rows = statement.executeQuery();
            while (rows.next()) {
                matchingRequests.add(buildRequestFromRow(rows));
            }
        }
        return matchingRequests;
    }

    public List<ServiceRequest> filterByServiceType(String serviceType) throws Exception {
        String filterQuery = "SELECT * FROM service_request WHERE service_type = ? ORDER BY submission_date DESC";
        List<ServiceRequest> filteredRequests = new ArrayList<>();

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(filterQuery)) {

            statement.setString(1, serviceType);
            ResultSet rows = statement.executeQuery();

            while (rows.next()) {
                filteredRequests.add(buildRequestFromRow(rows));
            }
        }
        return filteredRequests;
    }

    public void updateExistingRequest(ServiceRequest request) throws Exception {
        String updateQuery = "UPDATE service_request SET "
                + "full_name = ?, email = ?, phone_number = ?, organisation_name = ?, "
                + "country = ?, job_title = ?, industry_sector = ?, service_type = ?, "
                + "description = ?, status = ? WHERE request_id = ?";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(updateQuery)) {

            statement.setString(1, request.getFullName());
            statement.setString(2, request.getEmail());
            statement.setString(3, request.getPhoneNumber());
            statement.setString(4, request.getOrganisationName());
            statement.setString(5, request.getCountry());
            statement.setString(6, request.getJobTitle());
            statement.setString(7, request.getIndustrySector());
            statement.setString(8, request.getServiceType());
            statement.setString(9, request.getDescription());
            statement.setString(10, request.getStatus());
            statement.setInt(11, request.getRequestId());

            statement.executeUpdate();
        }
    }

    public void deleteRequestById(int requestId) throws Exception {
        String deleteQuery = "DELETE FROM service_request WHERE request_id = ?";

        try (Connection database = DatabaseConnection.openConnection();
             PreparedStatement statement = database.prepareStatement(deleteQuery)) {

            statement.setInt(1, requestId);
            statement.executeUpdate();
        }
    }

    public int countTotalRequests() throws Exception {
        String countQuery = "SELECT COUNT(*) AS total FROM service_request";

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet result = statement.executeQuery(countQuery)) {

            if (result.next()) {
                return result.getInt("total");
            }
            return 0;
        }
    }

    public Map<String, Integer> countRequestsGroupedByServiceType() throws Exception {
        String groupQuery = "SELECT service_type, COUNT(*) AS total "
                + "FROM service_request GROUP BY service_type ORDER BY total DESC";
        return executeGroupedCount(groupQuery);
    }

    public Map<String, Integer> countRequestsGroupedByCountry() throws Exception {
        String groupQuery = "SELECT country, COUNT(*) AS total "
                + "FROM service_request GROUP BY country ORDER BY total DESC";
        return executeGroupedCount(groupQuery);
    }

    public Map<String, Integer> countRequestsGroupedByStatus() throws Exception {
        String groupQuery = "SELECT status, COUNT(*) AS total "
                + "FROM service_request GROUP BY status ORDER BY total DESC";
        return executeGroupedCount(groupQuery);
    }

    public Map<String, Integer> countRequestsGroupedByIndustry() throws Exception {
        String groupQuery = "SELECT industry_sector, COUNT(*) AS total "
                + "FROM service_request WHERE industry_sector IS NOT NULL AND industry_sector != '' "
                + "GROUP BY industry_sector ORDER BY total DESC";
        return executeGroupedCount(groupQuery);
    }

    public int countDistinctCountries() throws Exception {
        String countQuery = "SELECT COUNT(DISTINCT country) AS total FROM service_request";

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet result = statement.executeQuery(countQuery)) {

            if (result.next()) {
                return result.getInt("total");
            }
            return 0;
        }
    }

    public int countResolvedRequests() throws Exception {
        String countQuery = "SELECT COUNT(*) AS total FROM service_request WHERE status = 'resolved'";

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet result = statement.executeQuery(countQuery)) {

            if (result.next()) {
                return result.getInt("total");
            }
            return 0;
        }
    }

    private Map<String, Integer> executeGroupedCount(String query) throws Exception {
        Map<String, Integer> groupedCounts = new LinkedHashMap<>();

        try (Connection database = DatabaseConnection.openConnection();
             Statement statement = database.createStatement();
             ResultSet rows = statement.executeQuery(query)) {

            while (rows.next()) {
                groupedCounts.put(rows.getString(1), rows.getInt("total"));
            }
        }
        return groupedCounts;
    }

    private ServiceRequest buildRequestFromRow(ResultSet row) throws Exception {
        ServiceRequest request = new ServiceRequest();
        request.setRequestId(row.getInt("request_id"));
        request.setFullName(row.getString("full_name"));
        request.setEmail(row.getString("email"));
        request.setPhoneNumber(row.getString("phone_number"));
        request.setOrganisationName(row.getString("organisation_name"));
        request.setCountry(row.getString("country"));
        request.setJobTitle(row.getString("job_title"));
        request.setIndustrySector(row.getString("industry_sector"));
        request.setServiceType(row.getString("service_type"));
        request.setDescription(row.getString("description"));
        request.setStatus(row.getString("status"));
        request.setSubmissionDate(row.getTimestamp("submission_date"));
        return request;
    }
}
