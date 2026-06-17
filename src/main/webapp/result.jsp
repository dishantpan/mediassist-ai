<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="MediAssist AI — Your personalized department recommendation based on AI symptom analysis.">
  <title>MediAssist AI — Department Recommendation</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="css/mediassist.css" rel="stylesheet">
  <style>
    body { background: var(--bg-dark); color: var(--text-primary); font-family: 'Inter', sans-serif; }

    /* ── Reveal animation ── */
    @keyframes revealIn { from { opacity:0; transform:scale(0.94) translateY(20px); } to { opacity:1; transform:scale(1) translateY(0); } }
    @keyframes slideDown { from { opacity:0; transform:translateY(-20px); } to { opacity:1; transform:translateY(0); } }
    @keyframes countUp { from { opacity:0; } to { opacity:1; } }

    /* ── Progress ring ── */
    .ring-wrapper {
      position: relative;
      width: 160px; height: 160px;
      margin: 0 auto 24px;
    }
    .ring-svg { transform: rotate(-90deg); }
    .ring-bg { fill: none; stroke: rgba(255,255,255,0.08); stroke-width: 10; }
    .ring-fill {
      fill: none;
      stroke-width: 10;
      stroke-linecap: round;
      stroke-dasharray: 440;
      stroke-dashoffset: 440;
      transition: stroke-dashoffset 2s cubic-bezier(0.4,0,0.2,1);
    }
    .ring-center {
      position: absolute;
      top: 50%; left: 50%;
      transform: translate(-50%, -50%);
      text-align: center;
    }
    .ring-percent {
      font-size: 2rem;
      font-weight: 900;
      line-height: 1;
    }
    .ring-label {
      font-size: 0.7rem;
      color: var(--text-muted);
      letter-spacing: 0.05em;
      text-transform: uppercase;
      margin-top: 2px;
    }

    /* ── Main result card ── */
    .result-hero {
      text-align: center;
      padding: 60px 0 40px;
      animation: slideDown 0.8s ease both;
    }
    .ai-badge {
      display: inline-flex; align-items: center; gap: 8px;
      background: rgba(16,185,129,0.12); border: 1px solid rgba(16,185,129,0.3);
      border-radius: 999px; padding: 6px 16px;
      font-size: 0.75rem; font-weight: 700;
      color: #6ee7b7; letter-spacing: 0.05em; text-transform: uppercase;
      margin-bottom: 28px;
    }
    .dept-card {
      background: var(--bg-card);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-glass);
      border-radius: 28px;
      padding: 48px 40px;
      text-align: center;
      animation: revealIn 0.9s cubic-bezier(0.34,1.56,0.64,1) 0.2s both;
      box-shadow: var(--shadow-lg), var(--shadow-glow);
      max-width: 640px;
      margin: 0 auto 32px;
      position: relative;
      overflow: hidden;
    }
    .dept-card::before {
      content: '';
      position: absolute;
      top: 0; left: 0; right: 0;
      height: 3px;
      background: linear-gradient(90deg, var(--primary), var(--teal), var(--cyan));
    }
    .dept-icon-ring {
      width: 90px; height: 90px;
      border-radius: 50%;
      background: linear-gradient(135deg, rgba(14,165,233,0.1), rgba(20,184,166,0.1));
      border: 2px solid rgba(14,165,233,0.2);
      display: flex; align-items: center; justify-content: center;
      font-size: 2.2rem;
      margin: 0 auto 20px;
      box-shadow: 0 0 30px rgba(14,165,233,0.15);
      animation: heartbeat 2s ease-in-out infinite;
    }
    .dept-name {
      font-size: clamp(1.6rem, 5vw, 2.4rem);
      font-weight: 900;
      letter-spacing: -0.03em;
      margin-bottom: 12px;
    }
    .dept-description {
      color: var(--text-secondary);
      font-size: 0.95rem;
      line-height: 1.6;
      max-width: 420px;
      margin: 0 auto 28px;
    }

    /* ── Symptom chips on result ── */
    .symptom-chips-row {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      justify-content: center;
      margin-top: 20px;
    }
    .sym-chip {
      background: rgba(14,165,233,0.06);
      border: 1px solid rgba(14,165,233,0.15);
      border-radius: 999px;
      padding: 6px 14px;
      font-size: 0.8rem;
      font-weight: 500;
      color: var(--text-secondary);
      animation: revealIn 0.5s ease both;
    }

    /* ── Next steps ── */
    .next-steps { margin: 32px 0; }
    .step-card {
      background: var(--bg-card);
      border: 1px solid var(--border-glass);
      border-radius: var(--radius-md);
      padding: 20px;
      text-align: center;
      box-shadow: var(--shadow-sm);
      transition: var(--transition);
      animation: revealIn 0.6s ease both;
    }
    .step-card:hover { border-color: var(--primary); background: rgba(14,165,233,0.04); transform: translateY(-3px); box-shadow: var(--shadow-md); }
    .step-num {
      width: 36px; height: 36px;
      border-radius: 50%;
      background: linear-gradient(135deg, var(--primary), var(--teal));
      color: white;
      font-weight: 800; font-size: 0.9rem;
      display: flex; align-items: center; justify-content: center;
      margin: 0 auto 12px;
      box-shadow: 0 4px 15px rgba(14,165,233,0.25);
    }

    /* ── Hospital cards ── */
    .hospital-card {
      background: var(--bg-card);
      border: 1px solid var(--border-glass);
      border-radius: var(--radius-md);
      padding: 20px;
      box-shadow: var(--shadow-sm);
      transition: var(--transition);
      animation: revealIn 0.6s ease both;
    }
    .hospital-card:hover { border-color: rgba(14,165,233,0.3); background: rgba(14,165,233,0.03); transform: translateY(-3px); box-shadow: var(--shadow-md), var(--shadow-glow); }
    .hosp-badge {
      display: inline-block;
      background: linear-gradient(135deg, var(--primary), var(--teal));
      color: white;
      border-radius: 8px;
      padding: 6px 10px;
      font-size: 1.2rem;
      margin-bottom: 12px;
    }

    /* ── Doctor placeholders ── */
    .doc-card {
      background: var(--bg-card);
      border: 1px solid var(--border-glass);
      border-radius: var(--radius-md);
      padding: 18px;
      display: flex; align-items: center; gap: 14px;
      box-shadow: var(--shadow-sm);
      transition: var(--transition);
    }
    .doc-avatar {
      width: 48px; height: 48px;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 1.5rem;
      flex-shrink: 0;
    }

    /* ── Section title ── */
    .section-title-row {
      display: flex; align-items: center; gap: 12px;
      margin-bottom: 20px;
    }
    .section-title-row h4 { font-weight: 700; font-size: 1.1rem; margin: 0; }
    .section-divider {
      flex: 1; height: 1px;
      background: rgba(255,255,255,0.07);
    }

    /* ── CTA buttons ── */
    .cta-row { display: flex; gap: 12px; flex-wrap: wrap; justify-content: center; padding: 40px 0; }
  </style>
