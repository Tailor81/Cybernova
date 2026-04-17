<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="includes/header.jsp">
    <jsp:param name="pageTitle" value="Resources"/>
</jsp:include>

<section class="section">
    <div class="container">
        <h1 class="page-heading">Resources</h1>
        <p class="page-subheading">Download our guides and reports to strengthen your cybersecurity knowledge.</p>

        <div class="resources-list">

            <div class="resource-card">
                <div class="resource-icon"><i class="fa-solid fa-file-lines"></i></div>
                <div class="resource-info">
                    <h4>AI Security Guide</h4>
                    <p>A comprehensive guide to AI-powered security.</p>
                </div>
                <a href="#" class="btn btn-primary btn-sm">Download</a>
            </div>

            <div class="resource-card">
                <div class="resource-icon"><i class="fa-solid fa-clipboard-list"></i></div>
                <div class="resource-info">
                    <h4>Network Safety Checklist</h4>
                    <p>A practical checklist to secure your network.</p>
                </div>
                <a href="#" class="btn btn-primary btn-sm">Download</a>
            </div>

            <div class="resource-card">
                <div class="resource-icon"><i class="fa-solid fa-chart-bar"></i></div>
                <div class="resource-info">
                    <h4>Cyber Risk Report 2026</h4>
                    <p>Key insights and trends shaping cybersecurity.</p>
                </div>
                <a href="#" class="btn btn-primary btn-sm">Download</a>
            </div>

        </div>
    </div>
</section>

<jsp:include page="includes/footer.jsp"/>
