<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="Skill_Link.ForgotPassword" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password - SkillLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --accent-glow: rgba(72, 229, 194, 0.18);
            --bg:          #0d1117;
            --card:        #1c2230;
            --border:      rgba(255,255,255,0.07);
            --text:        #e2e8f0;
            --muted:       #64748b;
            --danger:      #f87171;
            --success:     #4ade80;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background: var(--bg);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

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
            font-size: 22px;
            font-weight: 800;
            color: var(--accent);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .header-nav { display: flex; align-items: center; gap: 6px; }
        .header-nav a {
            padding: 7px 14px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #94a3b8;
            text-decoration: none;
            transition: color 0.15s, background 0.15s;
        }
        .header-nav a:hover { color: var(--accent); background: var(--accent-glow); }
        .sign-in-btn {
            background: transparent !important;
            border: 1.5px solid rgba(255,255,255,0.1) !important;
            color: #cbd5e1 !important;
            font-weight: 600 !important;
        }
        .sign-in-btn:hover {
            border-color: var(--accent) !important;
            color: var(--accent) !important;
            background: var(--accent-glow) !important;
        }

        /* ── LAYOUT ── */
        .page-body {
            position: relative;
            z-index: 1;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 48px 20px;
        }
        .auth-wrap {
            width: 100%;
            max-width: 440px;
            animation: fadeUp 0.45s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── HEADING ── */
        .icon-badge {
            width: 64px; height: 64px;
            border-radius: 50%;
            background: rgba(72,229,194,0.1);
            border: 1.5px solid rgba(72,229,194,0.25);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px;
            font-size: 26px;
            color: var(--accent);
        }
        .auth-heading { text-align: center; margin-bottom: 32px; }
        .auth-heading h1 {
            font-size: 28px; font-weight: 800;
            color: #fff; margin-bottom: 8px; letter-spacing: -0.5px;
        }
        .auth-heading p { font-size: 14px; color: var(--muted); line-height: 1.6; }

        /* ── CARD ── */
        .auth-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 18px;
            padding: 36px 32px;
            box-shadow: 0 24px 64px rgba(0,0,0,0.35);
        }

        /* ── FORM ── */
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 12px; font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase; letter-spacing: 0.6px;
            margin-bottom: 7px;
        }
        .input-wrap { position: relative; }
        .input-wrap i {
            position: absolute; left: 13px; top: 50%;
            transform: translateY(-50%);
            color: var(--muted); font-size: 14px;
            pointer-events: none; transition: color 0.15s;
        }
        .input-wrap:focus-within i { color: var(--accent); }
        .aspTextBox {
            width: 100%;
            padding: 11px 14px 11px 38px;
            background: rgba(255,255,255,0.04);
            border: 1px solid var(--border);
            border-radius: 9px;
            font-size: 14px;
            font-family: inherit;
            color: var(--text);
            outline: none;
            transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
        }
        .aspTextBox:focus {
            border-color: var(--accent);
            background: rgba(72,229,194,0.04);
            box-shadow: 0 0 0 3px rgba(72,229,194,0.1);
        }
        .aspTextBox::placeholder { color: #475569; }

        /* ── BUTTON ── */
        .btn-submit {
            width: 100%; padding: 12px;
            background: var(--accent);
            border: none; color: #062023;
            font-size: 15px; font-weight: 700;
            font-family: inherit;
            border-radius: 9px; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: background 0.15s, transform 0.1s, box-shadow 0.15s;
            box-shadow: 0 4px 18px rgba(72,229,194,0.2);
            margin-bottom: 16px;
            text-decoration: none;
        }
        .btn-submit:hover {
            background: var(--accent-dark);
            box-shadow: 0 6px 24px rgba(72,229,194,0.3);
            transform: translateY(-1px);
        }
        .btn-submit:active { transform: translateY(0); }

        /* ── BACK LINK ── */
        .back-link {
            display: flex; align-items: center; justify-content: center; gap: 7px;
            font-size: 14px; color: var(--muted);
            text-decoration: none; transition: color 0.15s; margin-top: 4px;
        }
        .back-link:hover { color: var(--accent); }

        /* ── ALERT ── */
        .alert {
            display: none; padding: 12px 14px; border-radius: 8px;
            font-size: 13px; font-weight: 500; margin-bottom: 20px;
            align-items: center; gap: 9px;
        }
        .alert.show { display: flex; }
        .alert-error { background: rgba(248,113,113,0.1); border: 1px solid rgba(248,113,113,0.2); color: var(--danger); }

        /* ── SUCCESS STATE ── */
        .success-wrap { text-align: center; padding: 8px 0 4px; }
        .success-icon {
            width: 72px; height: 72px; border-radius: 50%;
            background: rgba(74,222,128,0.1);
            border: 2px solid rgba(74,222,128,0.3);
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto 20px; font-size: 30px; color: var(--success);
            animation: popIn 0.45s cubic-bezier(0.34,1.26,0.64,1) both;
        }
        @keyframes popIn {
            from { transform: scale(0.5); opacity: 0; }
            to   { transform: scale(1);   opacity: 1; }
        }
        .success-wrap h3 { font-size: 20px; font-weight: 800; color: #fff; margin-bottom: 10px; }
        .success-wrap p  { font-size: 14px; color: var(--muted); line-height: 1.65; margin-bottom: 24px; }
        .success-wrap p strong { color: var(--accent); }

        /* ── FOOTER ── */
        .site-footer {
            position: relative; z-index: 1;
            background: rgba(13,17,23,0.9);
            border-top: 1px solid var(--border);
            padding: 20px;
        }
        .footer-bottom {
            max-width: 1100px; margin: 0 auto;
            display: flex; justify-content: space-between; align-items: center;
            font-size: 12px; color: #64748b; flex-wrap: wrap; gap: 8px;
        }
        .footer-links { display: flex; gap: 12px; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 12px; transition: color 0.15s; }
        .footer-links a:hover { color: var(--accent); }

        @media (max-width: 520px) {
            .auth-card { padding: 24px 18px; }
            .header    { padding: 14px 18px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <a href="Home.aspx" class="logo-text">SkillLink</a>
        <nav class="header-nav">
            <a href="Login.aspx" class="sign-in-btn">Sign In</a>
        </nav>
    </div>

    <!-- MAIN -->
    <div class="page-body">
        <div class="auth-wrap">

            <div class="auth-heading">
                <div class="icon-badge"><i class="fas fa-key"></i></div>
                <h1>Reset your password</h1>
                <p>Enter the email address linked to your account<br />and we'll send you a reset link.</p>
            </div>

            <div class="auth-card">

                <%-- FORM PANEL: visible by default, hidden after submit --%>
                <asp:Panel ID="pnlForm" runat="server">
                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-error" />

                    <div class="form-group">
                        <label>Email Address</label>
                        <div class="input-wrap">
                            <i class="fas fa-envelope"></i>
                            <asp:TextBox ID="txtEmail" runat="server"
                                TextMode="Email"
                                CssClass="aspTextBox"
                                placeholder="you@example.com"
                                MaxLength="254" />
                        </div>
                    </div>

                    <asp:Button ID="btnReset" runat="server"
                        Text="Send Reset Link"
                        CssClass="btn-submit"
                        OnClick="btnReset_Click" />

                    <a href="Login.aspx" class="back-link">
                        <i class="fas fa-arrow-left"></i> Back to Sign In
                    </a>
                </asp:Panel>

                <%-- SUCCESS PANEL: hidden by default, shown after submit --%>
                <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
                    <div class="success-wrap">
                        <div class="success-icon">
                            <i class="fas fa-envelope-open-text"></i>
                        </div>
                        <h3>Check your inbox</h3>
                        <p>
                            If an account exists for
                            <strong><asp:Literal ID="litEmail" runat="server" /></strong>,
                            a password reset link has been sent.<br /><br />
                            Didn't receive it? Check your spam folder or try again in a few minutes.
                        </p>
                        <a href="Login.aspx" class="btn-submit">
                            <i class="fas fa-sign-in-alt"></i> Back to Sign In
                        </a>
                    </div>
                </asp:Panel>

            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-bottom">
            <p>© <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
            <div class="footer-links">
                <a href="Terms.aspx">Terms</a>
                <a href="Privacy.aspx">Privacy</a>
            </div>
        </div>
    </footer>

</form>
</body>
</html>
