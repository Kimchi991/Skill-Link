<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Order.aspx.cs" Inherits="Skill_Link.Order" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Place Order - SkillLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:       #48e5c2;
            --accent-dark:  #2abfa0;
            --accent-glow:  rgba(72,229,194,0.15);
            --bg:           #f0f4f8;
            --card:         #ffffff;
            --border:       #e2e8f0;
            --text:         #1a202c;
            --muted:        #64748b;
            --dark:         #1a202c;
            --danger:       #ef4444;
            --success:      #22c55e;
            --warn:         #f59e0b;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
        }

        /* ── HEADER ── */
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
            font-size: 22px; font-weight: 800;
            color: var(--accent);
            text-decoration: none;
        }
        .header-right { display: flex; align-items: center; gap: 8px; }
        .header-link {
            color: #94a3b8; font-size: 13px; font-weight: 500;
            text-decoration: none; padding: 7px 14px; border-radius: 8px;
            transition: color 0.15s, background 0.15s;
        }
        .header-link:hover { color: var(--accent); background: var(--accent-glow); }
        .secure-badge {
            display: flex; align-items: center; gap: 6px;
            font-size: 12px; font-weight: 600;
            color: var(--accent); background: var(--accent-glow);
            padding: 6px 14px; border-radius: 20px;
            border: 1px solid rgba(72,229,194,0.3);
        }

        /* ── PROGRESS STEPPER ── */
        .stepper-wrap {
            background: var(--card);
            border-bottom: 1px solid var(--border);
            padding: 0 32px;
            margin-top: 62px;
        }
        .stepper {
            max-width: 860px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            padding: 18px 0;
        }
        .step-item {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
        }
        .step-item:last-child { flex: none; }
        .step-num {
            width: 34px; height: 34px;
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700;
            border: 2px solid var(--border);
            color: var(--muted);
            background: var(--card);
            transition: all 0.3s;
            flex-shrink: 0;
        }
        .step-item.active   .step-num { border-color: var(--accent); background: var(--accent); color: #062023; box-shadow: 0 0 0 4px rgba(72,229,194,0.15); }
        .step-item.done     .step-num { border-color: var(--accent); background: rgba(72,229,194,0.1); color: var(--accent-dark); }
        .step-item.done     .step-num::before { content: '\f00c'; font-family: 'Font Awesome 6 Free'; font-weight: 900; font-size: 12px; }
        .step-item.done     .step-num span { display: none; }
        .step-label { font-size: 12px; font-weight: 600; color: var(--muted); white-space: nowrap; }
        .step-item.active .step-label { color: var(--text); }
        .step-item.done   .step-label { color: var(--accent-dark); }
        .step-connector {
            flex: 1;
            height: 2px;
            background: var(--border);
            margin: 0 8px;
            border-radius: 2px;
            transition: background 0.3s;
        }
        .step-connector.done { background: var(--accent); }

        /* ── PAGE LAYOUT ── */
        .page-wrap {
            max-width: 1060px;
            margin: 36px auto 60px;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 24px;
            align-items: start;
        }

        /* ── CARDS ── */
        .card {
            background: var(--card);
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 28px;
            box-shadow: 0 2px 10px rgba(15,23,42,0.04);
            margin-bottom: 20px;
        }
        .card-title {
            font-family: 'Syne', sans-serif;
            font-size: 17px; font-weight: 800;
            color: var(--text);
            margin-bottom: 20px;
            display: flex; align-items: center; gap: 10px;
        }
        .card-title i { color: var(--accent); font-size: 16px; }

        /* ── STEP PANELS ── */
        .step-panel { display: none; }
        .step-panel.active { display: block; animation: fadeIn 0.3s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* ── SERVICE SUMMARY (step 1) ── */
        .service-summary-card {
            display: flex;
            gap: 16px;
            align-items: flex-start;
            padding: 18px;
            background: var(--bg);
            border-radius: 12px;
            border: 1px solid var(--border);
            margin-bottom: 20px;
        }
        .svc-thumb {
            width: 72px; height: 72px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 28px; color: #fff;
            flex-shrink: 0;
        }
        .svc-info h3 { font-size: 15px; font-weight: 700; color: var(--text); margin-bottom: 4px; line-height: 1.35; }
        .svc-info .svc-seller { font-size: 13px; color: var(--muted); margin-bottom: 6px; }
        .svc-info .svc-cat {
            display: inline-block;
            font-size: 11px; font-weight: 700; text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--accent-dark);
            background: var(--accent-glow);
            padding: 2px 8px; border-radius: 20px;
        }

        /* package selector */
        .pkg-selector { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px; }
        .pkg-option {
            border: 2px solid var(--border);
            border-radius: 10px;
            padding: 14px 12px;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            text-align: center;
        }
        .pkg-option:hover { border-color: rgba(72,229,194,0.5); background: rgba(72,229,194,0.03); }
        .pkg-option.selected { border-color: var(--accent); background: rgba(72,229,194,0.06); }
        .pkg-option .pkg-opt-name { font-size: 13px; font-weight: 700; color: var(--text); margin-bottom: 4px; }
        .pkg-option .pkg-opt-price { font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 800; color: var(--accent-dark); margin-bottom: 6px; }
        .pkg-option .pkg-opt-meta { font-size: 11px; color: var(--muted); display: flex; flex-direction: column; gap: 3px; }

        /* ── FORM ELEMENTS ── */
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 12px; font-weight: 600;
            color: var(--muted);
            text-transform: uppercase; letter-spacing: 0.5px;
            margin-bottom: 7px;
        }
        .form-group label .req { color: var(--danger); margin-left: 3px; }
        .form-input, .form-textarea, .form-select {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid var(--border);
            border-radius: 9px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            background: #fff;
            transition: border-color 0.15s, box-shadow 0.15s;
            outline: none;
        }
        .form-input:focus, .form-textarea:focus, .form-select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(72,229,194,0.1);
        }
        .form-textarea { resize: vertical; min-height: 110px; line-height: 1.6; }
        .form-select { cursor: pointer; }

        .char-count { font-size: 11px; color: var(--muted); text-align: right; margin-top: 4px; }

        /* file upload */
        .file-drop {
            border: 2px dashed var(--border);
            border-radius: 10px;
            padding: 28px 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            position: relative;
        }
        .file-drop:hover { border-color: var(--accent); background: rgba(72,229,194,0.03); }
        .file-drop.drag-over { border-color: var(--accent); background: rgba(72,229,194,0.06); }
        .file-drop input[type="file"] { position: absolute; inset: 0; opacity: 0; cursor: pointer; }
        .file-drop i { font-size: 28px; color: var(--border); margin-bottom: 10px; display: block; }
        .file-drop p { font-size: 14px; color: var(--muted); }
        .file-drop span { font-size: 12px; color: var(--muted); margin-top: 4px; display: block; }
        .file-list { margin-top: 12px; display: flex; flex-direction: column; gap: 8px; }
        .file-item {
            display: flex; align-items: center; gap: 10px;
            padding: 8px 12px;
            background: var(--bg); border-radius: 8px;
            font-size: 13px;
        }
        .file-item i { color: var(--accent-dark); }
        .file-item .fname { flex: 1; color: var(--text); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .file-item .fsize { color: var(--muted); font-size: 11px; }
        .file-item .fremove { color: var(--danger); cursor: pointer; font-size: 13px; background: none; border: none; }

        /* date picker */
        .deadline-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }

        /* ── CONFIRM STEP ── */
        .confirm-line {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }
        .confirm-line:last-child { border-bottom: none; }
        .confirm-line .cl-label { color: var(--muted); }
        .confirm-line .cl-value { font-weight: 600; color: var(--text); }
        .confirm-line.total .cl-label { font-weight: 700; color: var(--text); font-size: 15px; }
        .confirm-line.total .cl-value { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; color: var(--accent-dark); }

        /* ── PAYMENT STEP ── */
        .payment-methods { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; }
        .payment-option {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 18px;
            border: 2px solid var(--border);
            border-radius: 12px;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            position: relative;
        }
        .payment-option:hover { border-color: rgba(72,229,194,0.5); }
        .payment-option.selected { border-color: var(--accent); background: rgba(72,229,194,0.04); }
        .payment-option input[type="radio"] { position: absolute; opacity: 0; }
        .pm-icon { width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; flex-shrink: 0; }
        .pm-gcash   { background: #0060a9; color: #fff; }
        .pm-paypal  { background: #003087; color: #fff; }
        .pm-bank    { background: #1a202c; color: var(--accent); }
        .pm-card    { background: linear-gradient(135deg,#7c3aed,#2563eb); color: #fff; }
        .pm-info .pm-name { font-size: 14px; font-weight: 700; color: var(--text); }
        .pm-info .pm-desc { font-size: 12px; color: var(--muted); margin-top: 2px; }
        .pm-check { margin-left: auto; width: 20px; height: 20px; border-radius: 50%; border: 2px solid var(--border); display: flex; align-items: center; justify-content: center; transition: all 0.15s; }
        .payment-option.selected .pm-check { border-color: var(--accent); background: var(--accent); }
        .payment-option.selected .pm-check::after { content: '\f00c'; font-family: 'Font Awesome 6 Free'; font-weight: 900; font-size: 9px; color: #062023; }

        /* card fields */
        .card-fields { display: none; padding: 16px; background: var(--bg); border-radius: 10px; margin-top: 10px; }
        .card-fields.show { display: block; animation: fadeIn 0.2s ease; }
        .card-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }

        /* ── SUCCESS STEP ── */
        .success-wrap {
            text-align: center;
            padding: 20px 0 10px;
        }
        .success-icon-wrap {
            width: 90px; height: 90px;
            border-radius: 50%;
            background: rgba(34,197,94,0.1);
            border: 3px solid rgba(34,197,94,0.3);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 24px;
            animation: popIn 0.5s cubic-bezier(0.34,1.26,0.64,1);
        }
        @keyframes popIn { from { transform: scale(0.5); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .success-icon-wrap i { font-size: 40px; color: var(--success); }
        .success-wrap h2 { font-family: 'Syne', sans-serif; font-size: 26px; font-weight: 800; color: var(--text); margin-bottom: 8px; }
        .success-wrap p { font-size: 15px; color: var(--muted); margin-bottom: 28px; line-height: 1.6; }
        .order-ref {
            display: inline-block;
            background: var(--bg); border: 1.5px solid var(--border);
            border-radius: 10px; padding: 12px 24px;
            font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 800;
            color: var(--text); letter-spacing: 1px;
            margin-bottom: 28px;
        }
        .order-ref small { display: block; font-family: 'DM Sans', sans-serif; font-size: 11px; font-weight: 500; color: var(--muted); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .next-steps { display: flex; flex-direction: column; gap: 12px; text-align: left; margin-bottom: 28px; }
        .next-step-item {
            display: flex; gap: 14px; align-items: flex-start;
            padding: 14px 16px;
            background: var(--bg); border-radius: 10px;
            border: 1px solid var(--border);
        }
        .ns-icon { width: 36px; height: 36px; border-radius: 8px; background: var(--accent-glow); display: flex; align-items: center; justify-content: center; color: var(--accent-dark); font-size: 15px; flex-shrink: 0; }
        .ns-text h4 { font-size: 14px; font-weight: 700; color: var(--text); margin-bottom: 2px; }
        .ns-text p  { font-size: 13px; color: var(--muted); }
        .success-actions { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }

        /* ── BUTTONS ── */
        .btn {
            display: inline-flex; align-items: center; justify-content: center; gap: 8px;
            padding: 12px 24px;
            border-radius: 10px;
            font-size: 15px; font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; border: none;
            transition: all 0.15s;
            text-decoration: none;
        }
        .btn-primary {
            background: var(--accent); color: #062023;
            box-shadow: 0 4px 18px rgba(72,229,194,0.22);
        }
        .btn-primary:hover { background: var(--accent-dark); transform: translateY(-1px); }
        .btn-outline {
            background: transparent; border: 1.5px solid var(--border); color: var(--text);
        }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent-dark); }
        .btn-full { width: 100%; }
        .btn-nav { display: flex; gap: 10px; margin-top: 8px; }

        /* ── ORDER SIDEBAR ── */
        .sidebar-card { background: var(--card); border-radius: 16px; border: 1px solid var(--border); padding: 22px; box-shadow: 0 2px 10px rgba(15,23,42,0.04); margin-bottom: 16px; }
        .sidebar-card h4 { font-family: 'Syne', sans-serif; font-size: 15px; font-weight: 800; color: var(--text); margin-bottom: 16px; }

        .price-breakdown { display: flex; flex-direction: column; gap: 10px; }
        .price-row { display: flex; justify-content: space-between; align-items: center; font-size: 14px; }
        .price-row .pr-label { color: var(--muted); }
        .price-row .pr-value { font-weight: 600; color: var(--text); }
        .price-divider { height: 1px; background: var(--border); margin: 4px 0; }
        .price-total { font-size: 16px; font-weight: 700; }
        .price-total .pr-label { color: var(--text); }
        .price-total .pr-value { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; color: var(--accent-dark); }

        .guarantee-item { display: flex; align-items: flex-start; gap: 10px; font-size: 13px; color: #334155; margin-bottom: 10px; }
        .guarantee-item:last-child { margin-bottom: 0; }
        .guarantee-item i { color: var(--accent-dark); margin-top: 2px; flex-shrink: 0; }

        /* ── ALERT ── */
        .alert { display: none; padding: 12px 16px; border-radius: 9px; font-size: 13px; font-weight: 500; margin-bottom: 16px; align-items: center; gap: 9px; }
        .alert.show { display: flex; }
        .alert-error   { background: rgba(239,68,68,0.08);  border: 1px solid rgba(239,68,68,0.2);  color: var(--danger); }
        .alert-success { background: rgba(34,197,94,0.08);  border: 1px solid rgba(34,197,94,0.2);  color: var(--success); }

        /* ── FOOTER ── */
        .site-footer { background: var(--dark); color: #cbd5e1; padding: 40px 20px 22px; }
        .footer-inner { max-width: 1200px; margin: 0 auto; display: flex; gap: 24px; flex-wrap: wrap; justify-content: space-between; }
        .footer-col { min-width: 150px; flex: 1; margin-bottom: 16px; }
        .footer-col h4 { color: #fff; margin-bottom: 12px; font-family: 'Syne', sans-serif; font-size: 14px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 8px; }
        .footer-col a { color: #94a3b8; text-decoration: none; font-size: 13px; transition: color 0.15s; }
        .footer-col a:hover { color: var(--accent); }
        .footer-brand .logo { font-family: 'Syne', sans-serif; font-size: 19px; font-weight: 800; color: var(--accent); text-decoration: none; }
        .footer-brand p { color: #64748b; font-size: 13px; margin-top: 8px; line-height: 1.6; }
        .footer-bottom { max-width: 1200px; margin: 18px auto 0; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; font-size: 12px; color: #475569; flex-wrap: wrap; gap: 8px; }
        .footer-links { display: flex; gap: 12px; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 12px; }
        .footer-links a:hover { color: var(--accent); }

        /* ── RESPONSIVE ── */
        @media (max-width: 860px) {
            .page-wrap { grid-template-columns: 1fr; }
            .order-sidebar { position: static; }
            .pkg-selector { grid-template-columns: 1fr; }
            .deadline-row { grid-template-columns: 1fr; }
            .card-row { grid-template-columns: 1fr; }
        }
        @media (max-width: 520px) {
            .stepper { overflow-x: auto; }
            .step-label { display: none; }
            .header { padding: 0 16px; }
        }

        /* ── ESCROW MODAL SHELL ── */
        .order-modal-backdrop {
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.45);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 500; padding: 20px;
            padding-top: 82px; /* clears fixed header */
        }
        .order-modal {
            background: var(--card);
            border-radius: 20px;
            width: 100%; max-width: 1060px;
            max-height: 88vh;
            overflow-y: auto;
            box-shadow: 0 24px 60px rgba(0,0,0,0.2);
            display: grid;
            grid-template-rows: auto auto 1fr;
        }
        .order-modal-header {
            background: linear-gradient(135deg, #0f766e, #0d9488);
            border-radius: 20px 20px 0 0;
            padding: 20px 28px;
            display: flex; align-items: center; justify-content: space-between;
            color: #fff;
        }
        .omh-left { display: flex; align-items: center; gap: 12px; }
        .omh-left .omh-icon { font-size: 1.6rem; }
        .omh-left h2 { font-size: 1.15rem; font-weight: 800; margin-bottom: 2px; font-family: 'Syne', sans-serif; }
        .omh-left p  { font-size: 0.78rem; opacity: 0.8; }
        .omh-close {
            background: rgba(255,255,255,0.15); border: none; color: #fff;
            width: 32px; height: 32px; border-radius: 50%;
            cursor: pointer; font-size: 1rem;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.2s; text-decoration: none;
        }
        .omh-close:hover { background: rgba(255,255,255,0.3); }

        /* ── MODAL STEPPER ── */
        .order-modal-stepper {
            display: flex; align-items: center; justify-content: center;
            padding: 16px 28px; gap: 0;
            border-bottom: 1px solid var(--border);
            background: var(--card);
            flex-wrap: wrap;
        }
        .oms-step {
            display: flex; align-items: center; gap: 7px;
            padding: 7px 14px; border-radius: 8px;
            font-size: 12px; font-weight: 600; color: var(--muted);
            border: 1.5px solid var(--border);
            background: var(--bg);
            transition: all 0.2s; white-space: nowrap;
        }
        .oms-step.active { background: var(--accent); color: #062023; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(72,229,194,0.2); }
        .oms-step.done   { background: rgba(72,229,194,0.1); color: var(--accent-dark); border-color: rgba(72,229,194,0.35); }
        .oms-arrow { color: var(--border); margin: 0 5px; font-size: 11px; flex-shrink: 0; }
        .order-modal-body { padding: 0; }

        @media(max-width:680px){
            .oms-step { padding:5px 9px; font-size:11px; }
            .order-modal-header { padding: 16px 18px; }
        }
    </style>

</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Home.aspx" CssClass="logo-text" Text="SkillLink" />
        <div class="header-right">
            <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/Home.aspx" CssClass="header-link">
                <i class="fas fa-arrow-left"></i> Back to Services
            </asp:HyperLink>
            <span class="secure-badge"><i class="fas fa-lock"></i> Secure Checkout</span>
        </div>
    </div>

    <!-- STEPPER -->
    <div class="stepper-wrap">
        <div class="stepper">
            <div class="step-item active" id="stepItem1">
                <div class="step-num"><span>1</span></div>
                <div class="step-label">Service</div>
            </div>
            <div class="step-connector" id="conn1"></div>
            <div class="step-item" id="stepItem2">
                <div class="step-num"><span>2</span></div>
                <div class="step-label">Requirements</div>
            </div>
            <div class="step-connector" id="conn2"></div>
            <div class="step-item" id="stepItem3">
                <div class="step-num"><span>3</span></div>
                <div class="step-label">Confirm</div>
            </div>
            <div class="step-connector" id="conn3"></div>
            <div class="step-item" id="stepItem4">
                <div class="step-num"><span>4</span></div>
                <div class="step-label">Payment</div>
            </div>
            <div class="step-connector" id="conn4"></div>
            <div class="step-item" id="stepItem5">
                <div class="step-num"><span>5</span></div>
                <div class="step-label">Done</div>
            </div>
        </div>
    </div>

    <!-- MODAL SHELL -->
    <div class="order-modal-backdrop">
    <div class="order-modal">

        <!-- Modal Header -->
        <div class="order-modal-header">
            <div class="omh-left">
                <span class="omh-icon">🛒</span>
                <div>
                    <h2>Place Your Order</h2>
                    <p>Secure checkout — powered by SkillLink</p>
                </div>
            </div>
            <a href="Home.aspx" class="omh-close" title="Close"><i class="fas fa-times"></i></a>
        </div>

        <!-- Modal Stepper -->
        <div class="order-modal-stepper" id="modalStepper">
            <div class="oms-step active" id="omsStep1"><i class="fas fa-search"></i> Service</div>
            <span class="oms-arrow"><i class="fas fa-chevron-right"></i></span>
            <div class="oms-step" id="omsStep2"><i class="fas fa-clipboard-list"></i> Requirements</div>
            <span class="oms-arrow"><i class="fas fa-chevron-right"></i></span>
            <div class="oms-step" id="omsStep3"><i class="fas fa-check-square"></i> Confirm</div>
            <span class="oms-arrow"><i class="fas fa-chevron-right"></i></span>
            <div class="oms-step" id="omsStep4"><i class="fas fa-credit-card"></i> Payment</div>
            <span class="oms-arrow"><i class="fas fa-chevron-right"></i></span>
            <div class="oms-step" id="omsStep5"><i class="fas fa-check-circle"></i> Done</div>
        </div>

        <!-- Modal Body -->
        <div class="order-modal-body">
        <div class="page-wrap">

            <!-- LEFT COLUMN -->
            <div class="order-main">

                <!-- ════ STEP 1: SERVICE DETAILS ════ -->
                <div class="step-panel active" id="panel1">

                <div class="card">
                    <div class="card-title"><i class="fas fa-search"></i> Service Details</div>

                    <asp:Label ID="lblStep1Error" runat="server" CssClass="alert alert-error" />

                    <!-- Service summary pulled from session/querystring -->
                    <div class="service-summary-card">
                        <div class="svc-thumb grad-tech" id="svcThumb">
                            <i class="fas fa-code" id="svcIcon"></i>
                        </div>
                        <div class="svc-info">
                            <h3 id="svcTitle">
                                <asp:Literal ID="litServiceTitle" runat="server" />
                            </h3>
                            <div class="svc-seller">by
                                <asp:Literal ID="litSellerName" runat="server" />
                            </div>
                            <span class="svc-cat"><asp:Literal ID="litCategory" runat="server" /></span>
                        </div>
                    </div>

                    <!-- Package selection -->
                    <div class="card-title" style="font-size:14px;margin-bottom:14px;"><i class="fas fa-box"></i> Choose a Package</div>
                    <div class="pkg-selector">
                        <div class="pkg-option selected" onclick="selectPkg(this, 0)" data-pkg="0">
                            <div class="pkg-opt-name">Basic</div>
                            <div class="pkg-opt-price" id="pkgPrice0">₱<asp:Literal ID="litPriceBasic" runat="server" /></div>
                            <div class="pkg-opt-meta">
                                <span><i class="fas fa-clock"></i> 5 days</span>
                                <span><i class="fas fa-redo"></i> 2 revisions</span>
                            </div>
                        </div>
                        <div class="pkg-option" onclick="selectPkg(this, 1)" data-pkg="1">
                            <div class="pkg-opt-name">Standard</div>
                            <div class="pkg-opt-price" id="pkgPrice1">₱<asp:Literal ID="litPriceStandard" runat="server" /></div>
                            <div class="pkg-opt-meta">
                                <span><i class="fas fa-clock"></i> 3 days</span>
                                <span><i class="fas fa-redo"></i> 5 revisions</span>
                            </div>
                        </div>
                        <div class="pkg-option" onclick="selectPkg(this, 2)" data-pkg="2">
                            <div class="pkg-opt-name">Premium</div>
                            <div class="pkg-opt-price" id="pkgPrice2">₱<asp:Literal ID="litPricePremium" runat="server" /></div>
                            <div class="pkg-opt-meta">
                                <span><i class="fas fa-clock"></i> 1 day</span>
                                <span><i class="fas fa-infinity"></i> Unlimited</span>
                            </div>
                        </div>
                    </div>

                    <div class="btn-nav">
                        <button type="button" class="btn btn-primary btn-full" onclick="goStep(2)">
                            Continue to Requirements <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- ════ STEP 2: REQUIREMENTS ════ -->
            <div class="step-panel" id="panel2">
                <div class="card">
                    <div class="card-title"><i class="fas fa-clipboard-list"></i> Project Requirements</div>

                    <asp:Label ID="lblStep2Error" runat="server" CssClass="alert alert-error" />

                    <div class="form-group">
                        <label>Project Title <span class="req">*</span></label>
                        <asp:TextBox ID="txtProjectTitle" runat="server" CssClass="form-input" placeholder="Give your project a short name" />
                    </div>

                    <div class="form-group">
                        <label>Describe Your Requirements <span class="req">*</span></label>
                        <asp:TextBox ID="txtRequirements" runat="server" TextMode="MultiLine" CssClass="form-textarea"
                            placeholder="Be as specific as possible — include style preferences, target audience, key messages, examples you like, etc."
                            oninput="updateCharCount(this, 'reqCount', 1000)" />
                        <div class="char-count"><span id="reqCount">0</span> / 1000</div>
                    </div>

                    <div class="deadline-row">
                        <div class="form-group">
                            <label>Preferred Deadline</label>
                            <asp:TextBox ID="txtDeadline" runat="server" CssClass="form-input" TextMode="Date" />
                        </div>
                        <div class="form-group">
                            <label>Communication Preference</label>
                            <asp:DropDownList ID="ddlComm" runat="server" CssClass="form-select">
                                <asp:ListItem Value="chat" Text="Chat / Messages" />
                                <asp:ListItem Value="email" Text="Email" />
                                <asp:ListItem Value="video" Text="Video Call" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Additional Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" CssClass="form-textarea"
                            placeholder="Anything else the freelancer should know?" style="min-height:70px;" />
                    </div>

                    <div class="btn-nav">
                        <button type="button" class="btn btn-outline" onclick="goStep(1)"><i class="fas fa-arrow-left"></i> Back</button>
                        <button type="button" class="btn btn-primary" style="flex:1;" onclick="validateStep2()">
                            Review Order <i class="fas fa-arrow-right"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- ════ STEP 3: CONFIRM ORDER ════ -->
            <div class="step-panel" id="panel3">
                <div class="card">
                    <div class="card-title"><i class="fas fa-check-square"></i> Review &amp; Confirm</div>

                    <!-- Service info -->
                    <div style="margin-bottom:4px;font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;">Service</div>
                    <div class="confirm-line">
                        <span class="cl-label">Title</span>
                        <span class="cl-value" id="confTitle">—</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Freelancer</span>
                        <span class="cl-value" id="confSeller">—</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Package</span>
                        <span class="cl-value" id="confPkg">—</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Delivery Time</span>
                        <span class="cl-value" id="confDelivery">—</span>
                    </div>

                    <!-- Requirements summary -->
                    <div style="margin:16px 0 4px;font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;">Your Requirements</div>
                    <div class="confirm-line">
                        <span class="cl-label">Project Title</span>
                        <span class="cl-value" id="confProjTitle">—</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Deadline</span>
                        <span class="cl-value" id="confDeadline">—</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Communication</span>
                        <span class="cl-value" id="confComm">—</span>
                    </div>

                    <!-- Price breakdown -->
                    <div style="margin:16px 0 4px;font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;">Price Breakdown</div>
                    <div class="confirm-line">
                        <span class="cl-label">Service Fee</span>
                        <span class="cl-value" id="confServiceFee">₱0</span>
                    </div>
                    <div class="confirm-line">
                        <span class="cl-label">Platform Fee (5%)</span>
                        <span class="cl-value" id="confPlatformFee">₱0</span>
                    </div>
                    <div class="confirm-line total">
                        <span class="cl-label">Total</span>
                        <span class="cl-value" id="confTotal">₱0</span>
                    </div>

                    <div class="btn-nav" style="margin-top:20px;">
                        <button type="button" class="btn btn-outline" onclick="goStep(2)"><i class="fas fa-arrow-left"></i> Edit</button>
                        <button type="button" class="btn btn-primary" style="flex:1;" onclick="goStep(4)">
                            <i class="fas fa-lock"></i> Proceed to Payment
                        </button>
                    </div>
                </div>
            </div>

            <!-- ════ STEP 4: PAYMENT ════ -->
            <div class="step-panel" id="panel4">
                <div class="card">
                    <div class="card-title"><i class="fas fa-credit-card"></i> Payment</div>

                    <asp:Label ID="lblPayError" runat="server" CssClass="alert alert-error" />

                    <div class="payment-methods" id="paymentMethods">
                        <div class="payment-option selected" onclick="selectPayment(this,'gcash')">
                            <input type="radio" name="payment" value="gcash" checked=""/>
                            <div class="pm-icon pm-gcash"><i class="fas fa-mobile-alt"></i></div>
                            <div class="pm-info">
                                <div class="pm-name">GCash</div>
                                <div class="pm-desc">Pay instantly via GCash e-wallet</div>
                            </div>
                            <div class="pm-check"></div>
                        </div>
                        <div class="payment-option" onclick="selectPayment(this,'paypal')">
                            <input type="radio" name="payment" value="paypal" />
                            <div class="pm-icon pm-paypal"><i class="fab fa-paypal"></i></div>
                            <div class="pm-info">
                                <div class="pm-name">PayPal</div>
                                <div class="pm-desc">Pay securely with your PayPal account</div>
                            </div>
                            <div class="pm-check"></div>
                        </div>
                        <div class="payment-option" onclick="selectPayment(this,'bank')">
                            <input type="radio" name="payment" value="bank" />
                            <div class="pm-icon pm-bank"><i class="fas fa-university"></i></div>
                            <div class="pm-info">
                                <div class="pm-name">Bank Transfer</div>
                                <div class="pm-desc">Direct bank transfer (BDO, BPI, UnionBank)</div>
                            </div>
                            <div class="pm-check"></div>
                        </div>
                        <div class="payment-option" onclick="selectPayment(this,'card')">
                            <input type="radio" name="payment" value="card" />
                            <div class="pm-icon pm-card"><i class="fas fa-credit-card"></i></div>
                            <div class="pm-info">
                                <div class="pm-name">Credit / Debit Card</div>
                                <div class="pm-desc">Visa, Mastercard, JCB</div>
                            </div>
                            <div class="pm-check"></div>
                        </div>
                    </div>

                    <!-- Card fields (shown only when card is selected) -->
                    <div class="card-fields" id="cardFields">
                        <div class="form-group">
                            <label>Card Number</label>
                            <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-input" placeholder="1234 5678 9012 3456" MaxLength="19" />
                        </div>
                        <div class="card-row">
                            <div class="form-group">
                                <label>Expiry Date</label>
                                <asp:TextBox ID="txtCardExpiry" runat="server" CssClass="form-input" placeholder="MM / YY" MaxLength="7" />
                            </div>
                            <div class="form-group">
                                <label>CVV</label>
                                <asp:TextBox ID="txtCardCVV" runat="server" CssClass="form-input" placeholder="123" MaxLength="4" TextMode="Password" />
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Name on Card</label>
                            <asp:TextBox ID="txtCardName" runat="server" CssClass="form-input" placeholder="Full name as printed on card" />
                        </div>
                    </div>

                    <!-- Hidden fields to pass data to server -->
                    <asp:HiddenField ID="hdnPackage"       runat="server" />
                    <asp:HiddenField ID="hdnPrice"         runat="server" />
                    <asp:HiddenField ID="hdnPaymentMethod" runat="server" />
                    <asp:HiddenField ID="hdnOrderRef"      runat="server" />
                    <asp:HiddenField ID="hdnSellerEmail"   runat="server" />

                    <div style="margin-top:20px;">
                        <asp:Button ID="btnPlaceOrder" runat="server" Text="Done"
                            CssClass="btn btn-primary btn-full"
                            OnClick="btnPlaceOrder_Click"
                            OnClientClick="return prepareOrder();"
                            Style="display:none;" />

                        <button type="button" class="btn btn-primary btn-full" onclick="if(prepareOrder()){simulatePayment();}">
                            <i class="fas fa-lock"></i> Place Order &amp; Pay
                        </button>
                    </div>

                    <div style="display:flex;align-items:center;justify-content:center;gap:8px;margin-top:16px;font-size:12px;color:var(--muted);">
                        <i class="fas fa-shield-alt" style="color:var(--accent-dark);"></i>
                        Your payment is protected by SkillLink's Money-Back Guarantee
                    </div>

                    <div style="margin-top:12px;">
                        <button type="button" class="btn btn-outline btn-full" onclick="goStep(3)" style="font-size:13px;padding:9px;">
                            <i class="fas fa-arrow-left"></i> Back to Confirm
                        </button>
                    </div>
                </div>
            </div>

            <!-- ════ STEP 5: SUCCESS ════ -->
            <div class="step-panel" id="panel5">
                <div class="card">
                    <div class="success-wrap">
                        <div class="success-icon-wrap">
                            <i class="fas fa-check"></i>
                        </div>
                        <h2>Order Placed Successfully!</h2>
                        <p>Your order has been confirmed and the freelancer has been notified.<br />You can track your order progress in <strong>My Orders</strong>.</p>

                        <div class="order-ref">
                            <small>Order Reference</small>
                            <asp:Literal ID="litOrderRef" runat="server" />
                        </div>

                        <div class="next-steps">
                            <div class="next-step-item">
                                <div class="ns-icon"><i class="fas fa-bell"></i></div>
                                <div class="ns-text">
                                    <h4>Freelancer Notified</h4>
                                    <p>The freelancer has received your order and will begin shortly.</p>
                                </div>
                            </div>
                            <div class="next-step-item">
                                <div class="ns-icon"><i class="fas fa-comments"></i></div>
                                <div class="ns-text">
                                    <h4>Communicate via Messages</h4>
                                    <p>Use the inbox to share additional details or ask questions.</p>
                                </div>
                            </div>
                            <div class="next-step-item">
                                <div class="ns-icon"><i class="fas fa-box-open"></i></div>
                                <div class="ns-text">
                                    <h4>Track Your Order</h4>
                                    <p>Monitor progress and receive updates in My Orders.</p>
                                </div>
                            </div>
                            <div class="next-step-item">
                                <div class="ns-icon"><i class="fas fa-star"></i></div>
                                <div class="ns-text">
                                    <h4>Review After Delivery</h4>
                                    <p>Once delivered, leave a rating and review to help the community.</p>
                                </div>
                            </div>
                        </div>

                        <div class="success-actions">
                            <a href="Profile.aspx?tab=orders" class="btn btn-primary"><i class="fas fa-clipboard-list"></i> View My Orders</a>
                            <a href="Home.aspx"    class="btn btn-outline"><i class="fas fa-search"></i> Browse More</a>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- RIGHT SIDEBAR -->
        <div class="order-sidebar">
            <div class="sidebar-card">
                <h4>Order Summary</h4>

                <%-- Service name shown at top of sidebar --%>
                <div style="padding:10px 14px;background:#f8fafc;border-radius:8px;border:1px solid var(--border);margin-bottom:14px;">
                    <div style="font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;font-weight:600;margin-bottom:4px;">Service</div>
                    <div id="sideSvcTitle" style="font-size:13px;font-weight:700;color:var(--text);line-height:1.4;">—</div>
                    <div id="sideSvcSeller" style="font-size:12px;color:var(--muted);margin-top:2px;">—</div>
                </div>

                <div class="price-breakdown">
                    <div class="price-row">
                        <span class="pr-label">Package</span>
                        <span class="pr-value" id="sidePkg">Basic</span>
                    </div>
                    <div class="price-row">
                        <span class="pr-label">Service Fee</span>
                        <span class="pr-value" id="sideServiceFee">₱0</span>
                    </div>
                    <div class="price-row">
                        <span class="pr-label">Platform Fee (5%)</span>
                        <span class="pr-value" id="sidePlatformFee">₱0</span>
                    </div>
                    <div class="price-divider"></div>
                    <div class="price-row price-total">
                        <span class="pr-label">Total</span>
                        <span class="pr-value" id="sideTotal">₱0</span>
                    </div>
                </div>
            </div>

            <div class="sidebar-card">
                <h4>SkillLink Guarantee</h4>
                <div class="guarantee-item"><i class="fas fa-shield-alt"></i> Money-back guarantee if work isn't delivered</div>
                <div class="guarantee-item"><i class="fas fa-lock"></i> Secure, encrypted payments</div>
                <div class="guarantee-item"><i class="fas fa-headset"></i> 24/7 customer support</div>
                <div class="guarantee-item"><i class="fas fa-undo"></i> Free revisions included</div>
            </div>
        </div>

    </div>
    
                </div><!-- /order-main -->
            </div><!-- /order-sidebar -->
        </div><!-- /page-wrap -->
    </div><!-- /order-modal-body -->
</div><!-- /order-modal -->
</div><!-- /order-modal-backdrop -->

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-col footer-brand">
                <a class="logo" href="Home.aspx">SkillLink</a>
                <p>Connect with talented professionals to get work done.</p>
            </div>
        </div>
        <div class="footer-inner footer-bottom">
            <p>© <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
            <div class="footer-links">
                <a>Terms</a>
                <a>Privacy</a>
            </div>
        </div>
    </footer>

</form>


<script>
    /* ═══════════════════════════════════════════
       STATE
    ═══════════════════════════════════════════ */
    // Read base price from the rendered litPriceBasic text (most reliable - already set by server)
    // Falls back to BasePrice property, then URL param
    function getBasePrice() {
        // Try reading from the package price display element first
        var el = document.getElementById('pkgPrice0');
        if (el) {
            var txt = el.textContent || el.innerText || '';
            var num = parseInt(txt.replace(/[^\d]/g, ''), 10);
            if (num > 0) return num;
        }
        // Fallback: server property
        var serverPrice = parseInt('<%= BasePrice %>') || 0;
        if (serverPrice > 0) return serverPrice;
        // Last resort: URL param
        var urlParams = new URLSearchParams(window.location.search);
        return parseInt(urlParams.get('price') || '0', 10) || 0;
    }

    var state = {
        currentStep: 1,
        selectedPkg: 0,
        basePrice: 0,  // set after DOM ready
        pkgNames: ['Basic', 'Standard', 'Premium'],
        pkgDays: ['5 days', '3 days', '1 day'],
        pkgMult: [1, 2, 3],
        payMethod: 'gcash'
    };

    /* ═══════════════════════════════════════════
       INIT
    ═══════════════════════════════════════════ */
    // Server-rendered strings (safe — Literals don't have ClientID)
    var svcTitle = '<%= System.Web.HttpUtility.JavaScriptStringEncode(litServiceTitle.Text) %>';
    var svcSeller = '<%= System.Web.HttpUtility.JavaScriptStringEncode(litSellerName.Text) %>';

    window.addEventListener('DOMContentLoaded', function () {
        // hdnSellerEmail is set server-side in LoadServiceFromDB — do not overwrite from JS.

        // Read base price reliably from rendered DOM
        state.basePrice = getBasePrice();

        // Populate sidebar service info
        var st = document.getElementById('sideSvcTitle');
        var ss = document.getElementById('sideSvcSeller');
        if (st) st.textContent = svcTitle || 'Service';
        if (ss) ss.textContent = svcSeller ? 'by ' + svcSeller : '';

        // Update prices
        updatePrices();

        // Set place order button text
        var btn = document.getElementById('<%= btnPlaceOrder.ClientID %>');
        if (btn) btn.innerHTML = '<i class="fas fa-lock"></i> Place Order &amp; Pay';

        // Pre-select package from modal choice
        var preselectedPkg = parseInt('<%= SelectedPkg %>') || 0;
        if (preselectedPkg > 0) {
            var pkgOpts = document.querySelectorAll('.pkg-option');
            pkgOpts.forEach(function (o) { o.classList.remove('selected'); });
            if (pkgOpts[preselectedPkg]) pkgOpts[preselectedPkg].classList.add('selected');
            state.selectedPkg = preselectedPkg;
            updatePrices();
        }

        // Set today as min date for deadline
        var dd = document.getElementById('<%= txtDeadline.ClientID %>');
        if (dd) {
            var today = new Date();
            today.setDate(today.getDate() + 1);
            dd.min = today.toISOString().split('T')[0];
        }

        // If server placed order successfully, go to step 5
        var ref = '<%= SuccessOrderRef %>';
        if (ref && ref !== '') {
            goStep(5);
        }
    });

    /* ═══════════════════════════════════════════
       STEP NAVIGATION
    ═══════════════════════════════════════════ */
    function goStep(n) {
        // Deactivate all
        for (var i = 1; i <= 5; i++) {
            document.getElementById('panel' + i).classList.remove('active');
            var si = document.getElementById('stepItem' + i);
            si.classList.remove('active', 'done');
            if (i < n) si.classList.add('done');
            
            // Sync modal stepper
            var ms = document.getElementById('omsStep' + i);
            if (ms) {
                ms.classList.remove('active', 'done');
                if (i < n) ms.classList.add('done');
            }
        }
        // Active connectors
        for (var j = 1; j <= 4; j++) {
            var c = document.getElementById('conn' + j);
            c.classList.toggle('done', j < n);
        }
        // Activate current
        document.getElementById('panel' + n).classList.add('active');
        document.getElementById('stepItem' + n).classList.add('active');
        var msActive = document.getElementById('omsStep' + n);
        if (msActive) msActive.classList.add('active');
        state.currentStep = n;

        // Populate confirm step
        if (n === 3) populateConfirm();

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }


    /* ═══════════════════════════════════════════
       PACKAGE SELECTION
    ═══════════════════════════════════════════ */
    function selectPkg(el, idx) {
        document.querySelectorAll('.pkg-option').forEach(function (o) { o.classList.remove('selected'); });
        el.classList.add('selected');
        state.selectedPkg = idx;
        if (!state.basePrice) state.basePrice = getBasePrice();
        updatePrices();
    }

    function updatePrices() {
        var base = Math.round(state.basePrice * state.pkgMult[state.selectedPkg]);
        var platform = Math.round(base * 0.05);
        var total = base + platform;

        // Sidebar
        document.getElementById('sidePkg').textContent = state.pkgNames[state.selectedPkg];
        document.getElementById('sideServiceFee').textContent = '₱' + base.toLocaleString();
        document.getElementById('sidePlatformFee').textContent = '₱' + platform.toLocaleString();
        document.getElementById('sideTotal').textContent = '₱' + total.toLocaleString();

        // Store in hidden fields for server
        document.getElementById('<%= hdnPackage.ClientID %>').value = state.pkgNames[state.selectedPkg];
        document.getElementById('<%= hdnPrice.ClientID %>').value   = total;
    }

    /* ═══════════════════════════════════════════
       STEP 2 VALIDATION
    ═══════════════════════════════════════════ */
    function validateStep2() {
        var title = document.getElementById('<%= txtProjectTitle.ClientID %>').value.trim();
        var req   = document.getElementById('<%= txtRequirements.ClientID %>').value.trim();
        if (!title) { showClientError('lblStep2Error', 'Please enter a project title.'); return; }
        if (req.length < 20) { showClientError('lblStep2Error', 'Please describe your requirements (at least 20 characters).'); return; }
        hideClientError('lblStep2Error');
        goStep(3);
    }

    /* ═══════════════════════════════════════════
       POPULATE CONFIRM PAGE
    ═══════════════════════════════════════════ */
    function populateConfirm() {
        var base     = Math.round(state.basePrice * state.pkgMult[state.selectedPkg]);
        var platform = Math.round(base * 0.05);
        var total    = base + platform;

        // Use the JS vars set from server-rendered strings (Literals have no ClientID)
        document.getElementById('confTitle').textContent  = svcTitle  || '—';
        document.getElementById('confSeller').textContent = svcSeller || '—';
        document.getElementById('confPkg').textContent      = state.pkgNames[state.selectedPkg];
        document.getElementById('confDelivery').textContent = state.pkgDays[state.selectedPkg];

        var projTitle = document.getElementById('<%= txtProjectTitle.ClientID %>').value.trim();
        var deadline  = document.getElementById('<%= txtDeadline.ClientID %>').value;
        var commSel   = document.getElementById('<%= ddlComm.ClientID %>');
        var commText  = commSel ? commSel.options[commSel.selectedIndex].text : '—';

        document.getElementById('confProjTitle').textContent  = projTitle || '—';
        document.getElementById('confDeadline').textContent   = deadline  || 'Flexible';
        document.getElementById('confComm').textContent       = commText;

        document.getElementById('confServiceFee').textContent  = '₱' + base.toLocaleString();
        document.getElementById('confPlatformFee').textContent = '₱' + platform.toLocaleString();
        document.getElementById('confTotal').textContent       = '₱' + total.toLocaleString();
    }

    /* ═══════════════════════════════════════════
       PAYMENT METHOD
    ═══════════════════════════════════════════ */
    function selectPayment(el, method) {
        document.querySelectorAll('.payment-option').forEach(function(o){ o.classList.remove('selected'); });
        el.classList.add('selected');
        state.payMethod = method;
        document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;
        document.getElementById('cardFields').classList.toggle('show', method === 'card');
    }

    function simulatePayment() {
        var method = state.payMethod;
        var total = document.getElementById('sideTotal').textContent;
        var icons = { gcash: 'fa-mobile-alt', paypal: 'fa-paypal fab', bank: 'fa-university', card: 'fa-credit-card' };
        var names = { gcash: 'GCash', paypal: 'PayPal', bank: 'Bank Transfer', card: 'Credit / Debit Card' };

        // Build processing overlay
        var overlay = document.createElement('div');
        overlay.id = 'payOverlay';
        overlay.style.cssText = 'position:fixed;inset:0;background:rgba(13,17,23,0.95);z-index:9999;display:flex;flex-direction:column;align-items:center;justify-content:center;gap:20px;';
        overlay.innerHTML =
            '<div style="width:72px;height:72px;border-radius:50%;border:3px solid rgba(72,229,194,0.2);border-top-color:#48e5c2;animation:spin 0.8s linear infinite;"></div>' +
            '<div style="text-align:center;">' +
            '<p style="color:#48e5c2;font-size:18px;font-weight:700;margin-bottom:6px;">Processing Payment...</p>' +
            '<p style="color:#64748b;font-size:14px;"><i class="fas ' + (icons[method] || 'fa-credit-card') + '" style="margin-right:6px;"></i>' + (names[method] || method) + ' · ' + total + '</p>' +
            '</div>' +
            '<p style="color:#334155;font-size:12px;">Please do not close this window</p>';
        document.body.appendChild(overlay);

        // Add spinner keyframes if not present
        if (!document.getElementById('spinStyle')) {
            var s = document.createElement('style');
            s.id = 'spinStyle';
            s.textContent = '@keyframes spin{to{transform:rotate(360deg)}}';
            document.head.appendChild(s);
        }

        // After 2.5 seconds, remove overlay and submit
        setTimeout(function () {
            document.getElementById('payOverlay').remove();
            document.getElementById('<%= btnPlaceOrder.ClientID %>').click();
        }, 2500);
    }

    /* ═══════════════════════════════════════════
       PRE-SUBMIT (client-side)
    ═══════════════════════════════════════════ */
    function prepareOrder() {
        document.getElementById('<%= hdnPackage.ClientID %>').value       = state.pkgNames[state.selectedPkg];
        document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = state.payMethod;
        var base  = Math.round(state.basePrice * state.pkgMult[state.selectedPkg]);
        var total = base + Math.round(base * 0.05);
        document.getElementById('<%= hdnPrice.ClientID %>').value = total;
        return true;
    }

    /* ═══════════════════════════════════════════
       FILE HANDLING
    ═══════════════════════════════════════════ */
    function handleFiles(input) {
        var files = input.files || input;
        var list = document.getElementById('fileList');
        Array.from(files).forEach(function (f) {
            var item = document.createElement('div');
            item.className = 'file-item';
            item.innerHTML = '<i class="fas fa-file-alt"></i><span class="fname">' + f.name + '</span>'
                + '<span class="fsize">' + (f.size / 1024).toFixed(0) + ' KB</span>'
                + '<button class="fremove" onclick="this.parentNode.remove()"><i class="fas fa-times"></i></button>';
            list.appendChild(item);
        });
    }

    /* ═══════════════════════════════════════════
       CHAR COUNT
    ═══════════════════════════════════════════ */
    function updateCharCount(el, countId, max) {
        var n = el.value.length;
        document.getElementById(countId).textContent = n;
        el.style.borderColor = n > max ? 'var(--danger)' : '';
    }

    /* ═══════════════════════════════════════════
       HELPERS
    ═══════════════════════════════════════════ */
    function showClientError(id, msg) {
        var el = document.getElementById(id);
        if (!el) return;
        el.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + msg;
        el.className = 'alert alert-error show';
    }
    function hideClientError(id) {
        var el = document.getElementById(id);
        if (el) el.className = 'alert alert-error';
    }
</script>
</body>
</html>
