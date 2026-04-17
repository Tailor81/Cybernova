<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics - CyberNova Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
</head>
<body class="admin-body">

<div class="admin-layout">
    <jsp:include page="/admin/includes/sidebar.jsp">
        <jsp:param name="activePage" value="analytics"/>
    </jsp:include>

    <div class="admin-main">
        <div class="admin-topbar">
            <button class="admin-mobile-toggle" id="adminMenuToggle"><i class="fa-solid fa-bars"></i></button>
            <h1>Analytics Overview</h1>
            <div class="admin-topbar-right">
                <span class="admin-user">Welcome, ${sessionScope.adminUsername}</span>
                <span class="admin-user-icon"><i class="fa-solid fa-circle-user"></i></span>
            </div>
        </div>

        <div class="admin-content">

            <c:if test="${not empty analyticsError}">
                <div class="alert alert-error">${analyticsError}</div>
            </c:if>

            <div class="dashboard-stats">
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Total Requests</span>
                    <span class="dash-stat-number">${totalRequests}</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Average Rating</span>
                    <span class="dash-stat-number">${averageRating}</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Client Reviews</span>
                    <span class="dash-stat-number">${totalRatings}</span>
                </div>
                <div class="dash-stat-card">
                    <span class="dash-stat-label">Countries Served</span>
                    <span class="dash-stat-number">${requestsByCountry.size()}</span>
                </div>
            </div>

            <div class="dashboard-charts">
                <div class="chart-card">
                    <h3>Most Requested Services</h3>
                    <canvas id="serviceTypeChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Regional Demand</h3>
                    <canvas id="countryChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3>Request Status Distribution</h3>
                    <canvas id="statusChart"></canvas>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
    var serviceTypeLabels = [];
    var serviceTypeValues = [];
    <c:forEach items="${requestsByServiceType}" var="entry">
        serviceTypeLabels.push('${entry.key}');
        serviceTypeValues.push(${entry.value});
    </c:forEach>

    var countryLabels = [];
    var countryValues = [];
    <c:forEach items="${requestsByCountry}" var="entry">
        countryLabels.push('${entry.key}');
        countryValues.push(${entry.value});
    </c:forEach>

    var statusLabels = [];
    var statusValues = [];
    <c:forEach items="${requestsByStatus}" var="entry">
        statusLabels.push('${entry.key}');
        statusValues.push(${entry.value});
    </c:forEach>

    var chartColors = ['#00B4D8', '#0077B6', '#023E8A', '#0096C7', '#90E0EF', '#CAF0F8'];

    if (serviceTypeLabels.length > 0) {
        new Chart(document.getElementById('serviceTypeChart'), {
            type: 'bar',
            data: {
                labels: serviceTypeLabels,
                datasets: [{
                    label: 'Requests',
                    data: serviceTypeValues,
                    backgroundColor: chartColors,
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
                indexAxis: 'y',
                plugins: { legend: { display: false } },
                scales: { x: { beginAtZero: true, ticks: { stepSize: 1 } } }
            }
        });
    }

    if (statusLabels.length > 0) {
        new Chart(document.getElementById('statusChart'), {
            type: 'doughnut',
            data: {
                labels: statusLabels,
                datasets: [{
                    data: statusValues,
                    backgroundColor: chartColors
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });
    }
</script>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>
