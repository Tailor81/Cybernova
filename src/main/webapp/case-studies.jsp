<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Case Studies"/>
</jsp:include>

<section class="page-hero">
    <div class="container">
        <h1>Case Studies</h1>
        <p>Real-world examples of how we have helped organisations strengthen their cybersecurity posture</p>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="case-studies-list">

            <article class="case-study-card">
                <div class="case-study-header">
                    <span class="case-study-tag">Financial Services</span>
                    <h3>National Bank of Botswana: Ransomware Prevention</h3>
                </div>
                <div class="case-study-body">
                    <div class="case-study-challenge">
                        <h4>The Challenge</h4>
                        <p>A major financial institution experienced repeated phishing attacks targeting their internal payment processing systems. Staff members were unknowingly clicking on malicious links, putting customer financial data at risk. Their existing security tools were generating too many false positives, causing alert fatigue among IT staff.</p>
                    </div>
                    <div class="case-study-solution">
                        <h4>Our Solution</h4>
                        <p>CyberNova deployed our AI Cyber Assistant to monitor all inbound email traffic and network connections. We trained the AI model on the bank's specific communication patterns to dramatically reduce false positives. A targeted phishing simulation campaign was run alongside staff training workshops.</p>
                    </div>
                    <div class="case-study-result">
                        <h4>The Result</h4>
                        <ul>
                            <li>Phishing click-through rate reduced by 94%</li>
                            <li>False positive alerts dropped by 87%</li>
                            <li>Zero successful ransomware attacks in 18 months</li>
                            <li>Full compliance with international banking security standards</li>
                        </ul>
                    </div>
                </div>
            </article>

            <article class="case-study-card">
                <div class="case-study-header">
                    <span class="case-study-tag">Government</span>
                    <h3>Ministry of Communications: Infrastructure Security Audit</h3>
                </div>
                <div class="case-study-body">
                    <div class="case-study-challenge">
                        <h4>The Challenge</h4>
                        <p>A government ministry needed to modernise its aging IT infrastructure while maintaining the security of sensitive citizen data. Legacy systems were running outdated software with known vulnerabilities, and there was no centralised incident response plan in place.</p>
                    </div>
                    <div class="case-study-solution">
                        <h4>Our Solution</h4>
                        <p>We conducted a comprehensive network security audit across all ministry offices, identifying 47 critical vulnerabilities. Our team designed a phased modernisation plan that prioritised the most critical systems. We implemented continuous monitoring using our AI platform and established a formal incident response protocol.</p>
                    </div>
                    <div class="case-study-result">
                        <h4>The Result</h4>
                        <ul>
                            <li>47 critical vulnerabilities identified and remediated</li>
                            <li>Incident response time improved from 72 hours to 4 hours</li>
                            <li>100% of core systems migrated to supported platforms</li>
                            <li>Continuous monitoring deployed across 12 offices</li>
                        </ul>
                    </div>
                </div>
            </article>

            <article class="case-study-card">
                <div class="case-study-header">
                    <span class="case-study-tag">Healthcare</span>
                    <h3>MedSecure Clinic Group: Data Breach Recovery</h3>
                </div>
                <div class="case-study-body">
                    <div class="case-study-challenge">
                        <h4>The Challenge</h4>
                        <p>A private healthcare group suffered a data breach that exposed patient records of over 15,000 individuals. The attackers exploited a vulnerability in their appointment booking system to gain access to the internal network. Immediate containment and full forensic investigation were required.</p>
                    </div>
                    <div class="case-study-solution">
                        <h4>Our Solution</h4>
                        <p>Our incident response team was on-site within 3 hours of notification. We isolated the compromised systems, preserved forensic evidence, and traced the attack vector to a SQL injection vulnerability. After containment, we conducted a full penetration test and rebuilt the booking system with secure coding practices.</p>
                    </div>
                    <div class="case-study-result">
                        <h4>The Result</h4>
                        <ul>
                            <li>Breach contained within 6 hours of detection</li>
                            <li>Complete forensic report delivered within 5 days</li>
                            <li>Rebuilt booking system passed all security tests</li>
                            <li>Zero data breaches in the 24 months following remediation</li>
                        </ul>
                    </div>
                </div>
            </article>

            <article class="case-study-card">
                <div class="case-study-header">
                    <span class="case-study-tag">SME</span>
                    <h3>TechStart Innovations: SME Security Programme</h3>
                </div>
                <div class="case-study-body">
                    <div class="case-study-challenge">
                        <h4>The Challenge</h4>
                        <p>A fast-growing tech startup with 45 employees had no formal cybersecurity programme. As they onboarded enterprise clients, they needed to demonstrate security compliance but lacked the budget for a large-scale security deployment.</p>
                    </div>
                    <div class="case-study-solution">
                        <h4>Our Solution</h4>
                        <p>CyberNova designed an affordable security programme tailored for SMEs. We implemented endpoint protection, email security, and our AI monitoring platform at a fraction of enterprise costs. Staff received targeted cyber awareness training, and we established security policies aligned with ISO 27001 principles.</p>
                    </div>
                    <div class="case-study-result">
                        <h4>The Result</h4>
                        <ul>
                            <li>Security programme established in under 6 weeks</li>
                            <li>Successfully passed three client security audits</li>
                            <li>Won two enterprise contracts worth BWP 2.5 million</li>
                            <li>Employee security awareness score improved by 78%</li>
                        </ul>
                    </div>
                </div>
            </article>

        </div>
    </div>
</section>

<section class="section cta-section">
    <div class="container">
        <h2>Want to Be Our Next Success Story?</h2>
        <p>Let us help you build a stronger cybersecurity posture for your organisation.</p>
        <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-primary btn-lg">Start Your Assessment</a>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
