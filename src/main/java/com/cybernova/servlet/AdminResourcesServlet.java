package com.cybernova.servlet;

import com.cybernova.dao.ResourceDAO;
import com.cybernova.model.Resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@WebServlet("/admin/resources")
@MultipartConfig(maxFileSize = 20 * 1024 * 1024, maxRequestSize = 25 * 1024 * 1024)
public class AdminResourcesServlet extends HttpServlet {

    private final ResourceDAO resourceDAO = new ResourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) == null || request.getSession(false).getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        try {
            List<Resource> resources = resourceDAO.findAll();
            request.setAttribute("resources", resources);
            request.getRequestDispatcher("/admin/resources.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) == null || request.getSession(false).getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("resourceId"));
                resourceDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin/resources?deleted=true");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/resources?error=delete");
            }
            return;
        }

        // upload
        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String category = request.getParameter("category");

            Part filePart = request.getPart("file");
            String fileName = extractFileName(filePart);
            String fileType = filePart.getContentType();

            if (title == null || title.trim().isEmpty() || fileName == null || fileName.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/resources?error=invalid");
                return;
            }

            byte[] fileData;
            try (InputStream in = filePart.getInputStream()) {
                fileData = in.readAllBytes();
            }

            resourceDAO.save(title.trim(), description, category, fileName, fileType, fileData);
            response.sendRedirect(request.getContextPath() + "/admin/resources?success=true");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String extractFileName(Part part) {
        String disposition = part.getHeader("content-disposition");
        if (disposition == null) return null;
        for (String token : disposition.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String name = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int slash = Math.max(name.lastIndexOf('/'), name.lastIndexOf('\\'));
                return slash >= 0 ? name.substring(slash + 1) : name;
            }
        }
        return null;
    }
}
