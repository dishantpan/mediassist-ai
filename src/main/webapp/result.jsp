<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MediAssist — Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f4ff; }
        .result-card { border-radius: 20px; border: none; box-shadow: 0 15px 40px rgba(102,126,234,0.2); }
        .dept-badge { background: linear-gradient(135deg, #667eea, #764ba2); color: white;
                      padding: 15px 30px; border-radius: 50px; font-size: 1.4rem; font-weight: 700; }
        .hospital-card { border-radius: 12px; border: 1px solid #e0e0ff; transition: transform 0.2s; }
        .hospital-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <%
        String department = (String) request.getAttribute("department");
        List<Map<String, String>> hospitals = (List<Map<String, String>>) request.getAttribute("hospitals");
        List<String> symptoms = (List<String>) request.getAttribute("symptoms");
    %>
    <div class="container py-5" style="max-width: 800px;">

        <!-- Result Card -->
        <div class="card result-card p-5 text-center mb-4">
            <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
            <h2 class="fw-bold mb-3">Recommended Department</h2>
            <div class="dept-badge d-inline-block mb-4">
                <i class="fas fa-hospital me-2"></i><%= department %>
            </div>
            <p class="text-muted">Based on your symptoms, please visit the <strong><%= department %></strong> department.</p>

            <!-- Symptoms shown -->
            <div class="mt-3">
                <small class="text-muted">Your selected symptoms: </small>
                <% if (symptoms != null) { for (String s : symptoms) { %>
                    <span class="badge bg-light text-dark border me-1"><%= s.replace("_", " ") %></span>
                <% }} %>
            </div>
        </div>

        <!-- Hospital List -->
        <h4 class="fw-bold mb-3"><i class="fas fa-map-marker-alt me-2 text-primary"></i>Nearby Hospitals</h4>
        <div class="row g-3">
            <% if (hospitals != null && !hospitals.isEmpty()) {
                for (Map<String, String> h : hospitals) { %>
                <div class="col-md-6">
                    <div class="card hospital-card p-3">
                        <h6 class="fw-bold mb-1"><i class="fas fa-hospital-alt me-2 text-primary"></i><%= h.get("name") %></h6>
                        <p class="text-muted mb-1"><i class="fas fa-map-marker-alt me-1"></i><%= h.get("city") %></p>
                        <p class="mb-0"><i class="fas fa-phone me-1 text-success"></i><%= h.get("contact") %></p>
                    </div>
                </div>
            <% }} else { %>
                <div class="col-12">
                    <div class="alert alert-info">No hospitals found in database for this department.</div>
                </div>
            <% } %>
        </div>

        <!-- Buttons -->
        <div class="text-center mt-4">
            <a href="symptoms.html" class="btn btn-primary me-3 px-4 py-2">
                <i class="fas fa-redo me-2"></i>Check Again
            </a>
            <a href="history" class="btn btn-outline-secondary px-4 py-2">
                <i class="fas fa-history me-2"></i>View History
            </a>
        </div>
    </div>
</body>
</html>