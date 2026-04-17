<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Resources"/>
</jsp:include>

<section class="section">
    <div class="container">
        <h1 class="page-heading">Resources</h1>
        <p class="page-subheading">Download our guides and reports to strengthen your cybersecurity knowledge.</p>

        <div class="resources-list">

            <c:choose>
                <c:when test="${empty resources}">
                    <div class="resource-empty">
                        <i class="fa-solid fa-folder-open"></i>
                        <p>No resources available yet. Check back soon.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${resources}" var="res">
                        <div class="resource-card">
                            <div class="resource-icon"><i class="fa-solid ${res.fileIcon}"></i></div>
                            <div class="resource-info">
                                <h4>${res.title}</h4>
                                <p>${not empty res.description ? res.description : res.category}</p>
                                <span class="resource-meta">${res.fileSizeLabel}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/resource-download?id=${res.resourceId}"
                               class="btn btn-primary btn-sm">
                                <i class="fa-solid fa-download"></i> Download
                            </a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>

