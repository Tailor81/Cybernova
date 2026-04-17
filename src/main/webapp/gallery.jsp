<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Gallery"/>
</jsp:include>

<section class="page-hero">
    <div class="container">
        <h1>Gallery</h1>
        <p>Highlights from our training workshops, events, and client engagements</p>
    </div>
</section>

<section class="section">
    <div class="container">

        <h3 class="gallery-section-title">Cyber Awareness Workshops</h3>
        <div class="gallery-grid">
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #00B4D8, #0077B6)">
                    <span>Workshop Session 1</span>
                </div>
                <p class="gallery-caption">Interactive phishing awareness workshop for financial services staff in Gaborone</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #0077B6, #023E8A)">
                    <span>Workshop Session 2</span>
                </div>
                <p class="gallery-caption">Hands-on network security training with government IT administrators</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #023E8A, #0D1B2A)">
                    <span>Workshop Session 3</span>
                </div>
                <p class="gallery-caption">Executive cybersecurity briefing for senior management teams</p>
            </div>
        </div>

        <h3 class="gallery-section-title">Security Events</h3>
        <div class="gallery-grid">
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #00B4D8, #0096C7)">
                    <span>Security Summit 2025</span>
                </div>
                <p class="gallery-caption">CyberNova presenting at the Southern Africa Cybersecurity Summit</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #0096C7, #0077B6)">
                    <span>Hackathon Event</span>
                </div>
                <p class="gallery-caption">University cybersecurity hackathon sponsored by CyberNova Analytics</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #0077B6, #023E8A)">
                    <span>Awards Ceremony</span>
                </div>
                <p class="gallery-caption">Receiving the SADC Innovation in Cybersecurity Award 2025</p>
            </div>
        </div>

        <h3 class="gallery-section-title">Client Engagements</h3>
        <div class="gallery-grid">
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #0D1B2A, #1B2838)">
                    <span>Security Operations</span>
                </div>
                <p class="gallery-caption">Our security operations centre monitoring client networks in real time</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #1B2838, #00B4D8)">
                    <span>On-site Audit</span>
                </div>
                <p class="gallery-caption">On-site network security audit at a major telecommunications provider</p>
            </div>
            <div class="gallery-item">
                <div class="gallery-placeholder" style="background: linear-gradient(135deg, #00B4D8, #0D1B2A)">
                    <span>Team Meeting</span>
                </div>
                <p class="gallery-caption">Strategy session with our cybersecurity research and development team</p>
            </div>
        </div>

    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
