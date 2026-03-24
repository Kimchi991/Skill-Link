<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="Skill_Link.Profile" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Account - SkillLink</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Syne:wght@600;700;800&display=swap" rel="stylesheet" />
    <style>
        :root { --accent:#48e5c2; --accent-dark:#2abfa0; --danger:#e5484d; --warn:#f59e0b; --bg:#f0f4f8; --card:#ffffff; --border:#e2e8f0; --text:#1a202c; --muted:#64748b; --sidebar-w:260px; }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
         body{font-family:'DM Sans',sans-serif;background:var(--card);color:var(--text);min-height:100vh;margin:0;padding:0;}
        .header{display:flex;justify-content:space-between;align-items:center;background:#1a202c;padding:14px 28px;position:sticky;top:0;z-index:100;box-shadow:0 2px 8px rgba(0,0,0,0.18);}
        .logo-text{font-family:'Syne',sans-serif;font-size:22px;font-weight:800;color:var(--accent);text-decoration:none;letter-spacing:-0.5px;}
        .header-right{display:flex;align-items:center;gap:18px;}
        .header-right a{color:#cbd5e1;text-decoration:none;font-size:14px;transition:color 0.15s;}
        .header-right a:hover{color:var(--accent);}
        .page-wrap{display:flex;max-width:1280px;margin:0 auto;padding:28px 28px 48px;gap:24px;align-items:flex-start;}
        .sidebar{flex:0 0 var(--sidebar-w);width:var(--sidebar-w);}
        .profile-card{background:var(--card);border-radius:16px;box-shadow:0 4px 16px rgba(15,23,42,0.07);padding:28px 20px 20px;text-align:center;border:1px solid var(--border);}
        .avatar-wrap{position:relative;display:inline-block;margin-bottom:14px;}
        .avatar-wrap i{font-size:72px;color:var(--accent);}
        .online-dot{position:absolute;bottom:4px;right:4px;width:14px;height:14px;background:#22c55e;border-radius:50%;border:2px solid #fff;}
        .profile-card h2{font-family:'Syne',sans-serif;font-size:18px;font-weight:700;color:var(--text);margin-bottom:4px;}
        .profile-card .email-tag{font-size:12px;color:var(--muted);margin-bottom:6px;}
        .role-badge{display:inline-block;background:rgba(72,229,194,0.12);color:var(--accent-dark);font-size:11px;font-weight:600;padding:3px 10px;border-radius:20px;margin-bottom:18px;text-transform:uppercase;letter-spacing:0.5px;}
        .side-nav{list-style:none;margin-top:4px;}
        .side-nav li+li{margin-top:2px;}
        .side-nav li{position:relative;border-radius:8px;}
        .side-nav li a{display:flex;align-items:center;gap:10px;width:100%;padding:10px 14px;border-radius:8px;font-size:14px;font-weight:500;color:var(--muted);text-decoration:none;transition:background 0.14s,color 0.14s;position:relative;z-index:1;}
        .side-nav li a:hover{background:rgba(72,229,194,0.08);color:var(--accent-dark);}
        .side-nav li.active a{background:rgba(72,229,194,0.12);color:var(--accent-dark);font-weight:600;}
        .side-nav li a i{width:18px;text-align:center;font-size:15px;}
        .nav-badge{position:absolute;top:50%;right:12px;transform:translateY(-50%);font-size:10px;font-weight:700;line-height:1;padding:2px 6px;border-radius:10px;pointer-events:none;z-index:2;}
        .logout-nav-btn{display:flex;align-items:center;gap:10px;width:100%;padding:10px 14px;border-radius:8px;font-size:14px;font-weight:500;font-family:'DM Sans',sans-serif;color:var(--danger);background:none;border:none;cursor:pointer;transition:background 0.14s;text-align:left;}
        .logout-nav-btn:hover{background:rgba(229,72,77,0.08);}
        .main-content{flex:1;min-width:0;}
        .tab-section{display:none;}
        .tab-section.active{display:block;animation:fadeIn 0.2s ease;}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
        .section-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;}
        .section-header h2{font-family:'Syne',sans-serif;font-size:22px;font-weight:700;}
        .card{background:var(--card);border-radius:14px;padding:24px;border:1px solid var(--border);box-shadow:0 2px 8px rgba(15,23,42,0.04);margin-bottom:20px;}
        .card h3{font-family:'Syne',sans-serif;font-size:15px;font-weight:700;color:var(--accent-dark);margin-bottom:16px;padding-bottom:10px;border-bottom:1px solid var(--border);}
        .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
        .info-grid .form-group{min-width:0;}
        .form-group label{display:block;font-size:12px;font-weight:600;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:6px;}
        .profile-input{width:100%;padding:9px 12px;border:1px solid var(--border);border-radius:8px;font-size:14px;font-family:'DM Sans',sans-serif;color:var(--text);background:#f8fafc;transition:border 0.15s;box-sizing:border-box;max-width:100%;}
        .profile-input:focus{outline:none;border-color:var(--accent);background:#fff;}
        .profile-input[readonly]{background:#f1f5f9;color:var(--muted);cursor:default;}
        .btn{display:inline-flex;align-items:center;gap:7px;padding:9px 18px;border-radius:8px;font-size:14px;font-weight:600;font-family:'DM Sans',sans-serif;cursor:pointer;border:none;transition:all 0.15s;text-decoration:none;}
        .btn-primary{background:var(--accent);color:#fff;}
        .btn-primary:hover{background:var(--accent-dark);}
        .btn-outline{background:transparent;border:1.5px solid var(--border);color:var(--text);}
        .btn-outline:hover{border-color:var(--accent);color:var(--accent-dark);}
        .btn-danger{background:var(--danger);color:#fff;}
        .btn-danger:hover{background:#c0393e;}
        .btn-sm{padding:6px 12px;font-size:13px;}
        .badge{display:inline-flex;align-items:center;gap:4px;padding:3px 10px;border-radius:20px;font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:0.4px;}
        .badge-active{background:rgba(34,197,94,0.1);color:#16a34a;}
        .badge-inactive{background:rgba(100,116,139,0.1);color:var(--muted);}
        .badge-ongoing{background:rgba(245,158,11,0.12);color:#d97706;}
        .badge-completed{background:rgba(72,229,194,0.12);color:var(--accent-dark);}
        .badge-pending{background:rgba(99,102,241,0.1);color:#6366f1;}
        .service-list{display:flex;flex-direction:column;gap:14px;}
        .service-item{display:flex;align-items:center;gap:16px;padding:16px;border:1px solid var(--border);border-radius:10px;background:#fafcff;transition:box-shadow 0.15s;}
        .service-item:hover{box-shadow:0 4px 14px rgba(15,23,42,0.07);}
        .service-thumb{width:56px;height:56px;border-radius:8px;display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:22px;color:#fff;}
        .service-info{flex:1;min-width:0;}
        .service-info h4{font-size:14px;font-weight:600;margin-bottom:3px;}
        .service-info p{font-size:12px;color:var(--muted);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
        .service-price{font-size:15px;font-weight:700;color:var(--accent-dark);white-space:nowrap;}
        .service-actions{display:flex;gap:8px;align-items:center;}
        .empty-state{text-align:center;padding:48px 20px;color:var(--muted);}
        .empty-state i{font-size:42px;color:var(--border);display:block;margin-bottom:14px;}
        .empty-state h4{font-family:'Syne',sans-serif;font-size:16px;color:var(--text);margin-bottom:6px;}
        .orders-table{width:100%;border-collapse:collapse;font-size:14px;}
        .orders-table th{background:#f8fafc;padding:10px 14px;text-align:left;font-size:11px;text-transform:uppercase;letter-spacing:0.5px;color:var(--muted);font-weight:600;border-bottom:1px solid var(--border);}
        .orders-table td{padding:12px 14px;border-bottom:1px solid var(--border);vertical-align:middle;}
        .orders-table tr:last-child td{border-bottom:none;}
        .orders-table tr:hover td{background:#f8fcfb;}
        .alert{padding:12px 16px;border-radius:8px;font-size:14px;margin-bottom:16px;display:none;}
        .alert-success{background:rgba(34,197,94,0.1);color:#16a34a;border:1px solid rgba(34,197,94,0.2);}
        .alert-error{background:rgba(229,72,77,0.1);color:var(--danger);border:1px solid rgba(229,72,77,0.2);}
        .alert.show{display:block;}
        .rate-star{transition:color 0.12s,transform 0.1s;}
        .rate-star:hover{transform:scale(1.15);}
        .btn-rate-done{background:rgba(245,158,11,0.08)!important;color:#d97706!important;border-color:rgba(245,158,11,0.3)!important;cursor:default!important;}
        .review-summary{display:flex;align-items:center;gap:28px;padding:20px 24px;background:linear-gradient(135deg,rgba(72,229,194,0.06),rgba(37,99,235,0.04));border-radius:12px;border:1px solid rgba(72,229,194,0.18);margin-bottom:20px;flex-wrap:wrap;}
        .review-big-score{text-align:center;min-width:80px;}
        .review-big-score .score-num{font-family:'Syne',sans-serif;font-size:52px;font-weight:800;color:var(--text);line-height:1;}
        .review-big-score .score-stars{display:flex;gap:3px;justify-content:center;margin:6px 0 4px;}
        .review-big-score .score-stars i{font-size:16px;color:#f59e0b;}
        .review-big-score .score-count{font-size:12px;color:var(--muted);}
        .review-divider{width:1px;height:64px;background:var(--border);}
        .review-bars{flex:1;min-width:160px;display:flex;flex-direction:column;gap:6px;}
        .review-bar-row{display:flex;align-items:center;gap:8px;font-size:12px;}
        .review-bar-row .bar-label{width:32px;color:var(--muted);font-weight:600;text-align:right;flex-shrink:0;}
        .review-bar-row .bar-track{flex:1;height:7px;background:#e2e8f0;border-radius:10px;overflow:hidden;}
        .review-bar-row .bar-fill{height:100%;background:#f59e0b;border-radius:10px;transition:width 0.6s ease;}
        .review-bar-row .bar-count{width:24px;color:var(--muted);font-size:11px;text-align:right;flex-shrink:0;}
        .review-list{display:flex;flex-direction:column;gap:14px;}
        .review-card{padding:18px 20px;border:1px solid var(--border);border-radius:12px;background:#fafcff;transition:box-shadow 0.15s;}
        .review-card:hover{box-shadow:0 4px 14px rgba(15,23,42,0.07);}
        .review-card-header{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:10px;gap:12px;}
        .review-card-left{display:flex;align-items:center;gap:12px;}
        .reviewer-avatar{width:40px;height:40px;border-radius:50%;background:linear-gradient(135deg,var(--accent),#2563eb);display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;font-size:15px;flex-shrink:0;}
        .reviewer-name{font-size:14px;font-weight:700;color:var(--text);margin-bottom:2px;}
        .review-service-tag{font-size:11px;color:var(--muted);}
        .review-card-right{text-align:right;flex-shrink:0;}
        .review-stars{display:flex;gap:2px;justify-content:flex-end;margin-bottom:3px;}
        .review-stars i{font-size:13px;color:#f59e0b;}
        .review-date{font-size:11px;color:var(--muted);}
        .review-comment{font-size:13px;color:#334155;line-height:1.65;padding:10px 14px;background:rgba(72,229,194,0.04);border-left:3px solid rgba(72,229,194,0.4);border-radius:0 8px 8px 0;}
        .review-empty{text-align:center;padding:52px 20px;color:var(--muted);}
        .review-empty i{font-size:44px;color:var(--border);display:block;margin-bottom:14px;}
        .sidebar-rating{margin:12px 0 4px;padding:12px 14px;background:rgba(245,158,11,0.06);border:1px solid rgba(245,158,11,0.2);border-radius:10px;text-align:center;}
        .sidebar-rating .sr-stars{display:flex;gap:3px;justify-content:center;margin-bottom:4px;}
        .sidebar-rating .sr-stars i{font-size:15px;color:#f59e0b;}
        .sidebar-rating .sr-score{font-family:'Syne',sans-serif;font-size:20px;font-weight:800;color:var(--text);line-height:1;margin-bottom:2px;}
        .sidebar-rating .sr-count{font-size:11px;color:var(--muted);}
        .sidebar-rating-none{margin:12px 0 4px;font-size:12px;color:var(--muted);text-align:center;padding:8px 0;}
        .svc-grad-tech{background:linear-gradient(135deg,#1e3a5f,#2563eb);}
        .svc-grad-design{background:linear-gradient(135deg,#7c3aed,#db2777);}
        .svc-grad-video{background:linear-gradient(135deg,#1a202c,#e11d48);}
        .svc-grad-audio{background:linear-gradient(135deg,#065f46,#059669);}
        .svc-grad-writing{background:linear-gradient(135deg,#92400e,#f59e0b);}
        .svc-grad-marketing{background:linear-gradient(135deg,#1d4ed8,#0ea5e9);}
        .svc-grad-business{background:linear-gradient(135deg,#134e4a,#14b8a6);}
        .svc-grad-other{background:linear-gradient(135deg,#48e5c2,#2563eb);}
        @keyframes modalIn{from{opacity:0;transform:scale(0.94) translateY(20px);}to{opacity:1;transform:scale(1) translateY(0);}}
        .site-footer{background:#1a202c;color:#cbd5e1;padding:40px 20px 24px;}
        .footer-inner{max-width:1280px;margin:0 auto;display:flex;gap:28px;flex-wrap:wrap;justify-content:space-between;}
        .footer-col{min-width:160px;flex:1;margin-bottom:18px;}
        .footer-col h4{color:#fff;margin-bottom:12px;font-family:'Syne',sans-serif;font-size:15px;}
        .footer-col ul{list-style:none;}
        .footer-col ul li{margin-bottom:8px;}
        .footer-col a{color:#94a3b8;text-decoration:none;font-size:14px;transition:color 0.15s;}
        .footer-col a:hover{color:var(--accent);}
        .footer-brand .logo{font-family:'Syne',sans-serif;font-size:20px;font-weight:800;color:var(--accent);}
        .footer-brand p{color:#94a3b8;font-size:13px;margin-top:8px;line-height:1.6;}
        .socials{display:flex;gap:10px;margin-top:12px;}
        .socials a{width:34px;height:34px;border-radius:6px;background:rgba(255,255,255,0.06);color:#94a3b8;display:inline-flex;align-items:center;justify-content:center;text-decoration:none;transition:background 0.15s,color 0.15s;}
        .socials a:hover{background:var(--accent);color:#062023;}
        .footer-bottom{max-width:1280px;margin:22px auto 0;padding-top:18px;border-top:1px solid rgba(255,255,255,0.06);display:flex;justify-content:space-between;align-items:center;font-size:13px;color:#64748b;flex-wrap:wrap;gap:10px;}
        .footer-links{display:flex;gap:14px;}
        .footer-links a{color:#64748b;text-decoration:none;font-size:13px;}
        .footer-links a:hover{color:var(--accent);}
        @media(max-width:900px){.page-wrap{flex-direction:column;}.sidebar{width:100%;}.info-grid{grid-template-columns:1fr;}}
        @media(max-width:600px){.info-grid{grid-template-columns:1fr;}.card{padding:16px;}.page-wrap{padding:16px;}}
        @media(max-width:520px){.orders-table{font-size:12px;}}
    </style>
</head>
<body>
<form id="form1" runat="server">

    <div class="header">
        <asp:HyperLink ID="lnkHome" runat="server" NavigateUrl="~/Home.aspx" CssClass="logo-text" Text="SkillLink" />
        <div class="header-right">
            <asp:HyperLink ID="lnkBrowse" runat="server" NavigateUrl="~/Home.aspx">
                <i class="fas fa-search"></i> Browse Services
            </asp:HyperLink>
        </div>
    </div>

    <div class="page-wrap">
        <aside class="sidebar">
            <div class="profile-card">
                <div class="avatar-wrap">
                    <i class="fas fa-user-circle"></i>
                    <span class="online-dot"></span>
                </div>
                <h2><asp:Literal ID="litName" runat="server" /></h2>
                <p class="email-tag"><asp:Literal ID="litEmail" runat="server" /></p>
                <span class="role-badge"><asp:Literal ID="litRole" runat="server" /></span>
                <asp:Panel ID="pnlSidebarRating" runat="server" Visible="false">
                    <div class="sidebar-rating">
                        <div class="sr-stars"><asp:Literal ID="litSidebarStars" runat="server" /></div>
                        <div class="sr-score"><asp:Literal ID="litSidebarScore" runat="server" /></div>
                        <div class="sr-count"><asp:Literal ID="litSidebarCount" runat="server" /></div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlSidebarNoRating" runat="server" Visible="true">
                    <div class="sidebar-rating-none"><i class="fas fa-star" style="color:#e2e8f0;margin-right:4px;"></i>No ratings yet</div>
                </asp:Panel>
                <ul class="side-nav">
                    <li class="active" id="navProfile"><a href="javascript:void(0)" onclick="showTab('profile','navProfile')"><i class="fas fa-user"></i> Profile Info</a></li>
                    <asp:Panel ID="pnlNavServices" runat="server">
                        <li id="navServices"><a href="javascript:void(0)" onclick="showTab('services','navServices')"><i class="fas fa-briefcase"></i> My Services</a></li>
                    </asp:Panel>
                    <asp:Panel ID="pnlNavReceived" runat="server">
                        <li id="navReceived">
                            <a href="javascript:void(0)" onclick="showTab('received','navReceived')"><i class="fas fa-inbox"></i> Orders Received</a>
                            <asp:Label ID="lblReceivedBadge" runat="server" CssClass="nav-badge" style="background:var(--danger);color:#fff;" />
                        </li>
                    </asp:Panel>
                    <asp:Panel ID="pnlNavOrders" runat="server">
                        <li id="navOrders"><a href="javascript:void(0)" onclick="showTab('orders','navOrders')"><i class="fas fa-clipboard-list"></i> My Orders</a></li>
                    </asp:Panel>
                    <asp:Panel ID="pnlNavBookings" runat="server">
                        <li id="navBookings">
                            <a href="javascript:void(0)" onclick="showTab('bookings','navBookings')">
                                <i class="fas fa-calendar-check"></i> My Bookings
                            </a>
                            <asp:Label ID="lblBookingBadge" runat="server" CssClass="nav-badge" style="background:var(--accent);color:#062023;" />
                        </li>
                    </asp:Panel>
                    <asp:Panel ID="pnlNavBookingRequests" runat="server">
                        <li id="navBookingRequests">
                            <a href="javascript:void(0)" onclick="showTab('bookingrequests','navBookingRequests')">
                                <i class="fas fa-inbox"></i> Booking Requests
                            </a>
                            <asp:Label ID="lblBookingRequestBadge" runat="server" CssClass="nav-badge" style="background:var(--danger);color:#fff;" />
                        </li>
                    </asp:Panel>
                    <li id="navReviews">
                        <a href="javascript:void(0)" onclick="showTab('reviews','navReviews')"><i class="fas fa-star"></i> My Reviews</a>
                        <asp:Label ID="lblReviewBadge" runat="server" CssClass="nav-badge" style="background:var(--warn);color:#fff;" />
                    </li>
                    <li>
                        <asp:Button ID="btnLogoutSide" runat="server" OnClick="lnkLogout_Click" style="display:none;" />
                        <button type="button" class="logout-nav-btn" onclick="document.getElementById('<%= btnLogoutSide.ClientID %>').click();">
                            <i class="fas fa-sign-out-alt" style="width:18px;text-align:center;font-size:15px;"></i> Logout
                        </button>
                    </li>
                </ul>
            </div>
        </aside>

        <main class="main-content">

            <!-- PROFILE INFO -->
            <div id="tab-profile" class="tab-section active">
                <div class="section-header">
                    <h2>Profile Information</h2>
                    <div style="display:flex;gap:10px;">
                        <asp:Button ID="btnEdit"   runat="server" Text="Edit Profile"  CssClass="btn btn-outline" OnClick="btnEdit_Click" />
                        <asp:Button ID="btnSave"   runat="server" Text="Save Changes"  CssClass="btn btn-primary" OnClick="btnSave_Click"   Visible="false" />
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel"        CssClass="btn btn-outline" OnClick="btnCancel_Click" Visible="false" />
                    </div>
                </div>
                <asp:Label ID="lblMsg" runat="server" CssClass="alert" />
                <div class="card">
                    <h3><i class="fas fa-id-card" style="margin-right:8px;"></i>Basic Information</h3>
                    <div class="info-grid">
                        <div class="form-group"><label>Username</label><asp:TextBox ID="txtName" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>Email Address</label><asp:TextBox ID="txtEmail" runat="server" CssClass="profile-input" ReadOnly="true" /></div>
                        <div class="form-group"><label>First Name</label><asp:TextBox ID="txtFirstName" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>Last Name</label><asp:TextBox ID="txtLastName" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>Date of Birth</label><asp:TextBox ID="txtDOB" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>Phone Number</label><asp:TextBox ID="txtPhone" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group" style="grid-column:1/-1;">
                            <label>Skills <span style="font-weight:400;text-transform:none;color:var(--muted);font-size:11px;">(comma separated — e.g. React, Node.js, Figma)</span></label>
                            <asp:TextBox ID="txtSkills" runat="server" CssClass="profile-input" placeholder="e.g. React, Node.js, Azure SQL, Figma" />
                        </div>
                    </div>
                </div>
                <div class="card">
                    <h3><i class="fas fa-map-marker-alt" style="margin-right:8px;"></i>Location</h3>
                    <div class="info-grid">
                        <div class="form-group"><label>Country</label><asp:TextBox ID="txtCountry" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>City</label><asp:TextBox ID="txtCity" runat="server" CssClass="profile-input" /></div>
                        <div class="form-group"><label>Postal Code</label><asp:TextBox ID="txtPostalCode" runat="server" CssClass="profile-input" /></div>
                    </div>
                </div>
            </div>

            <!-- MY SERVICES -->
            <div id="tab-services" class="tab-section">
                <div class="section-header">
                    <h2>My Services</h2>
                    <a href="Freelancer.aspx" class="btn btn-primary"><i class="fas fa-plus"></i> Add New Service</a>
                </div>
                <asp:Label ID="lblServiceMsg" runat="server" CssClass="alert" />
                <div class="card">
                    <h3><i class="fas fa-briefcase" style="margin-right:8px;"></i>Posted Services
                        <asp:Label ID="lblServiceCount" runat="server" style="font-family:'DM Sans',sans-serif;font-size:12px;font-weight:600;background:rgba(72,229,194,0.12);color:var(--accent-dark);padding:2px 10px;border-radius:20px;margin-left:8px;vertical-align:middle;" />
                    </h3>
                    <div class="service-list">
                        <asp:Repeater ID="rptMyServices" runat="server" OnItemCommand="rptMyServices_ItemCommand">
                            <ItemTemplate>
                                <div class="service-item">
                                    <div class="service-thumb <%# ((Skill_Link.Profile)Page).GetServiceGradientClass(Eval("Category").ToString()) %>">
                                        <i class="<%# ((Skill_Link.Profile)Page).GetServiceIcon(Eval("Category").ToString()) %>"></i>
                                    </div>
                                    <div class="service-info">
                                        <h4><%# Server.HtmlEncode(Eval("Title").ToString()) %></h4>
                                        <p><%# Server.HtmlEncode(Eval("Category").ToString()) %> &middot; <%# Server.HtmlEncode(Eval("Description").ToString().Length > 60 ? Eval("Description").ToString().Substring(0,60) + "..." : Eval("Description").ToString()) %></p>
                                    </div>
                                    <span class="badge badge-active">Active</span>
                                    <span class="service-price">&#8369;<%# string.Format("{0:N0}", Eval("Price")) %></span>
                                    <div class="service-actions">
                                        <asp:LinkButton runat="server" CommandName="DeleteService" CommandArgument='<%# Eval("ServiceID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Delete this service?');"><i class="fas fa-trash"></i></asp:LinkButton>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <asp:Panel ID="pnlNoServices" runat="server" Visible="false" CssClass="empty-state">
                        <i class="fas fa-folder-open"></i>
                        <h4>No services posted yet</h4>
                        <p>Click <strong>Add New Service</strong> to publish your first offering.</p>
                    </asp:Panel>
                </div>
            </div>

            <!-- ORDERS RECEIVED -->
            <div id="tab-received" class="tab-section">
                <div class="section-header">
                    <h2>Orders Received</h2>
                    <asp:Label ID="lblReceivedCount" runat="server" style="font-size:12px;font-weight:600;background:rgba(72,229,194,0.12);color:var(--accent-dark);padding:2px 10px;border-radius:20px;" />
                </div>
                <asp:Label ID="lblReceivedMsg" runat="server" CssClass="alert" />
                <div class="card" style="padding:0;overflow:hidden;">
                    <div style="overflow-x:auto;">
                        <table class="orders-table">
                            <thead><tr><th>Order Ref</th><th>Client</th><th>Service</th><th>Date</th><th>Total</th><th>Status</th><th>Actions</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptReceived" runat="server" OnItemCommand="rptReceived_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong style="font-family:'Syne',sans-serif;font-size:12px;"><%# Eval("OrderRef") %></strong></td>
                                            <td>
                                                <div style="font-size:13px;font-weight:600;"><%# Server.HtmlEncode(Eval("UserEmail").ToString().Split('@')[0]) %></div>
                                                <div style="font-size:11px;color:var(--muted);"><%# Server.HtmlEncode(Eval("UserEmail").ToString()) %></div>
                                            </td>
                                            <td>
                                                <div style="max-width:140px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-size:13px;font-weight:600;"><%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %></div>
                                                <div style="font-size:11px;color:var(--muted);"><%# Eval("Package") %> package</div>
                                            </td>
                                            <td style="font-size:12px;color:var(--muted);"><%# ((Skill_Link.Profile)Page).FormatDate(Eval("OrderDate")) %></td>
                                            <td><strong style="color:var(--accent-dark);">&#8369;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong></td>
                                            <td><span class="<%# ((Skill_Link.Profile)Page).GetStatusBadge(Eval("Status").ToString()) %>"><i class="<%# ((Skill_Link.Profile)Page).GetStatusIcon(Eval("Status").ToString()) %>"></i> <%# Eval("Status") %></span></td>
                                            <td>
                                                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                                    <button type="button" class="btn btn-outline btn-sm view-order-btn"
                                                        data-ref="<%# Server.HtmlEncode(Eval("OrderRef").ToString()) %>"
                                                        data-client="<%# Server.HtmlEncode(Eval("UserEmail").ToString()) %>"
                                                        data-service="<%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %>"
                                                        data-projtitle="<%# Server.HtmlEncode(Eval("ProjectTitle").ToString()) %>"
                                                        data-reqs="<%# Server.HtmlEncode(Eval("Requirements").ToString()) %>"
                                                        data-notes="<%# Server.HtmlEncode((Eval("Notes") ?? "").ToString()) %>"
                                                        data-deadline="<%# ((Skill_Link.Profile)Page).FormatDate(Eval("Deadline")) %>"
                                                        data-comm="<%# Server.HtmlEncode(Eval("Communication").ToString()) %>"
                                                        data-pkg="<%# Server.HtmlEncode(Eval("Package").ToString()) %>"
                                                        data-total="<%# string.Format("{0:N0}", Eval("TotalAmount")) %>"
                                                        data-status="<%# Server.HtmlEncode(Eval("Status").ToString()) %>">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                    <asp:LinkButton runat="server" Visible='<%# Eval("Status").ToString() == "Pending" %>' CommandName="AcceptOrder" CommandArgument='<%# Eval("OrderRef") %>' CssClass="btn btn-sm" style="background:rgba(34,197,94,0.1);color:#16a34a;border:1px solid rgba(34,197,94,0.3);" OnClientClick="return confirm('Accept this order?');"><i class="fas fa-check"></i> Accept</asp:LinkButton>
                                                    <asp:LinkButton runat="server" Visible='<%# Eval("Status").ToString() == "In Progress" %>' CommandName="DeliverOrder" CommandArgument='<%# Eval("OrderRef") %>' CssClass="btn btn-sm" style="background:rgba(72,229,194,0.12);color:var(--accent-dark);border:1px solid rgba(72,229,194,0.3);" OnClientClick="return confirm('Mark as Delivered?');"><i class="fas fa-paper-plane"></i> Deliver</asp:LinkButton>
                                                    <asp:LinkButton runat="server" Visible='<%# Eval("Status").ToString() == "Pending" %>' CommandName="RejectOrder" CommandArgument='<%# Eval("OrderRef") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Reject this order?');"><i class="fas fa-times"></i> Reject</asp:LinkButton>
                                                    <button type="button"
                                                        class="btn btn-sm <%# ((Skill_Link.Profile)Page).HasRatedClient(Eval("OrderRef").ToString(), Session["UserEmail"].ToString()) ? "btn-rate-done" : "open-rate-client-btn btn-outline" %>"
                                                        <%# Eval("Status").ToString() == "Completed" ? "" : "style=\"display:none;\"" %>
                                                        data-ref="<%# Server.HtmlEncode(Eval("OrderRef").ToString()) %>"
                                                        data-client="<%# Server.HtmlEncode(Eval("UserEmail").ToString()) %>"
                                                        data-service="<%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %>">
                                                        <i class="fas fa-star" style="color:#f59e0b;"></i>
                                                        <%# ((Skill_Link.Profile)Page).HasRatedClient(Eval("OrderRef").ToString(), Session["UserEmail"].ToString()) ? "Client Rated" : "Rate Client" %>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <asp:Panel ID="pnlNoReceived" runat="server" Visible="false" CssClass="empty-state" style="padding:48px 24px;">
                        <i class="fas fa-inbox"></i><h4>No orders received yet</h4>
                        <p>When clients purchase your services, their orders will appear here.</p>
                    </asp:Panel>
                </div>
            </div>

            <!-- MY ORDERS -->
            <div id="tab-orders" class="tab-section">
                <div class="section-header">
                    <h2>My Orders</h2>
                    <asp:Label ID="lblOrderCount" runat="server" style="font-size:12px;font-weight:600;background:rgba(72,229,194,0.12);color:var(--accent-dark);padding:2px 10px;border-radius:20px;" />
                </div>
                <asp:Label ID="lblOrderMsg" runat="server" CssClass="alert" />
                <div class="card" style="padding:0;overflow:hidden;">
                    <div style="overflow-x:auto;">
                        <table class="orders-table">
                            <thead><tr><th>Order Ref</th><th>Service</th><th>Freelancer</th><th>Package</th><th>Ordered</th><th>Deadline</th><th>Total</th><th>Status</th><th>Review</th></tr></thead>
                            <tbody>
                                <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong style="font-family:'Syne',sans-serif;font-size:13px;"><%# Eval("OrderRef") %></strong></td>
                                            <td><div style="max-width:160px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-size:13px;font-weight:600;"><%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %></div></td>
                                            <td style="font-size:13px;color:var(--muted);"><%# Server.HtmlEncode(Eval("SellerName").ToString()) %></td>
                                            <td><span style="font-size:11px;font-weight:700;background:rgba(72,229,194,0.1);color:var(--accent-dark);padding:2px 9px;border-radius:20px;text-transform:uppercase;"><%# Eval("Package") %></span></td>
                                            <td style="font-size:12px;color:var(--muted);"><%# ((Skill_Link.Profile)Page).FormatDate(Eval("OrderDate")) %></td>
                                            <td style="font-size:12px;color:var(--muted);"><%# ((Skill_Link.Profile)Page).FormatDate(Eval("Deadline")) %></td>
                                            <td><strong style="color:var(--accent-dark);">&#8369;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong></td>
                                            <td><span class="<%# ((Skill_Link.Profile)Page).GetStatusBadge(Eval("Status").ToString()) %>"><i class="<%# ((Skill_Link.Profile)Page).GetStatusIcon(Eval("Status").ToString()) %>"></i> <%# Eval("Status") %></span></td>
                                            <td>
                                                <div style="display:flex;flex-direction:column;gap:6px;">

                                                    <%-- Confirm Delivery button: only when Status = Delivered --%>
                                                    <asp:LinkButton
                                                        runat="server"
                                                        Visible='<%# Eval("Status").ToString() == "Delivered" %>'
                                                        CommandName="ConfirmDelivery"
                                                        CommandArgument='<%# Eval("OrderRef") %>'
                                                        CssClass="btn btn-sm"
                                                        style="background:rgba(72,229,194,0.12);color:#2abfa0;border:1px solid rgba(72,229,194,0.3);"
                                                        OnClientClick="return confirm('Confirm that the work has been delivered? This will mark the order as Completed.');">
                                                        <i class="fas fa-check-circle"></i> Confirm Delivery
                                                    </asp:LinkButton>

                                                    <%-- Rate button: when Delivered or Completed --%>
                                                    <%# (Eval("Status").ToString() == "Delivered" || Eval("Status").ToString() == "Completed")
                                                        ? string.Format(
                                                            "<button type=\"button\" class=\"btn btn-sm {0}\" {1} " +
                                                            "data-ref=\"{2}\" data-seller=\"{3}\" data-service=\"{4}\">" +
                                                            "<i class=\"fas fa-star\" style=\"color:#f59e0b;\"></i> {5}</button>",
                                                            ((Skill_Link.Profile)Page).HasRated(Eval("OrderRef").ToString(), Session["UserEmail"].ToString())
                                                                ? "btn-rate-done" : "open-rate-btn btn-outline",
                                                            ((Skill_Link.Profile)Page).HasRated(Eval("OrderRef").ToString(), Session["UserEmail"].ToString())
                                                                ? "disabled" : "",
                                                            Server.HtmlEncode(Eval("OrderRef").ToString()),
                                                            Server.HtmlEncode(!string.IsNullOrEmpty(Eval("SellerEmail") != null ? Eval("SellerEmail").ToString() : "") ? Eval("SellerEmail").ToString() : Eval("SellerName").ToString()),
                                                            Server.HtmlEncode(Eval("ServiceTitle").ToString()),
                                                            ((Skill_Link.Profile)Page).HasRated(Eval("OrderRef").ToString(), Session["UserEmail"].ToString())
                                                                ? "Rated" : "Rate"
                                                        )
                                                        : "<span style=\"color:var(--muted);font-size:12px;\">&mdash;</span>" %>

                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="empty-state" style="padding:52px 24px;">
                        <i class="fas fa-clipboard-list"></i><h4>No orders yet</h4>
                        <p>When you purchase a service it will appear here.</p>
                        <a href="Home.aspx" style="display:inline-flex;align-items:center;gap:8px;margin-top:16px;padding:10px 22px;background:var(--accent);color:#062023;font-weight:700;border-radius:8px;text-decoration:none;"><i class="fas fa-search"></i> Browse Services</a>
                    </asp:Panel>
                </div>
            </div>

            <!-- MY REVIEWS -->
            <div id="tab-reviews" class="tab-section">
                <div class="section-header">
                    <h2>My Reviews</h2>
                    <asp:Label ID="lblReviewCount" runat="server" style="font-size:12px;font-weight:600;background:rgba(245,158,11,0.1);color:#d97706;padding:2px 10px;border-radius:20px;" />
                </div>
                <asp:Panel ID="pnlReviewSummary" runat="server">
                    <div class="review-summary">
                        <div class="review-big-score">
                            <div class="score-num"><asp:Literal ID="litAvgRating" runat="server" /></div>
                            <div class="score-stars"><asp:Literal ID="litAvgStars" runat="server" /></div>
                            <div class="score-count"><asp:Literal ID="litReviewCount" runat="server" /></div>
                        </div>
                        <div class="review-divider"></div>
                        <div class="review-bars"><asp:Literal ID="litBreakdownBars" runat="server" /></div>
                    </div>
                </asp:Panel>
                <div class="card" style="padding:20px;">
                    <h3><i class="fas fa-star" style="margin-right:8px;color:#f59e0b;"></i>Client Reviews</h3>
                    <div class="review-list">
                        <asp:Repeater ID="rptReviews" runat="server">
                            <ItemTemplate>
                                <div class="review-card">
                                    <div class="review-card-header">
                                        <div class="review-card-left">
                                            <div class="reviewer-avatar"><%# Server.HtmlEncode(Eval("ReviewerEmail").ToString().Substring(0,1).ToUpper()) %></div>
                                            <div>
                                                <div class="reviewer-name"><%# Server.HtmlEncode(Eval("ReviewerEmail").ToString().Split('@')[0]) %></div>
                                                <div class="review-service-tag"><%# Server.HtmlEncode(Eval("ServiceTitle") != null ? Eval("ServiceTitle").ToString() : "") %></div>
                                            </div>
                                        </div>
                                        <div class="review-card-right">
                                            <div class="review-stars"><%# ((Skill_Link.Profile)Page).RenderStars(Convert.ToInt32(Eval("Rating"))) %></div>
                                            <div class="review-date"><%# ((Skill_Link.Profile)Page).FormatDate(Eval("CreatedAt")) %></div>
                                        </div>
                                    </div>
                                    <%# !string.IsNullOrWhiteSpace(Eval("Comment") != null ? Eval("Comment").ToString() : "")
                                        ? "<div class=\"review-comment\">" + Server.HtmlEncode(Eval("Comment").ToString()) + "</div>"
                                        : "<div style=\"font-size:12px;color:var(--muted);font-style:italic;\">No comment left.</div>" %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    <asp:Panel ID="pnlNoReviews" runat="server" Visible="false">
                        <div class="review-empty">
                            <i class="fas fa-star"></i>
                            <h4 style="font-family:'Syne',sans-serif;font-size:16px;color:var(--text);margin-bottom:6px;">No reviews yet</h4>
                            <p>Complete orders to start receiving client reviews.</p>
                        </div>
                    </asp:Panel>
                </div>
            </div>
                        <!-- MY BOOKINGS (Client) -->
            <div id="tab-bookings" class="tab-section">
                <div class="section-header">
                    <h2>My Bookings</h2>
                    <asp:Label ID="lblBookingCount" runat="server" style="font-size:12px;font-weight:600;background:rgba(72,229,194,0.12);color:var(--accent-dark);padding:2px 10px;border-radius:20px;" />
                </div>
                <asp:Label ID="lblBookingMsg" runat="server" CssClass="alert" />
                <div class="card" style="padding:0;overflow:hidden;">
                    <div style="overflow-x:auto;">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>Booking Ref</th>
                                    <th>Service</th>
                                    <th>Freelancer</th>
                                    <th>Package</th>
                                    <th>Date</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptMyBookings" runat="server" OnItemCommand="rptMyBookings_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong style="font-family:'Syne',sans-serif;font-size:12px;"><%# Eval("BookingRef") %></strong></td>
                                            <td>
                                                <div style="max-width:160px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;font-size:13px;font-weight:600;">
                                                    <%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %>
                                                </div>
                                            </td>
                                            <td style="font-size:13px;color:var(--muted);">
                                                <%# Server.HtmlEncode(Eval("FreelancerEmail").ToString().Split('@')[0]) %>
                                            </td>
                                            <td>
                                                <span style="font-size:11px;font-weight:700;background:rgba(72,229,194,0.1);color:var(--accent-dark);padding:2px 9px;border-radius:20px;text-transform:uppercase;">
                                                    <%# Eval("Package") %>
                                                </span>
                                            </td>
                                            <td style="font-size:12px;color:var(--muted);">
                                                <%# ((Skill_Link.Profile)Page).FormatDate(Eval("BookingDate")) %>
                                            </td>
                                            <td><strong style="color:var(--accent-dark);">&#8369;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong></td>
                                            <td>
                                                <span class="<%# ((Skill_Link.Profile)Page).GetStatusBadge(Eval("Status").ToString()) %>">
                                                    <i class="<%# ((Skill_Link.Profile)Page).GetStatusIcon(Eval("Status").ToString()) %>"></i>
                                                    <%# Eval("Status") %>
                                                </span>
                                            </td>
                                            <td>
                                                <asp:LinkButton runat="server"
                                                    Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                                    CommandName="CancelBooking"
                                                    CommandArgument='<%# Eval("BookingRef") %>'
                                                    CssClass="btn btn-danger btn-sm"
                                                    OnClientClick="return confirm('Cancel this booking?');">
                                                    <i class="fas fa-times"></i> Cancel
                                                </asp:LinkButton>
                                                <span style='<%# Eval("Status").ToString() == "Pending" ? "display:none;" : "" %>' class="badge <%# ((Skill_Link.Profile)Page).GetStatusBadge(Eval("Status").ToString()) %>">
                                                    <%# Eval("Status") %>
                                                </span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <asp:Panel ID="pnlNoBookings" runat="server" Visible="false" CssClass="empty-state" style="padding:48px 24px;">
                        <i class="fas fa-calendar-check"></i>
                        <h4>No bookings yet</h4>
                        <p>When you book a freelancer it will appear here.</p>
                        <a href="Home.aspx" style="display:inline-flex;align-items:center;gap:8px;margin-top:16px;padding:10px 22px;background:var(--accent);color:#062023;font-weight:700;border-radius:8px;text-decoration:none;">
                            <i class="fas fa-search"></i> Browse Freelancers
                        </a>
                    </asp:Panel>
                </div>
            </div>

            <!-- BOOKING REQUESTS (Freelancer) -->
            <div id="tab-bookingrequests" class="tab-section">
                <div class="section-header">
                    <h2>Booking Requests</h2>
                    <asp:Label ID="lblBookingRequestCount" runat="server" style="font-size:12px;font-weight:600;background:rgba(229,72,77,0.12);color:var(--danger);padding:2px 10px;border-radius:20px;" />
                </div>
                <asp:Label ID="lblBookingRequestMsg" runat="server" CssClass="alert" />
                <div class="card" style="padding:0;overflow:hidden;">
                    <div style="overflow-x:auto;">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>Booking Ref</th>
                                    <th>Client</th>
                                    <th>Service</th>
                                    <th>Project</th>
                                    <th>Date</th>
                                    <th>Package</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptBookingRequests" runat="server" OnItemCommand="rptBookingRequests_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong style="font-family:'Syne',sans-serif;font-size:12px;"><%# Eval("BookingRef") %></strong></td>
                                            <td>
                                                <div style="font-size:13px;font-weight:600;"><%# Server.HtmlEncode(Eval("ClientEmail").ToString().Split('@')[0]) %></div>
                                                <div style="font-size:11px;color:var(--muted);"><%# Server.HtmlEncode(Eval("ClientEmail").ToString()) %></div>
                                            </td>
                                            <td style="font-size:13px;font-weight:600;max-width:130px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                <%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %>
                                            </td>
                                            <td style="font-size:13px;color:var(--muted);max-width:130px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;">
                                                <%# Server.HtmlEncode(Eval("ProjectTitle").ToString()) %>
                                            </td>
                                            <td style="font-size:12px;color:var(--muted);">
                                                <%# ((Skill_Link.Profile)Page).FormatDate(Eval("BookingDate")) %>
                                            </td>
                                            <td>
                                                <span style="font-size:11px;font-weight:700;background:rgba(72,229,194,0.1);color:var(--accent-dark);padding:2px 9px;border-radius:20px;text-transform:uppercase;">
                                                    <%# Eval("Package") %>
                                                </span>
                                            </td>
                                            <td><strong style="color:var(--accent-dark);">&#8369;<%# string.Format("{0:N0}", Eval("TotalAmount")) %></strong></td>
                                            <td>
                                                <span class="<%# ((Skill_Link.Profile)Page).GetStatusBadge(Eval("Status").ToString()) %>">
                                                    <i class="<%# ((Skill_Link.Profile)Page).GetStatusIcon(Eval("Status").ToString()) %>"></i>
                                                    <%# Eval("Status") %>
                                                </span>
                                            </td>
                                            <td>
                                                <div style="display:flex;gap:6px;flex-wrap:wrap;">
                                                    <asp:LinkButton runat="server"
                                                        Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                                        CommandName="AcceptBooking"
                                                        CommandArgument='<%# Eval("BookingRef") %>'
                                                        CssClass="btn btn-sm"
                                                        style="background:rgba(34,197,94,0.1);color:#16a34a;border:1px solid rgba(34,197,94,0.3);"
                                                        OnClientClick="return confirm('Accept this booking?');">
                                                        <i class="fas fa-check"></i> Accept
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server"
                                                        Visible='<%# Eval("Status").ToString() == "Accepted" %>'
                                                        CommandName="CompleteBooking"
                                                        CommandArgument='<%# Eval("BookingRef") %>'
                                                        CssClass="btn btn-sm"
                                                        style="background:rgba(72,229,194,0.12);color:var(--accent-dark);border:1px solid rgba(72,229,194,0.3);"
                                                        OnClientClick="return confirm('Mark this booking as Completed?');">
                                                        <i class="fas fa-flag-checkered"></i> Complete
                                                    </asp:LinkButton>
                                                    <asp:LinkButton runat="server"
                                                        Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                                        CommandName="RejectBooking"
                                                        CommandArgument='<%# Eval("BookingRef") %>'
                                                        CssClass="btn btn-danger btn-sm"
                                                        OnClientClick="return confirm('Reject this booking?');">
                                                        <i class="fas fa-times"></i> Reject
                                                    </asp:LinkButton>
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                    <asp:Panel ID="pnlNoBookingRequests" runat="server" Visible="false" CssClass="empty-state" style="padding:48px 24px;">
                        <i class="fas fa-inbox"></i>
                        <h4>No booking requests yet</h4>
                        <p>When clients book your services, requests will appear here.</p>
                    </asp:Panel>
                </div>
            </div>
        </main>
    </div>

    <br /><br /><br />

    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-col footer-brand">
                <a class="logo" href="Home.aspx">SkillLink</a>
                <p>Connect with talented professionals to get work done.</p>
                <div class="socials">
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Explore</h4>
                <ul>
                    <li><a href="Home.aspx">Home</a></li>
                    <li><a href="Freelance.aspx">Post a Service</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-inner footer-bottom">
            <p>&#169; <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
            <div class="footer-links"><a>Terms</a><a >Privacy</a></div>
        </div>
    </footer>

    <%-- Order modal hidden fields --%>
    <asp:HiddenField ID="hdnOrderCmd" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnOrderRef" runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnOrderAction" runat="server" Text="" style="display:none;" OnClick="btnOrderAction_Click" ClientIDMode="Static" />

    <%-- Rating hidden fields — ClientIDMode="Static" so JS getElementById always works --%>
    <asp:HiddenField ID="hdnRateOrderRef" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnRateRating"   runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnRateComment"  runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnRateSeller"   runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnRateService"  runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnSubmitRating" runat="server" Text="Submit Review" ClientIDMode="Static"
        CssClass="btn btn-primary" OnClick="btnSubmitRating_Click" style="display:none;" />
    <%-- Client rating hidden fields --%>
    <asp:HiddenField ID="hdnClientRateOrderRef" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnClientRateRating"   runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnClientRateComment"  runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnClientRateClient"   runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnClientRateService"  runat="server" ClientIDMode="Static" />
    <asp:Button ID="btnSubmitClientRating" runat="server" Text="Submit Client Review"
        ClientIDMode="Static" style="display:none;"
        OnClick="btnSubmitClientRating_Click" />
    <!-- ORDER DETAIL MODAL -->
    <div id="orderDetailModal" style="display:none;position:fixed;inset:0;background:rgba(10,14,20,0.65);backdrop-filter:blur(4px);z-index:600;align-items:center;justify-content:center;padding:20px;">
        <div style="background:#fff;border-radius:18px;width:100%;max-width:620px;max-height:90vh;overflow-y:auto;box-shadow:0 32px 80px rgba(0,0,0,0.3);animation:modalIn 0.25s cubic-bezier(0.34,1.26,0.64,1);">
            <div style="display:flex;justify-content:space-between;align-items:center;padding:20px 24px 16px;border-bottom:1px solid var(--border);">
                <div><h3 style="font-family:'Syne',sans-serif;font-size:18px;font-weight:800;color:var(--text);">Order Details</h3><span id="odRef" style="font-size:12px;color:var(--muted);"></span></div>
                <button type="button" onclick="closeOrderDetail()" style="width:34px;height:34px;border-radius:50%;background:var(--bg);border:1px solid var(--border);cursor:pointer;font-size:16px;color:var(--muted);display:flex;align-items:center;justify-content:center;"><i class="fas fa-times"></i></button>
            </div>
            <div style="padding:24px;">
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:20px;">
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Client</div><div id="odClient" style="font-size:14px;font-weight:700;color:var(--text);"></div></div>
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Service</div><div id="odService" style="font-size:14px;font-weight:700;color:var(--text);"></div></div>
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Package</div><div id="odPackage" style="font-size:14px;font-weight:700;color:var(--accent-dark);"></div></div>
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Total</div><div id="odTotal" style="font-size:14px;font-weight:700;color:var(--accent-dark);"></div></div>
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Deadline</div><div id="odDeadline" style="font-size:14px;font-weight:700;color:var(--text);"></div></div>
                    <div style="background:var(--bg);border-radius:10px;padding:14px;border:1px solid var(--border);"><div style="font-size:11px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:5px;">Communication</div><div id="odComm" style="font-size:14px;font-weight:700;color:var(--text);"></div></div>
                </div>
                <div style="margin-bottom:16px;"><div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:8px;">Project Title</div><div id="odProjTitle" style="font-size:15px;font-weight:700;color:var(--text);padding:12px 16px;background:var(--bg);border-radius:8px;border:1px solid var(--border);"></div></div>
                <div style="margin-bottom:16px;"><div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:8px;"><i class="fas fa-clipboard-list" style="color:var(--accent-dark);margin-right:5px;"></i>Requirements</div><div id="odReqs" style="font-size:14px;color:#334155;line-height:1.7;padding:14px 16px;background:rgba(72,229,194,0.04);border:1px solid rgba(72,229,194,0.2);border-radius:10px;white-space:pre-wrap;"></div></div>
                <div id="odNotesWrap" style="margin-bottom:20px;display:none;"><div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;margin-bottom:8px;">Notes</div><div id="odNotes" style="font-size:14px;color:#334155;padding:12px 16px;background:var(--bg);border:1px solid var(--border);border-radius:10px;white-space:pre-wrap;"></div></div>
                <div style="display:flex;align-items:center;gap:10px;padding:12px 16px;background:var(--bg);border-radius:10px;border:1px solid var(--border);margin-bottom:20px;"><span style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;">Status:</span><span id="odStatus"></span></div>
                <div id="odActions" style="display:flex;gap:10px;flex-wrap:wrap;"></div>
            </div>
        </div>
    </div>

    <!-- RATE SERVICE MODAL -->
    <div id="rateModal" style="display:none;position:fixed;inset:0;background:rgba(10,14,20,0.65);backdrop-filter:blur(4px);z-index:700;align-items:center;justify-content:center;padding:20px;">
        <div style="background:#fff;border-radius:18px;width:100%;max-width:480px;box-shadow:0 32px 80px rgba(0,0,0,0.3);animation:modalIn 0.25s cubic-bezier(0.34,1.26,0.64,1);">
            <div style="display:flex;justify-content:space-between;align-items:center;padding:20px 24px 16px;border-bottom:1px solid var(--border);">
                <div><h3 style="font-family:'Syne',sans-serif;font-size:18px;font-weight:800;color:var(--text);">Rate this Service</h3><p style="font-size:12px;color:var(--muted);margin-top:2px;">Share your experience with this freelancer</p></div>
                <button type="button" onclick="closeRateModal()" style="width:34px;height:34px;border-radius:50%;background:var(--bg);border:1px solid var(--border);cursor:pointer;font-size:16px;color:var(--muted);display:flex;align-items:center;justify-content:center;"><i class="fas fa-times"></i></button>
            </div>
            <div style="padding:24px;">
                <div style="background:var(--bg);border-radius:10px;padding:14px 16px;border:1px solid var(--border);margin-bottom:20px;">
                    <div id="rateServiceName" style="font-size:15px;font-weight:700;color:var(--text);margin-bottom:4px;"></div>
                    <div id="rateSellerName"  style="font-size:13px;color:var(--muted);"></div>
                </div>
                <div style="margin-bottom:20px;">
                    <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:10px;">Your Rating</div>
                    <div id="starRow" style="display:flex;gap:6px;margin-bottom:8px;">
                        <i class="fas fa-star rate-star" data-val="1" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star rate-star" data-val="2" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star rate-star" data-val="3" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star rate-star" data-val="4" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star rate-star" data-val="5" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                    </div>
                    <div id="rateLabel" style="font-size:13px;font-weight:600;color:var(--warn);height:18px;"></div>
                </div>
                <div style="margin-bottom:24px;">
                    <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">Comment <span style="font-weight:400;text-transform:none;">(optional)</span></div>
                    <textarea id="rateComment" rows="3" placeholder="Share your experience..."
                        style="width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:8px;font-size:14px;font-family:'DM Sans',sans-serif;resize:vertical;background:#f8fafc;transition:border 0.15s;"
                        onfocus="this.style.borderColor='var(--accent)';this.style.background='#fff';"
                        onblur="this.style.borderColor='var(--border)';this.style.background='#f8fafc';"></textarea>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="button" class="btn btn-primary" style="flex:1;" onclick="submitRating()"><i class="fas fa-paper-plane"></i> Submit Review</button>
                    <button type="button" onclick="closeRateModal()" class="btn btn-outline">Cancel</button>
                </div>
            </div>
        </div>
    </div>
        <!-- RATE CLIENT MODAL -->
    <div id="rateClientModal" style="display:none;position:fixed;inset:0;background:rgba(10,14,20,0.65);backdrop-filter:blur(4px);z-index:700;align-items:center;justify-content:center;padding:20px;">
        <div style="background:#fff;border-radius:18px;width:100%;max-width:480px;box-shadow:0 32px 80px rgba(0,0,0,0.3);animation:modalIn 0.25s cubic-bezier(0.34,1.26,0.64,1);">
            <div style="display:flex;justify-content:space-between;align-items:center;padding:20px 24px 16px;border-bottom:1px solid var(--border);">
                <div><h3 style="font-family:'Syne',sans-serif;font-size:18px;font-weight:800;color:var(--text);">Rate this Client</h3><p style="font-size:12px;color:var(--muted);margin-top:2px;">How was your experience with this client?</p></div>
                <button type="button" onclick="closeRateClientModal()" style="width:34px;height:34px;border-radius:50%;background:var(--bg);border:1px solid var(--border);cursor:pointer;font-size:16px;color:var(--muted);display:flex;align-items:center;justify-content:center;"><i class="fas fa-times"></i></button>
            </div>
            <div style="padding:24px;">
                <div style="background:var(--bg);border-radius:10px;padding:14px 16px;border:1px solid var(--border);margin-bottom:20px;">
                    <div id="rateClientName" style="font-size:15px;font-weight:700;color:var(--text);margin-bottom:4px;"></div>
                    <div id="rateClientService" style="font-size:13px;color:var(--muted);"></div>
                </div>
                <div style="margin-bottom:20px;">
                    <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:10px;">Your Rating</div>
                    <div id="clientStarRow" style="display:flex;gap:6px;margin-bottom:8px;">
                        <i class="fas fa-star client-rate-star" data-val="1" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star client-rate-star" data-val="2" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star client-rate-star" data-val="3" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star client-rate-star" data-val="4" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                        <i class="fas fa-star client-rate-star" data-val="5" style="font-size:34px;color:#e2e8f0;cursor:pointer;"></i>
                    </div>
                    <div id="clientRateLabel" style="font-size:13px;font-weight:600;color:var(--warn);height:18px;"></div>
                </div>
                <div style="margin-bottom:24px;">
                    <div style="font-size:12px;font-weight:700;color:var(--muted);text-transform:uppercase;letter-spacing:0.5px;margin-bottom:8px;">Comment <span style="font-weight:400;text-transform:none;">(optional)</span></div>
                    <textarea id="clientRateComment" rows="3" placeholder="Share your experience with this client..."
                        style="width:100%;padding:10px 12px;border:1px solid var(--border);border-radius:8px;font-size:14px;font-family:'DM Sans',sans-serif;resize:vertical;background:#f8fafc;transition:border 0.15s;"
                        onfocus="this.style.borderColor='var(--accent)';this.style.background='#fff';"
                        onblur="this.style.borderColor='var(--border)';this.style.background='#f8fafc';"></textarea>
                </div>
                <div style="display:flex;gap:10px;">
                    <button type="button" class="btn btn-primary" style="flex:1;" onclick="submitClientRating()"><i class="fas fa-paper-plane"></i> Submit Review</button>
                    <button type="button" onclick="closeRateClientModal()" class="btn btn-outline">Cancel</button>
                </div>
            </div>
        </div>
    </div>
</form>

<script>
    // Tab switching
    window.addEventListener('DOMContentLoaded', function () {
        var defaultTab = '<%= DefaultTab %>';
        if (defaultTab && defaultTab !== 'profile') {
            var navMap = { orders:'navOrders', received:'navReceived', services:'navServices', reviews:'navReviews' };
            showTab(defaultTab, navMap[defaultTab] || 'navProfile');
            setTimeout(function () {
                var el = document.getElementById('tab-' + defaultTab);
                if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }, 120);
        }
    });

    function showTab(tabId, navId) {
        document.querySelectorAll('.tab-section').forEach(function(t) { t.classList.remove('active'); });
        var el = document.getElementById('tab-' + tabId);
        if (el) el.classList.add('active');
        document.querySelectorAll('.side-nav li').forEach(function(li) { li.classList.remove('active'); });
        var nav = document.getElementById(navId);
        if (nav) nav.classList.add('active');
    }

    // Event delegation for all button clicks
    document.addEventListener('click', function(e) {
        var viewBtn = e.target.closest('.view-order-btn');
        if (viewBtn) {
            var d = viewBtn.dataset;
            openOrderDetail(d.ref, d.client, d.service, d.projtitle, d.reqs, d.notes, d.deadline, d.comm, d.pkg, d.total, d.status);
            return;
        }
        var actionBtn = e.target.closest('.modal-order-action');
        if (actionBtn) {
            if (confirm(actionBtn.dataset.msg)) {
                closeOrderDetail();
                // Uses static IDs
                document.getElementById('hdnOrderCmd').value = actionBtn.dataset.cmd;
                document.getElementById('hdnOrderRef').value = actionBtn.dataset.ref;
                document.getElementById('btnOrderAction').click();
            }
            return;
        }
        var rateBtn = e.target.closest('.open-rate-btn');
        if (rateBtn) {
            openRateModal(rateBtn.dataset.ref, rateBtn.dataset.seller, rateBtn.dataset.service);
        }
        var rateClientBtn = e.target.closest('.open-rate-client-btn');
        if (rateClientBtn) {
            openRateClientModal(
                rateClientBtn.dataset.ref,
                rateClientBtn.dataset.client,
                rateClientBtn.dataset.service
            );
        }
    });

    function openOrderDetail(ref, client, service, projTitle, reqs, notes, deadline, comm, pkg, total, status) {
        document.getElementById('odRef').textContent       = ref;
        document.getElementById('odClient').textContent    = client;
        document.getElementById('odService').textContent   = service;
        document.getElementById('odProjTitle').textContent = projTitle || '-';
        document.getElementById('odReqs').textContent      = reqs || 'No requirements provided.';
        document.getElementById('odDeadline').textContent  = deadline || 'Flexible';
        document.getElementById('odComm').textContent      = comm || '-';
        document.getElementById('odPackage').textContent   = pkg || '-';
        document.getElementById('odTotal').textContent     = '\u20B1' + total;
        var notesWrap = document.getElementById('odNotesWrap');
        if (notes && notes.trim()) { document.getElementById('odNotes').textContent = notes; notesWrap.style.display = 'block'; }
        else { notesWrap.style.display = 'none'; }
        var badgeMap = { 'Pending':'badge badge-pending','In Progress':'badge badge-ongoing','Delivered':'badge badge-active','Completed':'badge badge-completed','Cancelled':'badge badge-inactive','Rejected':'badge badge-inactive','Revision':'badge badge-ongoing' };
        var iconMap  = { 'Pending':'fas fa-clock','In Progress':'fas fa-spinner','Delivered':'fas fa-box-open','Completed':'fas fa-check-circle','Cancelled':'fas fa-times-circle','Rejected':'fas fa-ban','Revision':'fas fa-redo' };
        var statusEl = document.getElementById('odStatus');
        statusEl.className = badgeMap[status] || 'badge badge-inactive';
        statusEl.innerHTML = '<i class="' + (iconMap[status] || 'fas fa-circle') + '" style="margin-right:4px;"></i>' + status;
        var actDiv = document.getElementById('odActions');
        actDiv.innerHTML = '';
        if (status === 'Pending') {
            actDiv.innerHTML =
                '<button type="button" class="btn btn-sm modal-order-action" data-cmd="AcceptOrder" data-ref="' + ref + '" data-msg="Accept this order?" style="background:rgba(34,197,94,0.1);color:#16a34a;border:1px solid rgba(34,197,94,0.3);"><i class="fas fa-check"></i> Accept Order</button>' +
                '<button type="button" class="btn btn-danger btn-sm modal-order-action" data-cmd="RejectOrder" data-ref="' + ref + '" data-msg="Reject and refund client?"><i class="fas fa-times"></i> Reject Order</button>';
        } else if (status === 'In Progress') {
            actDiv.innerHTML = '<button type="button" class="btn btn-sm modal-order-action" data-cmd="DeliverOrder" data-ref="' + ref + '" data-msg="Mark as Delivered?" style="background:rgba(72,229,194,0.12);color:var(--accent-dark);border:1px solid rgba(72,229,194,0.3);"><i class="fas fa-paper-plane"></i> Deliver Work</button>';
        }
        document.getElementById('orderDetailModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeOrderDetail() {
        document.getElementById('orderDetailModal').style.display = 'none';
        document.body.style.overflow = '';
    }
    document.getElementById('orderDetailModal').addEventListener('click', function(e) { if (e.target === this) closeOrderDetail(); });

    // Rate modal — ALL IDs are static, no <%= ClientID %> needed
    var _rateVal = 0;
    var rateLabels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

    function openRateModal(ref, seller, service) {
        _rateVal = 0;
        setStars(0);
        document.getElementById('rateComment').value = '';
        document.getElementById('rateLabel').textContent = '';
        document.getElementById('rateServiceName').textContent = service;
        document.getElementById('rateSellerName').textContent = 'Freelancer: ' + seller;
        // Static IDs — guaranteed to work regardless of master pages or naming containers
        document.getElementById('hdnRateOrderRef').value = ref;
        document.getElementById('hdnRateSeller').value = seller;
        document.getElementById('hdnRateService').value = service;
        document.getElementById('hdnRateRating').value = '';
        document.getElementById('hdnRateComment').value = '';
        document.getElementById('rateModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeRateModal() {
        document.getElementById('rateModal').style.display = 'none';
        document.body.style.overflow = '';
    }
    document.getElementById('rateModal').addEventListener('click', function (e) { if (e.target === this) closeRateModal(); });

    document.querySelectorAll('.rate-star').forEach(function (star) {
        star.addEventListener('mouseover', function () { setStars(+this.dataset.val); });
        star.addEventListener('mouseout', function () { setStars(_rateVal); });
        star.addEventListener('click', function () {
            _rateVal = +this.dataset.val;
            document.getElementById('hdnRateRating').value = _rateVal;
            setStars(_rateVal);
        });
    });

    function setStars(n) {
        document.querySelectorAll('.rate-star').forEach(function (s) {
            s.style.color = +s.dataset.val <= n ? '#f59e0b' : '#e2e8f0';
        });
        document.getElementById('rateLabel').textContent = n ? rateLabels[n] : '';
    }

    function submitRating() {
        if (!_rateVal) { alert('Please select a star rating before submitting.'); return; }
        // Write final values to hidden fields (static IDs)
        document.getElementById('hdnRateRating').value = _rateVal;
        document.getElementById('hdnRateComment').value = document.getElementById('rateComment').value;
        closeRateModal();
        document.getElementById('btnSubmitRating').click();
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') { closeOrderDetail(); closeRateModal(); closeRateClientModal(); }
    });

    // Rate Client modal
    var _clientRateVal = 0;

    function openRateClientModal(ref, client, service) {
        _clientRateVal = 0;
        setClientStars(0);
        document.getElementById('clientRateComment').value = '';
        document.getElementById('clientRateLabel').textContent = '';
        document.getElementById('rateClientName').textContent = 'Client: ' + client;
        document.getElementById('rateClientService').textContent = service;
        document.getElementById('hdnClientRateOrderRef').value = ref;
        document.getElementById('hdnClientRateClient').value = client;
        document.getElementById('hdnClientRateService').value = service;
        document.getElementById('hdnClientRateRating').value = '';
        document.getElementById('hdnClientRateComment').value = '';
        document.getElementById('rateClientModal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }

    function closeRateClientModal() {
        document.getElementById('rateClientModal').style.display = 'none';
        document.body.style.overflow = '';
    }

    document.getElementById('rateClientModal').addEventListener('click', function (e) {
        if (e.target === this) closeRateClientModal();
    });

    document.querySelectorAll('.client-rate-star').forEach(function (star) {
        star.addEventListener('mouseover', function () { setClientStars(+this.dataset.val); });
        star.addEventListener('mouseout', function () { setClientStars(_clientRateVal); });
        star.addEventListener('click', function () {
            _clientRateVal = +this.dataset.val;
            document.getElementById('hdnClientRateRating').value = _clientRateVal;
            setClientStars(_clientRateVal);
        });
    });

    function setClientStars(n) {
        document.querySelectorAll('.client-rate-star').forEach(function (s) {
            s.style.color = +s.dataset.val <= n ? '#f59e0b' : '#e2e8f0';
        });
        document.getElementById('clientRateLabel').textContent = n ? ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'][n] : '';
    }

    function submitClientRating() {
        if (!_clientRateVal) { alert('Please select a star rating before submitting.'); return; }
        document.getElementById('hdnClientRateRating').value = _clientRateVal;
        document.getElementById('hdnClientRateComment').value = document.getElementById('clientRateComment').value;
        closeRateClientModal();
        document.getElementById('btnSubmitClientRating').click();
    }
</script>
</body>
</html>