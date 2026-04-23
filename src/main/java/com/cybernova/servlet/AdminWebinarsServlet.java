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
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/webinars")
public class AdminWebinarsServlet extends HttpServlet {

    private final WebinarDAO webinarDAO = new WebinarDAO();
    private final WebinarRegistrationDAO registrationDAO = new WebinarRegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String viewParam = request.getParameter("view");

            if ("registrations".equals(viewParam)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int webinarId = Integer.parseInt(idParam.trim());
                    Webinar webinar = webinarDAO.findById(webinarId);
                    List<WebinarRegistration> registrations = registrationDAO.findByWebinarId(webinarId);
                    request.setAttribute("webinar", webinar);
                    request.setAttribute("registrations", registrations);
                    request.getRequestDispatcher("/admin/webinar-registrations.jsp").forward(request, response);
                    return;
                }
            }

            List<Webinar> webinars = webinarDAO.findAllWebinars();
            request.setAttribute("webinars", webinars);

            String success = request.getParameter("success");
            String deleted = request.getParameter("deleted");
            if (success != null) request.setAttribute("successMessage", "Webinar created successfully.");
            if (deleted != null) request.setAttribute("successMessage", "Webinar deleted.");

            request.getRequestDispatcher("/admin/webinars.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                String dateParam = request.getParameter("webinarDate");
                String time = request.getParameter("webinarTime");
                String platform = request.getParameter("platform");
                String speaker = request.getParameter("speaker");

                if (title == null || title.trim().isEmpty() || dateParam == null || time == null) {
                    request.setAttribute("formError", "Title, date, and time are required.");
                    List<Webinar> webinars = webinarDAO.findAllWebinars();
                    request.setAttribute("webinars", webinars);
                    request.getRequestDispatcher("/admin/webinars.jsp").forward(request, response);
                    return;
                }

                Webinar w = new Webinar();
                w.setTitle(title.trim());
                w.setDescription(description != null ? description.trim() : "");
                w.setWebinarDate(Date.valueOf(dateParam.trim()));
                w.setWebinarTime(time.trim());
                w.setPlatform(platform != null && !platform.trim().isEmpty() ? platform.trim() : "Online");
                w.setSpeaker(speaker != null ? speaker.trim() : "");

                webinarDAO.save(w);
                response.sendRedirect(request.getContextPath() + "/admin/webinars?success=1");

            } else if ("delete".equals(action)) {
                String idParam = request.getParameter("webinarId");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    webinarDAO.delete(Integer.parseInt(idParam.trim()));
                }
                response.sendRedirect(request.getContextPath() + "/admin/webinars?deleted=1");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
