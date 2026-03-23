<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Skill_Link.Admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Panel - SkillLink</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --danger:      #e5484d;
            --warn:        #f59e0b;
            --info:        #3b82f6;
            --purple:      #8b5cf6;
            --bg:          #0f172a;
            --sidebar-bg:  #1e293b;
            --card:        #1e293b;
            --card2:       #273548;
            --border:      rgba(255,255,255,0.07);
            --text:        #f1f5f9;
            --muted:       #94a3b8;
            --sidebar-w:   240px;
        }
        *, *::before, *::after { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
        }
        html { height: 100%; }
        body { 
            font-family: 'DM Sans', sans-serif; 
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            height: 100%;
        }
        /* The ASP.NET form wraps everything — make it a full-width flex row */
        form#form1 {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* ── SIDEBAR ── */
        .sidebar {
            width: var(--sidebar-w);
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0; bottom: 0;
            z-index: 200;
        }
        .sidebar-logo {
            padding: 24px 20px 20px;
            border-bottom: 1px solid var(--border);
        }
        .sidebar-logo .logo {
            font-family: 'Syne', sans-serif;
            font-size: 20px;
            font-weight: 800;
            color: var(--accent);
            text-decoration: none;
        }
        .sidebar-logo .admin-tag {
            display: block;
            font-size: 10px;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 2px;
        }
        .sidebar-nav { 
            flex: 1; 
            padding: 16px 10px; 
            overflow-y: auto; 
        }
        .nav-section-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 12px 10px 6px;
        }
        .nav-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: var(--muted);
            cursor: pointer;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            font-family: 'DM Sans', sans-serif;
            transition: background 0.14s, color 0.14s;
            margin-bottom: 2px;
        }
        .nav-item i {
            width: 18px; 
            text-align: center;
            font-size: 14px; 
        }
        .nav-item:hover { 
            background: rgba(255,255,255,0.06);
            color: var(--text); 
        }
        .nav-item.active { 
            background: rgba(72,229,194,0.12); 
            color: var(--accent); 
        }
        .nav-item.active i { 
            color: var(--accent); 
        }
        .nav-item.logout { 
            color: var(--danger); 
        }
        .nav-item.logout:hover { 
            background: rgba(229,72,77,0.1); 
            color: var(--danger); 
        }

        .sidebar-user {
            padding: 16px 20px;
            border-top: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .sidebar-user .u-avatar {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), #2563eb);
            display: flex; align-items: center; 
            justify-content: center;
            font-weight: 700; 
            font-size: 14px; 
            color: #fff; 
            flex-shrink: 0;
        }
        .sidebar-user .u-name { 
            font-size: 13px; 
            font-weight: 600; 
        }
        .sidebar-user .u-role {
            font-size: 11px;
            color: var(--accent); 
            font-weight: 600; 
        }
        /* ── MAIN ── */
        .main-wrap {
            margin-left: var(--sidebar-w);
            flex: 1 1 0%;
            min-width: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            width: calc(100% - var(--sidebar-w));
        }

        /* top bar */
        .topbar {
            background: var(--sidebar-bg);
            border-bottom: 1px solid var(--border);
            padding: 14px 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
        }
        .topbar-title {
            font-family: 'Syne', sans-serif;
            font-size: 18px;
            font-weight: 700;
        }
        .topbar-right { 
            display: flex; 
            align-items: center;
            gap: 14px; 
        }
        .topbar-right a {
            color: var(--muted);
            text-decoration: none;
            font-size: 13px;
            transition: color 0.15s;
        }
        .topbar-right a:hover { 
            color: var(--accent); 
        }

        /* page content */
        .page-content { 
            flex: 1;
            padding: 28px;
        }

        /* sections */
        .section { 
            display: none; 
        }
        .section.active { 
            display: block; 
        }
        /* ── STAT CARDS ── */
        .stat-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 18px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 22px;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
        }
        .stat-card.teal::before   { background: var(--accent); }
        .stat-card.blue::before   { background: var(--info); }
        .stat-card.orange::before { background: var(--warn); }
        .stat-card.purple::before { background: var(--purple); }
        .stat-card.green::before  { background: #22c55e; }
        .stat-card .s-icon {
            width: 42px; height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center; 
            justify-content: center;
            font-size: 18px;
            margin-bottom: 14px;
        }
        .stat-card.teal .s-icon   { background: rgba(72,229,194,0.12);  color: var(--accent); }
        .stat-card.blue .s-icon   { background: rgba(59,130,246,0.12);  color: var(--info); }
        .stat-card.orange .s-icon { background: rgba(245,158,11,0.12);  color: var(--warn); }
        .stat-card.purple .s-icon { background: rgba(139,92,246,0.12);  color: var(--purple); }
        .stat-card.green .s-icon  { background: rgba(34,197,94,0.12);   color: #22c55e; }
        .stat-card .s-val {
            font-family: 'Syne', sans-serif;
            font-size: 30px;
            font-weight: 800;
            color: var(--text);
            line-height: 1;
        }
        .stat-card .s-label { 
            font-size: 13px;
            color: var(--muted);
            margin-top: 6px;
        }
        /* ── PANEL CARD ── */
        .panel {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 14px;
            margin-bottom: 24px;
            overflow: hidden;
        }
        .panel-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 22px;
            border-bottom: 1px solid var(--border);
        }
        .panel-head h3 {
            font-family: 'Syne', sans-serif;
            font-size: 15px;
            font-weight: 700;
            color: var(--text);
        }
        .panel-head p {
            font-size: 12px; 
            color: var(--muted);
            margin-top: 2px;
        }
        .panel-body { 
            padding: 22px; 
        }

        /* filter bar */
        .filter-bar {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        /* search input */
        .search-input {
            background: var(--card2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 8px 14px;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            width: 220px;
            outline: none;
            transition: border-color 0.15s;
        }
        .search-input:focus { border-color: var(--accent); }
        .search-input::placeholder { color: var(--muted); }

        /* select filter */
        .filter-select {
            background: var(--card2);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 13px;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            outline: none;
            cursor: pointer;
            transition: border-color 0.15s;
        }
        .filter-select:focus { border-color: var(--accent); }
        .filter-select option { background: var(--card2); }

        /* ── DATA TABLE ── */
        .data-table { 
            width: 100%; 
            border-collapse: collapse; 
            font-size: 13px;
        }
        .data-table th {
            background: rgba(255,255,255,0.03);
            padding: 10px 14px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--muted);
            font-weight: 600;
            border-bottom: 1px solid var(--border);
        }
        .data-table td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            color: var(--text);
        }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background: rgba(255,255,255,0.02); }

        /* user avatar in table */
        .t-avatar {
            width: 32px; height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), #2563eb);
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 12px; font-weight: 700; color: #fff;
            margin-right: 8px; vertical-align: middle;
        }

        /* ── BADGES ── */
        .badge {
            display: inline-block;
            padding: 3px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        .badge-active    { background: rgba(72,229,194,0.12);  color: var(--accent); }
        .badge-admin     { background: rgba(139,92,246,0.15);  color: var(--purple); }
        .badge-member    { background: rgba(148,163,184,0.12); color: var(--muted); }
        .badge-pending   { background: rgba(245,158,11,0.12);  color: var(--warn); }
        .badge-ongoing   { background: rgba(59,130,246,0.12);  color: var(--info); }
        .badge-completed { background: rgba(72,229,194,0.12);  color: var(--accent); }
        .badge-disabled  { background: rgba(229,72,77,0.12);   color: var(--danger); }
        .badge-approved  { background: rgba(72,229,194,0.12);  color: var(--accent); }
        .badge-rejected  { background: rgba(229,72,77,0.12);   color: var(--danger); }
        .badge-cancelled { background: rgba(229,72,77,0.12);   color: var(--danger); }

        /* ── BUTTONS ── */
        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 7px 14px; border-radius: 7px;
            font-size: 12px; font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; border: none; transition: all 0.15s;
            text-decoration: none;
        }
        .btn-primary { background: var(--accent);  color: #062023; }
        .btn-primary:hover { background: var(--accent-dark); }
        .btn-danger  { background: var(--danger);  color: #fff; }
        .btn-danger:hover  { background: #c0393e; }
        .btn-warn    { background: var(--warn);    color: #fff; }
        .btn-warn:hover    { background: #d97706; }
        .btn-info    { background: var(--info);    color: #fff; }
        .btn-info:hover    { background: #2563eb; }
        .btn-success { background: var(--accent);  color: #062023; }
        .btn-success:hover { background: var(--accent-dark); }
        .btn-outline { background: transparent; border: 1px solid var(--border); color: var(--muted); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }
        .btn-ghost   { background: transparent; color: var(--muted); border: none; }
        .btn-ghost:hover   { color: var(--text); background: rgba(255,255,255,0.06); }
        .btn-xs { padding: 4px 10px; font-size: 11px; }

        /* ── ALERT ── */
        .alert { padding: 12px 16px; border-radius: 8px; font-size: 13px; margin-bottom: 16px; display: none; }
        .alert.show { display: block; }
        .alert-success { background: rgba(72,229,194,0.1);  color: var(--accent); border: 1px solid rgba(72,229,194,0.2); }
        .alert-error   { background: rgba(229,72,77,0.1);   color: var(--danger); border: 1px solid rgba(229,72,77,0.2); }

        /* ── DASHBOARD 2-COL ── */
        .dash-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

        /* ── EMPTY STATE ── */
        .empty-state {
            text-align: center; padding: 48px 20px; color: var(--muted);
        }
        .empty-state i { font-size: 40px; color: var(--border); display: block; margin-bottom: 14px; }
        .empty-state p { font-size: 14px; }

        /* ── RESPONSIVE ── */
        @media (max-width: 1400px) { .stat-grid { grid-template-columns: repeat(3,1fr); } }
        @media (max-width: 1100px) { .stat-grid { grid-template-columns: repeat(2,1fr); } }
        @media (max-width: 900px)  { .dash-grid { grid-template-columns: 1fr; } }
        @media (max-width: 768px)  {
            .sidebar { transform: translateX(-100%); }
            .main-wrap { margin-left: 0; }
            .stat-grid { grid-template-columns: 1fr 1fr; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <%-- Tracks which section is active across postbacks --%>
    <asp:HiddenField ID="hfActiveSection" runat="server" Value="dashboard" />

    <!--SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-logo">
            <a class="logo" href="Home.aspx">SkillLink</a>
            <span class="admin-tag">Admin Panel</span>
        </div>

        <nav class="sidebar-nav">
            <div class="nav-section-label">Main</div>
            <button type="button" class="nav-item active" id="navDash" onclick="showSection('dashboard','navDash')">
                <i class="fas fa-chart-pie"></i> Dashboard
            </button>
            <button type="button" class="nav-item" id="navUsers" onclick="showSection('users','navUsers')">
                <i class="fas fa-users"></i> Manage Users
            </button>
            <button type="button" class="nav-item" id="navServices" onclick="showSection('services','navServices')">
                <i class="fas fa-briefcase"></i> Manage Services
            </button>
            <button type="button" class="nav-item" id="navOrders" onclick="showSection('orders','navOrders')">
                <i class="fas fa-clipboard-list"></i> Manage Orders
            </button>
            <div class="nav-section-label">Account</div>
            <asp:Button ID="btnLogout" runat="server" OnClick="btnLogout_Click" style="display:none;" />
            <button type="button" class="nav-item logout"
                onclick="document.getElementById('<%= btnLogout.ClientID %>').click();">
                <i class="fas fa-sign-out-alt"></i> Logout
            </button>
        </nav>

        <div class="sidebar-user">
            <div class="u-avatar"><asp:Literal ID="litAdminInitial" runat="server" /></div>
            <div>
                <div class="u-name"><asp:Literal ID="litAdminName" runat="server" /></div>
                <div class="u-role">Administrator</div>
            </div>
        </div>
    </aside>

    <!--MAIN WRAP-->
    <div class="main-wrap">

        <!-- TOP BAR -->
        <div class="topbar">
            <div class="topbar-title" id="topbarTitle">Dashboard</div>
            <div class="topbar-right">
                <a href="Home.aspx"><i class="fas fa-globe"></i> View Site</a>
            </div>
        </div>

        <div class="page-content">

            <!-- DASHBOARD -->
            <div id="section-dashboard" class="section active">

                <asp:Label ID="lblDashAlert" runat="server" CssClass="alert" />

                <!-- Stat cards -->
                <div class="stat-grid">
                    <div class="stat-card teal">
                        <div class="s-icon"><i class="fas fa-users"></i></div>
                        <div class="s-val"><asp:Literal ID="litTotalUsers" runat="server" Text="0" /></div>
                        <div class="s-label">Total Users</div>
                    </div>
                    <div class="stat-card blue">
                        <div class="s-icon"><i class="fas fa-briefcase"></i></div>
                        <div class="s-val"><asp:Literal ID="litTotalServices" runat="server" Text="0" /></div>
                        <div class="s-label">Total Services</div>
                    </div>
                    <div class="stat-card orange">
                        <div class="s-icon"><i class="fas fa-clipboard-list"></i></div>
                        <div class="s-val"><asp:Literal ID="litTotalOrders" runat="server" Text="0" /></div>
                        <div class="s-label">Total Orders</div>
                    </div>
                    <div class="stat-card purple">
                        <div class="s-icon"><i class="fas fa-circle-check"></i></div>
                        <div class="s-val" style="font-size:22px;"><asp:Literal ID="litTotalEarnings" runat="server" Text="₱0.00" /></div>
                        <div class="s-label">Earned (5% Commission)</div>
                        <div style="font-size:10px;color:var(--muted);margin-top:4px;">From completed orders</div>
                    </div>
                    <div class="stat-card green">
                        <div class="s-icon"><i class="fas fa-hourglass-half"></i></div>
                        <div class="s-val" style="font-size:22px;"><asp:Literal ID="litPendingEarnings" runat="server" Text="₱0.00" /></div>
                        <div class="s-label">Pending Commission</div>
                        <div style="font-size:10px;color:var(--muted);margin-top:4px;">From active orders</div>
                    </div>
                </div>

                <div class="dash-grid">
                    <!-- Recent Users -->
                    <div class="panel">
                        <div class="panel-head">
                            <div><h3>Recent Users</h3><p>Latest registered accounts</p></div>
                        </div>
                        <div class="panel-body" style="padding:0;">
                            <table class="data-table">
                                <thead><tr><th>User</th><th>Role</th><th>Email</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentUsers" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td>
                                                    <span class="t-avatar"><%# Eval("Username").ToString().Substring(0,1).ToUpper() %></span>
                                                    <%# Server.HtmlEncode(Eval("Username").ToString()) %>
                                                </td>
                                                <td>
                                                    <span class='badge <%# Eval("Role").ToString().ToLower()=="admin" ? "badge-admin" : "badge-member" %>'>
                                                        <%# string.IsNullOrWhiteSpace(Eval("Role").ToString()) ? "Member" : Eval("Role").ToString() %>
                                                    </span>
                                                </td>
                                                <td style="color:var(--muted);font-size:12px;">
                                                    <%# Eval("Email").ToString() %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Recent Services -->
                    <div class="panel">
                        <div class="panel-head">
                            <div><h3>Recent Services</h3><p>Latest posted services</p></div>
                        </div>
                        <div class="panel-body" style="padding:0;">
                            <table class="data-table">
                                <thead><tr><th>Title</th><th>Category</th><th>Price</th></tr></thead>
                                <tbody>
                                    <asp:Repeater ID="rptRecentServices" runat="server">
                                        <ItemTemplate>
                                            <tr>
                                                <td style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                    <%# Server.HtmlEncode(Eval("Title").ToString()) %>
                                                </td>
                                                <td><span class="badge badge-member"><%# Eval("Category") %></span></td>
                                                <td style="color:var(--accent);font-weight:700;">
                                                    &#8369;<%# string.Format("{0:N0}", Eval("Price")) %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:Repeater>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!--MANAGE USERS-->
            <div id="section-users" class="section">
                <asp:Label ID="lblUserAlert" runat="server" CssClass="alert" />
                <div class="panel">
                    <div class="panel-head">
                        <div><h3>All Users</h3><p>Manage registered accounts</p></div>
                        <asp:TextBox ID="txtUserSearch" runat="server" CssClass="search-input"
                            placeholder="&#xf002; Search users…"
                            AutoPostBack="true" OnTextChanged="txtUserSearch_TextChanged" />
                    </div>
                    <div class="panel-body" style="padding:0;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Phone</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <span class="t-avatar"><%# Eval("Username").ToString().Length > 0 ? Eval("Username").ToString().Substring(0,1).ToUpper() : "?" %></span>
                                                <strong><%# Server.HtmlEncode(Eval("Username").ToString()) %></strong><br />
                                                <span style="font-size:11px;color:var(--muted);"><%# Eval("FirstName") %> <%# Eval("LastName") %></span>
                                            </td>
                                            <td style="color:var(--muted);"><%# Server.HtmlEncode(Eval("Email").ToString()) %></td>
                                            <td>
                                                <span class='badge <%# Eval("Role").ToString().ToLower()=="admin" ? "badge-admin" : "badge-member" %>'>
                                                    <%# string.IsNullOrWhiteSpace(Eval("Role").ToString()) ? "Member" : Eval("Role").ToString() %>
                                                </span>
                                            </td>
                                            <td style="color:var(--muted);"><%# Eval("Phone") %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CommandName="MakeAdmin"
                                                    CommandArgument='<%# Eval("Email") %>'
                                                    CssClass="btn btn-info btn-xs"
                                                    ToolTip="Make Admin"
                                                    OnClientClick="return confirm('Change this user to Admin?');">
                                                    <i class="fas fa-crown"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="DeleteUser"
                                                    CommandArgument='<%# Eval("Email") %>'
                                                    CssClass="btn btn-danger btn-xs"
                                                    OnClientClick="return confirm('Delete this user permanently?');">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoUsers" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-users"></i><p>No users found.</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <!--MANAGE SERVICES-->
            <div id="section-services" class="section">
                <asp:Label ID="lblServiceAlert" runat="server" CssClass="alert" />
                <div class="panel">
                    <div class="panel-head">
                        <div><h3>All Services</h3><p>Review and manage posted services</p></div>
                        <asp:TextBox ID="txtServiceSearch" runat="server" CssClass="search-input"
                            placeholder="&#xf002; Search services…"
                            AutoPostBack="true" OnTextChanged="txtServiceSearch_TextChanged" />
                    </div>
                    <div class="panel-body" style="padding:0;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Category</th>
                                    <th>Posted By</th>
                                    <th>Price</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptServices" runat="server" OnItemCommand="rptServices_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="color:var(--muted);font-size:12px;">#<%# Eval("ServiceID") %></td>
                                            <td style="max-width:200px;">
                                                <strong><%# Server.HtmlEncode(Eval("Title").ToString()) %></strong><br />
                                                <span style="font-size:11px;color:var(--muted);">
                                                    <%# Eval("Description").ToString().Length > 50 ? Eval("Description").ToString().Substring(0,50)+"…" : Eval("Description").ToString() %>
                                                </span>
                                            </td>
                                            <td><span class="badge badge-member"><%# Eval("Category") %></span></td>
                                            <td style="color:var(--muted);font-size:12px;"><%# Server.HtmlEncode(Eval("Name").ToString()) %></td>
                                            <td style="color:var(--accent);font-weight:700;">&#8369;<%# string.Format("{0:N0}", Eval("Price")) %></td>
                                            <td>
                                                <asp:LinkButton runat="server" CommandName="DeleteService"
                                                    CommandArgument='<%# Eval("ServiceID") %>'
                                                    CssClass="btn btn-danger btn-xs"
                                                    OnClientClick="return confirm('Delete this service?');">
                                                    <i class="fas fa-trash"></i> Delete
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoServices" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-briefcase"></i><p>No services found.</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>

            <!--MANAGE ORDERS-->
            <div id="section-orders" class="section">
                <asp:Label ID="lblOrderAlert" runat="server" CssClass="alert" />
                <div class="panel">
                    <div class="panel-head">
                        <div><h3>All Orders</h3><p>View and manage customer orders</p></div>
                        <div class="filter-bar">
                            <asp:DropDownList ID="ddlOrderStatus" runat="server" CssClass="filter-select"
                                AutoPostBack="true" OnSelectedIndexChanged="ddlOrderStatus_SelectedIndexChanged">
                                <asp:ListItem Value="">All Statuses</asp:ListItem>
                                <asp:ListItem Value="Pending">Pending</asp:ListItem>
                                <asp:ListItem Value="Ongoing">Ongoing</asp:ListItem>
                                <asp:ListItem Value="Completed">Completed</asp:ListItem>
                                <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtOrderSearch" runat="server" CssClass="search-input"
                                placeholder="&#xf002; Search orders…"
                                AutoPostBack="true" OnTextChanged="txtOrderSearch_TextChanged" />
                        </div>
                    </div>
                    <div class="panel-body" style="padding:0;">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Ref</th>
                                    <th>Service / Project</th>
                                    <th>Client</th>
                                    <th>Seller</th>
                                    <th>Package</th>
                                    <th>Amount</th>
                                    <th>Commission (5%)</th>
                                    <th>Payment</th>
                                    <th>Deadline</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptOrders" runat="server" OnItemCommand="rptOrders_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <%-- Ref + ID --%>
                                            <td style="white-space:nowrap;">
                                                <span style="color:var(--accent);font-weight:700;font-size:12px;"><%# Server.HtmlEncode(Eval("OrderRef").ToString()) %></span><br />
                                                <span style="color:var(--muted);font-size:11px;">#<%# Eval("OrderID") %></span>
                                            </td>
                                            <%-- Service title + project title --%>
                                            <td style="max-width:200px;">
                                                <strong style="display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                    <%# Server.HtmlEncode(Eval("ServiceTitle").ToString()) %>
                                                </strong>
                                                <span style="font-size:11px;color:var(--muted);">
                                                    <%# Server.HtmlEncode(Eval("ProjectTitle").ToString()) %>
                                                </span>
                                            </td>
                                            <%-- Client email --%>
                                            <td style="color:var(--muted);font-size:12px;max-width:140px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                <%# Server.HtmlEncode(Eval("UserEmail").ToString()) %>
                                            </td>
                                            <%-- Seller name + email --%>
                                            <td style="max-width:140px;">
                                                <span style="display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                    <%# Server.HtmlEncode(Eval("SellerName").ToString()) %>
                                                </span>
                                                <span style="font-size:11px;color:var(--muted);display:block;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
                                                    <%# Server.HtmlEncode(Eval("SellerEmail").ToString()) %>
                                                </span>
                                            </td>
                                            <%-- Package --%>
                                            <td><span class="badge badge-member"><%# Server.HtmlEncode(Eval("Package").ToString()) %></span></td>
                                            <%-- TotalAmount --%>
                                            <td style="color:var(--accent);font-weight:700;white-space:nowrap;">
                                                &#8369;<%# string.Format("{0:N2}", Eval("TotalAmount")) %>
                                            </td>
                                            <%-- Commission: 5% of TotalAmount, computed inline --%>
                                            <td style="white-space:nowrap;">
                                                <span style="color:var(--purple);font-weight:700;">
                                                    &#8369;<%# string.Format("{0:N2}", Convert.ToDecimal(Eval("TotalAmount")) * 0.05m) %>
                                                </span><br />
                                                <span style="font-size:10px;color:var(--muted);">5% fee</span>
                                            </td>
                                            <%-- PaymentMethod --%>
                                            <td style="color:var(--muted);font-size:12px;">
                                                <%# Server.HtmlEncode(Eval("PaymentMethod").ToString()) %>
                                            </td>
                                            <%-- Deadline --%>
                                            <td style="color:var(--muted);font-size:12px;white-space:nowrap;">
                                                <%# Eval("Deadline") != DBNull.Value ? Convert.ToDateTime(Eval("Deadline")).ToString("MMM dd, yyyy") : "—" %>
                                            </td>
                                            <%-- Status badge --%>
                                            <td>
                                                <span class='badge <%# Eval("Status").ToString().ToLower() == "completed" ? "badge-completed"
                                                                     : Eval("Status").ToString().ToLower() == "ongoing"   ? "badge-ongoing"
                                                                     : Eval("Status").ToString().ToLower() == "cancelled" ? "badge-cancelled"
                                                                     : "badge-pending" %>'>
                                                    <%# Eval("Status") %>
                                                </span>
                                            </td>
                                            <%-- OrderDate --%>
                                            <td style="color:var(--muted);font-size:12px;white-space:nowrap;">
                                                <%# Eval("OrderDate") != DBNull.Value ? Convert.ToDateTime(Eval("OrderDate")).ToString("MMM dd, yyyy") : "—" %>
                                            </td>
                                            <%-- Actions --%>
                                            <td style="white-space:nowrap;">
                                                <asp:LinkButton runat="server" CommandName="SetCompleted"
                                                    CommandArgument='<%# Eval("OrderID") %>'
                                                    CssClass="btn btn-success btn-xs"
                                                    ToolTip="Mark as Completed"
                                                    OnClientClick="return confirm('Mark this order as Completed?');">
                                                    <i class="fas fa-check"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="SetCancelled"
                                                    CommandArgument='<%# Eval("OrderID") %>'
                                                    CssClass="btn btn-warn btn-xs"
                                                    ToolTip="Mark as Cancelled"
                                                    OnClientClick="return confirm('Mark this order as Cancelled?');">
                                                    <i class="fas fa-ban"></i>
                                                </asp:LinkButton>
                                                <asp:LinkButton runat="server" CommandName="DeleteOrder"
                                                    CommandArgument='<%# Eval("OrderID") %>'
                                                    CssClass="btn btn-danger btn-xs"
                                                    ToolTip="Delete Order"
                                                    OnClientClick="return confirm('Delete this order permanently?');">
                                                    <i class="fas fa-trash"></i>
                                                </asp:LinkButton>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                        <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="empty-state">
                            <i class="fas fa-clipboard-list"></i><p>No orders found.</p>
                        </asp:Panel>
                    </div>
                </div>
            </div>

        </div>
    </div>

</form>

<script>
    var sectionTitles = {
        'dashboard': 'Dashboard',
        'users':     'Manage Users',
        'services':  'Manage Services',
        'orders':    'Manage Orders',
    };

    function showSection(id, navId) {
        document.querySelectorAll('.section').forEach(function(s){ s.classList.remove('active'); });
        var sec = document.getElementById('section-' + id);
        if (sec) sec.classList.add('active');

        document.querySelectorAll('.nav-item').forEach(function(n){ n.classList.remove('active'); });
        var nav = document.getElementById(navId);
        if (nav) nav.classList.add('active');

        var tb = document.getElementById('topbarTitle');
        if (tb) tb.textContent = sectionTitles[id] || id;

        // Persist active section so postbacks restore it
        var hf = document.getElementById('<%= hfActiveSection.ClientID %>');
        if (hf) hf.value = id;
    }

    // On page load (including after postback), restore the last active section
    document.addEventListener('DOMContentLoaded', function () {
        var hf = document.getElementById('<%= hfActiveSection.ClientID %>');
        var active = hf ? hf.value : 'dashboard';
        if (!active || active === '') active = 'dashboard';

        var navMap = {
            'dashboard': 'navDash',
            'users': 'navUsers',
            'services': 'navServices',
            'orders': 'navOrders',
        };

        // Only switch if not already the default dashboard — avoids a flash on fresh load
        showSection(active, navMap[active] || 'navDash');
    });
</script>
</body>
</html>
