<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Webinars - CyberNova Admin</title>
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
            <h1>Webinars</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">${successMessage}</div>
            </c:if>

            <div style="display: grid; grid-template-columns: 1fr 1.4fr; gap: 28px; align-items: start;">

                <div class="chart-card">
                    <h3>Create Webinar</h3>

                    <c:if test="${not empty formError}">
                        <div class="alert alert-error" style="margin-bottom: 16px;">${formError}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/admin/webinars" method="post">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label for="title">Title <span class="required">*</span></label>
                            <input type="text" id="title" name="title" required placeholder="e.g. Introduction to Zero Trust">
                        </div>
                        <div class="form-group">
                            <label for="description">Description</label>
                            <textarea id="description" name="description" rows="3" placeholder="Brief overview of the session"></textarea>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="webinarDate">Date <span class="required">*</span></label>
                                <input type="date" id="webinarDate" name="webinarDate" required>
                            </div>
                            <div class="form-group">
                                <label for="webinarTime">Time <span class="required">*</span></label>
                                <input type="text" id="webinarTime" name="webinarTime" required placeholder="e.g. 10:00 AM">
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="speaker">Speaker</label>
                                <input type="text" id="speaker" name="speaker" placeholder="Speaker name">
                            </div>
                            <div class="form-group">
                                <label for="platform">Platform</label>
                                <select id="platform" name="platform">
                                    <option value="Online">Online</option>
                                    <option value="In-Person">In-Person</option>
                                    <option value="Hybrid">Hybrid</option>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary btn-full">Create Webinar</button>
                    </form>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${empty webinars}">
                            <div class="chart-card">
                                <p style="color: var(--gray-500); text-align: center; padding: 20px 0;">No webinars yet. Create one on the left.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="admin-table">
                                    <thead>
                                        <tr>
                                            <th>Title</th>
                                            <th>Date</th>
                                            <th>Time</th>
                                            <th>Speaker</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${webinars}" var="w">
                                            <tr>
                                                <td>${w.title}</td>
                                                <td><fmt:formatDate value="${w.webinarDate}" pattern="d MMM yyyy"/></td>
                                                <td>${w.webinarTime}</td>
                                                <td>${not empty w.speaker ? w.speaker : '-'}</td>
                                                <td class="actions-cell">
                                                    <a href="${pageContext.request.contextPath}/admin/webinars?view=registrations&id=${w.webinarId}" class="btn btn-outline btn-sm">Registrations</a>
                                                    <form action="${pageContext.request.contextPath}/admin/webinars" method="post" class="inline-form">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="webinarId" value="${w.webinarId}">
                                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this webinar and all registrations?')">Delete</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

            </div>

        </div>
    </main>
</div>

</body>
</html>
