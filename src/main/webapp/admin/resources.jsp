<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resources - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="admin-body">

<div class="admin-layout">

    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="resources"/>
    </jsp:include>

    <main class="admin-main">
        <div class="admin-topbar">
            <h1>Resources</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <c:if test="${param.success == 'true'}">
                <div class="alert alert-success">Resource uploaded successfully.</div>
            </c:if>
            <c:if test="${param.deleted == 'true'}">
                <div class="alert alert-success">Resource deleted successfully.</div>
            </c:if>
            <c:if test="${param.error == 'delete'}">
                <div class="alert alert-error">Failed to delete resource.</div>
            </c:if>
            <c:if test="${param.error == 'invalid'}">
                <div class="alert alert-error">Please provide a title and select a file.</div>
            </c:if>

            <div class="admin-two-col">

                <div class="admin-form-card">
                    <h3 class="admin-form-title"><i class="fa-solid fa-upload"></i> Upload Resource</h3>
                    <form action="${pageContext.request.contextPath}/admin/resources" method="post"
                          enctype="multipart/form-data" class="admin-form">
                        <input type="hidden" name="action" value="upload">

                        <div class="form-group">
                            <label class="form-label">Title *</label>
                            <input type="text" name="title" class="form-input" placeholder="e.g. AI Security Guide 2026" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-input form-textarea" rows="3"
                                      placeholder="Brief description of this resource"></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Category</label>
                            <select name="category" class="form-input">
                                <option value="General">General</option>
                                <option value="Guide">Guide</option>
                                <option value="Report">Report</option>
                                <option value="Checklist">Checklist</option>
                                <option value="Whitepaper">Whitepaper</option>
                                <option value="Template">Template</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">File * <span class="form-hint">(max 20 MB)</span></label>
                            <input type="file" name="file" class="form-input form-file" required
                                   accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip,.txt,.csv">
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fa-solid fa-upload"></i> Upload
                        </button>
                    </form>
                </div>

                <div class="admin-table-col">
                    <div class="table-responsive">
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>File</th>
                                    <th>Size</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${resources}" var="res">
                                    <tr>
                                        <td>
                                            <div class="resource-title-cell">
                                                <i class="fa-solid ${res.fileIcon} resource-file-icon"></i>
                                                <div>
                                                    <div class="resource-name">${res.title}</div>
                                                    <div class="resource-desc-small">${res.description}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="category-badge">${res.category}</span></td>
                                        <td class="file-name-cell">${res.fileName}</td>
                                        <td>${res.fileSizeLabel}</td>
                                        <td>${res.uploadedDate}</td>
                                        <td class="actions-cell">
                                            <a href="${pageContext.request.contextPath}/resource-download?id=${res.resourceId}"
                                               class="btn btn-sm btn-outline">
                                                <i class="fa-solid fa-download"></i>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/resources" method="post"
                                                  class="inline-form"
                                                  onsubmit="return confirm('Delete this resource?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="resourceId" value="${res.resourceId}">
                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty resources}">
                                    <tr>
                                        <td colspan="6" class="empty-state">No resources uploaded yet</td>
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
