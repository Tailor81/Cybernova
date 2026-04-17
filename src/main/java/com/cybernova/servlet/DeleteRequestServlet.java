package com.cybernova.servlet;

import com.cybernova.dao.ServiceRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/delete-request")
public class DeleteRequestServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            requestDAO.deleteRequestById(requestId);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?deleted=true");

        } catch (Exception deleteError) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=delete");
        }
    }
}
