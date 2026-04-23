package com.cybernova.servlet;

import com.cybernova.dao.WebinarDAO;
import com.cybernova.model.Webinar;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/webinars")
public class WebinarsServlet extends HttpServlet {

    private final WebinarDAO webinarDAO = new WebinarDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Webinar> webinars = webinarDAO.findAllWebinars();
            request.setAttribute("webinars", webinars);
        } catch (Exception e) {
            throw new ServletException(e);
        }
        request.getRequestDispatcher("/webinars.jsp").forward(request, response);
    }
}
