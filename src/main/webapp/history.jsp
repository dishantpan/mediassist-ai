<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.mediassist.model.Consultation" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="MediAssist AI — View your clinical consultation history and AI department recommendations.">
  <title>MediAssist AI — Consultation History</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="css/mediassist.css" rel="stylesheet">
  <style>
    body { background: var(--bg-dark); color: var(--text-primary); font-family: 'Inter', sans-serif; }

    /* ── Page Header ── */
    .history-header {
      padding: 40px 0 24px;
      text-align: center;
    }
    .history-badge {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(139,92,246,0.12); border: 1px solid rgba(139,92,246,0.3);
      border-radius: 999px; padding: 6px 16px;
      font-size: 0.75rem; font-weight: 700;
      color: var(--purple-light); letter-spacing: 0.05em; text-transform: uppercase;
      margin-bottom: 20px;
    }

    /* ── Search/Filter Bar ── */
    .filter-wrap {
      max-width: 700px;
      margin: 0 auto 40px;
      display: flex;
      gap: 12px;
      animation: fadeIn 0.6s ease both;
    }
    .search-input-group {
      position: relative;
      flex: 1;
    }
    .search-input-group i {
      position: absolute; left: 16px; top: 50%;
      transform: translateY(-50%);
      color: var(--text-muted);
    }
    .search-input {
      width: 100%;
      padding: 14px 16px 14px 44px;
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.12);
      border-radius: var(--radius-md);
      color: var(--text-primary);
      outline: none;
      transition: var(--transition);
      font-size: 0.92rem;
    }
    .search-input:focus {
      border-color: var(--primary);
      background: rgba(14,165,233,0.08);
      box-shadow: 0 0 0 3px rgba(14,165,233,0.15);
    }
    
    .dept-select {
      padding: 14px 20px;
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.12);
      border-radius: var(--radius-md);
      color: var(--text-primary);
      outline: none;
      transition: var(--transition);
      font-size: 0.92rem;
      cursor: pointer;
    }
    .dept-select:focus {
      border-color: var(--primary);
      background: rgba(14,165,233,0.08);
    }
    .dept-select option {
      background: #0b1524;
      color: var(--text-primary);
    }

    /* ── Timeline Construction ── */
    .timeline-container {
      position: relative;
      max-width: 800px;
      margin: 0 auto;
      padding-left: 32px;
    }
    .timeline-container::before {
      content: '';
      position: absolute;
      left: 7px; top: 8px; bottom: 8px;
      width: 2px;
      background: linear-gradient(to bottom, var(--primary), var(--purple), var(--teal), rgba(255,255,255,0.05));
    }

    .timeline-item {
      position: relative;
      margin-bottom: 32px;
      animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) both;
    }
    .timeline-dot {
      position: absolute;
      left: -32px; top: 18px;
      width: 16px; height: 16px;
      border-radius: 50%;
      background: var(--bg-dark);
      border: 3px solid var(--primary);
      box-shadow: 0 0 10px var(--primary);
      z-index: 2;
      transition: var(--transition);
    }
    .timeline-item:hover .timeline-dot {
      background: var(--primary);
      transform: scale(1.2);
    }

    /* ── Card Styling ── */
    .history-card {
      background: rgba(255, 255, 255, 0.05);
      backdrop-filter: blur(20px);
      border: 1px solid rgba(255, 255, 255, 0.1);
      border-radius: var(--radius-md);
      padding: 24px;
      transition: var(--transition);
    }
    .history-card:hover {
      border-color: var(--border-glass-hover);
      background: rgba(255, 255, 255, 0.08);
      transform: translateY(-2px);
      box-shadow: var(--shadow-md), 0 0 25px rgba(14,165,233,0.1);
    }

    .card-header-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      flex-wrap: wrap;
      gap: 12px;
      margin-bottom: 16px;
    }

    .date-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      font-size: 0.8rem;
      color: var(--text-muted);
      font-weight: 500;
    }

    .dept-badge-glow {
      padding: 6px 14px;
      border-radius: var(--radius-full);
      font-size: 0.82rem;
      font-weight: 700;
      letter-spacing: 0.02em;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .symptom-tag-row {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-bottom: 16px;
    }
    .sym-tag {
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(255,255,255,0.1);
      color: var(--text-secondary);
      font-size: 0.78rem;
      padding: 4px 10px;
      border-radius: var(--radius-full);
    }

    /* Expandable clinical notes */
    .details-trigger {
      background: transparent;
      border: none;
      color: var(--primary-light);
      font-size: 0.82rem;
      font-weight: 600;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      padding: 0;
      transition: var(--transition-fast);
    }
    .details-trigger:hover {
      color: white;
    }
    .details-trigger i {
      transition: transform 0.2s ease;
    }
    .details-trigger.active i {
      transform: rotate(180deg);
    }

    .details-content {
      max-height: 0;
      overflow: hidden;
      transition: max-height 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      border-top: 1px solid transparent;
      margin-top: 0;
      padding-top: 0;
    }
    .details-content.show {
      border-top: 1px solid rgba(255,255,255,0.08);
      margin-top: 16px;
      padding-top: 16px;
    }

    .clinical-note-card {
      background: rgba(0, 0, 0, 0.15);
      border-radius: var(--radius-sm);
      padding: 14px 16px;
      font-size: 0.85rem;
      border-left: 3px solid var(--primary);
    }

    /* ── Empty State ── */
    .empty-state-card {
      max-width: 600px;
      margin: 40px auto;
      text-align: center;
      padding: 60px 40px;
    }
    .empty-icon-ring {
      width: 80px; height: 80px;
      border-radius: 50%;
      background: rgba(255,255,255,0.04);
      border: 1.5px solid rgba(255,255,255,0.1);
      display: flex; align-items: center; justify-content: center;
      font-size: 2rem;
      color: var(--text-muted);
      margin: 0 auto 24px;
      animation: float 4s ease-in-out infinite;
    }
    @keyframes float {
      0%, 100% { transform: translateY(0); }
      50% { transform: translateY(-10px); }
    }

    /* ── Animations ── */
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
  </style>
</head>
<body>

<%
  List<Consultation> history = (List<Consultation>) request.getAttribute("history");
  String userName = (String) session.getAttribute("userName");
  int totalConsultations = history != null ? history.size() : 0;
%>

<div class="med-bg"></div>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="orb orb-3"></div>
<canvas id="particles-canvas"></canvas>

<!-- Navbar -->
<nav class="med-navbar">
  <a href="symptoms.html" class="brand text-decoration-none">
    <div class="brand-icon"><i class="fas fa-heartbeat"></i></div>
    <div>
      <div class="brand-text">MediAssist AI</div>
      <div class="brand-sub">Clinical History</div>
    </div>
  </a>
  <div class="nav-actions">
    <a href="symptoms.html" class="btn-med-outline text-decoration-none" style="padding:8px 16px; font-size:0.82rem;">
      <i class="fas fa-redo"></i><span class="d-none d-sm-inline">New Analysis</span>
    </a>
    <a href="index.html" class="btn-med-outline text-decoration-none" style="padding:8px 16px; font-size:0.82rem;">
      <i class="fas fa-right-from-bracket"></i><span class="d-none d-sm-inline">Logout</span>
    </a>
  </div>
</nav>

<div class="med-content">
  <div class="container py-4">

    <!-- Header -->
    <div class="history-header">
      <div class="history-badge">
        <i class="fas fa-history me-1"></i> Patient Records
      </div>
      <h1 style="font-size:clamp(1.6rem, 4vw, 2.6rem); font-weight:800; margin-bottom:8px; letter-spacing:-0.03em;">
        Welcome back, <span class="gradient-text"><%= userName != null ? userName : "User" %></span>
      </h1>
      <p style="color:var(--text-secondary); font-size:0.95rem; max-width:500px; margin:0 auto 20px;">
        Review your past clinical routing reports, symptom checklists, and AI recommendations.
      </p>
      
      <% if (totalConsultations > 0) { %>
      <div class="d-flex justify-content-center gap-3 mt-3">
        <div style="background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08); border-radius:12px; padding:10px 20px; text-align:center;">
          <div style="font-size:1.3rem; font-weight:800; color:var(--primary-light);"><%= totalConsultations %></div>
          <div style="font-size:0.7rem; text-transform:uppercase; color:var(--text-muted); font-weight:600; letter-spacing:0.04em;">Total Checkups</div>
        </div>
      </div>
      <% } %>
    </div>

    <% if (history == null || history.isEmpty()) { %>
      <!-- Empty State -->
      <div class="glass-card empty-state-card fade-up">
        <div class="empty-icon-ring">
          <i class="fas fa-clipboard-list"></i>
        </div>
        <h4 style="font-weight:700; margin-bottom:10px;">No consultations recorded</h4>
        <p style="color:var(--text-secondary); font-size:0.9rem; max-width:380px; margin:0 auto 24px; line-height:1.6;">
          You haven't run any symptom routing sessions yet. Analyze your symptoms to see referrals here.
        </p>
        <a href="symptoms.html" class="btn-med-primary text-decoration-none ripple-btn">
          <i class="fas fa-microscope"></i> Start Symptom Analysis
        </a>
      </div>
    <% } else { %>
      
      <!-- Filter Bar -->
      <div class="filter-wrap">
        <div class="search-input-group">
          <i class="fas fa-search"></i>
          <input type="text" class="search-input" id="historySearch" placeholder="Search by symptom or department...">
        </div>
        <select class="dept-select" id="deptFilter">
          <option value="">All Departments</option>
          <% 
             Set<String> uniqueDepts = new LinkedHashSet<String>();
             for (Consultation c : history) {
               if (c.getDepartmentSuggested() != null) {
                 uniqueDepts.add(c.getDepartmentSuggested());
               }
             }
             for (String deptName : uniqueDepts) {
          %>
            <option value="<%= deptName %>"><%= deptName %></option>
          <% } %>
        </select>
      </div>

      <!-- Timeline -->
      <div class="timeline-container">
        <% 
           int idx = 0; 
           for (Consultation c : history) { 
             idx++;
             String dept = c.getDepartmentSuggested();
             String deptIcon = "🏥";
             String deptColor = "#0ea5e9";
             String glowStyle = "rgba(14,165,233,0.15)";
             String borderStyle = "rgba(14,165,233,0.3)";
             
             String triageLevel = "Standard";
             String triageColor = "var(--success)";
             String clinicalNote = "Schedule an appointment with the recommended department. Bring all previous medical records.";
             
             if (dept != null) {
               String d = dept.toLowerCase();
               if (d.contains("cardio") || d.contains("heart")) { 
                 deptIcon = "❤️"; deptColor = "#ef4444"; glowStyle = "rgba(239,68,68,0.15)"; borderStyle = "rgba(239,68,68,0.3)";
                 triageLevel = "PRIORITY"; triageColor = "var(--emergency)"; clinicalNote = "Priority consultation recommended. Avoid heavy physical strain. Monitor blood pressure.";
               }
               else if (d.contains("neuro") || d.contains("brain")) { 
                 deptIcon = "🧠"; deptColor = "#8b5cf6"; glowStyle = "rgba(139,92,246,0.15)"; borderStyle = "rgba(139,92,246,0.3)";
                 triageLevel = "PRIORITY"; triageColor = "var(--purple-light)"; clinicalNote = "Specialist review suggested. Keep track of visual/sensory issues or headaches.";
               }
               else if (d.contains("ortho") || d.contains("bone")) { 
                 deptIcon = "🦴"; deptColor = "#f59e0b"; glowStyle = "rgba(245,158,11,0.15)"; borderStyle = "rgba(245,158,11,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--warning)"; clinicalNote = "Avoid load-bearing activities on the affected areas. Apply cold compression if swollen.";
               }
               else if (d.contains("ent") || d.contains("ear") || d.contains("nose")) { 
                 deptIcon = "👂"; deptColor = "#06b6d4"; glowStyle = "rgba(6,182,212,0.15)"; borderStyle = "rgba(6,182,212,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--cyan)"; clinicalNote = "Consultation for localized throat/ear pain. Rest vocal cords; use saline rinses if needed.";
               }
               else if (d.contains("eye") || d.contains("opth")) { 
                 deptIcon = "👁️"; deptColor = "#3b82f6"; glowStyle = "rgba(59,130,246,0.15)"; borderStyle = "rgba(59,130,246,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--primary-light)"; clinicalNote = "Avoid screen glare. Do not rub your eyes. Get visual acuity checked.";
               }
               else if (d.contains("skin") || d.contains("derm")) { 
                 deptIcon = "🔬"; deptColor = "#f472b6"; glowStyle = "rgba(244,114,182,0.15)"; borderStyle = "rgba(244,114,182,0.3)";
                 triageLevel = "STANDARD"; triageColor = "#f472b6"; clinicalNote = "Avoid applying unprescribed lotions. Note if rash spreads or develops heat/pain.";
               }
               else if (d.contains("gastro") || d.contains("digest")) { 
                 deptIcon = "🫀"; deptColor = "#eab308"; glowStyle = "rgba(234,179,8,0.15)"; borderStyle = "rgba(234,179,8,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--warning)"; clinicalNote = "Stick to light, non-spicy foods. Ensure adequate fluid intake. Avoid self-medicating.";
               }
               else if (d.contains("general") || d.contains("medicine")) { 
                 deptIcon = "⚕️"; deptColor = "#14b8a6"; glowStyle = "rgba(20,184,166,0.15)"; borderStyle = "rgba(20,184,166,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--teal)"; clinicalNote = "General medical consult recommended. Keep a log of temperature and symptoms.";
               }
               else if (d.contains("emergency") || d.contains("casualty")) { 
                 deptIcon = "🚨"; deptColor = "#ef4444"; glowStyle = "rgba(239,68,68,0.2)"; borderStyle = "rgba(239,68,68,0.5)";
                 triageLevel = "CRITICAL / EMERGENCY"; triageColor = "var(--emergency)"; clinicalNote = "Proceed directly to clinical emergency facility. Immediate stabilization required.";
               }
               else if (d.contains("psych") || d.contains("mental")) { 
                 deptIcon = "🧘"; deptColor = "#8b5cf6"; glowStyle = "rgba(139,92,246,0.15)"; borderStyle = "rgba(139,92,246,0.3)";
                 triageLevel = "STANDARD"; triageColor = "var(--purple-light)"; clinicalNote = "Reach out for supportive consulting. Access immediate care resources if stressed.";
               }
             }
             String[] syms = c.getSymptomsSelected() != null ? c.getSymptomsSelected().split(", ") : new String[0];
        %>
          <div class="timeline-item filterable-record" data-dept="<%= dept %>" data-symptoms="<%= c.getSymptomsSelected() != null ? c.getSymptomsSelected().toLowerCase() : "" %>" style="animation-delay: <%= (idx * 80) %>ms;">
            <div class="timeline-dot" style="border-color: <%= deptColor %>; box-shadow: 0 0 10px <%= deptColor %>;"></div>
            
            <div class="history-card">
              <div class="card-header-row">
                <div>
                  <div class="date-badge mb-1">
                    <i class="far fa-calendar-alt"></i>
                    <span><%= c.getConsultationDate() %></span>
                  </div>
                  <h4 style="font-weight: 700; margin: 0; font-size: 1.15rem; display: flex; align-items: center; gap: 8px;">
                    <span style="font-size:1.1rem;"><%= deptIcon %></span>
                    <span class="gradient-text"><%= dept %></span>
                  </h4>
                </div>
                
                <div>
                  <span class="dept-badge-glow" style="background: <%= glowStyle %>; border: 1px solid <%= borderStyle %>; color: <%= deptColor %>;">
                    Triage: <%= triageLevel %>
                  </span>
                </div>
              </div>

              <!-- Symptoms Selected -->
              <div class="symptom-tag-row">
                <% for (String sym : syms) { %>
                  <span class="sym-tag"><%= sym.replace("_", " ") %></span>
                <% } %>
              </div>

              <!-- Expand/Collapse Action -->
              <div>
                <button class="details-trigger" onclick="toggleDetails(this, <%= idx %>)">
                  <span>View Clinical Note</span> <i class="fas fa-chevron-down"></i>
                </button>
              </div>

              <!-- Expanded Details -->
              <div class="details-content" id="details-<%= idx %>">
                <div class="clinical-note-card" style="border-left-color: <%= deptColor %>;">
                  <div style="font-size:0.75rem; font-weight:700; color:var(--text-muted); text-transform:uppercase; letter-spacing:0.04em; margin-bottom:4px;">
                    <i class="fas fa-user-md me-1" style="color:<%= deptColor %>"></i> AI Consultation Note
                  </div>
                  <div style="color: var(--text-secondary); line-height: 1.5;"><%= clinicalNote %></div>
                  <div class="mt-2 d-flex justify-content-between align-items: center; font-size: 0.72rem; color: var(--text-muted);">
                    <span>Analysis accuracy: ~92%</span>
                    <span>ID: MA-<%= idx * 1000 + 423 %></span>
                  </div>
                </div>
              </div>

            </div>
          </div>
        <% } %>
      </div>
    <% } %>

  </div>
</div>

<script>
// ── Particle System ──
const canvas = document.getElementById('particles-canvas');
if (canvas) {
  const ctx = canvas.getContext('2d');
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
  const particles = Array.from({length: 25}, () => ({
    x: Math.random() * canvas.width,
    y: Math.random() * canvas.height,
    r: Math.random() * 2.5 + 1.2,
    speed: Math.random() * 0.25 + 0.05,
    opacity: Math.random() * 0.08 + 0.02
  }));
  function draw() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    particles.forEach(p => {
      ctx.globalAlpha = p.opacity;
      ctx.fillStyle = '#0ea5e9';
      ctx.beginPath();
      ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
      ctx.fill();
      p.y -= p.speed;
      if (p.y < -10) {
        p.y = canvas.height + 10;
        p.x = Math.random() * canvas.width;
      }
    });
    ctx.globalAlpha = 1;
    requestAnimationFrame(draw);
  }
  draw();
  window.addEventListener('resize', () => {
    canvas.width = window.innerWidth;
    canvas.height = window.innerHeight;
  });
}

