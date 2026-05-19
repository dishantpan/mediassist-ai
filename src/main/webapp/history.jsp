<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.mediassist.model.Consultation" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MediAssist — History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f0f4ff; }
        .navbar { background: linear-gradient(135deg, #667eea, #764ba2); }
        .table-card { border-radius: 15px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
    <nav class="navbar navbar-dark px-4 py-3">
        <span class="navbar-brand fw-bold"><i class="fas fa-history me-2"></i>Consultation History</span>
        <a href="symptoms.html" class="btn btn-outline-light btn-sm">
            <i class="fas fa-arrow-left me-1"></i>Back
        </a>
    </nav>

    <%
        List<Consultation> history = (List<Consultation>) request.getAttribute("history");
        String userName = (String) session.getAttribute("userName");
    %>

    <div class="container py-4">
        <h4 class="fw-bold mb-1">Welcome, <%= userName != null ? userName : "User" %></h4>
        <p class="text-muted mb-4">Your past consultations are listed below.</p>

        <div class="card table-card p-4">
            <% if (history == null || history.isEmpty()) { %>
                <div class="text-center py-5">
                    <i class="fas fa-clipboard fa-3x text-muted mb-3"></i>
                    <p class="text-muted">No consultations yet.
                        <a href="symptoms.html">Check your symptoms now!</a>
                    </p>
                </div>
            <% } else { %>
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Date</th>
                            <th>Symptoms</th>
                            <th>Department</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int i = 1; for (Consultation c : history) { %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><small><%= c.getConsultationDate() %></small></td>
                            <td>
                                <% String[] syms = c.getSymptomsSelected().split(", ");
                                   for (String sym : syms) { %>
                                    <span class="badge bg-light text-dark border me-1">
                                        <%= sym.replace("_"," ") %>
                                    </span>
                                <% } %>
                            </td>
                            <td><span class="badge bg-primary"><%= c.getDepartmentSuggested() %></span></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>