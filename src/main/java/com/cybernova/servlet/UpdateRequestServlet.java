package com.cybernova.servlet;

import com.cybernova.dao.ServiceRequestDAO;
import com.cybernova.model.ServiceRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/update-request")
public class UpdateRequestServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));

            ServiceRequest updatedRequest = new ServiceRequest();
            updatedRequest.setRequestId(requestId);
            updatedRequest.setFullName(request.getParameter("fullName").trim());
            updatedRequest.setEmail(request.getParameter("email").trim());
            updatedRequest.setPhoneNumber(request.getParameter("phoneNumber"));
            updatedRequest.setOrganisationName(request.getParameter("organisationName"));
            updatedRequest.setCountry(request.getParameter("country"));
            updatedRequest.setJobTitle(request.getParameter("jobTitle"));
            updatedRequest.setIndustrySector(request.getParameter("industrySector"));
            updatedRequest.setServiceType(request.getParameter("serviceType"));
            updatedRequest.setDescription(request.getParameter("description"));
            updatedRequest.setStatus(request.getParameter("status"));

            requestDAO.updateExistingRequest(updatedRequest);

            response.sendRedirect(request.getContextPath()
                    + "/admin/request-detail?id=" + requestId + "&updated=true");

        } catch (Exception updateError) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=update");
        }
    }
}
