<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="admin-body">

<div class="admin-layout">

    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="users"/>
    </jsp:include>

    <main class="admin-main">
        <div class="admin-topbar">
            <h1>Admin Users</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success">Admin user created successfully.</div>
            </c:if>
            <c:if test="${param.deleted == 'true'}">
                <div class="alert alert-success">Admin user deleted.</div>
            </c:if>
            <c:if test="${param.error == 'delete'}">
                <div class="alert alert-error">Failed to delete user.</div>
            </c:if>
            <c:if test="${param.error == 'self'}">
                <div class="alert alert-error">You cannot delete your own account.</div>
            </c:if>
            <c:if test="${param.error == 'last'}">
                <div class="alert alert-error">Cannot delete the last admin account.</div>
            </c:if>
            <c:if test="${param.error == 'invalid'}">
                <div class="alert alert-error">Username and password are required.</div>
            </c:if>
            <c:if test="${param.error == 'mismatch'}">
                <div class="alert alert-error">Passwords do not match.</div>
            </c:if>
            <c:if test="${param.error == 'exists'}">
                <div class="alert alert-error">That username is already taken.</div>
            </c:if>

            <div class="admin-two-col">

                <div class="admin-form-card">
                    <h3 class="admin-form-title"><i class="fa-solid fa-user-plus"></i> Create Admin User</h3>
                    <form action="${pageContext.request.contextPath}/admin/users" method="post" class="admin-form">
                        <input type="hidden" name="action" value="create">

                        <div class="form-group">
                            <label class="form-label">Username *</label>
                            <input type="text" name="username" class="form-input"
                                   placeholder="e.g. johndoe" required autocomplete="off">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password *</label>
                            <input type="password" name="password" class="form-input"
                                   placeholder="Min 8 characters" required minlength="8" autocomplete="new-password">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Confirm Password *</label>
                            <input type="password" name="confirmPassword" class="form-input"
                                   placeholder="Re-enter password" required autocomplete="new-password">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fa-solid fa-user-plus"></i> Create User
                        </button>
                    </form>
                </div>

                <div class="admin-table-col">
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${admins}" var="adm">
                                    <tr>
                                        <td>#${adm.adminId}</td>
                                        <td>
                                            <div class="user-row">
                                                <span class="user-avatar-icon"><i class="fa-solid fa-circle-user"></i></span>
                                                <span>${adm.username}</span>
                                                <c:if test="${adm.username == sessionScope.adminUsername}">
                                                    <span class="you-badge">You</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td class="actions-cell">
                                            <c:if test="${adm.username != sessionScope.adminUsername}">
                                                <form action="${pageContext.request.contextPath}/admin/users" method="post"
                                                      class="inline-form"
                                                      onsubmit="return confirm('Delete admin user ${adm.username}?');">
                                                    <input type="hidden" name="action" value="delete">
                                                    <input type="hidden" name="adminId" value="${adm.adminId}">
                                                    <button type="submit" class="btn btn-sm btn-danger">
                                                        <i class="fa-solid fa-trash"></i> Delete
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${adm.username == sessionScope.adminUsername}">
                                                <span class="text-muted-sm">Current session</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty admins}">
                                    <tr>
                                        <td colspan="3" class="empty-state">No admin users found</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </main>

</div>

</body>
</html>
