package com.cybernova.servlet;

import com.cybernova.dao.ResourceDAO;
import com.cybernova.model.Resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/resources")
public class ResourcesServlet extends HttpServlet {

    private final ResourceDAO resourceDAO = new ResourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Resource> resources = resourceDAO.findAll();
            request.setAttribute("resources", resources);
            request.getRequestDispatcher("/resources.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
