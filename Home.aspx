<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Home.aspx.cs" Inherits="Skill_Link.Home" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SkillLink – Find Expert Freelancers</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --accent-glow: rgba(72,229,194,0.18);
            --danger:      #e5484d;
            --warn:        #f59e0b;
            --bg:          #f0f4f8;
            --card:        #ffffff;
            --border:      #e2e8f0;
            --text:        #1a202c;
            --muted:       #64748b;
            --dark:        #1a202c;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ═══════════════════════════════════════
           HEADER
        ═══════════════════════════════════════ */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--dark);
            padding: 0 32px;
            height: 62px;
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 200;
            box-shadow: 0 2px 20px rgba(0,0,0,0.25);
        }
        .logo-text {
            font-family: 'Syne', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: var(--accent);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .header-right { display: flex; align-items: center; gap: 6px; }
        .header-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            text-decoration: none;
            color: #94a3b8;
            background: transparent;
            border: none;
            cursor: pointer;
            transition: color 0.15s, background 0.15s;
        }
        .header-btn:hover { color: var(--accent); background: rgba(72,229,194,0.07); }
        .header-btn.accent {
            background: var(--accent);
            color: #062023;
            border-radius: 8px;
            padding: 8px 18px;
        }
        .header-btn.accent:hover { background: var(--accent-dark); color: #fff; }

        /* ═══════════════════════════════════════
           HERO
        ═══════════════════════════════════════ */
        .hero {
            margin-top: 62px;
            background: var(--dark);
            position: relative;
            overflow: hidden;
            padding: 80px 24px 70px;
            text-align: center;
        }
        .hero::before, .hero::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            filter: blur(80px);
            pointer-events: none;
        }
        .hero::before {
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(72,229,194,0.14) 0%, transparent 70%);
            top: -100px; left: -80px;
            animation: orb1 8s ease-in-out infinite alternate;
        }
        .hero::after {
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(37,99,235,0.12) 0%, transparent 70%);
            bottom: -80px; right: -60px;
            animation: orb2 10s ease-in-out infinite alternate;
        }
        @keyframes orb1 { from { transform: translate(0,0); } to { transform: translate(60px,40px); } }
        @keyframes orb2 { from { transform: translate(0,0); } to { transform: translate(-40px,-30px); } }

        .hero-inner { position: relative; z-index: 2; max-width: 760px; margin: 0 auto; }
        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(72,229,194,0.1);
            border: 1px solid rgba(72,229,194,0.25);
            color: var(--accent);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            padding: 5px 14px;
            border-radius: 20px;
            margin-bottom: 22px;
        }
        .hero h1 {
            font-family: 'Syne', sans-serif;
            font-size: clamp(32px, 5vw, 52px);
            font-weight: 800;
            color: #fff;
            line-height: 1.1;
            margin-bottom: 16px;
        }
        .hero h1 em { font-style: normal; color: var(--accent); }
        .hero p {
            font-size: 17px;
            color: #94a3b8;
            margin-bottom: 36px;
            line-height: 1.65;
        }
        .search-row {
            display: flex;
            max-width: 600px;
            margin: 0 auto 32px;
            background: rgba(255,255,255,0.06);
            border: 1.5px solid rgba(255,255,255,0.12);
            border-radius: 14px;
            overflow: hidden;
            backdrop-filter: blur(10px);
            transition: border-color 0.2s, box-shadow 0.2s;
            box-shadow: 0 4px 24px rgba(0,0,0,0.2);
        }
        .search-row:focus-within {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(72,229,194,0.15), 0 4px 24px rgba(0,0,0,0.2);
        }
        /* Target the ASP.NET TextBox rendered <input> */
        .search-row input[type="text"] {
            flex: 1;
            background: transparent !important;
            border: none !important;
            padding: 15px 20px;
            font-size: 15px;
            font-family: 'DM Sans', sans-serif;
            color: #fff !important;
            outline: none;
            min-width: 0;
            -webkit-text-fill-color: #fff;
        }
        .search-row input[type="text"]::placeholder { color: #64748b; }
        .search-row input[type="text"]:-webkit-autofill {
            -webkit-box-shadow: 0 0 0 1000px transparent inset !important;
            -webkit-text-fill-color: #fff !important;
        }
        /* Target the ASP.NET Button rendered <input type=submit> AND regular buttons */
        .search-row input[type="submit"],
        .search-row button {
            background: var(--accent);
            border: none;
            padding: 0 26px;
            cursor: pointer;
            color: #062023;
            font-size: 15px;
            font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            transition: background 0.15s;
            white-space: nowrap;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            gap: 7px;
        }
        .search-row input[type="submit"]:hover,
        .search-row button:hover { background: var(--accent-dark); }
        .popular-tags { display: flex; justify-content: center; flex-wrap: wrap; gap: 8px; }
        .popular-tags span { font-size: 13px; color: #64748b; align-self: center; }
        .tag-pill {
            padding: 5px 13px;
            border-radius: 20px;
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            color: #94a3b8;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
        }
        .tag-pill:hover { background: var(--accent-glow); border-color: var(--accent); color: var(--accent); }

        .search-input { /* handled by .search-row input[type=text] */ }
        .search-btn   { /* handled by .search-row input[type=submit] */ }
                /* ═══════════════════════════════════════
           MAIN TOGGLE
        ═══════════════════════════════════════ */
        .main-toggle {
            background: var(--card);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 62px;
            z-index: 101;
        }
        .main-toggle-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 10px 20px;
            display: flex;
            gap: 8px;
        }
        .toggle-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            color: var(--muted);
            background: transparent;
            border: 1.5px solid var(--border);
            cursor: pointer;
            transition: all 0.15s;
        }
        .toggle-btn:hover { color: var(--accent-dark); border-color: var(--accent); }
        .toggle-btn.active {
            background: var(--accent);
            color: #062023;
            border-color: var(--accent);
        }

        /* ═══════════════════════════════════════
           FREELANCER GRID
        ═══════════════════════════════════════ */
        .freelancers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        .fl-card {
            background: var(--card);
            border-radius: 14px;
            border: 1px solid var(--border);
            padding: 22px;
            transition: transform 0.18s, box-shadow 0.18s;
        }
        .fl-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(15,23,42,0.1);
        }
        .fl-card-header {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 14px;
        }
        .fl-avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), #2563eb);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            color: #fff;
            flex-shrink: 0;
        }
        .fl-info h4 {
            font-size: 15px;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 2px;
        }
        .fl-info .fl-role {
            font-size: 12px;
            color: var(--muted);
        }
        .fl-rating {
            display: flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: var(--muted);
            margin-bottom: 10px;
        }
        .fl-rating i { color: #f59e0b; font-size: 12px; }
        .fl-skills {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            margin-bottom: 14px;
        }
        .fl-skill-tag {
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            background: rgba(72,229,194,0.1);
            color: var(--accent-dark);
            border: 1px solid rgba(72,229,194,0.2);
        }
        .fl-works {
            border-top: 1px solid var(--border);
            padding-top: 12px;
            margin-bottom: 14px;
        }
        .fl-works-label {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--muted);
            margin-bottom: 8px;
        }
        .fl-work-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: var(--text);
            padding: 5px 0;
            border-bottom: 1px solid var(--border);
        }
        .fl-work-item:last-child { border-bottom: none; }
        .fl-work-date { font-size: 11px; color: var(--muted); }
        .fl-no-works {
            font-size: 12px;
            color: var(--muted);
            font-style: italic;
        }
        .fl-book-btn {
            width: 100%;
            padding: 10px;
            background: var(--accent);
            border: none;
            color: #062023;
            font-size: 13px;
            font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .fl-book-btn:hover { background: var(--accent-dark); }

        /* ═══════════════════════════════════════
           CATEGORY NAV
        ═══════════════════════════════════════ */
        .cat-nav {
            background: var(--card);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 62px;
            z-index: 100;
        }
        .cat-nav-inner {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            gap: 2px;
            overflow-x: auto;
            scrollbar-width: none;
        }
        .cat-nav-inner::-webkit-scrollbar { display: none; }
        .cat-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 16px 18px;
            font-size: 13px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            color: var(--muted);
            background: transparent;
            border: none;
            border-bottom: 2.5px solid transparent;
            cursor: pointer;
            white-space: nowrap;
            transition: color 0.15s, border-color 0.15s;
        }
        .cat-btn i { font-size: 14px; }
        .cat-btn:hover { color: var(--accent-dark); }
        .cat-btn.active { color: var(--accent-dark); border-bottom-color: var(--accent); }

        /* ═══════════════════════════════════════
           MAIN AREA
        ═══════════════════════════════════════ */
        .page-body { max-width: 1200px; margin: 36px auto 60px; padding: 0 20px; }
        .section-head { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px; }
        .section-head h2 { font-family: 'Syne', sans-serif; font-size: 22px; font-weight: 800; color: var(--text); }
        .section-head p { font-size: 14px; color: var(--muted); margin-top: 4px; }

        /* ═══════════════════════════════════════
           SERVICE GRID
        ═══════════════════════════════════════ */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
            gap: 20px;
        }
        .service-card {
            background: var(--card);
            border-radius: 14px;
            border: 1px solid var(--border);
            overflow: hidden;
            transition: transform 0.18s, box-shadow 0.18s;
            cursor: pointer;
        }
        .service-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(15,23,42,0.1);
        }
        .sc-thumb {
            height: 140px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .sc-thumb::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, transparent 40%, rgba(0,0,0,0.25) 100%);
        }
        .grad-tech     { background: linear-gradient(135deg, #1e3a5f 0%, #2563eb 100%); }
        .grad-design   { background: linear-gradient(135deg, #7c3aed 0%, #db2777 100%); }
        .grad-video    { background: linear-gradient(135deg, #1a202c 0%, #e11d48 100%); }
        .grad-audio    { background: linear-gradient(135deg, #065f46 0%, #059669 100%); }
        .grad-writing  { background: linear-gradient(135deg, #92400e 0%, #f59e0b 100%); }
        .grad-marketing{ background: linear-gradient(135deg, #1d4ed8 0%, #0ea5e9 100%); }
        .grad-business { background: linear-gradient(135deg, #134e4a 0%, #14b8a6 100%); }
        .grad-other    { background: linear-gradient(135deg, #374151 0%, #6b7280 100%); }

        .sc-body { padding: 16px; }
        .sc-category { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.6px; color: var(--accent-dark); margin-bottom: 6px; }
.sc-title { 
    font-size: 14px; 
    font-weight: 600; 
    color: var(--text); 
    line-height: 1.45; 
    margin-bottom: 8px; 
    display: -webkit-box; 
    -webkit-line-clamp: 2; 
    -webkit-box-orient: vertical; 
    overflow: hidden;
    overflow-wrap: break-word;
    line-clamp: 2;
}
        .sc-seller { display: flex; align-items: center; gap: 7px; margin-bottom: 12px; }
        .sc-avatar { width: 24px; height: 24px; border-radius: 50%; background: linear-gradient(135deg, var(--accent), #2563eb); display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: 700; color: #fff; flex-shrink: 0; }
        .sc-seller-name { font-size: 12px; color: var(--muted); font-weight: 500; }
        .sc-footer { display: flex; justify-content: space-between; align-items: center; padding-top: 12px; border-top: 1px solid var(--border); }
        .sc-price { 
            font-family: 'Syne', sans-serif; 
            font-size: 20px; 
            font-weight: 800; 
            color: #22C55E; 
            text-shadow: 0 0 12px rgba(34,197,94,0.6);
            line-height: 1.2;
        }
        .sc-price small { 
            font-family: 'DM Sans', sans-serif; 
            font-size: 11px; 
            color: #22C55E; 
            font-weight: 500;
            opacity: 0.9;
            display: block;
        }

        .sc-cta {
            font-size: 12px;
            font-weight: 600;
            color: var(--accent-dark);
            background: var(--accent-glow);
            border: none;
            padding: 5px 12px;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            transition: background 0.14s, color 0.14s;
            line-height: 1.2;
        }
        .sc-cta:hover { background: var(--accent); color: #fff; }
        .sc-cta.buy-btn-neon { background: linear-gradient(135deg, #22c55e, #16a34a); color: white; padding: 8px 16px; font-weight: 700; box-shadow: 0 4px 12px rgba(34,197,94,0.3); margin-left: 8px; }
        .sc-cta.buy-btn-neon:hover { background: linear-gradient(135deg, #16a34a, #15803d); transform: translateY(-1px); }

        /* empty state */
        .empty-state { grid-column: 1 / -1; text-align: center; padding: 60px 20px; color: var(--muted); }
        .empty-state i { font-size: 48px; color: var(--border); margin-bottom: 16px; display: block; }
        .empty-state h3 { font-family: 'Syne', sans-serif; font-size: 18px; color: var(--text); margin-bottom: 8px; }
        .empty-state p { font-size: 14px; }
        .empty-state a { display: inline-flex; align-items: center; gap: 7px; margin-top: 20px; padding: 10px 22px; background: var(--accent); color: #062023; font-weight: 700; border-radius: 8px; text-decoration: none; transition: background 0.15s; }
        .empty-state a:hover { background: var(--accent-dark); color: #fff; }

        /* ═══════════════════════════════════════
           SERVICE DETAIL MODAL
        ═══════════════════════════════════════ */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(10,14,20,0.72);
            backdrop-filter: blur(4px);
            z-index: 500;
            align-items: center;
            justify-content: center;
            padding: 20px;
            animation: overlayIn 0.2s ease;
        }
        .modal-overlay.open { display: flex; }
        @keyframes overlayIn { from { opacity: 0; } to { opacity: 1; } }

        .modal {
            background: #fff;
            border-radius: 20px;
            width: 100%;
            max-width: 880px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 32px 80px rgba(0,0,0,0.35);
            animation: modalIn 0.25s cubic-bezier(0.34,1.26,0.64,1);
            position: relative;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.94) translateY(20px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal::-webkit-scrollbar { width: 6px; }
        .modal::-webkit-scrollbar-track { background: transparent; }
        .modal::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

        /* modal header bar */
        .modal-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 24px 0;
        }
        .modal-topbar h3 {
            font-family: 'Syne', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
        }
        .modal-close {
            width: 34px; height: 34px;
            border-radius: 50%;
            background: var(--bg);
            border: 1px solid var(--border);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            font-size: 16px;
            color: var(--muted);
            transition: background 0.15s, color 0.15s;
            flex-shrink: 0;
        }
        .modal-close:hover { background: #fee2e2; color: var(--danger); border-color: #fca5a5; }

        /* modal body layout */
        .modal-body {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 0;
        }

        /* LEFT column */
        .modal-left { padding: 20px 24px 28px; }

        /* service image/banner */
        .modal-banner {
            width: 100%;
            height: 220px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 64px;
            color: rgba(255,255,255,0.9);
            margin-bottom: 20px;
            overflow: hidden;
            position: relative;
        }
        .modal-banner::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.2) 100%);
        }

        /* seller info card */
        .seller-card {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px;
            border: 1px solid var(--border);
            border-radius: 12px;
            margin-bottom: 20px;
            background: var(--bg);
        }
        .seller-avatar-lg {
            width: 52px; height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), #2563eb);
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; font-weight: 700; color: #fff;
            flex-shrink: 0;
        }
        .seller-info { flex: 1; min-width: 0; }
        .seller-info h4 { font-size: 15px; font-weight: 700; color: var(--text); margin-bottom: 2px; }
        .seller-info .seller-badge {
            display: inline-flex; align-items: center; gap: 4px;
            font-size: 11px; font-weight: 600;
            background: rgba(72,229,194,0.12); color: var(--accent-dark);
            padding: 2px 8px; border-radius: 20px;
        }
        .btn-contact {
            padding: 8px 18px;
            background: transparent;
            border: 1.5px solid var(--accent);
            color: var(--accent-dark);
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.15s;
            white-space: nowrap;
        }
        .btn-contact:hover { background: var(--accent); color: #fff; }

        /* about section */
        .modal-section-title {
            font-family: 'Syne', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 10px;
        }
        .modal-description {
            font-size: 14px;
            color: #334155;
            line-height: 1.7;
            margin-bottom: 20px;
        }
        .feature-list { list-style: none; display: flex; flex-direction: column; gap: 8px; }
        .feature-list li {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 14px;
            color: #334155;
        }
        .feature-list li i { color: var(--accent-dark); margin-top: 2px; font-size: 14px; flex-shrink: 0; }

        /* RIGHT column */
        .modal-right {
            border-left: 1px solid var(--border);
            padding: 20px 24px 28px;
            display: flex;
            flex-direction: column;
            gap: 0;
        }

        /* package tabs */
        .pkg-tabs {
            display: flex;
            border-bottom: 1px solid var(--border);
            margin-bottom: 16px;
            gap: 0;
        }
        .pkg-tab {
            flex: 1;
            padding: 10px 6px;
            text-align: center;
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: color 0.15s, border-color 0.15s;
            background: none;
            border-top: none;
            border-left: none;
            border-right: none;
            font-family: 'DM Sans', sans-serif;
        }
        .pkg-tab.active { color: var(--text); border-bottom-color: var(--accent); }

        .pkg-panel { display: none; }
        .pkg-panel.active { display: block; }

        .pkg-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 6px;
        }
        .pkg-name { font-size: 16px; font-weight: 700; color: var(--text); }
        .pkg-price { font-family: 'Syne', sans-serif; font-size: 24px; font-weight: 800; color: var(--text); }
        .pkg-desc { font-size: 13px; color: var(--muted); margin-bottom: 14px; }

        .pkg-meta { display: flex; flex-direction: column; gap: 7px; margin-bottom: 16px; }
        .pkg-meta-row { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #334155; }
        .pkg-meta-row i { color: var(--muted); width: 16px; text-align: center; }

        .pkg-includes { display: flex; flex-direction: column; gap: 7px; margin-bottom: 20px; }
        .pkg-includes-item { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #334155; }
        .pkg-includes-item i { color: var(--accent-dark); font-size: 14px; }

        /* CTA buttons */
        .btn-continue {
            width: 100%;
            padding: 13px;
            background: var(--accent);
            border: none;
            color: #062023;
            font-size: 15px;
            font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.15s, transform 0.1s;
            margin-bottom: 10px;
            box-shadow: 0 4px 18px rgba(72,229,194,0.22);
        }
        .btn-continue:hover { background: var(--accent-dark); transform: translateY(-1px); }
        .btn-compare {
            width: 100%;
            padding: 11px;
            background: transparent;
            border: 1.5px solid var(--border);
            color: var(--text);
            font-size: 14px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            border-radius: 10px;
            cursor: pointer;
            transition: border-color 0.15s, color 0.15s;
            margin-bottom: 16px;
        }
        .btn-compare:hover { border-color: var(--accent); color: var(--accent-dark); }

        /* action row */
        .modal-actions {
            display: flex;
            gap: 16px;
            justify-content: center;
        }
        .modal-action-btn {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 600;
            color: var(--muted);
            background: none;
            border: none;
            cursor: pointer;
            font-family: 'DM Sans', sans-serif;
            padding: 6px 8px;
            border-radius: 6px;
            transition: color 0.15s, background 0.15s;
        }
        .modal-action-btn:hover { color: var(--accent-dark); background: var(--accent-glow); }
        .modal-action-btn i { font-size: 15px; }

        /* ═══════════════════════════════════════
           FOOTER
        ═══════════════════════════════════════ */
        .site-footer { background: var(--dark); color: #cbd5e1; padding: 48px 20px 24px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: flex; gap: 28px; flex-wrap: wrap; justify-content: space-between; }
        .footer-col { min-width: 160px; flex: 1; margin-bottom: 18px; }
        .footer-col h4 { color: #fff; margin-bottom: 14px; font-family: 'Syne', sans-serif; font-size: 15px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 9px; }
        .footer-col a { color: #94a3b8; text-decoration: none; font-size: 14px; transition: color 0.15s; }
        .footer-col a:hover { color: var(--accent); }
        .footer-brand .logo { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; color: var(--accent); text-decoration: none; }
        .footer-brand p { color: #94a3b8; font-size: 13px; margin-top: 10px; line-height: 1.65; }
        .socials { display: flex; gap: 8px; margin-top: 14px; }
        .socials a { width: 34px; height: 34px; border-radius: 6px; background: rgba(255,255,255,0.05); color: #94a3b8; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; transition: background 0.15s, color 0.15s; }
        .socials a:hover { background: var(--accent); color: #062023; }
        .footer-bottom { max-width: 1200px; margin: 24px auto 0; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #64748b; flex-wrap: wrap; gap: 10px; }
        .footer-links { display: flex; gap: 14px; }
        .footer-links a { color: #64748b; text-decoration: none; font-size: 13px; }
        .footer-links a:hover { color: var(--accent); }

        /* ═══════════════════════════════════════
           RESPONSIVE
        ═══════════════════════════════════════ */
        @media (max-width: 768px) {
            .hero { padding: 56px 18px 48px; }
            .services-grid { grid-template-columns: 1fr 1fr; }
            .modal-body { grid-template-columns: 1fr; }
            .modal-right { border-left: none; border-top: 1px solid var(--border); }
        }
        @media (max-width: 480px) {
            .services-grid { grid-template-columns: 1fr; }
            .header { padding: 0 16px; }
            .modal { border-radius: 16px 16px 0 0; max-height: 95vh; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:HiddenField ID="hdnActiveView" runat="server" ClientIDMode="Static" Value="services" />
<asp:HiddenField ID="hdnIsLoggedIn" runat="server" ClientIDMode="Static" Value="0" />

    <!-- ══ HEADER ══ -->
    <header class="header">
        <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Home.aspx" CssClass="logo-text" Text="SkillLink" />
        <div class="header-right">
            <asp:HyperLink ID="lnkFreelance" runat="server" NavigateUrl="~/Freelancer.aspx" CssClass="header-btn">
                <i class="fas fa-plus-circle"></i> Post a Service
            </asp:HyperLink>
            <asp:HyperLink ID="lnkProfile" runat="server" NavigateUrl="~/Profile.aspx" CssClass="header-btn">
                <i class="fas fa-user-circle"></i> My Account
            </asp:HyperLink>
            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="~/Login.aspx" CssClass="header-btn accent">
                Sign In
            </asp:HyperLink>
        </div>
    </header>

    <!-- ══ HERO ══ -->
    <section class="hero">
        <div class="hero-inner">
            <div class="hero-eyebrow"><i class="fas fa-bolt"></i> Trusted by thousands of clients</div>
            <h1>Find the perfect<br /><em>freelancer</em> for any job</h1>
            <p>Browse services from skilled professionals in design, tech,<br />marketing, video and more — all in one place.</p>
            <div class="search-row">
                <asp:TextBox ID="txtSearch" runat="server" placeholder="Search for any service…" CssClass="search-input" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
                    CssClass="search-btn" />
            </div>
            <div class="popular-tags">
                <span>Popular:</span>
                <asp:LinkButton ID="lpTech"      runat="server" CssClass="tag-pill" Text="Web Dev"        OnClick="lnkTech_Click" />
                <asp:LinkButton ID="lpDesign"    runat="server" CssClass="tag-pill" Text="Logo Design"    OnClick="lnkGraphics_Click" />
                <asp:LinkButton ID="lpVideo"     runat="server" CssClass="tag-pill" Text="Video Editing"  OnClick="lnkVideo_Click" />
                <asp:LinkButton ID="lpMarketing" runat="server" CssClass="tag-pill" Text="SEO"            OnClick="lnkMarketing_Click" />
                <asp:LinkButton ID="lpAudio"     runat="server" CssClass="tag-pill" Text="Voiceover"      OnClick="lnkMusic_Click" />
            </div>
        </div>
    </section>

    <!-- ══ MAIN TOGGLE ══ -->
<div class="main-toggle">
    <div class="main-toggle-inner">
        <button type="button" class="toggle-btn active" id="toggleServices" onclick="switchMainView('services')">
            <i class="fas fa-briefcase"></i> Browse Services
        </button>
        <button type="button" class="toggle-btn" id="toggleFreelancers" onclick="switchMainView('freelancers')">
            <i class="fas fa-users"></i> Browse Freelancers
        </button>
    </div>
</div>

<!-- ══ CATEGORY NAV (Services only) ══ -->
<nav class="cat-nav" id="catNavBar">
    <div class="cat-nav-inner">
        <asp:LinkButton ID="lnkTech"      runat="server" CssClass="cat-btn" OnClick="lnkTech_Click"><i class="fas fa-code"></i> Programming &amp; Tech</asp:LinkButton>
        <asp:LinkButton ID="lnkGraphics"  runat="server" CssClass="cat-btn" OnClick="lnkGraphics_Click"><i class="fas fa-paint-brush"></i> Graphics &amp; Design</asp:LinkButton>
        <asp:LinkButton ID="lnkVideo"     runat="server" CssClass="cat-btn" OnClick="lnkVideo_Click"><i class="fas fa-video"></i> Video &amp; Animation</asp:LinkButton>
        <asp:LinkButton ID="lnkMusic"     runat="server" CssClass="cat-btn" OnClick="lnkMusic_Click"><i class="fas fa-music"></i> Music &amp; Audio</asp:LinkButton>
        <asp:LinkButton ID="lnkMarketing" runat="server" CssClass="cat-btn" OnClick="lnkMarketing_Click"><i class="fas fa-bullhorn"></i> Digital Marketing</asp:LinkButton>
        <asp:LinkButton ID="lnkWriting"   runat="server" CssClass="cat-btn" OnClick="lnkWriting_Click"><i class="fas fa-pen-nib"></i> Writing &amp; Translation</asp:LinkButton>
        <asp:LinkButton ID="lnkBusiness"  runat="server" CssClass="cat-btn" OnClick="lnkBusiness_Click"><i class="fas fa-briefcase"></i> Business</asp:LinkButton>
    </div>
</nav>


    <!-- ══ MAIN BODY ══ -->
<div class="page-body">

    <!-- SERVICES VIEW -->
    <div id="viewServices" runat="server" style="display:none;">
        <div class="section-head">
            <div>
                <h2><asp:Literal ID="litCatTitle" runat="server" /></h2>
                <p><asp:Literal ID="litCatDesc" runat="server" /></p>
            </div>
        </div>

        <div class="services-grid">
            <asp:Repeater ID="rptServices" runat="server" OnItemCommand="rptServices_ItemCommand">
                <ItemTemplate>
                    <div class="service-card" style="cursor:pointer;" onclick="event.stopPropagation();">
        
                        <div class="sc-thumb <%# GetGradient(Eval("Category").ToString()) %>">
                            <i class="<%# GetIcon(Eval("Category").ToString()) %>"></i>
                        </div>

                        <div class="sc-body">
                            <div class="sc-category"><%# Eval("Category") %></div>
                            <div class="sc-title"><%# Server.HtmlEncode(Eval("Title").ToString()) %></div>
            
                            <div class="sc-seller">
                                <div class="sc-avatar"><%# GetInitial(Eval("Name").ToString()) %></div>
                                <span class="sc-seller-name"><%# ShortenName(Eval("Name").ToString()) %></span>
                            </div>


                            <div class="sc-footer">
                                <div class="sc-price">
                                    <%# GetDisplayPrice(Eval("Price")) %>
                                </div>
                                <button class="sc-cta" onclick="openModalSafe('<%# Server.HtmlEncode(Eval("Title") ?? "Untitled") %>', '<%# Server.HtmlEncode(Eval("Description") ?? "") %>', '<%# Eval("Category") ?? "Other" %>', '<%# ShortenName(Eval("Name") ?? "Anon") %>', '<%# GetInitial(Eval("Name") ?? "?") %>', '<%# (Eval("Price") ?? 500).ToString() %>');">View Details</button>
                            </div>
                        </div>
                     </div> </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
                    <i class="fas fa-folder-open"></i>
                    <h3>No services yet in this category</h3>
                    <p>Be the first to offer a service here and reach hundreds of clients.</p>
                    <a href="Freelancer.aspx"><i class="fas fa-plus"></i> Post Your Service</a>
                </asp:Panel>
            </div>
        </div>

        <!-- FREELANCERS VIEW -->
<div id="viewFreelancers" style="display: none;">
            <div class="section-head">
                <div>
                    <h2>Browse Freelancers</h2>
                    <p>Find and book talented professionals for your project</p>
                </div>
            </div>
            <div class="freelancers-grid">
                <asp:Repeater ID="rptFreelancers" runat="server">
                    <ItemTemplate>
                        <div class="fl-card">
                            <div class="fl-card-header">
                                <div class="fl-avatar">
                                    <%# GetInitial(Eval("Username").ToString()) %>
                                </div>
                                <div class="fl-info">
                                    <h4><%# Server.HtmlEncode(Eval("Username").ToString()) %></h4>
                                    <div class="fl-role">Freelancer</div>
                                </div>
                            </div>

                            <%-- Rating --%>
                            <div class="fl-rating">
                                <i class="fas fa-star"></i>
                                <span><%# Eval("AvgRating") != DBNull.Value ? string.Format("{0:0.0}", Eval("AvgRating")) : "No ratings" %></span>
                                <span style="color:var(--muted);">
                                    <%# Eval("ReviewCount") != DBNull.Value && Convert.ToInt32(Eval("ReviewCount")) > 0 ? "(" + Eval("ReviewCount") + " reviews)" : "" %>
                                </span>
                            </div>

                            <%-- Skills --%>
                            <div class="fl-skills">
                                <%# ((Skill_Link.Home)Page).RenderSkillTags(Eval("Skills")) %>
                            </div>

                            <%-- Completed Works --%>
                            <div class="fl-works">
                                <div class="fl-works-label">Completed Works</div>
                                <%# ((Skill_Link.Home)Page).RenderCompletedWorks(Eval("Email").ToString()) %>
                            </div>

                            <%-- Book Button --%>
                            <button type="button" class="fl-book-btn"
                                onclick="bookFreelancer('<%# Server.HtmlEncode(Eval("Email").ToString()) %>','<%# Server.HtmlEncode(Eval("Username").ToString()) %>');
                                <i class="fas fa-calendar-plus"></i> Book this Freelancer
                            </button>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <asp:Panel ID="pnlNoFreelancers" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-users"></i>
                <h3>No freelancers available yet</h3>
                <p>Check back soon as more professionals join SkillLink.</p>
            </asp:Panel>
        </div>
    </div>

    </div>

    <!-- ══ SERVICE DETAIL MODAL ══ -->
    <div class="modal-overlay" id="serviceModal" onclick="closeModalOutside(event)">
        <div class="modal" id="modalBox">

            <!-- Top bar -->
            <div class="modal-topbar">
                <h3>Service Details</h3>
                <button type="button" class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
            </div>

            <div class="modal-body">
                <!-- LEFT -->
                <div class="modal-left">
                    <!-- Banner -->
                    <div class="modal-banner" id="modalBanner">
                        <i id="modalBannerIcon" class="fas fa-star"></i>
                    </div>

                    <!-- Seller card -->
                    <div class="seller-card">
                        <div class="seller-avatar-lg" id="modalSellerInitial">?</div>
                        <div class="seller-info">
                            <h4 id="modalSellerName">Seller Name</h4>
                            <span class="seller-badge"><i class="fas fa-shield-alt"></i> Verified Seller</span>
                        </div>
                        <button type="button" class="btn-contact" onclick="contactSeller()"><i class="fas fa-envelope"></i> Contact</button>
                    </div>

                    <!-- Description -->
                    <div class="modal-section-title">About This Service</div>
                    <div class="modal-description" id="modalDescription">Loading…</div>

                    <!-- Feature highlights -->
                    <div class="modal-section-title">What's Included</div>
                    <ul class="feature-list" id="modalFeatures">
                        <li><i class="fas fa-check-circle"></i> <span>Professional quality delivery</span></li>
                        <li><i class="fas fa-check-circle"></i> <span>Clear communication throughout</span></li>
                        <li><i class="fas fa-check-circle"></i> <span>Revisions until satisfied</span></li>
                        <li><i class="fas fa-check-circle"></i> <span>On-time delivery guaranteed</span></li>
                    </ul>
                </div>

                <!-- RIGHT -->
                <div class="modal-right">
                    <!-- Title + rating -->
                    <div style="margin-bottom:16px;">
                        <h2 id="modalTitle" style="font-family:'Syne',sans-serif;font-size:18px;font-weight:800;color:var(--text);line-height:1.35;margin-bottom:10px;">Service Title</h2>
                    </div>

                    <!-- Package tabs -->
                    <div class="pkg-tabs">
                        <button type="button" class="pkg-tab active" onclick="switchPkg(0, this)">Basic</button>
                        <button type="button" class="pkg-tab" onclick="switchPkg(1, this)">Standard</button>
                        <button type="button" class="pkg-tab" onclick="switchPkg(2, this)">Premium</button>
                    </div>

                    <!-- Basic package -->
                    <div class="pkg-panel active" id="pkg0">
                        <div class="pkg-header">
                            <span class="pkg-name">Basic Package</span>
                            <span class="pkg-price" id="modalPriceBasic">₱0</span>
                        </div>
                        <div class="pkg-desc">Great for getting started with this service</div>
                        <div class="pkg-meta">
                            <div class="pkg-meta-row"><i class="fas fa-clock"></i> 5 days delivery</div>
                            <div class="pkg-meta-row"><i class="fas fa-redo"></i> 2 revisions</div>
                        </div>
                        <div class="pkg-includes">
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Core service delivery</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Source files included</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Commercial use rights</div>
                        </div>
                    </div>

                    <!-- Standard package -->
                    <div class="pkg-panel" id="pkg1">
                        <div class="pkg-header">
                            <span class="pkg-name">Standard Package</span>
                            <span class="pkg-price" id="modalPriceStandard">₱0</span>
                        </div>
                        <div class="pkg-desc">More features and faster delivery for growing projects</div>
                        <div class="pkg-meta">
                            <div class="pkg-meta-row"><i class="fas fa-clock"></i> 3 days delivery</div>
                            <div class="pkg-meta-row"><i class="fas fa-redo"></i> 5 revisions</div>
                        </div>
                        <div class="pkg-includes">
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Everything in Basic</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Priority support</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Dedicated account manager</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Extended revisions</div>
                        </div>
                    </div>

                    <!-- Premium package -->
                    <div class="pkg-panel" id="pkg2">
                        <div class="pkg-header">
                            <span class="pkg-name">Premium Package</span>
                            <span class="pkg-price" id="modalPricePremium">₱0</span>
                        </div>
                        <div class="pkg-desc">Full-service solution with unlimited revisions</div>
                        <div class="pkg-meta">
                            <div class="pkg-meta-row"><i class="fas fa-clock"></i> 1 day delivery</div>
                            <div class="pkg-meta-row"><i class="fas fa-infinity"></i> Unlimited revisions</div>
                        </div>
                        <div class="pkg-includes">
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Everything in Standard</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Express delivery</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> 1-on-1 consultation</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Unlimited revisions</div>
                            <div class="pkg-includes-item"><i class="fas fa-check-circle"></i> Post-delivery support (7 days)</div>
                        </div>
                    </div>

                    <!-- CTA -->
                    <button type="button" class="btn-continue" id="btnContinue" onclick="proceedToOrder();">
                        <i class="fas fa-arrow-right"></i> Continue (₱0)
                    </button>
                    <button type="button" class="btn-compare" onclick="switchPkg(1, document.querySelectorAll('.pkg-tab')[1])">Compare Packages</button>

                    <!-- Save / Share -->
                    <div class="modal-actions">
                        <button type="button" class="modal-action-btn" style="opacity:0.4;cursor:not-allowed;" title="Coming soon"><i class="fas fa-heart"></i> Save</button>
                        <button type="button" class="modal-action-btn" onclick="shareService()"><i class="fas fa-share-alt"></i> Share</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ══ FOOTER ══ -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-col footer-brand">
                <a class="logo" href="Home.aspx">SkillLink</a>
                <p>Connect with talented professionals to get work done — design, marketing, development and more.</p>
                <div class="socials">
                    <a href="#" title="Twitter"><i class="fab fa-twitter"></i></a>
                    <a href="#" title="Facebook"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" title="LinkedIn"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#" title="Instagram"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Explore</h4>
                <ul>
                    <li><a href="Home.aspx">Home</a></li>
                    <li><a href="Freelancer.aspx">Post a Service</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Categories</h4>
                <ul>
                    <li><asp:LinkButton ID="fl1" runat="server" Text="Programming &amp; Tech" OnClick="lnkTech_Click"      style="color:#94a3b8;font-size:14px;background:none;border:none;cursor:pointer;padding:0;" /></li>
                    <li><asp:LinkButton ID="fl2" runat="server" Text="Graphics &amp; Design"  OnClick="lnkGraphics_Click"  style="color:#94a3b8;font-size:14px;background:none;border:none;cursor:pointer;padding:0;" /></li>
                    <li><asp:LinkButton ID="fl3" runat="server" Text="Video &amp; Animation"  OnClick="lnkVideo_Click"     style="color:#94a3b8;font-size:14px;background:none;border:none;cursor:pointer;padding:0;" /></li>
                    <li><asp:LinkButton ID="fl4" runat="server" Text="Music &amp; Audio"      OnClick="lnkMusic_Click"     style="color:#94a3b8;font-size:14px;background:none;border:none;cursor:pointer;padding:0;" /></li>
                </ul>
            </div>
        </div>
        <div class="footer-inner footer-bottom">
            <p>© <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
            <div class="footer-links">
                <a>Terms</a>
                <a>Privacy</a>
                <a>Sitemap</a>
            </div>
        </div>
    </footer>

</form>

<script>
    // ── Search button icon ──
    (function () {
        // Search button: asp:Button renders as input[type=submit], Text is set server-side

        var active = '<%= ActiveCategory %>';
        document.querySelectorAll('.cat-btn').forEach(function (b) {
            if (b.textContent.trim().toLowerCase().indexOf(active.toLowerCase()) !== -1)
                b.classList.add('active');
        });
    })();

    // ── Modal state ──
    var currentPrice = 0;
    var currentPkg = 0;
    var currentTitle = '';
    var currentSeller = '';
    var currentCat = '';

    var gradMap = {
        'Programming & Tech': 'grad-tech',
        'Graphics & Design': 'grad-design',
        'Video & Animation': 'grad-video',
        'Music & Audio': 'grad-audio',
        'Writing & Translation': 'grad-writing',
        'Digital Marketing': 'grad-marketing',
        'Business': 'grad-business'
    };
    var iconMap = {
        'Programming & Tech': 'fas fa-code',
        'Graphics & Design': 'fas fa-paint-brush',
        'Video & Animation': 'fas fa-video',
        'Music & Audio': 'fas fa-music',
        'Writing & Translation': 'fas fa-pen-nib',
        'Digital Marketing': 'fas fa-chart-line',
        'Business': 'fas fa-briefcase'
    };

function openModalSafe(title, description, category, sellerName, sellerInitial, price) {
        var p = parseInt(price.replace(/,/g, ''), 10) || 500;
        openModal(title, description, category, sellerName, sellerInitial, p);
    }
    function openModal(title, description, category, sellerName, sellerInitial, price) {
        currentPrice = parseInt(price.replace(/,/g, ''), 10) || 0;
        currentPkg = 0;
        currentTitle = title;
        currentSeller = sellerName;
        currentCat = category;

        // Populate content
        document.getElementById('modalTitle').textContent = title;
        document.getElementById('modalDescription').textContent = description || 'No description provided for this service.';
        document.getElementById('modalSellerName').textContent = sellerName;
        document.getElementById('modalSellerInitial').textContent = sellerInitial;

        // Banner gradient + icon
        var banner = document.getElementById('modalBanner');
        var icon = document.getElementById('modalBannerIcon');
        banner.className = 'modal-banner ' + (gradMap[category] || 'grad-other');
        icon.className = (iconMap[category] || 'fas fa-star');

        // Prices (basic = listed, standard = 2x, premium = 3x)
        var basicP = currentPrice;
        var standardP = Math.round(currentPrice * 1.5);
        var premiumP = Math.round(currentPrice * 2);
        document.getElementById('modalPriceBasic').textContent = '₱' + basicP.toLocaleString();
        document.getElementById('modalPriceStandard').textContent = '₱' + standardP.toLocaleString();
        document.getElementById('modalPricePremium').textContent = '₱' + premiumP.toLocaleString();
        document.getElementById('btnContinue').innerHTML = '<i class="fas fa-arrow-right"></i> Continue (₱' + basicP.toLocaleString() + ')';

        // Reset to Basic tab
        switchPkg(0, document.querySelectorAll('.pkg-tab')[0]);

        // Open overlay
        document.getElementById('serviceModal').classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        document.getElementById('serviceModal').classList.remove('open');
        document.body.style.overflow = '';
    }

    function closeModalOutside(e) {
        if (e.target === document.getElementById('serviceModal')) closeModal();
    }

    // Escape key closes modal
    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeModal();
    });

    function switchPkg(idx, tabBtn) {
        currentPkg = idx;
        // tabs
        document.querySelectorAll('.pkg-tab').forEach(function (t) { t.classList.remove('active'); });
        tabBtn.classList.add('active');
        // panels
        document.querySelectorAll('.pkg-panel').forEach(function (p) { p.classList.remove('active'); });
        document.getElementById('pkg' + idx).classList.add('active');
        // update continue button price
        var multipliers = [1, 2, 3];
        var p = Math.round(currentPrice * multipliers[idx]);
        document.getElementById('btnContinue').innerHTML = '<i class="fas fa-arrow-right"></i> Continue (₱' + p.toLocaleString() + ')';
    }

    function contactSeller() {
        if (!currentSeller) return;
        window.location.href = 'mailto:' + currentSeller;
    }

    function saveService() {
        var btn = event.currentTarget;
        btn.style.color = '#e5484d';
        btn.innerHTML = '<i class="fas fa-heart"></i> Saved!';
        setTimeout(function () {
            btn.style.color = '';
            btn.innerHTML = '<i class="fas fa-heart"></i> Save';
        }, 2000);
    }

    function shareService() {
        var title = document.getElementById('modalTitle').textContent;
        if (navigator.share) {
            navigator.share({ title: title, url: window.location.href });
        } else {
            navigator.clipboard.writeText(window.location.href).then(function () {
                alert('Link copied to clipboard!');
            });
        }
    }

    function requireLogin() {
        if (document.getElementById('hdnIsLoggedIn').value !== '1') {
            window.location.href = 'Login.aspx?returnUrl=' + encodeURIComponent(window.location.pathname);
            return false;
        }
        return true;
    }

    function proceedToOrder() {
        if (!requireLogin()) return;
    }

    function bookFreelancer(email, username) {
        if (!requireLogin()) return;
        var params = new URLSearchParams({
            freelancer: email,
            name: username
        });
        window.location.href = 'Booking.aspx?' + params.toString();
    }

    function switchMainView(view) {
        var servicesView = document.getElementById('viewServices');
        var freelancersView = document.getElementById('viewFreelancers');
        var catNav = document.getElementById('catNavBar');
        var btnServices = document.getElementById('toggleServices');
        var btnFreelancers = document.getElementById('toggleFreelancers');
        var hdn = document.getElementById('hdnActiveView');

        if (view === 'services') {
            servicesView.style.display = '';
            freelancersView.style.display = 'none';
            catNav.style.display = '';
            btnServices.classList.add('active');
            btnFreelancers.classList.remove('active');
        } else {
            servicesView.style.display = 'none';
            freelancersView.style.display = '';
            catNav.style.display = 'none';
            btnServices.classList.remove('active');
            btnFreelancers.classList.add('active');
        }

        if (hdn) hdn.value = view;
    }

    // Restore active view on page load including after postback
    window.addEventListener('DOMContentLoaded', function () {
        var hdn = document.getElementById('hdnActiveView');
        if (hdn && hdn.value === 'freelancers') {
            switchMainView('freelancers');
        }
    });
</script>
</body>
</html>
