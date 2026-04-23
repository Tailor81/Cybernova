package com.cybernova.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/admin/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
        HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;

        String requestedPath = httpRequest.getServletPath();

        boolean isLoginPage = requestedPath.equals("/admin/login")
                || requestedPath.equals("/admin/login.jsp");

        if (isLoginPage) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        HttpSession currentSession = httpRequest.getSession(false);
        boolean isAuthenticated = currentSession != null
                && currentSession.getAttribute("adminLoggedIn") != null;

        if (isAuthenticated) {
            chain.doFilter(servletRequest, servletResponse);
        } else {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin/login.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}
