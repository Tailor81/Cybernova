package com.cybernova.servlet;

import com.cybernova.dao.WebinarDAO;
import com.cybernova.dao.WebinarRegistrationDAO;
import com.cybernova.model.Webinar;
import com.cybernova.model.WebinarRegistration;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/webinar-register")
public class WebinarRegisterServlet extends HttpServlet {

    private final WebinarDAO webinarDAO = new WebinarDAO();
    private final WebinarRegistrationDAO registrationDAO = new WebinarRegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/webinars");
            return;
        }

        try {
            int webinarId = Integer.parseInt(idParam.trim());
            Webinar webinar = webinarDAO.findById(webinarId);

            if (webinar == null) {
                response.sendRedirect(request.getContextPath() + "/webinars");
                return;
            }

            request.setAttribute("webinar", webinar);
            request.getRequestDispatcher("/webinar-register.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/webinars");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("webinarId");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String organisation = request.getParameter("organisation");
        String phone = request.getParameter("phone");

        if (idParam == null || fullName == null || email == null
                || fullName.trim().isEmpty() || email.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/webinars");
            return;
        }

        try {
            int webinarId = Integer.parseInt(idParam.trim());
            Webinar webinar = webinarDAO.findById(webinarId);

            if (webinar == null) {
                response.sendRedirect(request.getContextPath() + "/webinars");
                return;
            }

            if (registrationDAO.hasAlreadyRegistered(webinarId, email.trim())) {
                request.setAttribute("webinar", webinar);
                request.setAttribute("alreadyRegistered", true);
                request.getRequestDispatcher("/webinar-register.jsp").forward(request, response);
                return;
            }

            WebinarRegistration reg = new WebinarRegistration();
            reg.setWebinarId(webinarId);
            reg.setFullName(fullName.trim());
            reg.setEmail(email.trim());
            reg.setOrganisation(organisation != null ? organisation.trim() : "");
            reg.setPhone(phone != null ? phone.trim() : "");

            registrationDAO.save(reg);

            request.setAttribute("webinar", webinar);
            request.setAttribute("registeredName", fullName.trim());
            request.getRequestDispatcher("/webinar-register.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
