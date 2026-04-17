<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle} - CyberNova Analytics</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<nav class="navbar">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/" class="nav-logo">
            <span class="logo-icon"><i class="fa-solid fa-shield-halved"></i></span>
            <span class="logo-text"><span class="logo-cyber">CyberNova</span> <span class="logo-nova">Analytics</span></span>
        </a>
        <button class="nav-toggle" id="navToggle" aria-label="Toggle navigation">
            <span class="hamburger"></span>
        </button>
        <ul class="nav-menu" id="navMenu">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/services.jsp">Services</a></li>
            <li><a href="${pageContext.request.contextPath}/webinars">Webinars</a></li>
            <li><a href="${pageContext.request.contextPath}/resources.jsp">Resources</a></li>
            <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/login.jsp" class="nav-cta">Login</a></li>
        </ul>
    </div>
</nav>
