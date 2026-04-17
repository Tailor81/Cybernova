<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Detail - CyberNova Admin</title>
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
            <h1>Request Detail</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

        <div class="admin-header">
            <a href="${pageContext.request.contextPath}/admin/requests" class="back-link">&larr; Back to Requests</a>
            <h2>Request #${serviceRequest.requestId}</h2>
        </div>

        <c:if test="${param.updated == 'true'}">
            <div class="alert alert-success">Request has been updated successfully.</div>
        </c:if>

        <c:if test="${not empty detailError}">
            <div class="alert alert-error">${detailError}</div>
        </c:if>

        <c:if test="${not empty serviceRequest}">
            <div class="detail-card">
                <form action="${pageContext.request.contextPath}/admin/update-request" method="post">
                    <input type="hidden" name="requestId" value="${serviceRequest.requestId}">

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" value="${serviceRequest.fullName}">
                        </div>
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${serviceRequest.email}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="text" id="phoneNumber" name="phoneNumber" value="${serviceRequest.phoneNumber}">
                        </div>
                        <div class="form-group">
                            <label for="organisationName">Organisation</label>
                            <input type="text" id="organisationName" name="organisationName" value="${serviceRequest.organisationName}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="country">Country</label>
                            <input type="text" id="country" name="country" value="${serviceRequest.country}">
                        </div>
                        <div class="form-group">
                            <label for="jobTitle">Job Title</label>
                            <input type="text" id="jobTitle" name="jobTitle" value="${serviceRequest.jobTitle}">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="industrySector">Industry Sector</label>
                            <input type="text" id="industrySector" name="industrySector" value="${serviceRequest.industrySector}">
                        </div>
                        <div class="form-group">
                            <label for="serviceType">Service Type</label>
                            <select id="serviceType" name="serviceType">
                                <option value="AI Cyber Assistant" ${serviceRequest.serviceType == 'AI Cyber Assistant' ? 'selected' : ''}>AI Cyber Assistant</option>
                                <option value="Network Security Audit" ${serviceRequest.serviceType == 'Network Security Audit' ? 'selected' : ''}>Network Security Audit</option>
                                <option value="Penetration Testing" ${serviceRequest.serviceType == 'Penetration Testing' ? 'selected' : ''}>Penetration Testing</option>
                                <option value="Incident Response" ${serviceRequest.serviceType == 'Incident Response' ? 'selected' : ''}>Incident Response</option>
                                <option value="Security Consultation" ${serviceRequest.serviceType == 'Security Consultation' ? 'selected' : ''}>Security Consultation</option>
                                <option value="Cyber Awareness Training" ${serviceRequest.serviceType == 'Cyber Awareness Training' ? 'selected' : ''}>Cyber Awareness Training</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="5">${serviceRequest.description}</textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="status">Status</label>
                            <select id="status" name="status">
                                <option value="pending" ${serviceRequest.status == 'pending' ? 'selected' : ''}>Pending</option>
                                <option value="in_progress" ${serviceRequest.status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                <option value="resolved" ${serviceRequest.status == 'resolved' ? 'selected' : ''}>Resolved</option>
                                <option value="closed" ${serviceRequest.status == 'closed' ? 'selected' : ''}>Closed</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Submitted</label>
                            <input type="text" value="${serviceRequest.submissionDate}" disabled>
                        </div>
                    </div>

                    <div class="form-actions detail-actions">
                        <button type="submit" class="btn btn-primary">Update Request</button>
                        <a href="${pageContext.request.contextPath}/admin/requests" class="btn btn-outline">Cancel</a>
                    </div>
                </form>
            </div>
        </c:if>

        </div>
    </main>

</div>

</body>
</html>
