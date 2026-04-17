<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
</head>
<body class="admin-body">

<div class="admin-layout">

    <jsp:include page="includes/sidebar.jsp">
        <jsp:param name="activePage" value="dashboard"/>
    </jsp:include>

    <main class="admin-main">
        <div class="admin-topbar">
            <h1>Dashboard</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, Admin</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <div class="dashboard-stats">
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Total Requests</span>
                    <span class="dash-stat-number">${totalRequests}</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Webinar Registrations</span>
                    <span class="dash-stat-number">${webinarRegistrations}</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Conversion Rate</span>
                    <span class="dash-stat-number">${conversionRate}%</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">This Month Growth</span>
                    <span class="dash-stat-number dash-stat-growth">&#8593; ${monthGrowth}%</span>
                </div>
            </div>

            <div class="dashboard-charts">
                <div class="chart-card">
                    <h3>Requests by Industry</h3>
                    <canvas id="industryChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Requests by Service</h3>
                    <canvas id="serviceChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Requests by Country</h3>
                    <canvas id="countryChart"></canvas>
                </div>
            </div>

            <div class="dashboard-footer-note">
                <p>Requests increased by ${monthGrowth}% this month compared to last month.</p>
            </div>

        </div>
    </main>

</div>

<script>
    var chartColors = ['#00B4D8', '#0077B6', '#023E8A', '#0096C7', '#90E0EF', '#CAF0F8', '#48CAE4', '#ADE8F4'];

    var industryLabels = [];
    var industryValues = [];
    <c:forEach items="${requestsByIndustry}" var="entry">
        industryLabels.push('${entry.key}');
        industryValues.push(${entry.value});
    </c:forEach>

    var serviceLabels = [];
    var serviceValues = [];
    <c:forEach items="${requestsByServiceType}" var="entry">
        serviceLabels.push('${entry.key}');
        serviceValues.push(${entry.value});
    </c:forEach>

    var countryLabels = [];
    var countryValues = [];
    <c:forEach items="${requestsByCountry}" var="entry">
        countryLabels.push('${entry.key}');
        countryValues.push(${entry.value});
    </c:forEach>

    if (industryLabels.length > 0) {
        new Chart(document.getElementById('industryChart'), {
            type: 'doughnut',
            data: {
                labels: industryLabels,
                datasets: [{
                    data: industryValues,
                    backgroundColor: chartColors
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'right', labels: { boxWidth: 12, padding: 12 } } }
            }
        });
    }

    if (serviceLabels.length > 0) {
        new Chart(document.getElementById('serviceChart'), {
            type: 'bar',
            data: {
                labels: serviceLabels,
                datasets: [{
                    label: 'Requests',
                    data: serviceValues,
                    backgroundColor: chartColors,
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                indexAxis: 'y',
                plugins: { legend: { display: false } },
                scales: { x: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    }

    if (countryLabels.length > 0) {
        new Chart(document.getElementById('countryChart'), {
            type: 'bar',
            data: {
                labels: countryLabels,
                datasets: [{
                    label: 'Requests',
                    data: countryValues,
                    backgroundColor: '#00B4D8',
                    borderRadius: 6
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    }
</script>

</body>
</html>
