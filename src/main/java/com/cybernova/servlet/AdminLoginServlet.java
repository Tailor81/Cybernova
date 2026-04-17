package com.cybernova.servlet;

import com.cybernova.dao.AdminDAO;
import com.cybernova.model.Admin;
import com.cybernova.util.PasswordHasher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Admin matchingAdmin = adminDAO.findByUsername(username);

            if (matchingAdmin != null && PasswordHasher.verifyPassword(password, matchingAdmin.getPasswordHash())) {
                HttpSession session = request.getSession();
                session.setAttribute("adminLoggedIn", true);
                session.setAttribute("adminUsername", matchingAdmin.getUsername());
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            request.setAttribute("loginError", "Invalid username or password");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);

        } catch (Exception authenticationError) {
            request.setAttribute("loginError", "System error. Please try again.");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }
}
