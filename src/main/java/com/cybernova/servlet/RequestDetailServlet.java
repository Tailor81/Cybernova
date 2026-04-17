package com.cybernova.servlet;

import com.cybernova.dao.ServiceRequestDAO;
import com.cybernova.model.ServiceRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/request-detail")
public class RequestDetailServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String requestIdParam = request.getParameter("id");

        try {
            int requestId = Integer.parseInt(requestIdParam);
            ServiceRequest foundRequest = requestDAO.findRequestById(requestId);

            if (foundRequest == null) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            request.setAttribute("serviceRequest", foundRequest);
            request.getRequestDispatcher("/admin/request-detail.jsp").forward(request, response);

        } catch (NumberFormatException invalidId) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } catch (Exception loadError) {
            request.setAttribute("detailError", "Could not load request details");
            request.getRequestDispatcher("/admin/request-detail.jsp").forward(request, response);
        }
    }
}