</head>
<body>
<%
  String department = (String) request.getAttribute("department");
  List<Map<String, String>> hospitals = (List<Map<String, String>>) request.getAttribute("hospitals");
  List<String> symptoms = (List<String>) request.getAttribute("symptoms");

  // Department icon mapping
  String deptIcon = "🏥";
  String deptColor = "#0ea5e9";
  String deptColorLight = "#38bdf8";
  String deptDesc = "Based on your symptom profile, our AI has determined this department as the most suitable for your consultation.";
  if (department != null) {
    String d = department.toLowerCase();
    if (d.contains("cardio") || d.contains("heart")) { deptIcon = "❤️"; deptColor = "#ef4444"; deptColorLight = "#f87171"; deptDesc = "Your cardiovascular symptoms indicate the need for specialist cardiac evaluation. The Cardiology department handles heart-related conditions."; }
    else if (d.contains("neuro") || d.contains("brain")) { deptIcon = "🧠"; deptColor = "#8b5cf6"; deptColorLight = "#a78bfa"; deptDesc = "Your neurological symptom profile requires specialist evaluation. Neurology covers brain, spine, and nervous system disorders."; }
    else if (d.contains("ortho") || d.contains("bone")) { deptIcon = "🦴"; deptColor = "#f59e0b"; deptColorLight = "#fbbf24"; deptDesc = "Your musculoskeletal symptoms point to Orthopedics. This department specializes in bones, joints, muscles, and ligaments."; }
    else if (d.contains("ent") || d.contains("ear") || d.contains("nose")) { deptIcon = "👂"; deptColor = "#06b6d4"; deptColorLight = "#22d3ee"; deptDesc = "Your ENT symptoms require a specialist evaluation for Ear, Nose, and Throat conditions."; }
    else if (d.contains("eye") || d.contains("opth")) { deptIcon = "👁️"; deptColor = "#3b82f6"; deptColorLight = "#60a5fa"; deptDesc = "Your ocular symptoms require Ophthalmology evaluation. This department handles all vision and eye-related conditions."; }
    else if (d.contains("skin") || d.contains("derm")) { deptIcon = "🔬"; deptColor = "#f472b6"; deptColorLight = "#f9a8d4"; deptDesc = "Your skin-related symptoms indicate Dermatology. This specialty covers all skin, hair, and nail conditions."; }
    else if (d.contains("gastro") || d.contains("digest")) { deptIcon = "🫀"; deptColor = "#eab308"; deptColorLight = "#fde047"; deptDesc = "Your digestive symptoms indicate Gastroenterology. This department specializes in stomach, intestine, liver, and pancreas conditions."; }
    else if (d.contains("general") || d.contains("medicine")) { deptIcon = "⚕️"; deptColor = "#14b8a6"; deptColorLight = "#2dd4bf"; deptDesc = "Your symptoms are best evaluated by General Medicine first, where a comprehensive assessment will guide further specialist referrals."; }
    else if (d.contains("emergency") || d.contains("casualty")) { deptIcon = "🚨"; deptColor = "#ef4444"; deptColorLight = "#f87171"; deptDesc = "Your symptoms indicate a potential emergency. Please proceed to the Emergency/Casualty department IMMEDIATELY without delay."; }
    else if (d.contains("psych") || d.contains("mental")) { deptIcon = "🧘"; deptColor = "#8b5cf6"; deptColorLight = "#a78bfa"; deptDesc = "Your symptoms indicate the need for mental health evaluation. The Psychiatry department provides confidential, compassionate care."; }
  }
  if (department == null) department = "General Medicine";

  // Build specific doctor lists for Parul Sevashram Hospital based on department
  List<Map<String, String>> deptDoctors = new ArrayList<Map<String, String>>();
  if (department != null) {
    String d = department.toLowerCase();
    if (d.contains("cardio") || d.contains("heart")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Tanvi H. Patel"); dr1.put("spec", "Consultant Cardiologist"); dr1.put("deg", "MD, DM (Cardiology)");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Dr. Parth Solanki"); dr2.put("spec", "Cardiothoracic Surgeon"); dr2.put("deg", "MCh (CTVS)");
      Map<String, String> dr3 = new HashMap<String, String>(); dr3.put("name", "Dr. Vihang C. Shah"); dr3.put("spec", "Interventional Cardiologist"); dr3.put("deg", "MD, DM");
      deptDoctors.add(dr1); deptDoctors.add(dr2); deptDoctors.add(dr3);
    } else if (d.contains("neuro") || d.contains("brain")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Ankitkumar Shah"); dr1.put("spec", "Consultant Neurologist"); dr1.put("deg", "MD, DM (Neurology)");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Dr. Mohit Shah"); dr2.put("spec", "Consultant Neurosurgeon"); dr2.put("deg", "MS, MCh (Neurosurgery)");
      deptDoctors.add(dr1); deptDoctors.add(dr2);
    } else if (d.contains("gastro") || d.contains("digest")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Dhaval Dave"); dr1.put("spec", "Consultant Gastroenterologist"); dr1.put("deg", "MD, DM (Gastro)");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Dr. Darshak Shah"); dr2.put("spec", "Surgical Gastroenterology"); dr2.put("deg", "MS, DNB");
      Map<String, String> dr3 = new HashMap<String, String>(); dr3.put("name", "Dr. Jaydeep Patel"); dr3.put("spec", "Gastroenterologist"); dr3.put("deg", "MD, DNB");
      Map<String, String> dr4 = new HashMap<String, String>(); dr4.put("name", "Dr. Ankur Tiwari"); dr4.put("spec", "Gastroenterologist"); dr4.put("deg", "MD, DM");
      Map<String, String> dr5 = new HashMap<String, String>(); dr5.put("name", "Dr. Chirag Parikh"); dr5.put("spec", "Gastroenterologist"); dr5.put("deg", "MD, DM");
      deptDoctors.add(dr1); deptDoctors.add(dr2); deptDoctors.add(dr3); deptDoctors.add(dr4); deptDoctors.add(dr5);
    } else if (d.contains("eye") || d.contains("opth")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Ruchi Vala"); dr1.put("spec", "Vitreo Retinal Surgeon"); dr1.put("deg", "MS, FVRS");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Dr. Divya Vakharia"); dr2.put("spec", "Corneal Surgeon"); dr2.put("deg", "MS, Fellowship Cornea");
      deptDoctors.add(dr1); deptDoctors.add(dr2);
    } else if (d.contains("ent") || d.contains("ear") || d.contains("nose")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Sudhir Chauhan"); dr1.put("spec", "Audiologist & Speech Therapist"); dr1.put("deg", "BASLP");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Sunil Bhatt"); dr2.put("spec", "ENT Consultant Specialist"); dr2.put("deg", "MS (ENT)");
      deptDoctors.add(dr1); deptDoctors.add(dr2);
    } else if (d.contains("psych") || d.contains("mental")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Snehal Telang"); dr1.put("spec", "Clinical Psychologist"); dr1.put("deg", "M.Phil (Clin. Psych)");
      deptDoctors.add(dr1);
    } else if (d.contains("skin") || d.contains("derm")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Samir Saini"); dr1.put("spec", "Endocrinologist / Skin Care Referral"); dr1.put("deg", "MD, DM");
      deptDoctors.add(dr1);
    } else if (d.contains("ortho") || d.contains("bone")) {
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Jeet Patel"); dr1.put("spec", "Rheumatologist / Orthopedic Joint Specialist"); dr1.put("deg", "MD, DM");
      deptDoctors.add(dr1);
    } else {
      // Default: General Medicine
      Map<String, String> dr1 = new HashMap<String, String>(); dr1.put("name", "Dr. Divyesh Patel"); dr1.put("spec", "General Medicine Head"); dr1.put("deg", "MD (Internal Medicine)");
      Map<String, String> dr2 = new HashMap<String, String>(); dr2.put("name", "Dr. Ashish Bavishi"); dr2.put("spec", "Consultant Physician"); dr2.put("deg", "MD (General Medicine)");
      deptDoctors.add(dr1); deptDoctors.add(dr2);
    }
  }