// ── Ripple Button effect ──
document.querySelectorAll('.ripple-btn').forEach(btn => {
  btn.addEventListener('click', function(e) {
    const r = document.createElement('span'); r.className='ripple';
    const rect = this.getBoundingClientRect(), size = Math.max(rect.width, rect.height);
    r.style.cssText=`width:${size}px;height:${size}px;left:${e.clientX-rect.left-size/2}px;top:${e.clientY-rect.top-size/2}px;`;
    this.appendChild(r); setTimeout(()=>r.remove(),600);
  });
});

// ── Expand/Collapse Details ──
function toggleDetails(btn, index) {
  const content = document.getElementById('details-' + index);
  if (!content) return;
  
  if (content.classList.contains('show')) {
    content.classList.remove('show');
    content.style.maxHeight = null;
    btn.classList.remove('active');
  } else {
    // Close other open panels first (optional, standard accordion style)
    document.querySelectorAll('.details-content').forEach(other => {
      other.classList.remove('show');
      other.style.maxHeight = null;
    });
    document.querySelectorAll('.details-trigger').forEach(otherBtn => {
      otherBtn.classList.remove('active');
    });
    
    content.classList.add('show');
    content.style.maxHeight = content.scrollHeight + "px";
    btn.classList.add('active');
  }
}

// ── Interactive Filters ──
const historySearch = document.getElementById('historySearch');
const deptFilter = document.getElementById('deptFilter');
const records = document.querySelectorAll('.filterable-record');

function filterRecords() {
  const searchQuery = historySearch ? historySearch.value.toLowerCase() : '';
  const selectedDept = deptFilter ? deptFilter.value : '';

  records.forEach(card => {
    const cardDept = card.getAttribute('data-dept') || '';
    const cardSymptoms = card.getAttribute('data-symptoms') || '';
    
    const matchesSearch = cardDept.toLowerCase().includes(searchQuery) || 
                          cardSymptoms.includes(searchQuery);
    const matchesDept = selectedDept === '' || cardDept === selectedDept;

    if (matchesSearch && matchesDept) {
      card.style.display = '';
    } else {
      card.style.display = 'none';
    }
  });
}

if (historySearch) historySearch.addEventListener('input', filterRecords);
if (deptFilter) deptFilter.addEventListener('change', filterRecords);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>