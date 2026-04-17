package com.cybernova.servlet;

import com.cybernova.dao.RatingDAO;
import com.cybernova.dao.ServiceRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/analytics")
public class AnalyticsServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();
    private final RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int totalRequests = requestDAO.countTotalRequests();
            Map<String, Integer> requestsByServiceType = requestDAO.countRequestsGroupedByServiceType();
            Map<String, Integer> requestsByCountry = requestDAO.countRequestsGroupedByCountry();
            Map<String, Integer> requestsByStatus = requestDAO.countRequestsGroupedByStatus();
            double averageRating = ratingDAO.calculateAverageRating();
            int totalRatings = ratingDAO.countTotalRatings();

            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("requestsByServiceType", requestsByServiceType);
            request.setAttribute("requestsByCountry", requestsByCountry);
            request.setAttribute("requestsByStatus", requestsByStatus);
            request.setAttribute("averageRating", averageRating);
            request.setAttribute("totalRatings", totalRatings);

            request.getRequestDispatcher("/admin/analytics.jsp").forward(request, response);

        } catch (Exception analyticsError) {
            request.setAttribute("analyticsError", "Could not load analytics data");
            request.getRequestDispatcher("/admin/analytics.jsp").forward(request, response);
        }
    }
}
