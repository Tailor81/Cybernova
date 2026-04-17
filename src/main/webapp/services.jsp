<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Services"/>
</jsp:include>

<section class="page-hero">
    <div class="container">
        <h1>Our Cybersecurity Services</h1>
        <p>Comprehensive AI-driven security solutions tailored to your organisation</p>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="services-detailed">

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-robot"></i></div>
                <div class="service-detail-content">
                    <h3>AI Cyber Assistant</h3>
                    <p>Our flagship AI-powered cyber assistant continuously monitors your network infrastructure, detects anomalies in real time, and explains risks in plain language. It analyses traffic patterns using machine learning algorithms, identifies suspicious behaviour, and recommends mitigation strategies tailored to your environment.</p>
                    <ul class="service-features">
                        <li>Real-time network traffic analysis</li>
                        <li>Anomaly detection and alerting</li>
                        <li>Plain-language risk explanations</li>
                        <li>Automated mitigation recommendations</li>
                    </ul>
                </div>
            </div>

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-magnifying-glass"></i></div>
                <div class="service-detail-content">
                    <h3>Network Security Audit</h3>
                    <p>A thorough examination of your entire network architecture to identify security weaknesses, misconfigurations, and compliance gaps. Our auditors assess firewalls, access controls, encryption protocols, and endpoint security to deliver a comprehensive security posture report.</p>
                    <ul class="service-features">
                        <li>Infrastructure vulnerability scanning</li>
                        <li>Firewall and access control review</li>
                        <li>Compliance gap analysis</li>
                        <li>Detailed remediation roadmap</li>
                    </ul>
                </div>
            </div>

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-laptop-code"></i></div>
                <div class="service-detail-content">
                    <h3>Penetration Testing</h3>
                    <p>Simulated cyber attacks conducted by our certified ethical hackers to test your organisation's defences. We probe your systems, applications, and networks using the same techniques that real attackers use, providing you with a realistic assessment of your security readiness.</p>
                    <ul class="service-features">
                        <li>External and internal penetration tests</li>
                        <li>Web application security testing</li>
                        <li>Social engineering assessments</li>
                        <li>Executive summary and technical report</li>
                    </ul>
                </div>
            </div>

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-bell"></i></div>
                <div class="service-detail-content">
                    <h3>Incident Response</h3>
                    <p>When a security incident occurs, every second counts. Our incident response team provides rapid containment, thorough forensic investigation, and complete recovery support. We help you understand what happened, limit the damage, and prevent future occurrences.</p>
                    <ul class="service-features">
                        <li>24/7 emergency response availability</li>
                        <li>Digital forensics and evidence collection</li>
                        <li>Breach containment and eradication</li>
                        <li>Post-incident review and hardening</li>
                    </ul>
                </div>
            </div>

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-users"></i></div>
                <div class="service-detail-content">
                    <h3>Security Consultation</h3>
                    <p>Strategic cybersecurity advisory services for organisations looking to build or improve their security programmes. Our consultants work closely with your leadership team to develop policies, frameworks, and governance structures that align with international standards.</p>
                    <ul class="service-features">
                        <li>Security strategy development</li>
                        <li>Policy and framework design</li>
                        <li>Risk management planning</li>
                        <li>Board-level security briefings</li>
                    </ul>
                </div>
            </div>

            <div class="service-detail-card">
                <div class="service-detail-icon"><i class="fa-solid fa-graduation-cap"></i></div>
                <div class="service-detail-content">
                    <h3>Cyber Awareness Training</h3>
                    <p>Empower your workforce to become your strongest line of defence. Our interactive training programmes educate employees on recognising phishing attempts, handling sensitive data, and following security best practices in their daily work.</p>
                    <ul class="service-features">
                        <li>Interactive workshop sessions</li>
                        <li>Phishing simulation campaigns</li>
                        <li>Role-based security training</li>
                        <li>Certification upon completion</li>
                    </ul>
                </div>
            </div>

        </div>
    </div>
</section>

<section class="section cta-section">
    <div class="container">
        <h2>Need a Custom Security Solution?</h2>
        <p>Contact our team to discuss how we can tailor our services to your organisation's specific needs.</p>
        <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-primary btn-lg">Get in Touch</a>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
