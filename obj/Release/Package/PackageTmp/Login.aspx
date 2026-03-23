<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Skill_Link.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign In - SkillLink</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --accent-glow: rgba(72, 229, 194, 0.18);
            --bg:          #0d1117;
            --bg2:         #161b22;
            --card:        #1c2230;
            --border:      rgba(255,255,255,0.07);
            --text:        #e2e8f0;
            --muted:       #64748b;
            --danger:      #f87171;
            --success:     #4ade80;
        }

        *, *::before, *::after { 
            box-sizing: border-box; 
            margin: 0; 
            padding: 0; 
        }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* ── ANIMATED BACKGROUND ── */
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background:
                radial-gradient(ellipse 80% 60% at 20% -10%, rgba(72,229,194,0.08) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 80% 110%, rgba(37,99,235,0.07) 0%, transparent 60%);
            pointer-events: none;
            z-index: 0;
        }

        /* ── HEADER ── */
        .header {
            position: relative;
            z-index: 10;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 32px;
            border-bottom: 1px solid var(--border);
            background: rgba(13,17,23,0.85);
            backdrop-filter: blur(12px);
        }
        .logo-text {
            font-family: 'Syne', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: var(--accent);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .header-nav {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .header-nav a {
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.15s, background 0.15s;
        }
        .header-nav a:hover { 
            color: var(--accent); 
            background: var(--accent-glow); 
        }
        .header-nav .join-btn {
            background: var(--accent);
            color: #062023;
            font-weight: 600;
            padding: 7px 18px;
        }
        .header-nav .join-btn:hover { 
            background: var(--accent-dark); 
            color: #fff; 
        }

        /* ── MAIN LAYOUT ── */
        .page-body {
            position: relative;
            z-index: 1;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 48px 20px;
        }

        /* ── AUTH CARD ── */
        .auth-wrap {
            width: 100%;
            max-width: 440px;
            animation: fadeUp 0.45s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; 
                   transform: translateY(22px); 
            }
            to   { 
                opacity: 1;
                transform: translateY(0);    
            }
        }

        .auth-heading {
            text-align: center;
            margin-bottom: 32px;
        }
        .auth-heading h1 {
            font-family: 'Syne', sans-serif;
            font-size: 30px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        .auth-heading p {
            font-size: 15px;
            color: var(--muted);
        }
        .auth-heading p a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 500;
        }
        .auth-heading p a:hover { 
            text-decoration: underline; 
        }

        .auth-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 36px 32px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.35), 0 0 0 1px rgba(72,229,194,0.04);
        }

        /* Tab switcher */
        .tab-bar {
            display: flex;
            background: rgba(255,255,255,0.04);
            border-radius: 10px;
            padding: 4px;
            margin-bottom: 28px;
            gap: 4px;
        }
        .tab-btn {
            flex: 1;
            padding: 9px;
            border: none;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            background: transparent;
            color: var(--muted);
            transition: all 0.2s;
        }
        .tab-btn.active {
            background: var(--accent);
            color: #062023;
            box-shadow: 0 2px 10px rgba(72,229,194,0.25);
        }

        /* Form panel */
        .form-panel { 
            display: none; 
        }
        .form-panel.active { 
            display: block; 
            animation: fadeIn 0.25s ease both; 
        }
        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }

        /* Form group */
        .form-group {
            margin-bottom: 18px;
        }
        .form-group label {
            display: block;
            font-size: 12px;
            font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 7px;
        }
        .input-wrap 
        {
            position: relative;
        }
        .input-wrap i 
        {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 14px;
            pointer-events: none;
            transition: color 0.15s;
        }
        .input-wrap:focus-within i 
        { 
            color: var(--accent); 

        }
        .input-wrap .toggle-pass {
            position: absolute;
            right: 40px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 14px;
            cursor: pointer;
            pointer-events: all;
            background: none;
            border: none;
            padding: 0;
            transition: color 0.15s;
        }
        .input-wrap .toggle-pass:hover { 
            color: var(--accent);
        }

        .aspTextBox, input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 11px 14px 11px 38px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 9px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
            outline: none;
        }
        .aspTextBox:focus, input:focus {
            border-color: var(--accent);
            background: rgba(72,229,194,0.04);
            box-shadow: 0 0 0 3px rgba(72,229,194,0.1);
        }
        .aspTextBox::placeholder { 
            color: #475569; 
        }

        /* Password field needs extra right padding for toggle */
        .has-toggle .aspTextBox { 
            padding-right: 40px;
        }

        /* Forgot password */
        .forgot-row {
            display: flex;
            justify-content: flex-end;
            margin-top: -10px;
            margin-bottom: 18px;
        }
        .forgot-row a {
            font-size: 13px;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.15s;
        }
        .forgot-row a:hover { 
            color: var(--accent); 
        }

        /* Submit button */
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: var(--accent);
            border: none;
            color: #062023;
            font-size: 15px;
            font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            border-radius: 9px;
            cursor: pointer;
            transition: background 0.15s, transform 0.1s, box-shadow 0.15s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            box-shadow: 0 4px 18px rgba(72,229,194,0.2);
        }
        .btn-submit:hover {
            background: var(--accent-dark);
            box-shadow: 0 6px 24px rgba(72,229,194,0.3);
            transform: translateY(-1px);
        }
        .btn-submit:active {
            transform: translateY(0); 
        }

        /* Alert messages */
        .alert {
            display: none;
            padding: 11px 14px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 18px;
            align-items: center;
            gap: 9px;
        }
        .alert.show { 
            display: flex; 
        }
        .alert-error   { 
            background: rgba(248,113,113,0.1);
            border: 1px solid rgba(248,113,113,0.2); 
            color: var(--danger); 
        }
        .alert-success { 
            background: rgba(74,222,128,0.1);
            border: 1px solid rgba(74,222,128,0.2); 
            color: var(--success); 
        }

        /* Divider */
        .or-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 22px 0;
            color: var(--muted);
            font-size: 12px;
            font-weight: 500;
        }
        .or-divider::before, .or-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        /* Social login buttons */
        .social-row {
            display: flex;
            gap: 10px;
        }
        .btn-social {
            flex: 1;
            padding: 10px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 9px;
            color: #94a3b8;
            font-size: 13px;
            font-weight: 500;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.15s, border-color 0.15s, color 0.15s;
            text-decoration: none;
        }
        .btn-social:hover {
            background: rgba(255,255,255,0.07);
            border-color: rgba(255,255,255,0.15);
            color: #fff;
        }

        /* ── FOOTER ── */
        .site-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            z-index: 1000;
            background: rgba(13,17,23,0.9);
            color: #fff;
            border-top: 1px solid var(--border);
            color: #64748b;
            padding: 32px 20px 20px;
        }

        .footer-inner {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            gap: 28px;
            flex-wrap: wrap;
            justify-content: space-between;
        }
        .footer-col { 
            min-width: 150px; 
            flex: 1; 
            margin-bottom: 16px;
        }
        .footer-col h4 { 
            color: #94a3b8; 
            font-family: 'Syne', sans-serif; 
            font-size: 13px; 
            margin-bottom: 10px; 
            text-transform: uppercase; 
            letter-spacing: 0.6px; 
        }
        .footer-col ul { 
            list-style: none; 
        }
        .footer-col ul li { 
            margin-bottom: 7px; 
        }
        .footer-col a { 
            color: #475569; 
            text-decoration: none; 
            font-size: 13px; 
            transition: color 0.15s; }
        .footer-col a:hover { 
            color: var(--accent); 
        }
        .footer-brand .logo { 
            font-family: 'Syne', sans-serif; 
            font-size: 18px; 
            font-weight: 800; 
            color: var(--accent);
        }
        .footer-brand p { 
            color: #475569; 
            font-size: 13px; 
            margin-top: 8px; 
            line-height: 1.6; 
            max-width: 240px; 
        }
        .socials { 
            display: flex; 
            gap: 8px; 
            margin-top: 12px; 
        }
        .socials a {
            width: 30px; height: 30px;
            border-radius: 6px;
            background: rgba(255,255,255,0.04);
            color: #475569;
            display: inline-flex; 
            align-items: center; 
            justify-content: center;
            text-decoration: none;
            font-size: 13px;
            transition: background 0.15s, color 0.15s;
        }
        .socials a:hover { 
            background: var(--accent); color: #062023; 
        }
        .footer-bottom {
            max-width: 1100px;
            margin: 16px auto 0;
            padding-top: 14px;
            border-top: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            flex-wrap: wrap;
            gap: 8px;
        }
        .footer-links { 
            display: flex; gap: 12px;
        }
        .footer-links a { 
            color: #475569;
            text-decoration: none; 
            font-size: 12px;
        }
        .footer-links a:hover { 
            color: var(--accent); 
        }
        @media (max-width: 520px)
        {
            .auth-card { 
                padding: 24px 18px; 
            }
            .header { 
                padding: 14px 18px;
            }
            .social-row { 
                flex-direction: column; 
            }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <asp:HyperLink ID="lnkHome" runat="server" CssClass="logo-text" Text="SkillLink" />
        <nav class="header-nav">
            <asp:HyperLink ID="lnkJoin" runat="server" NavigateUrl="~/Create.aspx" Text="Sign up" CssClass="join-btn" />
        </nav>
    </div>

    <!-- MAIN -->
    <div class="page-body">
        <div class="auth-wrap">

            <div class="auth-heading">
                <h1>Welcome back</h1>
                <p>Don't have an account? <a href="Create.aspx">Sign up for free</a></p>
            </div>

            <div class="auth-card">

                <!-- Tab switcher -->
                <div class="tab-bar">
                    <button type="button" id="tabLogin" class="tab-btn active" onclick="switchTab('login')">Sign In</button>
                    <button type="button" id="tabRegister" class="tab-btn" onclick="switchTab('register')">Create Account</button>
                </div>

                <!-- ── LOGIN PANEL ── -->
                <div id="panelLogin" class="form-panel active">

                    <asp:Label ID="lblLoginError" runat="server" CssClass="alert alert-error" />

                    <div class="form-group">
                        <label>Email Address</label>
                        <div class="input-wrap">
                            <i class="fas fa-envelope"></i>
                            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="aspTextBox" placeholder="you@example.com" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <div class="input-wrap has-toggle">
                            <i class="fas fa-lock"></i>
                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="aspTextBox" placeholder="Enter your password" />
                            <button type="button" class="toggle-pass" onclick="togglePass('txtPassword', this)" tabindex="-1">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div class="forgot-row">
                        <a href="ForgotPassword.aspx">Forgot password?</a>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn-submit" OnClick="btnLogin_Click" />

                    <div class="or-divider">or continue with</div>
                    <div class="social-row">
                        <a href="#" class="btn-social"><i class="fab fa-google"></i> Google</a>
                        <a href="#" class="btn-social"><i class="fab fa-facebook-f"></i> Facebook</a>
                    </div>
                </div>

                <!-- ── REGISTER PANEL (redirect prompt) ── -->
                <div id="panelRegister" class="form-panel">
                    <asp:Label ID="lblRegError" runat="server" CssClass="alert alert-error" />

                    <div style="text-align:center;padding:12px 0 24px;">
                        <i class="fas fa-user-plus" style="font-size:40px;color:var(--accent);margin-bottom:16px;display:block;"></i>
                        <p style="color:#94a3b8;font-size:15px;line-height:1.6;">
                            Create your SkillLink account to start offering services, hiring talent, and growing your freelance career.
                        </p>
                    </div>

                    <asp:Button ID="btnRegister" runat="server" Text="Create My Account" CssClass="btn-submit" OnClick="btnRegister_Click" />
                </div>

            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
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
    // Tab switching
    function switchTab(tab) {
        var isLogin = tab === 'login';
        document.getElementById('panelLogin').classList.toggle('active', isLogin);
        document.getElementById('panelRegister').classList.toggle('active', !isLogin);
        document.getElementById('tabLogin').classList.toggle('active', isLogin);
        document.getElementById('tabRegister').classList.toggle('active', !isLogin);
    }

    // Password visibility toggle
    function togglePass(clientId, btn) {
        var field = document.getElementById(clientId);
        var icon = btn.querySelector('i');
        if (!field) return;
        if (field.type === 'password') {
            field.type = 'text';
            icon.classList.replace('fa-eye', 'fa-eye-slash');
        } else {
            field.type = 'password';
            icon.classList.replace('fa-eye-slash', 'fa-eye');
        }
    }

    // If server set an error, keep correct tab visible
    (function () {
        var loginErr  = document.getElementById('<%= lblLoginError.ClientID %>');
        var regErr    = document.getElementById('<%= lblRegError.ClientID %>');
        if (loginErr && loginErr.classList.contains('show')) switchTab('login');
        if (regErr && regErr.classList.contains('show')) switchTab('register');
    })();
</script>
</body>
</html>
