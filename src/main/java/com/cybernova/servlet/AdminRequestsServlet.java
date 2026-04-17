package com.cybernova.servlet;

import com.cybernova.dao.ServiceRequestDAO;
import com.cybernova.model.ServiceRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/requests")
public class AdminRequestsServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String searchQuery = request.getParameter("search");
            String filterType = request.getParameter("filterType");
            List<ServiceRequest> displayedRequests;

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                displayedRequests = requestDAO.searchRequests(searchQuery.trim());
                request.setAttribute("activeSearch", searchQuery);
            } else if (filterType != null && !filterType.trim().isEmpty()) {
                displayedRequests = requestDAO.filterByServiceType(filterType.trim());
                request.setAttribute("activeFilter", filterType);
            } else {
                displayedRequests = requestDAO.findAllRequests();
            }

            int totalRequestCount = requestDAO.countTotalRequests();
            request.setAttribute("requests", displayedRequests);
            request.setAttribute("totalCount", totalRequestCount);
            request.getRequestDispatcher("/admin/requests.jsp").forward(request, response);

        } catch (Exception loadError) {
            request.setAttribute("dashboardError", "Could not load requests: " + loadError.getMessage());
            request.getRequestDispatcher("/admin/requests.jsp").forward(request, response);
        }
    }
}
