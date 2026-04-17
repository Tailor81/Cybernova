package com.cybernova.servlet;

import com.cybernova.dao.ServiceRequestDAO;
import com.cybernova.model.ServiceRequest;
import com.cybernova.util.InputValidator;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/submit-request")
public class SubmitRequestServlet extends HttpServlet {

    private final ServiceRequestDAO requestDAO = new ServiceRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String organisationName = request.getParameter("organisationName");
        String country = request.getParameter("country");
        String jobTitle = request.getParameter("jobTitle");
        String industrySector = request.getParameter("industrySector");
        String serviceType = request.getParameter("serviceType");
        String description = request.getParameter("description");

        List<String> validationErrors = new ArrayList<>();

        if (InputValidator.isBlank(fullName)) {
            validationErrors.add("Full name is required");
        }
        if (!InputValidator.isValidEmail(email)) {
            validationErrors.add("A valid email address is required");
        }
        if (!InputValidator.isValidPhone(phoneNumber)) {
            validationErrors.add("Phone number format is not valid");
        }
        if (InputValidator.isBlank(country)) {
            validationErrors.add("Country is required");
        }
        if (InputValidator.isBlank(serviceType)) {
            validationErrors.add("Type of security issue is required");
        }
        if (!InputValidator.meetsMinimumLength(description, 10)) {
            validationErrors.add("Description must be at least 10 characters");
        }

        if (!validationErrors.isEmpty()) {
            request.setAttribute("errors", validationErrors);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("organisationName", organisationName);
            request.setAttribute("country", country);
            request.setAttribute("jobTitle", jobTitle);
            request.setAttribute("industrySector", industrySector);
            request.setAttribute("serviceType", serviceType);
            request.setAttribute("description", description);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }

        try {
            ServiceRequest newRequest = new ServiceRequest();
            newRequest.setFullName(fullName.trim());
            newRequest.setEmail(email.trim());
            newRequest.setPhoneNumber(phoneNumber != null ? phoneNumber.trim() : "");
            newRequest.setOrganisationName(organisationName != null ? organisationName.trim() : "");
            newRequest.setCountry(country.trim());
            newRequest.setJobTitle(jobTitle != null ? jobTitle.trim() : "");
            newRequest.setIndustrySector(industrySector != null ? industrySector.trim() : "");
            newRequest.setServiceType(serviceType.trim());
            newRequest.setDescription(description.trim());

            int savedRequestId = requestDAO.saveNewRequest(newRequest);
            request.setAttribute("requestId", savedRequestId);
            request.setAttribute("fullName", fullName.trim());
            request.getRequestDispatcher("/confirmation.jsp").forward(request, response);

        } catch (Exception databaseError) {
            validationErrors.add("Something went wrong. Please try again later.");
            request.setAttribute("errors", validationErrors);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        }
    }
}
