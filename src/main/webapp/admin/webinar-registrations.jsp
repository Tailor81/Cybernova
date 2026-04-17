<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Webinar Registrations - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="admin-body">

<div class="admin-layout">

    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="webinars"/>
    </jsp:include>

    <main class="admin-main">
        <div class="admin-topbar">
            <button class="admin-mobile-toggle" id="adminMenuToggle"><i class="fa-solid fa-bars"></i></button>
            <h1>Webinar Registrations</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <a href="${pageContext.request.contextPath}/admin/webinars" class="back-link"><i class="fa-solid fa-arrow-left"></i> Back to Webinars</a>

            <div class="admin-header" style="margin-top: 12px;">
                <h2>${webinar.title}</h2>
                <p style="color: var(--gray-500); font-size: 0.9rem; margin-top: 4px;">
                    <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${webinar.webinarDate}" pattern="d MMM yyyy"/> &nbsp;
                    <i class="fa-regular fa-clock"></i> ${webinar.webinarTime} &nbsp;
                    <i class="fa-solid fa-users"></i> ${registrations.size()} registered
                </p>
            </div>

            <c:choose>
                <c:when test="${empty registrations}">
                    <div class="chart-card" style="text-align: center; padding: 40px; color: var(--gray-500);">
                        No registrations yet for this webinar.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Organisation</th>
                                    <th>Phone</th>
                                    <th>Registered</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${registrations}" var="reg" varStatus="loop">
                                    <tr>
                                        <td>${loop.index + 1}</td>
                                        <td>${reg.fullName}</td>
                                        <td>${reg.email}</td>
                                        <td>${not empty reg.organisation ? reg.organisation : '-'}</td>
                                        <td>${not empty reg.phone ? reg.phone : '-'}</td>
                                        <td><fmt:formatDate value="${reg.registrationDate}" pattern="d MMM yyyy, HH:mm"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
