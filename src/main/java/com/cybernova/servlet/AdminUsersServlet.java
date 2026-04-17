package com.cybernova.servlet;

import com.cybernova.dao.AdminDAO;
import com.cybernova.model.Admin;
import com.cybernova.util.PasswordHasher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (request.getSession(false) == null || request.getSession(false).getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }
        try {
            List<Admin> admins = adminDAO.findAll();
            request.setAttribute("admins", admins);
            request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
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
                int id = Integer.parseInt(request.getParameter("adminId"));
                // Prevent deleting self
                String currentUser = (String) request.getSession(false).getAttribute("adminUsername");
                Admin target = adminDAO.findAll().stream()
                        .filter(a -> a.getAdminId() == id)
                        .findFirst().orElse(null);
                if (target != null && target.getUsername().equals(currentUser)) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=self");
                    return;
                }
                // Prevent deleting last admin
                if (adminDAO.countAdmins() <= 1) {
                    response.sendRedirect(request.getContextPath() + "/admin/users?error=last");
                    return;
                }
                adminDAO.deleteById(id);
                response.sendRedirect(request.getContextPath() + "/admin/users?deleted=true");
            } catch (Exception e) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=delete");
            }
            return;
        }

        // create
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");

            if (username == null || username.trim().isEmpty() || password == null || password.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=invalid");
                return;
            }

            if (!password.equals(confirmPassword)) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=mismatch");
                return;
            }

            if (adminDAO.findByUsername(username.trim()) != null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?error=exists");
                return;
            }

            String hash = PasswordHasher.hashPassword(password);
            adminDAO.createAdmin(username.trim(), hash);
            response.sendRedirect(request.getContextPath() + "/admin/users?success=true");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
