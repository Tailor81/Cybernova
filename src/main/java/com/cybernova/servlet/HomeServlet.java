package com.cybernova.servlet;

import com.cybernova.dao.RatingDAO;
import com.cybernova.dao.ServiceRequestDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"", "/home"})
public class HomeServlet extends HttpServlet {

    private ServiceRequestDAO requestDAO = new ServiceRequestDAO();
    private RatingDAO ratingDAO = new RatingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int totalRequests = requestDAO.countTotalRequests();
            int resolvedThreats = requestDAO.countResolvedRequests();
            int countriesServed = requestDAO.countDistinctCountries();
            int totalRatings = ratingDAO.countTotalRatings();

            request.setAttribute("resolvedThreats", resolvedThreats);
            request.setAttribute("countriesServed", countriesServed);
            request.setAttribute("totalClients", totalRatings);

        } catch (Exception queryFailure) {
            getServletContext().log("Failed to load homepage stats: " + queryFailure.getMessage());
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
