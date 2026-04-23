package com.cybernova.servlet;

import com.cybernova.dao.ResourceDAO;
import com.cybernova.model.Resource;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/resource-download")
public class ResourceDownloadServlet extends HttpServlet {

    private final ResourceDAO resourceDAO = new ResourceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing resource id");
            return;
        }

        try {
            int id = Integer.parseInt(idParam.trim());
            Resource resource = resourceDAO.findById(id);

            if (resource == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found");
                return;
            }

            byte[] fileData = resourceDAO.getFileData(id);
            if (fileData == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File data not found");
                return;
            }

            String contentType = resource.getFileType() != null ? resource.getFileType() : "application/octet-stream";
            response.setContentType(contentType);
            response.setContentLengthLong(fileData.length);

            // Sanitize filename for Content-Disposition header
            String safeFileName = resource.getFileName().replaceAll("[^a-zA-Z0-9._\\-]", "_");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + safeFileName + "\"");

            try (OutputStream out = response.getOutputStream()) {
                out.write(fileData);
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid resource id");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
