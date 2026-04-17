<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Requests - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="admin-body">

<div class="admin-layout">

    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="requests"/>
    </jsp:include>

    <main class="admin-main">
        <div class="admin-topbar">
            <h1>Requests</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <c:if test="${param.deleted == 'true'}">
                <div class="alert alert-success">Request has been deleted successfully.</div>
            </c:if>
            <c:if test="${param.error == 'delete'}">
                <div class="alert alert-error">Failed to delete the request.</div>
            </c:if>
            <c:if test="${param.error == 'update'}">
                <div class="alert alert-error">Failed to update the request.</div>
            </c:if>

            <div class="admin-controls">
                <form action="${pageContext.request.contextPath}/admin/requests" method="get" class="search-form">
                    <input type="text" name="search" value="${activeSearch}" placeholder="Search by name, email, organisation...">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <c:if test="${not empty activeSearch || not empty activeFilter}">
                        <a href="${pageContext.request.contextPath}/admin/requests" class="btn btn-outline">Clear</a>
                    </c:if>
                </form>

                <form action="${pageContext.request.contextPath}/admin/requests" method="get" class="filter-form">
                    <select name="filterType" onchange="this.form.submit()">
                        <option value="">Filter by service type</option>
                        <option value="AI Cyber Assistant" ${activeFilter == 'AI Cyber Assistant' ? 'selected' : ''}>AI Cyber Assistant</option>
                        <option value="Network Security Audit" ${activeFilter == 'Network Security Audit' ? 'selected' : ''}>Network Security Audit</option>
                        <option value="Penetration Testing" ${activeFilter == 'Penetration Testing' ? 'selected' : ''}>Penetration Testing</option>
                        <option value="Incident Response" ${activeFilter == 'Incident Response' ? 'selected' : ''}>Incident Response</option>
                        <option value="Security Consultation" ${activeFilter == 'Security Consultation' ? 'selected' : ''}>Security Consultation</option>
                        <option value="Cyber Awareness Training" ${activeFilter == 'Cyber Awareness Training' ? 'selected' : ''}>Cyber Awareness Training</option>
                    </select>
                </form>
            </div>

            <c:if test="${not empty dashboardError}">
                <div class="alert alert-error">${dashboardError}</div>
            </c:if>

            <div class="table-responsive">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Organisation</th>
                            <th>Service Type</th>
                            <th>Country</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${requests}" var="req">
                            <tr>
                                <td>#${req.requestId}</td>
                                <td>${req.fullName}</td>
                                <td>${req.email}</td>
                                <td>${req.organisationName}</td>
                                <td><span class="service-badge">${req.serviceType}</span></td>
                                <td>${req.country}</td>
                                <td>
                                    <span class="status-badge status-${req.status}">${req.status}</span>
                                </td>
                                <td>${req.submissionDate}</td>
                                <td class="actions-cell">
                                    <a href="${pageContext.request.contextPath}/admin/request-detail?id=${req.requestId}" class="btn btn-sm btn-outline">View</a>
                                    <form action="${pageContext.request.contextPath}/admin/delete-request" method="post" class="inline-form" onsubmit="return confirm('Are you sure you want to delete this request?');">
                                        <input type="hidden" name="requestId" value="${req.requestId}">
                                        <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty requests}">
                            <tr>
                                <td colspan="9" class="empty-state">No service requests found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </main>

</div>

</body>
</html>
