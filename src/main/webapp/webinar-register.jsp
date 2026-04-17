<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Webinar Registration"/>
</jsp:include>

<section class="section">
    <div class="container">

        <c:choose>

            <c:when test="${not empty registeredName}">
                <div class="confirmation-card" style="max-width: 560px; margin: 0 auto;">
                    <div class="confirmation-icon"><i class="fa-solid fa-check"></i></div>
                    <h2>You are registered!</h2>
                    <p>Thanks, <strong>${registeredName}</strong>. You have successfully registered for:</p>
                    <div class="confirmation-details">
                        <p><strong>${webinar.title}</strong></p>
                        <p><i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${webinar.webinarDate}" pattern="d MMM, yyyy"/> &nbsp; <i class="fa-regular fa-clock"></i> ${webinar.webinarTime}</p>
                        <p>A confirmation will be sent to your email before the session.</p>
                    </div>
                    <div class="confirmation-actions">
                        <a href="${pageContext.request.contextPath}/webinars" class="btn btn-primary">View All Webinars</a>
                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline">Back to Home</a>
                    </div>
                </div>
            </c:when>

            <c:otherwise>
                <div class="assessment-layout">

                    <div class="assessment-info">
                        <h1>Webinar Registration</h1>
                        <p>Complete the form to secure your spot for this free online session.</p>

                        <c:if test="${not empty webinar}">
                            <div style="margin-top: 28px; padding: 20px; background: var(--white); border-radius: var(--radius); box-shadow: var(--shadow);">
                                <h3 style="font-size: 1rem; color: var(--black); margin-bottom: 10px;">${webinar.title}</h3>
                                <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 6px;">
                                    <i class="fa-regular fa-calendar"></i> <fmt:formatDate value="${webinar.webinarDate}" pattern="d MMM, yyyy"/>
                                </p>
                                <p style="font-size: 0.85rem; color: var(--gray-500); margin-bottom: 6px;">
                                    <i class="fa-regular fa-clock"></i> ${webinar.webinarTime}
                                </p>
                                <c:if test="${not empty webinar.speaker}">
                                    <p style="font-size: 0.85rem; color: var(--gray-500);">
                                        <i class="fa-solid fa-microphone"></i> ${webinar.speaker}
                                    </p>
                                </c:if>
                            </div>
                        </c:if>

                        <div class="assessment-icon" style="margin-top: 32px;">
                            <i class="fa-solid fa-video"></i>
                        </div>
                    </div>

                    <div class="assessment-form">

                        <c:if test="${alreadyRegistered}">
                            <div class="alert alert-error">This email is already registered for this webinar.</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/webinar-register" method="post" id="webinarRegisterForm">
                            <input type="hidden" name="webinarId" value="${webinar.webinarId}">

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="fullName">Full Name <span class="required">*</span></label>
                                    <input type="text" id="fullName" name="fullName" required placeholder="Your full name">
                                    <span class="field-error" id="fullNameError"></span>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email Address <span class="required">*</span></label>
                                    <input type="email" id="email" name="email" required placeholder="your@email.com">
                                    <span class="field-error" id="emailError"></span>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="organisation">Organisation</label>
                                    <input type="text" id="organisation" name="organisation" placeholder="Your company or institution">
                                </div>
                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" id="phone" name="phone" placeholder="+267 000 0000">
                                </div>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary btn-full">Register for Webinar</button>
                            </div>
                        </form>

                        <p style="text-align: center; margin-top: 16px; font-size: 0.85rem; color: var(--gray-500);">
                            <a href="${pageContext.request.contextPath}/webinars">View all webinars</a>
                        </p>
                    </div>

                </div>
            </c:otherwise>

        </c:choose>

    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
