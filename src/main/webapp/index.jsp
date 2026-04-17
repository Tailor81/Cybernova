<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Home"/>
</jsp:include>

<section class="hero">
    <div class="hero-split">
        <div class="hero-image">
            <div class="hero-image-placeholder">
                <span><i class="fa-solid fa-shield-halved"></i></span>
            </div>
        </div>
        <div class="hero-content">
            <h1>AI-Powered <span class="text-cyan">Cybersecurity</span> Solutions</h1>
            <p class="hero-subtitle">Protecting businesses with intelligent insights and innovative technology.</p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-primary">Request Cyber Risk Assessment</a>
                <a href="${pageContext.request.contextPath}/about.jsp" class="btn btn-outline">Contact Us</a>
            </div>
        </div>
    </div>
</section>

<section class="section">
    <div class="container">
        <h2 class="section-title">Our Services</h2>
        <div class="services-grid-home">
            <div class="service-home-card">
                <div class="service-home-icon"><i class="fa-solid fa-robot"></i></div>
                <h4>AI Cyber Assistant</h4>
                <p>Real-time threat detection and smart recommendations</p>
            </div>
            <div class="service-home-card">
                <div class="service-home-icon"><i class="fa-solid fa-magnifying-glass"></i></div>
                <h4>Network Security Audit</h4>
                <p>Identify vulnerabilities and strengthen defenses</p>
            </div>
            <div class="service-home-card">
                <div class="service-home-icon"><i class="fa-solid fa-laptop-code"></i></div>
                <h4>Penetration Testing</h4>
                <p>Simulate attacks to find and fix weaknesses</p>
            </div>
            <div class="service-home-card">
                <div class="service-home-icon"><i class="fa-solid fa-users"></i></div>
                <h4>Security Consultation</h4>
                <p>Expert guidance for your cybersecurity strategy</p>
            </div>
        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
