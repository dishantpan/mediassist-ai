<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediAssist AI — Admin Analytics</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5.3 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome 6.4 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <!-- Shared MediAssist CSS -->
    <link href="css/mediassist.css" rel="stylesheet">

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>

    <style>
        /* ══════════════════════════════════════════
           ADMIN DASHBOARD — PAGE-SPECIFIC STYLES
        ══════════════════════════════════════════ */

        /* ── Layout Shell ── */
        .admin-shell {
            display: flex;
            min-height: 100vh;
            position: relative;
            z-index: 10;
        }

        /* ── Sidebar ── */
        .admin-sidebar {
            width: 260px;
            min-height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            z-index: 1100;
            background: rgba(5, 13, 26, 0.92);
            backdrop-filter: blur(24px) saturate(180%);
            -webkit-backdrop-filter: blur(24px) saturate(180%);
            border-right: 1px solid rgba(255, 255, 255, 0.07);
            display: flex;
            flex-direction: column;
            padding: 0;
            transition: transform 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 4px 0 32px rgba(0, 0, 0, 0.5);
        }

        .admin-sidebar.collapsed {
            transform: translateX(-260px);
        }

        /* Brand area */
        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 24px 20px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            text-decoration: none;
        }

        .sidebar-brand-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            background: linear-gradient(135deg, #0ea5e9, #14b8a6);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            color: white;
            box-shadow: 0 4px 18px rgba(14, 165, 233, 0.45);
            animation: heartbeat 2.4s ease-in-out infinite;
            flex-shrink: 0;
        }

        .sidebar-brand-text {
            display: flex;
            flex-direction: column;
        }

        .sidebar-brand-name {
            font-size: 1.15rem;
            font-weight: 800;
            background: linear-gradient(135deg, #38bdf8, #14b8a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1.2;
            letter-spacing: -0.3px;
        }

        .sidebar-brand-sub {
            font-size: 0.65rem;
            color: rgba(240, 249, 255, 0.35);
            letter-spacing: 0.06em;
            font-weight: 400;
            text-transform: uppercase;
        }

        /* Nav section */
        .sidebar-nav {
            flex: 1;
            padding: 18px 12px;
            overflow-y: auto;
        }

        .sidebar-section-label {
            font-size: 0.63rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: rgba(240, 249, 255, 0.28);
            padding: 10px 10px 6px;
            margin-top: 8px;
        }

        .nav-item-admin {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 11px 14px;
            border-radius: 12px;
            color: rgba(240, 249, 255, 0.6);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            transition: all 0.25s ease;
            margin-bottom: 4px;
            position: relative;
            cursor: pointer;
        }

        .nav-item-admin:hover {
            background: rgba(255, 255, 255, 0.07);
            color: rgba(240, 249, 255, 0.9);
            transform: translateX(3px);
        }

        .nav-item-admin.active {
            background: linear-gradient(135deg, rgba(14, 165, 233, 0.2), rgba(20, 184, 166, 0.15));
            color: #38bdf8;
            border: 1px solid rgba(14, 165, 233, 0.3);
            box-shadow: 0 4px 16px rgba(14, 165, 233, 0.12);
        }

        .nav-item-admin.active .nav-icon {
            color: #0ea5e9;
        }

        .nav-icon {
            width: 20px;
            text-align: center;
            font-size: 0.95rem;
            flex-shrink: 0;
        }

        .nav-badge {
            margin-left: auto;
            background: rgba(14, 165, 233, 0.25);
            color: #38bdf8;
            border: 1px solid rgba(14, 165, 233, 0.3);
            border-radius: 20px;
            padding: 1px 8px;
            font-size: 0.7rem;
            font-weight: 600;
        }

        /* Active indicator bar */
        .nav-item-admin.active::before {
            content: '';
            position: absolute;
            left: 0;
            top: 25%;
            height: 50%;
            width: 3px;
            background: linear-gradient(180deg, #0ea5e9, #14b8a6);
            border-radius: 0 3px 3px 0;
        }

        /* Sidebar footer */
        .sidebar-footer {
            padding: 16px 12px 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.06);
        }

        /* Theme toggle */
        .theme-toggle-wrap {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 14px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.07);
            margin-bottom: 10px;
        }

        .theme-toggle-label {
            font-size: 0.83rem;
            color: rgba(240, 249, 255, 0.55);
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .toggle-switch {
            width: 42px;
            height: 24px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.12);
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
            flex-shrink: 0;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        .toggle-switch.light-mode {
            background: linear-gradient(135deg, #f59e0b, #fbbf24);
        }

        .toggle-switch::after {
            content: '';
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: white;
            position: absolute;
            top: 2px;
            left: 2px;
            transition: transform 0.3s ease;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.3);
        }

        .toggle-switch.light-mode::after {
            transform: translateX(18px);
        }

        .sidebar-user {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.07);
        }

        .sidebar-user-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            background: linear-gradient(135deg, #8b5cf6, #0ea5e9);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            color: white;
            flex-shrink: 0;
        }

        .sidebar-user-info {
            flex: 1;
            min-width: 0;
        }

        .sidebar-user-name {
            font-size: 0.82rem;
            font-weight: 600;
            color: rgba(240, 249, 255, 0.85);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .sidebar-user-role {
            font-size: 0.7rem;
            color: rgba(240, 249, 255, 0.38);
        }

        /* ── Main content area ── */
        .admin-main {
            flex: 1;
            margin-left: 260px;
            min-height: 100vh;
            transition: margin-left 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
        }

        .admin-main.expanded {
            margin-left: 0;
        }

        /* ── Top header bar ── */
        .admin-header {
            position: sticky;
            top: 0;
            z-index: 900;
            height: 66px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 28px;
            background: rgba(5, 13, 26, 0.85);
            backdrop-filter: blur(20px) saturate(150%);
            -webkit-backdrop-filter: blur(20px) saturate(150%);
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.3);
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .hamburger-btn {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.07);
            border: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(240, 249, 255, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 1rem;
        }

        .hamburger-btn:hover {
            background: rgba(14, 165, 233, 0.15);
            border-color: rgba(14, 165, 233, 0.3);
            color: #38bdf8;
        }

        /* Breadcrumb */
        .admin-breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.83rem;
        }

        .breadcrumb-item-link {
            color: rgba(240, 249, 255, 0.45);
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb-item-link:hover { color: #38bdf8; }

        .breadcrumb-separator {
            color: rgba(240, 249, 255, 0.25);
            font-size: 0.7rem;
        }

        .breadcrumb-current {
            color: #38bdf8;
            font-weight: 600;
        }

        /* Header right side */
        .header-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-icon-btn {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.09);
            color: rgba(240, 249, 255, 0.6);
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            font-size: 0.95rem;
            position: relative;
            text-decoration: none;
        }

        .header-icon-btn:hover {
            background: rgba(14, 165, 233, 0.12);
            border-color: rgba(14, 165, 233, 0.25);
            color: #38bdf8;
        }

        .notif-dot {
            position: absolute;
            top: 7px;
            right: 7px;
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #ef4444;
            border: 1.5px solid #050d1a;
            animation: pulseDot 2s infinite;
        }

        @keyframes pulseDot {
            0%, 100% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.4); opacity: 0.7; }
        }

        .admin-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: linear-gradient(135deg, #8b5cf6, #0ea5e9);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-weight: 700;
            color: white;
            cursor: pointer;
            border: 2px solid rgba(14, 165, 233, 0.4);
            box-shadow: 0 0 0 0 rgba(14, 165, 233, 0.4);
            transition: all 0.3s ease;
        }

        .admin-avatar:hover {
            box-shadow: 0 0 0 4px rgba(14, 165, 233, 0.2);
            transform: scale(1.06);
        }

        /* ── Page body ── */
        .admin-body {
            flex: 1;
            padding: 28px;
            display: flex;
            flex-direction: column;
            gap: 24px;
            overflow-x: hidden;
        }

        /* Page title area */
        .page-title-area {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
        }

        .page-title {
            font-size: 1.65rem;
            font-weight: 800;
            background: linear-gradient(135deg, #f0f9ff, #38bdf8, #14b8a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            line-height: 1.2;
            margin-bottom: 4px;
        }

        .page-subtitle {
            font-size: 0.85rem;
            color: rgba(240, 249, 255, 0.45);
            font-weight: 400;
        }

        .page-date {
            font-size: 0.8rem;
            color: rgba(240, 249, 255, 0.4);
            display: flex;
            align-items: center;
            gap: 6px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 8px;
            padding: 6px 12px;
        }

        /* ── KPI Stat Cards ── */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .kpi-card {
            background: rgba(255, 255, 255, 0.045);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 22px 22px 18px;
            position: relative;
            overflow: hidden;
            transition: all 0.35s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: default;
        }

        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: var(--kpi-gradient);
            opacity: 0.8;
        }

        .kpi-card::after {
            content: '';
            position: absolute;
            bottom: -40px; right: -40px;
            width: 120px; height: 120px;
            border-radius: 50%;
            background: var(--kpi-glow);
            filter: blur(30px);
            opacity: 0.25;
            transition: opacity 0.35s ease;
        }

        .kpi-card:hover {
            transform: translateY(-4px);
            border-color: rgba(255, 255, 255, 0.14);
            box-shadow: 0 16px 48px rgba(0, 0, 0, 0.4), var(--kpi-shadow);
        }

        .kpi-card:hover::after { opacity: 0.45; }

        /* KPI colour variants */
        .kpi-card.kpi-blue {
            --kpi-gradient: linear-gradient(90deg, #0ea5e9, #38bdf8);
            --kpi-glow: #0ea5e9;
            --kpi-shadow: 0 0 30px rgba(14, 165, 233, 0.18);
        }
        .kpi-card.kpi-teal {
            --kpi-gradient: linear-gradient(90deg, #14b8a6, #2dd4bf);
            --kpi-glow: #14b8a6;
            --kpi-shadow: 0 0 30px rgba(20, 184, 166, 0.18);
        }
        .kpi-card.kpi-purple {
            --kpi-gradient: linear-gradient(90deg, #8b5cf6, #a78bfa);
            --kpi-glow: #8b5cf6;
            --kpi-shadow: 0 0 30px rgba(139, 92, 246, 0.18);
        }
        .kpi-card.kpi-amber {
            --kpi-gradient: linear-gradient(90deg, #f59e0b, #fbbf24);
            --kpi-glow: #f59e0b;
            --kpi-shadow: 0 0 30px rgba(245, 158, 11, 0.18);
        }

        .kpi-top {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .kpi-icon-wrap {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--kpi-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: white;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
            flex-shrink: 0;
        }

        .kpi-trend {
            font-size: 0.72rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 4px;
            padding: 4px 8px;
            border-radius: 6px;
        }

        .kpi-trend.up {
            background: rgba(16, 185, 129, 0.12);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .kpi-trend.neutral {
            background: rgba(245, 158, 11, 0.12);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.2);
        }

        .kpi-value {
            font-size: 2.2rem;
            font-weight: 800;
            color: #f0f9ff;
            line-height: 1;
            margin-bottom: 5px;
            font-variant-numeric: tabular-nums;
            letter-spacing: -1px;
        }

        .kpi-label {
            font-size: 0.8rem;
            color: rgba(240, 249, 255, 0.5);
            font-weight: 500;
            letter-spacing: 0.01em;
        }

        .kpi-divider {
            height: 1px;
            background: rgba(255, 255, 255, 0.06);
            margin: 12px 0;
        }

        .kpi-footer {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 0.73rem;
            color: rgba(240, 249, 255, 0.38);
        }

        /* ── Charts Row ── */
        .charts-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .chart-panel {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 22px;
            transition: all 0.3s ease;
        }

        .chart-panel:hover {
            border-color: rgba(14, 165, 233, 0.2);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.35);
        }

        .panel-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .panel-title {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .panel-title-icon {
            width: 34px;
            height: 34px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            color: white;
        }

        .panel-title-text {
            font-size: 0.97rem;
            font-weight: 700;
            color: rgba(240, 249, 255, 0.9);
        }

        .panel-title-sub {
            font-size: 0.73rem;
            color: rgba(240, 249, 255, 0.38);
            font-weight: 400;
        }

        .panel-badge {
            font-size: 0.7rem;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
            border: 1px solid;
        }

        .panel-badge.live {
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border-color: rgba(16, 185, 129, 0.25);
        }

        .panel-badge.live::before {
            content: '';
            display: inline-block;
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #10b981;
            margin-right: 5px;
            animation: pulseDot 1.5s infinite;
        }

        .chart-canvas-wrap {
            position: relative;
            height: 280px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* ── Analytics Row ── */
        .analytics-row {
            display: grid;
            grid-template-columns: 1.3fr 0.7fr;
            gap: 20px;
        }

        /* Department Table */
        .dept-table-panel {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 22px;
        }

        .dept-table-wrap {
            width: 100%;
            border-collapse: collapse;
        }

        .dept-table-wrap thead th {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: rgba(240, 249, 255, 0.35);
            padding: 0 0 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
        }

        .dept-table-wrap tbody tr {
            transition: background 0.2s ease;
        }

        .dept-table-wrap tbody tr:hover {
            background: rgba(255, 255, 255, 0.04);
            border-radius: 10px;
        }

        .dept-table-wrap tbody td {
            padding: 12px 6px;
            font-size: 0.84rem;
            color: rgba(240, 249, 255, 0.75);
            border-bottom: 1px solid rgba(255, 255, 255, 0.04);
        }

        .dept-name-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .dept-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            flex-shrink: 0;
        }

        .dept-name-text {
            font-weight: 500;
            color: rgba(240, 249, 255, 0.85);
        }

        .dept-count-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 32px;
            height: 22px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(14, 165, 233, 0.12);
            color: #38bdf8;
            border: 1px solid rgba(14, 165, 233, 0.2);
            padding: 0 6px;
        }

        .dept-progress-bar {
            height: 5px;
            border-radius: 3px;
            background: rgba(255, 255, 255, 0.07);
            overflow: hidden;
            min-width: 80px;
        }

        .dept-progress-fill {
            height: 100%;
            border-radius: 3px;
            transition: width 1.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Activity Feed */
        .activity-panel {
            background: rgba(255, 255, 255, 0.04);
            backdrop-filter: blur(20px) saturate(180%);
            -webkit-backdrop-filter: blur(20px) saturate(180%);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            padding: 22px;
            display: flex;
            flex-direction: column;
        }

        .activity-list {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 12px;
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            transition: background 0.2s ease;
            border-radius: 8px;
        }

        .activity-item:last-child { border-bottom: none; }

        .activity-item:hover {
            background: rgba(255, 255, 255, 0.03);
            padding-left: 6px;
            padding-right: 6px;
        }

        .activity-icon {
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            flex-shrink: 0;
        }

        .activity-body { flex: 1; min-width: 0; }

        .activity-text {
            font-size: 0.82rem;
            color: rgba(240, 249, 255, 0.78);
            font-weight: 500;
            line-height: 1.35;
            margin-bottom: 3px;
        }

        .activity-time {
            font-size: 0.7rem;
            color: rgba(240, 249, 255, 0.32);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .activity-dot {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            flex-shrink: 0;
            margin-top: 6px;
        }

        /* ── Light mode overrides ── */
        [data-theme="light"] {
            --text-primary: #0f172a;
            --text-secondary: rgba(15, 23, 42, 0.65);
            --text-muted: rgba(15, 23, 42, 0.45);
        }

        [data-theme="light"] body {
            background: #f1f5f9;
        }

        [data-theme="light"] .admin-sidebar {
            background: rgba(255, 255, 255, 0.96);
            border-right-color: rgba(0, 0, 0, 0.08);
        }

        [data-theme="light"] .admin-header {
            background: rgba(241, 245, 249, 0.92);
            border-bottom-color: rgba(0, 0, 0, 0.07);
        }

        [data-theme="light"] .kpi-card,
        [data-theme="light"] .chart-panel,
        [data-theme="light"] .dept-table-panel,
        [data-theme="light"] .activity-panel {
            background: rgba(255, 255, 255, 0.85);
            border-color: rgba(0, 0, 0, 0.07);
        }

        [data-theme="light"] .kpi-value { color: #0f172a; }
        [data-theme="light"] .page-title { filter: brightness(0.7); }

        /* ── Sidebar overlay (mobile) ── */
        .sidebar-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 1050;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
        }

        .sidebar-overlay.active { display: block; }

        /* ── Responsive ── */
        @media (max-width: 1200px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 992px) {
            .charts-row { grid-template-columns: 1fr; }
            .analytics-row { grid-template-columns: 1fr; }
        }

        @media (max-width: 768px) {
            .admin-sidebar { transform: translateX(-260px); }
            .admin-sidebar.mobile-open { transform: translateX(0); }
            .admin-main { margin-left: 0 !important; }
            .admin-body { padding: 18px 14px; }
            .admin-header { padding: 0 16px; }
            .kpi-grid { grid-template-columns: repeat(2, 1fr); gap: 12px; }
            .kpi-value { font-size: 1.7rem; }
            .page-date { display: none; }
        }

        @media (max-width: 480px) {
            .kpi-grid { grid-template-columns: 1fr; }
        }

        /* ── Entrance animation ── */
        .fade-up-enter {
            opacity: 0;
            transform: translateY(24px);
        }
        .fade-up-enter.entered {
            opacity: 1;
            transform: translateY(0);
            transition: opacity 0.55s ease, transform 0.55s ease;
        }

        /* Stagger delays */
        .delay-100 { transition-delay: 0.1s !important; }
        .delay-200 { transition-delay: 0.2s !important; }
        .delay-300 { transition-delay: 0.3s !important; }
        .delay-400 { transition-delay: 0.4s !important; }
        .delay-500 { transition-delay: 0.5s !important; }
        .delay-600 { transition-delay: 0.6s !important; }
        .delay-700 { transition-delay: 0.7s !important; }
    </style>
</head>
<body>

<!-- ── Animated Background Layer ── -->
<div class="med-bg"></div>
<div class="orb orb-1"></div>
<div class="orb orb-2"></div>
<div class="orb orb-3"></div>

<!-- ── JSP Backend Data Processing ── -->
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

<!-- ── Mobile Sidebar Overlay ── -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- ── Admin Shell ── -->
<div class="admin-shell">

    <!-- ════════════════════════════════
         SIDEBAR NAVIGATION
    ════════════════════════════════ -->
    <aside class="admin-sidebar" id="adminSidebar">

        <!-- Brand -->
        <a href="#" class="sidebar-brand">
            <div class="sidebar-brand-icon">
                <i class="fas fa-heartbeat"></i>
            </div>
            <div class="sidebar-brand-text">
                <span class="sidebar-brand-name">MediAssist AI</span>
                <span class="sidebar-brand-sub">Admin Console</span>
            </div>
        </a>

        <!-- Navigation -->
        <nav class="sidebar-nav">
            <div class="sidebar-section-label">Main Menu</div>

            <a href="#" class="nav-item-admin active">
                <span class="nav-icon"><i class="fas fa-chart-pie"></i></span>
                Dashboard
                <span class="nav-badge">Live</span>
            </a>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-chart-line"></i></span>
                Analytics
            </a>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-hospital-alt"></i></span>
                Departments
            </a>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-user-md"></i></span>
                Physicians
            </a>

            <div class="sidebar-section-label">System</div>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-file-medical-alt"></i></span>
                Reports
            </a>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-cog"></i></span>
                Settings
            </a>

            <a href="#" class="nav-item-admin">
                <span class="nav-icon"><i class="fas fa-shield-alt"></i></span>
                Security
            </a>
        </nav>

        <!-- Footer -->
        <div class="sidebar-footer">
            <!-- Theme toggle -->
            <div class="theme-toggle-wrap">
                <span class="theme-toggle-label">
                    <i class="fas fa-moon" id="themeIcon" style="color: rgba(240,249,255,0.5)"></i>
                    <span id="themeLabel">Dark Mode</span>
                </span>
                <div class="toggle-switch" id="themeToggle" onclick="toggleTheme()"></div>
            </div>

            <!-- Sidebar user -->
            <div class="sidebar-user">
                <div class="sidebar-user-avatar">SA</div>
                <div class="sidebar-user-info">
                    <div class="sidebar-user-name">Super Admin</div>
                    <div class="sidebar-user-role">System Administrator</div>
                </div>
                <a href="#" style="color: rgba(240,249,255,0.35); font-size: 0.8rem; text-decoration: none; transition: color 0.2s;"
                   onmouseover="this.style.color='#ef4444'" onmouseout="this.style.color='rgba(240,249,255,0.35)'"
                   title="Logout">
                    <i class="fas fa-sign-out-alt"></i>
                </a>
            </div>
        </div>
    </aside>

    <!-- ════════════════════════════════
         MAIN CONTENT
    ════════════════════════════════ -->
    <main class="admin-main" id="adminMain">

        <!-- TOP HEADER BAR -->
        <header class="admin-header">
            <div class="header-left">
                <!-- Hamburger -->
                <button class="hamburger-btn" id="hamburgerBtn" onclick="toggleSidebar()" title="Toggle Sidebar">
                    <i class="fas fa-bars"></i>
                </button>

                <!-- Breadcrumb -->
                <nav class="admin-breadcrumb">
                    <a href="#" class="breadcrumb-item-link"><i class="fas fa-home" style="font-size:0.75rem;"></i></a>
                    <i class="fas fa-chevron-right breadcrumb-separator"></i>
                    <a href="#" class="breadcrumb-item-link">Admin</a>
                    <i class="fas fa-chevron-right breadcrumb-separator"></i>
                    <span class="breadcrumb-current">Dashboard</span>
                </nav>
            </div>

            <div class="header-right">
                <!-- Refresh -->
                <button class="header-icon-btn" title="Refresh Data" onclick="refreshData()">
                    <i class="fas fa-sync-alt" id="refreshIcon"></i>
                </button>

                <!-- Notifications -->
                <button class="header-icon-btn" title="Notifications">
                    <i class="fas fa-bell"></i>
                    <span class="notif-dot"></span>
                </button>

                <!-- Export -->
                <button class="header-icon-btn" title="Export Report">
                    <i class="fas fa-download"></i>
                </button>

                <!-- Separator -->
                <div style="width:1px; height:24px; background: rgba(255,255,255,0.08);"></div>

                <!-- Admin avatar -->
                <div class="admin-avatar" title="Super Admin">SA</div>
            </div>
        </header>

        <!-- SCROLLABLE BODY -->
        <div class="admin-body">

            <!-- Page title -->
            <div class="page-title-area fade-up-enter" id="pageTitleArea">
                <div>
                    <div class="page-title">Analytics Dashboard</div>
                    <div class="page-subtitle">Real-time insights across all departments &amp; consultations</div>
                </div>
                <div class="page-date">
                    <i class="fas fa-calendar-day" style="color: #0ea5e9; font-size: 0.75rem;"></i>
                    <span id="currentDate">Loading...</span>
                </div>
            </div>

            <!-- ════ KPI CARDS ════ -->
            <div class="kpi-grid">

                <!-- Total Consultations -->
                <div class="kpi-card kpi-blue fade-up-enter delay-100" id="kpiCard1">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap">
                            <i class="fas fa-notes-medical"></i>
                        </div>
                        <span class="kpi-trend up">
                            <i class="fas fa-arrow-up" style="font-size:0.62rem;"></i> 12.4%
                        </span>
                    </div>
                    <div class="kpi-value" data-target="<%= total %>" data-count="0">0</div>
                    <div class="kpi-label">Total Consultations</div>
                    <div class="kpi-divider"></div>
                    <div class="kpi-footer">
                        <i class="fas fa-clock" style="font-size:0.7rem; color:#0ea5e9;"></i>
                        Updated in real-time
                    </div>
                </div>

                <!-- Active Departments -->
                <div class="kpi-card kpi-teal fade-up-enter delay-200" id="kpiCard2">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap" style="background: linear-gradient(135deg,#14b8a6,#2dd4bf);">
                            <i class="fas fa-layer-group"></i>
                        </div>
                        <span class="kpi-trend up">
                            <i class="fas fa-arrow-up" style="font-size:0.62rem;"></i> 2 new
                        </span>
                    </div>
                    <div class="kpi-value" data-target="<%= deptCount != null ? deptCount.size() : 0 %>" data-count="0">0</div>
                    <div class="kpi-label">Active Departments</div>
                    <div class="kpi-divider"></div>
                    <div class="kpi-footer">
                        <i class="fas fa-check-circle" style="font-size:0.7rem; color:#14b8a6;"></i>
                        All departments online
                    </div>
                </div>

                <!-- Hospitals -->
                <div class="kpi-card kpi-purple fade-up-enter delay-300" id="kpiCard3">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap" style="background: linear-gradient(135deg,#8b5cf6,#a78bfa);">
                            <i class="fas fa-hospital"></i>
                        </div>
                        <span class="kpi-trend neutral">
                            <i class="fas fa-minus" style="font-size:0.62rem;"></i> Stable
                        </span>
                    </div>
                    <div class="kpi-value" data-target="8" data-count="0">0</div>
                    <div class="kpi-label">Partner Hospitals</div>
                    <div class="kpi-divider"></div>
                    <div class="kpi-footer">
                        <i class="fas fa-map-marker-alt" style="font-size:0.7rem; color:#8b5cf6;"></i>
                        Across 4 cities
                    </div>
                </div>

                <!-- Today's OPD -->
                <div class="kpi-card kpi-amber fade-up-enter delay-400" id="kpiCard4">
                    <div class="kpi-top">
                        <div class="kpi-icon-wrap" style="background: linear-gradient(135deg,#f59e0b,#fbbf24);">
                            <i class="fas fa-user-injured"></i>
                        </div>
                        <span class="kpi-trend up">
                            <i class="fas fa-arrow-up" style="font-size:0.62rem;"></i> 8.1%
                        </span>
                    </div>
                    <div class="kpi-value" data-target="24" data-count="0">0</div>
                    <div class="kpi-label">Today's OPD Visits</div>
                    <div class="kpi-divider"></div>
                    <div class="kpi-footer">
                        <i class="fas fa-sun" style="font-size:0.7rem; color:#f59e0b;"></i>
                        Today's count so far
                    </div>
                </div>

            </div>
            <!-- end kpi-grid -->

            <!-- ════ CHARTS ROW ════ -->
            <div class="charts-row">

                <!-- LEFT: Pie Chart — Department Distribution -->
                <div class="chart-panel fade-up-enter delay-400">
                    <div class="panel-header">
                        <div class="panel-title">
                            <div class="panel-title-icon" style="background: linear-gradient(135deg,#0ea5e9,#14b8a6);">
                                <i class="fas fa-chart-pie" style="font-size:0.85rem; color:white;"></i>
                            </div>
                            <div>
                                <div class="panel-title-text">Department Distribution</div>
                                <div class="panel-title-sub">Consultation share by specialty</div>
                            </div>
                        </div>
                        <span class="panel-badge live">Live</span>
                    </div>
                    <div class="chart-canvas-wrap">
                        <canvas id="deptChart"></canvas>
                    </div>
                </div>

                <!-- RIGHT: Bar Chart — Weekly Trends -->
                <div class="chart-panel fade-up-enter delay-500">
                    <div class="panel-header">
                        <div class="panel-title">
                            <div class="panel-title-icon" style="background: linear-gradient(135deg,#8b5cf6,#a78bfa);">
                                <i class="fas fa-chart-bar" style="font-size:0.85rem; color:white;"></i>
                            </div>
                            <div>
                                <div class="panel-title-text">Weekly Trends</div>
                                <div class="panel-title-sub">Consultations over the past 7 days</div>
                            </div>
                        </div>
                        <span class="panel-badge" style="background:rgba(139,92,246,0.12);color:#a78bfa;border-color:rgba(139,92,246,0.25);">This Week</span>
                    </div>
                    <div class="chart-canvas-wrap">
                        <canvas id="barChart"></canvas>
                    </div>
                </div>

            </div>
            <!-- end charts-row -->

            <!-- ════ ANALYTICS ROW ════ -->
            <div class="analytics-row">

                <!-- LEFT: Department Breakdown Table -->
                <div class="dept-table-panel fade-up-enter delay-500">
                    <div class="panel-header">
                        <div class="panel-title">
                            <div class="panel-title-icon" style="background: linear-gradient(135deg,#14b8a6,#06b6d4);">
                                <i class="fas fa-list-alt" style="font-size:0.85rem; color:white;"></i>
                            </div>
                            <div>
                                <div class="panel-title-text">Department Breakdown</div>
                                <div class="panel-title-sub">Consultation volume &amp; activity share</div>
                            </div>
                        </div>
                        <span class="panel-badge" style="background:rgba(20,184,166,0.1);color:#14b8a6;border-color:rgba(20,184,166,0.25);">
                            <i class="fas fa-table" style="font-size:0.65rem;margin-right:4px;"></i>Detail View
                        </span>
                    </div>

                    <table class="dept-table-wrap">
                        <thead>
                            <tr>
                                <th style="padding-left:4px;">Department</th>
                                <th style="text-align:center;">Consultations</th>
                                <th>Share</th>
                                <th style="text-align:right; padding-right:4px;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                /* Dept color palette for table rows */
                                String[] deptColors = {
                                    "#0ea5e9", "#14b8a6", "#8b5cf6", "#f59e0b",
                                    "#ef4444", "#10b981", "#06b6d4", "#a78bfa",
                                    "#f97316", "#ec4899"
                                };
                                int colorIdx = 0;
                                int maxCount = 1;
                                if (deptCount != null) {
                                    for (Map.Entry<String, Integer> e : deptCount.entrySet()) {
                                        if (e.getValue() > maxCount) maxCount = e.getValue();
                                    }
                                }
                                if (deptCount != null) {
                                    for (Map.Entry<String, Integer> e : deptCount.entrySet()) {
                                        String color = deptColors[colorIdx % deptColors.length];
                                        double pct = (double) e.getValue() / maxCount * 100.0;
                                        int sharePct = (total > 0) ? (int) Math.round((double) e.getValue() / total * 100.0) : 0;
                                        colorIdx++;
                            %>
                            <tr>
                                <td>
                                    <div class="dept-name-cell">
                                        <div class="dept-dot" style="background: <%= color %>;"></div>
                                        <span class="dept-name-text"><%= e.getKey() %></span>
                                    </div>
                                </td>
                                <td style="text-align:center;">
                                    <span class="dept-count-badge"><%= e.getValue() %></span>
                                </td>
                                <td style="min-width: 120px;">
                                    <div style="display:flex; align-items:center; gap:8px;">
                                        <div class="dept-progress-bar" style="flex:1;">
                                            <div class="dept-progress-fill"
                                                 style="width:0%; background: linear-gradient(90deg, <%= color %>99, <%= color %>);"
                                                 data-width="<%= (int) pct %>%">
                                            </div>
                                        </div>
                                        <span style="font-size:0.72rem; color:rgba(240,249,255,0.45); min-width:28px; text-align:right;"><%= sharePct %>%</span>
                                    </div>
                                </td>
                                <td style="text-align:right; padding-right:4px;">
                                    <span style="display:inline-flex; align-items:center; gap:4px; font-size:0.7rem; font-weight:600;
                                                 color:#10b981; background:rgba(16,185,129,0.1); border:1px solid rgba(16,185,129,0.2);
                                                 border-radius:6px; padding:2px 7px;">
                                        <i class="fas fa-circle" style="font-size:0.45rem;"></i> Active
                                    </span>
                                </td>
                            </tr>
                            <% }} %>

                            <!-- Fallback if no data -->
                            <% if (deptCount == null || deptCount.isEmpty()) { %>
                            <tr>
                                <td colspan="4" style="text-align:center; padding:30px 0; color:rgba(240,249,255,0.3);">
                                    <i class="fas fa-database" style="font-size:1.5rem; margin-bottom:8px; display:block;"></i>
                                    No department data available yet
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <!-- RIGHT: Real-time Activity Feed -->
                <div class="activity-panel fade-up-enter delay-600">
                    <div class="panel-header" style="margin-bottom:14px;">
                        <div class="panel-title">
                            <div class="panel-title-icon" style="background: linear-gradient(135deg,#ef4444,#f97316);">
                                <i class="fas fa-bolt" style="font-size:0.85rem; color:white;"></i>
                            </div>
                            <div>
                                <div class="panel-title-text">Activity Feed</div>
                                <div class="panel-title-sub">Recent system events</div>
                            </div>
                        </div>
                        <span class="panel-badge live">Live</span>
                    </div>

                    <div class="activity-list">

                        <!-- Activity Item 1 -->
                        <div class="activity-item">
                            <div class="activity-icon" style="background:rgba(14,165,233,0.15); color:#38bdf8;">
                                <i class="fas fa-user-plus"></i>
                            </div>
                            <div class="activity-body">
                                <div class="activity-text">New patient registered — <strong style="color:rgba(240,249,255,0.9);">Rahul Sharma</strong></div>
                                <div class="activity-time">
                                    <i class="fas fa-clock" style="font-size:0.62rem;"></i> 2 min ago &nbsp;·&nbsp; OPD Registration
                                </div>
                            </div>
                            <div class="activity-dot" style="background:#0ea5e9;"></div>
                        </div>

                        <!-- Activity Item 2 -->
                        <div class="activity-item">
                            <div class="activity-icon" style="background:rgba(16,185,129,0.15); color:#10b981;">
                                <i class="fas fa-stethoscope"></i>
                            </div>
                            <div class="activity-body">
                                <div class="activity-text">Consultation completed — <strong style="color:rgba(240,249,255,0.9);">Cardiology</strong></div>
                                <div class="activity-time">
                                    <i class="fas fa-clock" style="font-size:0.62rem;"></i> 8 min ago &nbsp;·&nbsp; Dr. Patel
                                </div>
                            </div>
                            <div class="activity-dot" style="background:#10b981;"></div>
                        </div>

                        <!-- Activity Item 3 -->
                        <div class="activity-item">
                            <div class="activity-icon" style="background:rgba(239,68,68,0.15); color:#ef4444;">
                                <i class="fas fa-ambulance"></i>
                            </div>
                            <div class="activity-body">
                                <div class="activity-text">Emergency case flagged — <strong style="color:rgba(240,249,255,0.9);">Unit 4B</strong></div>
                                <div class="activity-time">
                                    <i class="fas fa-clock" style="font-size:0.62rem;"></i> 15 min ago &nbsp;·&nbsp; High Priority
                                </div>
                            </div>
                            <div class="activity-dot" style="background:#ef4444; animation:pulseDot 1.5s infinite;"></div>
                        </div>

                        <!-- Activity Item 4 -->
                        <div class="activity-item">
                            <div class="activity-icon" style="background:rgba(245,158,11,0.15); color:#f59e0b;">
                                <i class="fas fa-file-medical"></i>
                            </div>
                            <div class="activity-body">
                                <div class="activity-text">Lab report uploaded — <strong style="color:rgba(240,249,255,0.9);">MRI Scan #2841</strong></div>
                                <div class="activity-time">
                                    <i class="fas fa-clock" style="font-size:0.62rem;"></i> 22 min ago &nbsp;·&nbsp; Radiology
                                </div>
                            </div>
                            <div class="activity-dot" style="background:#f59e0b;"></div>
                        </div>

                        <!-- Activity Item 5 -->
                        <div class="activity-item">
                            <div class="activity-icon" style="background:rgba(139,92,246,0.15); color:#a78bfa;">
                                <i class="fas fa-pills"></i>
                            </div>
                            <div class="activity-body">
                                <div class="activity-text">Prescription issued — <strong style="color:rgba(240,249,255,0.9);">Neurology Dept</strong></div>
                                <div class="activity-time">
                                    <i class="fas fa-clock" style="font-size:0.62rem;"></i> 35 min ago &nbsp;·&nbsp; Dr. Iyer
                                </div>
                            </div>
                            <div class="activity-dot" style="background:#8b5cf6;"></div>
                        </div>

                    </div>

                    <!-- View all link -->
                    <div style="margin-top:14px; padding-top:12px; border-top:1px solid rgba(255,255,255,0.06); text-align:center;">
                        <a href="#" style="font-size:0.78rem; color:#38bdf8; text-decoration:none; font-weight:600;
                                           display:inline-flex; align-items:center; gap:6px; transition: opacity 0.2s;"
                           onmouseover="this.style.opacity='0.75'" onmouseout="this.style.opacity='1'">
                            View all activity <i class="fas fa-arrow-right" style="font-size:0.7rem;"></i>
                        </a>
                    </div>
                </div>

            </div>
            <!-- end analytics-row -->

            <!-- Bottom spacer -->
            <div style="height: 12px;"></div>

        </div>
        <!-- end admin-body -->
    </main>
    <!-- end admin-main -->

</div>
<!-- end admin-shell -->

<!-- ── Bootstrap JS ── -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
/* ════════════════════════════════════════════════════════════
   MEDIASSIST ADMIN — DASHBOARD JAVASCRIPT
   Sidebar · Theme · Charts · Count-up · Animations
════════════════════════════════════════════════════════════ */

/* ── 1. Date Display ── */
(function () {
    const d = new Date();
    const opts = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' };
    document.getElementById('currentDate').textContent = d.toLocaleDateString('en-IN', opts);
})();


/* ── 2. Sidebar Toggle ── */
const sidebar    = document.getElementById('adminSidebar');
const mainArea   = document.getElementById('adminMain');
const overlay    = document.getElementById('sidebarOverlay');
let sidebarOpen  = true;

function toggleSidebar() {
    const isMobile = window.innerWidth <= 768;
    if (isMobile) {
        // Mobile: slide in/out with overlay
        sidebar.classList.toggle('mobile-open');
        overlay.classList.toggle('active');
    } else {
        // Desktop: collapse / expand
        sidebarOpen = !sidebarOpen;
        sidebar.classList.toggle('collapsed', !sidebarOpen);
        mainArea.classList.toggle('expanded', !sidebarOpen);
    }
}

overlay.addEventListener('click', function () {
    sidebar.classList.remove('mobile-open');
    overlay.classList.remove('active');
});

window.addEventListener('resize', function () {
    if (window.innerWidth > 768) {
        sidebar.classList.remove('mobile-open');
        overlay.classList.remove('active');
        if (sidebarOpen) {
            sidebar.classList.remove('collapsed');
            mainArea.classList.remove('expanded');
        }
    }
});


/* ── 3. Dark / Light Mode Toggle ── */
const themeToggle = document.getElementById('themeToggle');
const themeIcon   = document.getElementById('themeIcon');
const themeLabel  = document.getElementById('themeLabel');
let isDark = true;

function toggleTheme() {
    isDark = !isDark;
    document.documentElement.setAttribute('data-theme', isDark ? 'dark' : 'light');
    themeToggle.classList.toggle('light-mode', !isDark);
    themeIcon.className = isDark ? 'fas fa-moon' : 'fas fa-sun';
    themeLabel.textContent = isDark ? 'Dark Mode' : 'Light Mode';
    themeIcon.style.color = isDark ? 'rgba(240,249,255,0.5)' : '#f59e0b';

    // Update chart text colour
    const textColor = isDark ? 'rgba(240,249,255,0.65)' : 'rgba(15,23,42,0.65)';
    [deptChartInstance, barChartInstance].forEach(function (chart) {
        if (!chart) return;
        chart.options.plugins.legend.labels.color = textColor;
        if (chart.options.scales) {
            ['x', 'y'].forEach(function (ax) {
                if (chart.options.scales[ax]) {
                    chart.options.scales[ax].ticks.color = textColor;
                    chart.options.scales[ax].grid.color = isDark
                        ? 'rgba(255,255,255,0.06)'
                        : 'rgba(0,0,0,0.06)';
                }
            });
        }
        chart.update();
    });
}


/* ── 4. Refresh Button ── */
function refreshData() {
    const icon = document.getElementById('refreshIcon');
    icon.style.transition = 'transform 0.8s ease';
    icon.style.transform  = 'rotate(360deg)';
    setTimeout(function () {
        icon.style.transition = 'none';
        icon.style.transform  = 'rotate(0deg)';
    }, 900);
    // In production: fetch('/admin/refresh') then update KPI values
}


/* ── 5. Count-Up Animation ── */
function countUp(el) {
    const target = parseInt(el.getAttribute('data-target')) || 0;
    if (target === 0) { el.textContent = '0'; return; }
    const duration = 1800;
    const start    = performance.now();
    function step(now) {
        const elapsed = now - start;
        const progress = Math.min(elapsed / duration, 1);
        // Ease-out cubic
        const ease = 1 - Math.pow(1 - progress, 3);
        const current = Math.floor(ease * target);
        el.textContent = current.toLocaleString('en-IN');
        if (progress < 1) requestAnimationFrame(step);
        else el.textContent = target.toLocaleString('en-IN');
    }
    requestAnimationFrame(step);
}


/* ── 6. Intersection Observer for Fade-up + Count-up ── */
const fadeEls = document.querySelectorAll('.fade-up-enter');
const observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
        if (entry.isIntersecting) {
            entry.target.classList.add('entered');
            // Trigger count-up for KPI values inside this element
            entry.target.querySelectorAll('[data-target]').forEach(countUp);
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.12 });

fadeEls.forEach(function (el) { observer.observe(el); });


/* ── 7. Progress Bar Animation ── */
const progressBars = document.querySelectorAll('.dept-progress-fill');
const barObserver  = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
        if (entry.isIntersecting) {
            const targetWidth = entry.target.getAttribute('data-width') || '0%';
            setTimeout(function () {
                entry.target.style.width = targetWidth;
            }, 300);
            barObserver.unobserve(entry.target);
        }
    });
}, { threshold: 0.2 });

progressBars.forEach(function (bar) { barObserver.observe(bar); });


/* ── 8. Chart.js — Medical Colour Palette ── */
const medPalette = [
    '#0ea5e9', '#14b8a6', '#8b5cf6', '#f59e0b',
    '#ef4444', '#10b981', '#06b6d4', '#a78bfa',
    '#f97316', '#ec4899', '#84cc16', '#e879f9'
];

const medPaletteAlpha = medPalette.map(function (c) { return c + 'cc'; });

const chartDefaults = {
    responsive: true,
    maintainAspectRatio: false,
    animation: { duration: 1000, easing: 'easeOutQuart' },
    plugins: {
        legend: {
            labels: {
                color: 'rgba(240,249,255,0.65)',
                font: { family: 'Inter', size: 12, weight: '500' },
                usePointStyle: true,
                pointStyleWidth: 10,
                padding: 16
            }
        },
        tooltip: {
            backgroundColor: 'rgba(10, 22, 40, 0.92)',
            titleColor: '#f0f9ff',
            bodyColor: 'rgba(240,249,255,0.75)',
            borderColor: 'rgba(14,165,233,0.3)',
            borderWidth: 1,
            padding: 12,
            cornerRadius: 10,
            titleFont: { family: 'Inter', weight: '700', size: 13 },
            bodyFont:  { family: 'Inter', size: 12 }
        }
    }
};


/* ── 9. Pie Chart — Department Distribution (backend data) ── */
var deptChartInstance = null;

(function () {
    const ctx = document.getElementById('deptChart').getContext('2d');

    // Backend-injected labels and data from JSP
    const deptLabels = <%= labels %>;
    const deptData   = <%= data %>;

    if (!deptLabels.length) {
        ctx.font = '14px Inter';
        ctx.fillStyle = 'rgba(240,249,255,0.35)';
        ctx.textAlign = 'center';
        ctx.fillText('No data available', ctx.canvas.width / 2, ctx.canvas.height / 2);
        return;
    }

    deptChartInstance = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: deptLabels,
            datasets: [{
                data: deptData,
                backgroundColor: medPaletteAlpha.slice(0, deptLabels.length),
                borderColor: medPalette.slice(0, deptLabels.length),
                borderWidth: 2,
                hoverOffset: 10,
                hoverBorderWidth: 3
            }]
        },
        options: Object.assign({}, chartDefaults, {
            cutout: '62%',
            plugins: Object.assign({}, chartDefaults.plugins, {
                legend: Object.assign({}, chartDefaults.plugins.legend, {
                    position: 'bottom',
                    labels: Object.assign({}, chartDefaults.plugins.legend.labels, {
                        padding: 14,
                        boxWidth: 10,
                        boxHeight: 10
                    })
                }),
                tooltip: Object.assign({}, chartDefaults.plugins.tooltip, {
                    callbacks: {
                        label: function (ctx) {
                            const total = ctx.dataset.data.reduce(function (a, b) { return a + b; }, 0);
                            const pct   = total ? ((ctx.parsed / total) * 100).toFixed(1) : 0;
                            return '  ' + ctx.label + ': ' + ctx.parsed + ' (' + pct + '%)';
                        }
                    }
                })
            })
        })
    });
})();


/* ── 10. Bar Chart — Weekly Trends (static demo) ── */
var barChartInstance = null;

(function () {
    const ctx = document.getElementById('barChart').getContext('2d');

    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const consultData    = [38, 52, 47, 61, 55, 29, 18];
    const emergencyData  = [5, 8, 6, 11, 7, 4, 3];

    // Gradient fills
    const gradBlue = ctx.createLinearGradient(0, 0, 0, 260);
    gradBlue.addColorStop(0, 'rgba(14,165,233,0.85)');
    gradBlue.addColorStop(1, 'rgba(14,165,233,0.25)');

    const gradRed = ctx.createLinearGradient(0, 0, 0, 260);
    gradRed.addColorStop(0, 'rgba(239,68,68,0.75)');
    gradRed.addColorStop(1, 'rgba(239,68,68,0.2)');

    barChartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: days,
            datasets: [
                {
                    label: 'Consultations',
                    data: consultData,
                    backgroundColor: gradBlue,
                    borderColor: '#0ea5e9',
                    borderWidth: 1.5,
                    borderRadius: 7,
                    borderSkipped: false,
                    barPercentage: 0.55,
                    categoryPercentage: 0.7
                },
                {
                    label: 'Emergencies',
                    data: emergencyData,
                    backgroundColor: gradRed,
                    borderColor: '#ef4444',
                    borderWidth: 1.5,
                    borderRadius: 7,
                    borderSkipped: false,
                    barPercentage: 0.55,
                    categoryPercentage: 0.7
                }
            ]
        },
        options: Object.assign({}, chartDefaults, {
            scales: {
                x: {
                    ticks: {
                        color: 'rgba(240,249,255,0.55)',
                        font: { family: 'Inter', size: 11 }
                    },
                    grid: { color: 'rgba(255,255,255,0.04)' },
                    border: { color: 'transparent' }
                },
                y: {
                    ticks: {
                        color: 'rgba(240,249,255,0.55)',
                        font: { family: 'Inter', size: 11 },
                        maxTicksLimit: 6
                    },
                    grid: { color: 'rgba(255,255,255,0.06)' },
                    border: { color: 'transparent', dash: [4, 4] },
                    beginAtZero: true
                }
            },
            plugins: Object.assign({}, chartDefaults.plugins, {
                legend: Object.assign({}, chartDefaults.plugins.legend, {
                    position: 'bottom'
                })
            })
        })
    });
})();


/* ── 11. Nav item ripple / click handling ── */
document.querySelectorAll('.nav-item-admin').forEach(function (item) {
    item.addEventListener('click', function (e) {
        document.querySelectorAll('.nav-item-admin').forEach(function (i) {
            i.classList.remove('active');
        });
        item.classList.add('active');
    });
});

</script>
</body>
</html>