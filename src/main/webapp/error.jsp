<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Error"/>
</jsp:include>

<section class="section confirmation-section">
    <div class="container">
        <div class="confirmation-card">
            <div class="confirmation-icon error-icon">!</div>
            <h2>Something Went Wrong</h2>
            <p>The page you are looking for could not be found or an unexpected error occurred.</p>
            <div class="confirmation-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return Home</a>
                <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-outline">Contact Us</a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
