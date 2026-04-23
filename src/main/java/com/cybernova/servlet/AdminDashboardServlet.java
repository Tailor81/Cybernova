package com.cybernova.servlet;

import com.cybernova.dao.RatingDAO;
import com.cybernova.dao.ServiceRequestDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();
    private final RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int totalRequests = requestDAO.countTotalRequests();
            int totalRatings = ratingDAO.countTotalRatings();
            Map<String, Integer> requestsByServiceType = requestDAO.countRequestsGroupedByServiceType();
            Map<String, Integer> requestsByCountry = requestDAO.countRequestsGroupedByCountry();
            Map<String, Integer> requestsByIndustry = requestDAO.countRequestsGroupedByIndustry();

            int resolvedCount = requestDAO.countResolvedRequests();
            int conversionRate = totalRequests > 0 ? (resolvedCount * 100) / totalRequests : 0;

            request.setAttribute("totalRequests", totalRequests);
            request.setAttribute("webinarRegistrations", totalRatings);
            request.setAttribute("conversionRate", conversionRate);
            request.setAttribute("monthGrowth", 15);
            request.setAttribute("requestsByServiceType", requestsByServiceType);
            request.setAttribute("requestsByCountry", requestsByCountry);
            request.setAttribute("requestsByIndustry", requestsByIndustry);

            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);

        } catch (Exception loadError) {
            request.setAttribute("dashboardError", "Could not load dashboard: " + loadError.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
}
