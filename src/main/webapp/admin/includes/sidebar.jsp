<%@ page contentType="text/html;charset=UTF-8" %>
<div class="admin-mobile-overlay" id="adminOverlay"></div>
<aside class="admin-sidebar" id="adminSidebar">
    <div class="sidebar-brand">
        <span class="logo-icon"><i class="fa-solid fa-shield-halved"></i></span>
        <span class="sidebar-brand-text">CyberNova Admin</span>
    </div>
    <nav class="sidebar-nav">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="${param.activePage == 'dashboard' ? 'active' : ''}">
            <span class="sidebar-icon"><i class="fa-solid fa-chart-line"></i></span> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/admin/requests" class="${param.activePage == 'requests' ? 'active' : ''}">
            <span class="sidebar-icon"><i class="fa-solid fa-clipboard-list"></i></span> Requests
        </a>
        <a href="${pageContext.request.contextPath}/admin/webinars" class="${param.activePage == 'webinars' ? 'active' : ''}">
            <span class="sidebar-icon"><i class="fa-solid fa-video"></i></span> Webinars
        </a>
        <a href="${pageContext.request.contextPath}/admin/resources" class="${param.activePage == 'resources' ? 'active' : ''}">
            <span class="sidebar-icon"><i class="fa-solid fa-folder-open"></i></span> Resources
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="${param.activePage == 'users' ? 'active' : ''}">
            <span class="sidebar-icon"><i class="fa-solid fa-users"></i></span> Users
        </a>
    </nav>
    <div class="sidebar-bottom">
        <a href="${pageContext.request.contextPath}/admin/logout" class="sidebar-logout">
            <span class="sidebar-icon"><i class="fa-solid fa-right-from-bracket"></i></span> Logout
        </a>
    </div>
</aside>