%>

<div class="med-bg"></div>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<canvas id="particles-canvas"></canvas>

<!-- Navbar -->
<nav class="med-navbar">
  <a href="symptoms.html" class="brand text-decoration-none">
    <div class="brand-icon"><i class="fas fa-heartbeat"></i></div>
    <div>
      <div class="brand-text">MediAssist AI</div>
      <div class="brand-sub">Analysis Complete</div>
    </div>
  </a>
  <div class="nav-actions">
    <a href="symptoms.html" class="btn-med-outline text-decoration-none" style="padding:8px 16px; font-size:0.82rem;">
      <i class="fas fa-redo"></i><span class="d-none d-sm-inline">New Analysis</span>
    </a>
    <a href="history" class="btn-med-outline text-decoration-none" style="padding:8px 16px; font-size:0.82rem;">
      <i class="fas fa-clock-rotate-left"></i><span class="d-none d-sm-inline">History</span>
    </a>
  </div>
</nav>

<div class="med-content">
  <div class="container py-4" style="max-width: 900px;">

    <!-- Hero Header -->
    <div class="result-hero">
      <div class="ai-badge">
        <div style="width:6px;height:6px;background:#10b981;border-radius:50%;animation:blink 1.5s infinite;"></div>
        Analysis Complete
      </div>
      <h1 style="font-size:clamp(1.5rem,4vw,2.5rem); font-weight:800; margin-bottom:8px; letter-spacing:-0.03em;">
        AI Recommendation Ready
      </h1>
      <p style="color:var(--text-secondary); font-size:1rem; max-width:500px; margin:0 auto;">
        Your symptom profile has been analyzed. Here is your personalized department routing.
      </p>
    </div>

    <!-- Main Department Card -->
    <div class="dept-card fade-up">
      <!-- Confidence Ring -->
      <div class="ring-wrapper" id="ringWrap">
        <svg class="ring-svg" width="160" height="160" viewBox="0 0 160 160">
          <defs>
            <linearGradient id="ringGrad" x1="0%" y1="0%" x2="100%" y2="100%">
              <stop offset="0%" stop-color="<%= deptColor %>"/>
              <stop offset="100%" stop-color="#14b8a6"/>
            </linearGradient>
          </defs>
          <circle class="ring-bg" cx="80" cy="80" r="70"/>
          <circle class="ring-fill" id="ringFill" cx="80" cy="80" r="70" stroke="url(#ringGrad)"/>
        </svg>
        <div class="ring-center">
          <div class="ring-percent gradient-text" id="ringNum">0%</div>
          <div class="ring-label">Confidence</div>
        </div>
      </div>

      <!-- Department Icon -->
      <div class="dept-icon-ring" id="deptIconEl" style="background:linear-gradient(135deg, rgba(<%= deptColor.replace("#","") %>,0.2), rgba(20,184,166,0.2)); border-color:<%= deptColor %>30;">
        <%= deptIcon %>
      </div>

      <div class="dept-name gradient-text"><%= department %></div>
      <div class="dept-description"><%= deptDesc %></div>

      <!-- Symptom chips -->
      <% if (symptoms != null && !symptoms.isEmpty()) { %>
      <div style="border-top:1px solid rgba(255,255,255,0.07); padding-top:20px; margin-top:4px;">
        <div style="font-size:0.78rem; color:var(--text-muted); margin-bottom:10px; letter-spacing:0.04em; text-transform:uppercase; font-weight:600;">Analyzed Symptoms</div>
        <div class="symptom-chips-row">
          <% int delay = 0; for (String s : symptoms) { %>
          <span class="sym-chip" style="animation-delay:<%= delay %>ms;"><%= s.replace("_", " ") %></span>
          <% delay += 60; } %>
        </div>
      </div>
      <% } %>
    </div>

    <!-- Next Steps -->
    <div class="next-steps fade-up">
      <div class="section-title-row">
        <h4><i class="fas fa-list-check me-2" style="color:var(--primary);"></i>Suggested Next Steps</h4>
        <div class="section-divider"></div>
      </div>
      <div class="row g-3">
        <div class="col-md-4">
          <div class="step-card" style="animation-delay:0.1s">
            <div class="step-num">1</div>
            <div style="font-weight:700; margin-bottom:6px; font-size:0.95rem;">Book Appointment</div>
            <div style="color:var(--text-muted); font-size:0.82rem; line-height:1.5;">Visit the hospital reception or call ahead to schedule a consultation at <strong style="color:var(--primary-light);"><%= department %></strong>.</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="step-card" style="animation-delay:0.2s">
            <div class="step-num">2</div>
            <div style="font-weight:700; margin-bottom:6px; font-size:0.95rem;">Bring Medical Records</div>
            <div style="color:var(--text-muted); font-size:0.82rem; line-height:1.5;">Carry previous prescriptions, test reports, and your ID documents for a faster consultation process.</div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="step-card" style="animation-delay:0.3s">
            <div class="step-num">3</div>
            <div style="font-weight:700; margin-bottom:6px; font-size:0.95rem;">Arrive Early</div>
            <div style="color:var(--text-muted); font-size:0.82rem; line-height:1.5;">Reach the hospital 15-20 minutes before your appointment for registration and pre-consultation paperwork.</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Nearby Hospitals -->
    <div class="fade-up">
      <div class="section-title-row">
        <h4><i class="fas fa-map-marker-alt me-2" style="color:var(--teal);"></i>Nearby Hospitals</h4>
        <div class="section-divider"></div>
      </div>
      <div class="row g-3">
        <!-- Parul Sevashram Hospital (Primary Referral Partner) -->
        <div class="col-md-6">
          <div class="hospital-card" style="border-color: rgba(20,184,166,0.4); background: rgba(20,184,166,0.05); box-shadow: 0 0 20px rgba(20,184,166,0.15);">
            <div class="d-flex justify-content-between align-items-start">
              <div class="hosp-badge" style="background: linear-gradient(135deg, var(--teal), var(--primary));">🏥</div>
              <span style="font-size: 0.65rem; font-weight: 700; color: #14b8a6; background: rgba(20,184,166,0.15); border: 1.5px solid rgba(20,184,166,0.3); padding: 4px 10px; border-radius: 99px; text-transform: uppercase;">Primary Partner</span>
            </div>
            <h6 style="font-weight:700; margin-bottom:6px;">Parul Sevashram Hospital</h6>
            <div style="color:var(--text-muted); font-size:0.85rem; margin-bottom:8px;"><i class="fas fa-map-marker-alt me-1" style="color:var(--teal);"></i>Limda, Waghodia Road, Vadodara - 391760</div>
            <div style="color:var(--text-secondary); font-size:0.85rem; margin-bottom:14px;"><i class="fas fa-phone me-1" style="color:var(--success);"></i>+91 2668 260261</div>
            <a href="tel:+912668260261" class="btn-med-primary text-decoration-none" style="padding:8px 18px; font-size:0.82rem; border-radius:8px;">
              <i class="fas fa-phone-flip"></i> Call Now
            </a>
          </div>
        </div>

        <% if (hospitals != null && !hospitals.isEmpty()) {
             int hi = 0;
             for (Map<String, String> h : hospitals) {
               hi++;
               // Skip if it duplicates Parul
               if (h.get("name").toLowerCase().contains("parul")) continue;
        %>
        <div class="col-md-6">
          <div class="hospital-card" style="animation-delay:<%= hi * 100 %>ms;">
            <div class="hosp-badge">🏥</div>
            <h6 style="font-weight:700; margin-bottom:6px;"><%= h.get("name") %></h6>
            <div style="color:var(--text-muted); font-size:0.85rem; margin-bottom:8px;"><i class="fas fa-map-marker-alt me-1" style="color:var(--teal);"></i><%= h.get("city") %></div>
            <div style="color:var(--text-secondary); font-size:0.85rem; margin-bottom:14px;"><i class="fas fa-phone me-1" style="color:var(--success);"></i><%= h.get("contact") %></div>
            <a href="tel:<%= h.get("contact") %>" class="btn-med-primary text-decoration-none" style="padding:8px 18px; font-size:0.82rem; border-radius:8px;">
              <i class="fas fa-phone-flip"></i> Call Now
            </a>
          </div>
        </div>
        <% } } else { %>
        <!-- Secondary partner hospital placeholder -->
        <div class="col-md-6">
          <div class="hospital-card">
            <div class="hosp-badge">🏥</div>
            <h6 style="font-weight:700; margin-bottom:6px;">SSG Hospital Vadodara</h6>
            <div style="color:var(--text-muted); font-size:0.85rem; margin-bottom:8px;"><i class="fas fa-map-marker-alt me-1" style="color:var(--teal);"></i>Jail Road, Alkapuri, Vadodara - 390001</div>
            <div style="color:var(--text-secondary); font-size:0.85rem; margin-bottom:14px;"><i class="fas fa-phone me-1" style="color:var(--success);"></i>+91 265 242 4848</div>
            <a href="tel:+912652424848" class="btn-med-primary text-decoration-none" style="padding:8px 18px; font-size:0.82rem; border-radius:8px;">
              <i class="fas fa-phone-flip"></i> Call Now
            </a>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <!-- Doctor List -->
    <div class="fade-up" style="margin: 32px 0;">
      <div class="section-title-row">
        <h4><i class="fas fa-user-doctor me-2" style="color:var(--purple-light);"></i>Specialist Doctors (Parul Sevashram Hospital)</h4>
        <div class="section-divider"></div>
        <span style="font-size:0.72rem; background:rgba(16,185,129,0.12); border:1px solid rgba(16,185,129,0.3); padding:4px 10px; border-radius:999px; color:#6ee7b7; white-space:nowrap;">🟢 Active Today</span>
      </div>
      <div class="row g-3">
        <% if (deptDoctors != null && !deptDoctors.isEmpty()) {
             int di = 0;
             for (Map<String, String> doc : deptDoctors) {
               di++;
        %>
        <div class="col-md-6 col-12">
          <div class="doc-card" style="opacity: 1; border-color: rgba(255,255,255,0.08); background: rgba(255,255,255,0.05); transition: var(--transition); display: flex; align-items: center; gap: 14px; padding: 18px; border-radius: var(--radius-md);">
            <div class="doc-avatar" style="width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; flex-shrink: 0; background: linear-gradient(135deg, rgba(139,92,246,0.2), rgba(14,165,233,0.2)); border: 1.5px solid rgba(139,92,246,0.3); color: var(--purple-light);">
              👨‍⚕️
            </div>
            <div style="flex:1">
              <h6 style="font-weight:700; margin-bottom:2px; font-size:0.95rem; color:var(--text-primary);"><%= doc.get("name") %></h6>
              <div style="color:var(--text-secondary); font-size:0.8rem; font-weight:500;"><%= doc.get("spec") %></div>
              <div style="color:var(--text-muted); font-size:0.72rem;"><%= doc.get("deg") %></div>
            </div>
            <div style="text-align: right; display: flex; flex-direction: column; align-items: flex-end;">
              <span style="display:inline-block; font-size:0.62rem; color:#10b981; background:rgba(16,185,129,0.12); border:1px solid rgba(16,185,129,0.25); padding:2px 8px; border-radius:99px; margin-bottom:8px; font-weight:700; text-transform:uppercase; white-space: nowrap;">On Duty</span>
              <a href="tel:+912668260261" class="btn-med-outline text-decoration-none" style="padding:4px 12px; font-size:0.75rem; border-radius:6px;">
                Consult
              </a>
            </div>
          </div>
        </div>
        <% } } else { %>
        <!-- Fallback just in case -->
        <div class="col-12">
          <div class="doc-card">
            <div class="doc-avatar">👨‍⚕️</div>
            <div style="flex:1">
              <h6 style="font-weight:700; margin-bottom:2px;">Medical Duty Officer</h6>
              <div style="color:var(--text-secondary); font-size:0.8rem;">General Referral Desk</div>
            </div>
            <div>
              <a href="tel:+912668260261" class="btn-med-outline text-decoration-none" style="padding:6px 14px; font-size:0.78rem; border-radius:8px;">
                Contact
              </a>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <!-- CTA -->
    <div class="cta-row fade-up">
      <a href="symptoms.html" class="btn-med-primary text-decoration-none ripple-btn">
        <i class="fas fa-rotate-left"></i> New Symptom Check
      </a>
      <a href="history" class="btn-med-outline text-decoration-none">
        <i class="fas fa-clock-rotate-left"></i> View History
      </a>
      <a href="index.html" class="btn-med-outline text-decoration-none">
        <i class="fas fa-right-from-bracket"></i> Logout
      </a>
    </div>

  </div>
</div>

<script>
// ── Confidence ring animation ──
window.addEventListener('load', function() {
  setTimeout(function() {
    const confidence = 87;
    const fill = document.getElementById('ringFill');
    const numEl = document.getElementById('ringNum');
    const circumference = 2 * Math.PI * 70;
    const offset = circumference - (confidence / 100) * circumference;
    fill.style.strokeDashoffset = offset;
    let count = 0;
    const interval = setInterval(function() {
      count++;
      numEl.textContent = count + '%';
      if (count >= confidence) clearInterval(interval);
    }, 20);
  }, 400);
});

// ── Fade-up scroll ──
const obs = new IntersectionObserver(e => e.forEach(en => { if(en.isIntersecting) en.target.classList.add('visible'); }), { threshold:0.05 });
document.querySelectorAll('.fade-up').forEach(el => obs.observe(el));

// ── Particles (light) ──
const canvas = document.getElementById('particles-canvas');
if (canvas) {
  const ctx = canvas.getContext('2d');
  canvas.width = window.innerWidth; canvas.height = window.innerHeight;
  const particles = Array.from({length:20}, () => ({ x:Math.random()*canvas.width, y:Math.random()*canvas.height, r:Math.random()*2+1, speed:Math.random()*0.3+0.05, opacity:Math.random()*0.08+0.02 }));
  function draw() { ctx.clearRect(0,0,canvas.width,canvas.height); particles.forEach(p => { ctx.globalAlpha=p.opacity; ctx.fillStyle='#0ea5e9'; ctx.beginPath(); ctx.arc(p.x,p.y,p.r,0,Math.PI*2); ctx.fill(); p.y-=p.speed; if(p.y<-10){p.y=canvas.height+10;p.x=Math.random()*canvas.width;} }); ctx.globalAlpha=1; requestAnimationFrame(draw); }
  draw();
}

// ── Ripple ──
document.querySelectorAll('.ripple-btn').forEach(btn => {
  btn.addEventListener('click', function(e) {
    const r = document.createElement('span'); r.className='ripple';
    const rect = this.getBoundingClientRect(), size = Math.max(rect.width,rect.height);
    r.style.cssText=`width:${size}px;height:${size}px;left:${e.clientX-rect.left-size/2}px;top:${e.clientY-rect.top-size/2}px;`;
    this.appendChild(r); setTimeout(()=>r.remove(),600);
  });
});
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>