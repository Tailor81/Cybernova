<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Webinars"/>
</jsp:include>

<section class="section">
    <div class="container">
        <h1 class="page-heading">Upcoming Webinars</h1>
        <p class="page-subheading">Register for our free online sessions led by cybersecurity experts.</p>

        <c:choose>
            <c:when test="${empty webinars}">
                <p style="color: var(--gray-500); text-align: center; padding: 60px 0;">No upcoming webinars at this time. Check back soon.</p>
            </c:when>
            <c:otherwise>
                <div class="webinar-list">
                    <c:forEach items="${webinars}" var="w">
                        <div class="webinar-card">
                            <div class="webinar-image">
                                <div class="webinar-image-placeholder"></div>
                            </div>
                            <div class="webinar-details">
                                <h3>${w.title}</h3>
                                <div class="webinar-meta">
                                    <span><i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${w.webinarDate}" pattern="d MMM, yyyy"/></span>
                                    <span><i class="fa-regular fa-clock"></i> ${w.webinarTime}</span>
                                    <span><i class="fa-solid fa-globe"></i> ${w.platform}</span>
                                    <c:if test="${not empty w.speaker}">
                                        <span><i class="fa-solid fa-microphone"></i> ${w.speaker}</span>
                                    </c:if>
                                </div>
                                <p>${w.description}</p>
                                <a href="${pageContext.request.contextPath}/webinar-register?id=${w.webinarId}" class="btn btn-primary">Register Now</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>

