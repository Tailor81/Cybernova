<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Request Submitted"/>
</jsp:include>

<section class="section confirmation-section">
    <div class="container">
        <div class="confirmation-card">
            <div class="confirmation-icon"><i class="fa-solid fa-check"></i></div>
            <h2>Request Submitted Successfully</h2>
            <p>Thank you, <strong>${fullName}</strong>. Your cybersecurity service request has been received.</p>
            <div class="confirmation-details">
                <p>Your reference number is: <strong>#${requestId}</strong></p>
                <p>Our security team will review your request and contact you within 24 hours.</p>
            </div>
            <div class="confirmation-actions">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return Home</a>
                <a href="${pageContext.request.contextPath}/services.jsp" class="btn btn-outline">View Services</a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
