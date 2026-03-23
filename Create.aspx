<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Create.aspx.cs" Inherits="Skill_Link.Create" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Account - SkillLink</title>
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
            --warn:        #fbbf24;
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'DM Sans', sans-serif;
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
                radial-gradient(ellipse 70% 50% at 80% -10%, rgba(72,229,194,0.07) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 10% 110%, rgba(37,99,235,0.07) 0%, transparent 60%);
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
        .header-nav .sign-in-btn {
            background: transparent;
            border: 1.5px solid rgba(255,255,255,0.1);
            color: #cbd5e1;
            font-weight: 600;
        }
        .header-nav .sign-in-btn:hover { border-color: var(--accent); color: var(--accent); background: var(--accent-glow); }

        /* ── MAIN LAYOUT ── */
        .page-body {
            position: relative;
            z-index: 1;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px 56px;
        }

        /* ── AUTH CARD ── */
        .auth-wrap {
            width: 100%;
            max-width: 480px;
            animation: fadeUp 0.45s ease both;
        }
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .auth-heading {
            text-align: center;
            margin-bottom: 28px;
        }
        .auth-heading h1 {
            font-family: 'Syne', sans-serif;
            font-size: 30px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }
        .auth-heading p { font-size: 15px; color: var(--muted); }
        .auth-heading p a { color: var(--accent); text-decoration: none; font-weight: 500; }
        .auth-heading p a:hover { text-decoration: underline; }

        .auth-card {
            background: #1c2230;
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 18px;
            padding: 36px 32px;
            box-shadow: 0 32px 80px rgba(0,0,0,0.5), 0 0 0 1px rgba(72,229,194,0.05);
        }

        /* ── FORM ELEMENTS ── */
        .form-group { margin-bottom: 16px; }
        .form-group label {
            display: block;
            font-size: 11px;
            font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 7px;
        }
        .input-wrap { position: relative; }
        .input-wrap i.field-icon {
            position: absolute;
            left: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 14px;
            pointer-events: none;
            transition: color 0.15s;
        }
        .input-wrap:focus-within i.field-icon { color: var(--accent); }
        .input-wrap .toggle-pass {
            position: absolute;
            right: 13px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-size: 14px;
            cursor: pointer;
            background: none;
            border: none;
            padding: 0;
            transition: color 0.15s;
        }
        .input-wrap .toggle-pass:hover { color: var(--accent); }

        .aspTextBox {
            width: 100%;
            padding: 11px 14px 11px 38px;
            background: #0d1117 !important;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 9px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            color: #e2e8f0 !important;
            transition: border-color 0.15s, box-shadow 0.15s;
            outline: none;
            -webkit-text-fill-color: #e2e8f0;
            caret-color: #e2e8f0;
        }
        .aspTextBox:-webkit-autofill,
        .aspTextBox:-webkit-autofill:hover,
        .aspTextBox:-webkit-autofill:focus {
            -webkit-box-shadow: 0 0 0 1000px #0d1117 inset !important;
            -webkit-text-fill-color: #e2e8f0 !important;
            transition: background-color 9999s ease-in-out 0s;
        }
        .aspTextBox:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(72,229,194,0.12);
        }
        .aspTextBox.input-error { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(248,113,113,0.1); }
        .aspTextBox.input-ok    { border-color: var(--success) !important; }
        .aspTextBox::placeholder { color: #3d4f66; }
        .has-toggle .aspTextBox { padding-right: 40px; }

        /* Field hint */
        .field-hint {
            font-size: 11px;
            margin-top: 5px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .field-hint.ok  { color: var(--success); }
        .field-hint.err { color: var(--danger); }

        /* Password strength bar */
        .strength-wrap { margin-top: 6px; }
        .strength-bar {
            height: 4px;
            border-radius: 4px;
            background: rgba(255,255,255,0.07);
            overflow: hidden;
            margin-bottom: 4px;
        }
        .strength-fill {
            height: 100%;
            border-radius: 4px;
            width: 0%;
            transition: width 0.3s, background 0.3s;
        }
        .strength-label { font-size: 11px; color: var(--muted); }

        /* Terms checkbox */
        .terms-row {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin: 18px 0;
        }
        .terms-row input[type="checkbox"] {
            width: 16px; height: 16px;
            margin-top: 2px;
            accent-color: var(--accent);
            flex-shrink: 0;
            cursor: pointer;
        }
        .terms-row label {
            font-size: 13px;
            color: #94a3b8;
            text-transform: none;
            letter-spacing: 0;
            font-weight: 400;
            cursor: pointer;
        }
        .terms-row label a { color: var(--accent); text-decoration: none; }
        .terms-row label a:hover { text-decoration: underline; }

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
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.15s, transform 0.1s, box-shadow 0.15s;
            box-shadow: 0 4px 18px rgba(72,229,194,0.2);
        }
        .btn-submit:hover {
            background: var(--accent-dark);
            box-shadow: 0 6px 24px rgba(72,229,194,0.3);
            transform: translateY(-1px);
        }
        .btn-submit:active { transform: translateY(0); }
        .btn-submit:disabled { opacity: 0.45; cursor: not-allowed; transform: none; }

        /* Alert */
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
        .alert.show { display: flex; }
        .alert-error   { background: rgba(248,113,113,0.1); border: 1px solid rgba(248,113,113,0.2); color: var(--danger); }
        .alert-success { background: rgba(74,222,128,0.1);  border: 1px solid rgba(74,222,128,0.2);  color: var(--success); }

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
        .or-divider::before, .or-divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }

        /* Social buttons */
        .social-row { display: flex; gap: 10px; }
        .btn-social {
            flex: 1;
            padding: 10px;
            background: rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.09);
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
        .btn-social:hover { background: rgba(255,255,255,0.07); border-color: rgba(255,255,255,0.18); color: #fff; }

        /* ── FOOTER ── */
        .site-footer {
            position: relative; 
            z-index: 1;
            background: rgba(13,17,23,0.9);
            border-top: 1px solid var(--border);
            color: #64748b;
            padding: 32px 20px 20px;
        }
        .footer-inner { max-width: 1100px; margin: 0 auto; display: flex; gap: 28px; flex-wrap: wrap; justify-content: space-between; }
        .footer-col { min-width: 150px; flex: 1; margin-bottom: 16px; }
        .footer-col h4 { color: #94a3b8; font-family: 'Syne', sans-serif; font-size: 13px; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.6px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 7px; }
        .footer-col a { color: #475569; text-decoration: none; font-size: 13px; transition: color 0.15s; }
        .footer-col a:hover { color: var(--accent); }
        .footer-brand .logo { font-family: 'Syne', sans-serif; font-size: 18px; font-weight: 800; color: var(--accent); }
        .footer-brand p { color: #475569; font-size: 13px; margin-top: 8px; line-height: 1.6; max-width: 240px; }
        .socials { display: flex; gap: 8px; margin-top: 12px; }
        .socials a { width: 30px; height: 30px; border-radius: 6px; background: rgba(255,255,255,0.04); color: #475569; display: inline-flex; align-items: center; justify-content: center; text-decoration: none; font-size: 13px; transition: background 0.15s, color 0.15s; }
        .socials a:hover { background: var(--accent); color: #062023; }
        .footer-bottom { max-width: 1100px; margin: 16px auto 0; padding-top: 14px; border-top: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; font-size: 12px; flex-wrap: wrap; gap: 8px; }
        .footer-links { display: flex; gap: 12px; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 12px; }
        .footer-links a:hover { color: var(--accent); }

        @media (max-width: 560px) {
            .auth-card  { padding: 24px 18px; }
            .header     { padding: 14px 18px; }
            .social-row { flex-direction: column; }
        }
                        /* ── ROLE SELECTOR ── */
        .role-label {
            display: block;
            font-size: 11px; font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase; letter-spacing: 0.6px;
            margin-bottom: 10px;
        }
        .role-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
            margin-bottom: 20px;
        }
        .role-card {
            border: 2px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            padding: 16px 14px;
            cursor: pointer;
            transition: border-color 0.15s, background 0.15s;
            text-align: center;
            position: relative;
            background: rgba(255,255,255,0.02);
        }
        .role-card:hover { border-color: rgba(72,229,194,0.4); background: rgba(72,229,194,0.04); }
        .role-card.selected { border-color: var(--accent); background: rgba(72,229,194,0.08); }
        .role-check {
            position: absolute; top: 8px; right: 8px;
            width: 18px; height: 18px; border-radius: 50%;
            background: var(--accent);
            display: flex; align-items: center; justify-content: center;
            font-size: 10px; color: #062023;
            opacity: 0; transition: opacity 0.15s;
        }
        .role-card.selected .role-check { opacity: 1; }
        .role-icon { font-size: 26px; margin-bottom: 8px; display: block; }
        .role-card.freelancer .role-icon { color: var(--accent); }
        .role-card.client .role-icon { color: #60a5fa; }
        .role-title { font-size: 14px; font-weight: 600; color: var(--text); margin-bottom: 3px; }
        .role-desc { font-size: 11px; color: var(--muted); line-height: 1.4; }
        .role-error { font-size: 12px; color: var(--danger); margin-top: -12px; margin-bottom: 14px; display: none; }
        .role-error.show { display: block; }

    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <asp:HyperLink ID="lnkHome" runat="server" CssClass="logo-text" Text="SkillLink" />
        <nav class="header-nav">
            <asp:HyperLink ID="lnkSignIn" runat="server" NavigateUrl="~/Login.aspx" Text="Sign In" CssClass="sign-in-btn" />
        </nav>
    </div>

    <!-- MAIN -->
    <div class="page-body">
        <div class="auth-wrap">

            <div class="auth-heading">
                <h1>Join SkillLink</h1>
                <p>Already have an account? <a href="Login.aspx">Sign in</a></p>
            </div>

            <div class="auth-card">

                <!-- Alerts -->
                <asp:Label ID="lblError" runat="server" CssClass="alert alert-error" />
                <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" />
                <%-- Hidden field stores selected role --%>
                <asp:HiddenField ID="hdnRole" runat="server" Value="" />

                <%-- ROLE SELECTOR --%>
                <span class="role-label">I want to...</span>
                <div class="role-cards">
                    <div class="role-card freelancer" id="cardFreelancer" onclick="selectRole('Freelancer')">
                        <div class="role-check"><i class="fas fa-check"></i></div>
                        <span class="role-icon"><i class="fas fa-briefcase"></i></span>
                        <div class="role-title">Offer Services</div>
                        <div class="role-desc">I'm a freelancer — I want to sell my skills</div>
                    </div>
                    <div class="role-card client" id="cardClient" onclick="selectRole('Client')">
                        <div class="role-check"><i class="fas fa-check"></i></div>
                        <span class="role-icon"><i class="fas fa-search"></i></span>
                        <div class="role-title">Hire Talent</div>
                        <div class="role-desc">I'm a client — I want to find and hire freelancers</div>
                    </div>
                </div>
                <div class="role-error" id="roleError">
                    <i class="fas fa-exclamation-circle"></i> Please select a role to continue.
                </div>
                <!-- Username -->
                <div class="form-group">
                    <label>Username</label>
                    <div class="input-wrap">
                        <i class="fas fa-at field-icon"></i>
                        <asp:TextBox ID="txtNewUsername" runat="server" CssClass="aspTextBox" placeholder="e.g. john_dev" />
                    </div>
                    <div class="field-hint" id="hintUsername"><i class="fas fa-info-circle"></i> 3–20 characters, letters, numbers and underscores only</div>
                </div>

                <!-- Email -->
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrap">
                        <i class="fas fa-envelope field-icon"></i>
                        <asp:TextBox ID="txtNewEmail" runat="server" TextMode="Email" CssClass="aspTextBox" placeholder="you@example.com" />
                    </div>
                </div>

                <!-- Password -->
                <div class="form-group">
                    <label>Password</label>
                    <div class="input-wrap has-toggle">
                        <i class="fas fa-lock field-icon"></i>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="aspTextBox" placeholder="Create a strong password" oninput="checkStrength(this.value)" />
                        <button type="button" class="toggle-pass" onclick="togglePass('<%=txtNewPassword.ClientID%>', this)" tabindex="-1"><i class="fas fa-eye"></i></button>
                    </div>
                    <div class="strength-wrap">
                        <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                        <span class="strength-label" id="strengthLabel">Enter a password</span>
                    </div>
                </div>

                <!-- Confirm Password -->
                <div class="form-group">
                    <label>Confirm Password</label>
                    <div class="input-wrap has-toggle">
                        <i class="fas fa-lock field-icon"></i>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="aspTextBox" placeholder="Repeat your password" oninput="checkMatch(this.value)" />
                        <button type="button" class="toggle-pass" onclick="togglePass('<%=txtConfirmPassword.ClientID%>', this)" tabindex="-1"><i class="fas fa-eye"></i></button>
                    </div>
                    <div class="field-hint" id="hintMatch"><i class="fas fa-circle"></i> Passwords must match</div>
                </div>

                <!-- Terms -->
                <div class="terms-row">
                    <input type="checkbox" id="chkTerms" />
                    <label for="chkTerms">I agree to the <a href="Terms.aspx">Terms of Service</a> and <a href="Privacy.aspx">Privacy Policy</a></label>
                </div>

                <!-- Submit -->
                <asp:Button ID="btnCreateAccount" runat="server" Text="Create My Account"
                    CssClass="btn-submit" OnClick="btnCreateAccount_Click"
                    OnClientClick="if(!document.getElementById('chkTerms').checked){ alert('You must agree to the Terms of Service and Privacy Policy to create an account.'); return false; } if(!document.getElementById('hdnRole').value){ document.getElementById('roleError').classList.add('show'); return false; }" />

                <div class="or-divider">or sign up with</div>
                <div class="social-row">
                    <a class="btn-social" style="cursor:pointer;" onclick="mockOAuth('Google')"><i class="fab fa-google"></i> Google</a>
                    <a class="btn-social" style="cursor:pointer;" onclick="mockOAuth('Facebook')"><i class="fab fa-facebook-f"></i> Facebook</a>
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
    /* ── Role selection ── */
    function selectRole(role) {
        document.getElementById('cardFreelancer').classList.toggle('selected', role === 'Freelancer');
        document.getElementById('cardClient').classList.toggle('selected', role === 'Client');
        document.getElementById('hdnRole').value = role;
        document.getElementById('roleError').classList.remove('show');
    }
    /* ── Password visibility ── */
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

    /* ── Password strength ── */
    function checkStrength(val) {
        var fill = document.getElementById('strengthFill');
        var label = document.getElementById('strengthLabel');
        var score = 0;
        if (val.length >= 8) score++;
        if (/[A-Z]/.test(val)) score++;
        if (/[0-9]/.test(val)) score++;
        if (/[^A-Za-z0-9]/.test(val)) score++;

        var levels = [
            { w: '0%', bg: 'transparent', text: 'Enter a password' },
            { w: '25%', bg: '#f87171', text: 'Weak' },
            { w: '50%', bg: '#fbbf24', text: 'Fair' },
            { w: '75%', bg: '#60a5fa', text: 'Good' },
            { w: '100%', bg: 'var(--accent)', text: 'Strong' },
        ];
        var idx = val.length === 0 ? 0 : Math.min(score + 1, 4);
        fill.style.width = levels[idx].w;
        fill.style.background = levels[idx].bg;
        label.textContent = levels[idx].text;
        label.style.color = levels[idx].bg;

        checkMatch(document.getElementById('<%= txtConfirmPassword.ClientID %>').value);
    }

    /* ── Password match ── */
    function checkMatch(confirmVal) {
        var pass    = document.getElementById('<%= txtNewPassword.ClientID %>').value;
        var confirm = document.getElementById('<%= txtConfirmPassword.ClientID %>');
        var hint    = document.getElementById('hintMatch');

        if (!confirmVal) {
            hint.className = 'field-hint';
            hint.innerHTML = '<i class="fas fa-circle"></i> Passwords must match';
            confirm.classList.remove('input-ok', 'input-error');
            return;
        }
        if (pass === confirmVal) {
            hint.className = 'field-hint ok';
            hint.innerHTML = '<i class="fas fa-check-circle"></i> Passwords match';
            confirm.classList.add('input-ok');
            confirm.classList.remove('input-error');
        } else {
            hint.className = 'field-hint err';
            hint.innerHTML = '<i class="fas fa-times-circle"></i> Passwords do not match';
            confirm.classList.add('input-error');
            confirm.classList.remove('input-ok');
        }
    }

    /* ── Live username hint ── */
    document.addEventListener('DOMContentLoaded', function () {
        var un = document.getElementById('<%= txtNewUsername.ClientID %>');
        if (un) {
            un.addEventListener('input', function () {
                var hint = document.getElementById('hintUsername');
                var val = this.value.trim();
                if (val.length === 0) {
                    hint.className = 'field-hint';
                    hint.innerHTML = '<i class="fas fa-info-circle"></i> 3–20 characters, letters, numbers and underscores only';
                } else if (/^[a-zA-Z0-9_]{3,20}$/.test(val)) {
                    hint.className = 'field-hint ok';
                    hint.innerHTML = '<i class="fas fa-check-circle"></i> Looks good!';
                    this.classList.remove('input-error');
                } else {
                    hint.className = 'field-hint err';
                    hint.innerHTML = '<i class="fas fa-times-circle"></i> 3–20 chars, letters/numbers/underscore only';
                    this.classList.add('input-error');
                }
            });
        }
    });
    function mockOAuth(provider) {
        var overlay = document.createElement('div');
            overlay.id = 'oauthOverlay';
            overlay.style.cssText = 'position:fixed;inset:0;background:rgba(0,0,0,0.6);z-index:9999;display:flex;align-items:center;justify-content:center;';
            overlay.innerHTML =
            '<div style="background:#1c2230;border-radius:16px;padding:36px 40px;text-align:center;min-width:280px;">' +
                '<div id="oauthSpinner" style="width:48px;height:48px;border-radius:50%;border:3px solid rgba(72,229,194,0.2);border-top-color:#48e5c2;animation:spin 0.8s linear infinite;margin:0 auto 16px;"></div>' +
                '<p style="color:#e2e8f0;font-size:15px;font-weight:600;margin-bottom:4px;">Connecting to ' + provider + '...</p>' +
                '<p style="color:#64748b;font-size:12px;">Please wait</p>' +
                '<div id="oauthMsg" style="display:none;margin-top:16px;">' +
                    '<p style="color:#fbbf24;font-size:13px;"><i class="fas fa-clock" style="margin-right:6px;"></i>' + provider + ' sign-in is coming soon!</p>' +
                    '<p style="color:#64748b;font-size:12px;margin-top:4px;">Please use email and password for now.</p>' +
                    '<button onclick="document.getElementById(\'oauthOverlay\').remove()" style="margin-top:14px;padding:8px 20px;background:#48e5c2;color:#062023;border:none;border-radius:8px;font-weight:600;cursor:pointer;">Got it</button>' +
                    '</div>' +
                '</div>';
            if (!document.getElementById('spinStyle')) {
            var s = document.createElement('style');
            s.id = 'spinStyle';
            s.textContent = '@keyframes spin{to{transform:rotate(360deg)}}';
            document.head.appendChild(s);
        }
            document.body.appendChild(overlay);
            setTimeout(function() {
                document.getElementById('oauthSpinner').style.display = 'none';
            document.getElementById('oauthMsg').style.display = 'block';
        }, 2000);
    }
</script>
</body>
</html>
