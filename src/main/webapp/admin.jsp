<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MediAssist — Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { background: #f0f4ff; }
        .navbar { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .stat-card { border-radius: 15px; border: none; box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        .chart-card { border-radius: 15px; border: none; box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark px-4 py-3">
        <span class="navbar-brand fw-bold"><i class="fas fa-chart-pie me-2"></i>MediAssist Admin</span>
    </nav>

    <%
        Map<String, Integer> deptCount = (Map<String, Integer>) request.getAttribute("deptCount");
        int total = (int) request.getAttribute("total");

        StringBuilder labels = new StringBuilder("[");
        StringBuilder data   = new StringBuilder("[");
        if (deptCount != null) {
            for (Map.Entry<String, Integer> e : deptCount.entrySet()) {
                labels.append("'").append(e.getKey()).append("',");
                data.append(e.getValue()).append(",");
            }
        }
        if (labels.length() > 1) { labels.deleteCharAt(labels.length()-1); data.deleteCharAt(data.length()-1); }
        labels.append("]"); data.append("]");
    %>

    <div class="container py-4">

        <!-- Stats -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card stat-card p-4 text-center">
                    <i class="fas fa-notes-medical fa-2x text-primary mb-2"></i>
                    <h2 class="fw-bold"><%= total %></h2>
                    <p class="text-muted mb-0">Total Consultations</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card p-4 text-center">
                    <i class="fas fa-hospital fa-2x text-success mb-2"></i>
                    <h2 class="fw-bold">8</h2>
                    <p class="text-muted mb-0">Departments</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card stat-card p-4 text-center">
                    <i class="fas fa-user-md fa-2x text-warning mb-2"></i>
                    <h2 class="fw-bold"><%= deptCount != null ? deptCount.size() : 0 %></h2>
                    <p class="text-muted mb-0">Active Departments</p>
                </div>
            </div>
        </div>

        <!-- Chart + Table -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card chart-card p-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-chart-pie me-2 text-primary"></i>Department Distribution</h5>
                    <canvas id="deptChart" height="300"></canvas>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card chart-card p-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-list me-2 text-primary"></i>Department Breakdown</h5>
                    <table class="table table-hover">
                        <thead><tr><th>Department</th><th>Consultations</th></tr></thead>
                        <tbody>
                            <% if (deptCount != null) {
                               for (Map.Entry<String, Integer> e : deptCount.entrySet()) { %>
                            <tr>
                                <td><%= e.getKey() %></td>
                                <td><span class="badge bg-primary"><%= e.getValue() %></span></td>
                            </tr>
                            <% }} %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('deptChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: <%= labels %>,
                datasets: [{
                    data: <%= data %>,
                    backgroundColor: [
                        '#667eea','#764ba2','#f093fb','#f5576c',
                        '#4facfe','#00f2fe','#43e97b','#38f9d7'
                    ]
                }]
            },
            options: { responsive: true, plugins: { legend: { position: 'bottom' }}}
        });
    </script>
</body>
</html>