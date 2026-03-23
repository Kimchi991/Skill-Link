<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Privacy.aspx.cs" Inherits="Skill_Link.Privacy" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Privacy Policy - SkillLink</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --accent-glow: rgba(72,229,194,0.18);
            --bg:          #0d1117;
            --card:        #1c2230;
            --border:      rgba(255,255,255,0.07);
            --border-vis:  rgba(255,255,255,0.1);
            --text:        #e2e8f0;
            --muted:       #94a3b8;
            --muted2:      #64748b;
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
                radial-gradient(ellipse 70% 50% at 10% -10%, rgba(37,99,235,0.06) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 90% 110%, rgba(72,229,194,0.05) 0%, transparent 60%);
            pointer-events: none;
            z-index: 0;
        }

        /* ── HEADER ── */
        .header {
            position: sticky;
            top: 0;
            z-index: 10;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px 32px;
            border-bottom: 1px solid var(--border);
            background: rgba(13,17,23,0.9);
            backdrop-filter: blur(12px);
        }
        .logo-text {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
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
        .header-nav .cta {
            background: var(--accent);
            color: #062023;
            font-weight: 700;
            padding: 7px 18px;
        }
        .header-nav .cta:hover { background: var(--accent-dark); color: #fff; }

        /* ── HERO BAND ── */
        .hero-band {
            position: relative;
            z-index: 1;
            border-bottom: 1px solid var(--border);
            padding: 52px 20px 44px;
            text-align: center;
            background: linear-gradient(180deg, rgba(37,99,235,0.04) 0%, transparent 100%);
        }
        .hero-band .badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: rgba(59,130,246,0.1);
            border: 1px solid rgba(59,130,246,0.2);
            color: #60a5fa;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            padding: 5px 14px;
            border-radius: 20px;
            margin-bottom: 18px;
        }
        .hero-band h1 {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            font-size: clamp(26px, 4vw, 40px);
            font-weight: 800;
            color: #fff;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }
        .hero-band p {
            font-size: 15px;
            color: var(--muted);
            max-width: 520px;
            margin: 0 auto;
            line-height: 1.65;
        }
        .last-updated {
            margin-top: 14px;
            font-size: 12px;
            color: var(--muted2);
        }

        /* ── MAIN LAYOUT ── */
        .page-body {
            position: relative;
            z-index: 1;
            flex: 1;
            max-width: 820px;
            margin: 0 auto;
            width: 100%;
            padding: 48px 20px 80px;
        }

        /* ── TOC ── */
        .toc {
            background: var(--card);
            border: 1px solid var(--border-vis);
            border-radius: 14px;
            padding: 22px 24px;
            margin-bottom: 40px;
        }
        .toc-title {
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.8px;
            color: var(--muted);
            margin-bottom: 14px;
        }
        .toc ol {
            list-style: none;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px 24px;
            counter-reset: toc;
        }
        .toc ol li {
            counter-increment: toc;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .toc ol li::before {
            content: counter(toc, decimal-leading-zero);
            font-size: 11px;
            font-weight: 700;
            color: #60a5fa;
            min-width: 22px;
        }
        .toc ol li a {
            font-size: 13px;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.15s;
        }
        .toc ol li a:hover { color: #60a5fa; }

        /* ── SECTIONS ── */
        .section {
            margin-bottom: 44px;
            scroll-margin-top: 80px;
        }
        .section-num {
            font-size: 11px;
            font-weight: 700;
            color: #60a5fa;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 6px;
        }
        .section h2 {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            font-size: 20px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }
        .section p {
            font-size: 14px;
            color: var(--muted);
            line-height: 1.8;
            margin-bottom: 12px;
        }
        .section p:last-child { margin-bottom: 0; }
        .section ul {
            list-style: none;
            margin: 12px 0;
        }
        .section ul li {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            font-size: 14px;
            color: var(--muted);
            line-height: 1.7;
            margin-bottom: 8px;
        }
        .section ul li::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: #60a5fa;
            flex-shrink: 0;
            margin-top: 7px;
        }

        /* ── DATA TABLE ── */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            margin: 16px 0;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid var(--border-vis);
        }
        .data-table th {
            background: rgba(255,255,255,0.04);
            padding: 10px 14px;
            text-align: left;
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.6px;
            color: var(--muted2);
            font-weight: 600;
            border-bottom: 1px solid var(--border-vis);
        }
        .data-table td {
            padding: 11px 14px;
            border-bottom: 1px solid var(--border);
            color: var(--muted);
            vertical-align: top;
            line-height: 1.6;
        }
        .data-table tr:last-child td { border-bottom: none; }

        /* ── INFO BOX ── */
        .info-box {
            background: rgba(59,130,246,0.05);
            border: 1px solid rgba(59,130,246,0.18);
            border-radius: 10px;
            padding: 16px 20px;
            font-size: 14px;
            color: var(--muted);
            line-height: 1.7;
            margin: 16px 0;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .info-box i { color: #60a5fa; font-size: 16px; margin-top: 2px; flex-shrink: 0; }

        /* ── RIGHTS GRID ── */
        .rights-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            margin: 16px 0;
        }
        .right-item {
            background: var(--card);
            border: 1px solid var(--border-vis);
            border-radius: 10px;
            padding: 14px 16px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }
        .right-item i {
            color: var(--accent);
            font-size: 15px;
            margin-top: 2px;
            flex-shrink: 0;
            width: 18px;
            text-align: center;
        }
        .right-item div { font-size: 13px; color: var(--muted); line-height: 1.5; }
        .right-item strong { display: block; color: var(--text); font-size: 13px; margin-bottom: 3px; }

        /* ── DIVIDER ── */
        .divider { height: 1px; background: var(--border); margin: 40px 0; }

        /* ── CONTACT BAND ── */
        .contact-band {
            background: var(--card);
            border: 1px solid var(--border-vis);
            border-radius: 16px;
            padding: 32px;
            text-align: center;
        }
        .contact-band h3 {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            font-size: 18px;
            font-weight: 800;
            color: #fff;
            margin-bottom: 8px;
        }
        .contact-band p { font-size: 14px; color: var(--muted); margin-bottom: 20px; }
        .btn-outline {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 22px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            border: 1.5px solid var(--border-vis);
            color: var(--muted);
            text-decoration: none;
            transition: all 0.15s;
        }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }

        /* ── FOOTER ── */
        .site-footer {
            position: relative;
            z-index: 1;
            background: rgba(13,17,23,0.95);
            border-top: 1px solid var(--border);
            padding: 20px;
        }
        .footer-bottom {
            max-width: 1100px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
            color: var(--muted2);
            flex-wrap: wrap;
            gap: 8px;
        }
        .footer-links { display: flex; gap: 12px; }
        .footer-links a { color: #475569; text-decoration: none; font-size: 12px; transition: color 0.15s; }
        .footer-links a:hover { color: var(--accent); }

        @media (max-width: 600px) {
            .toc ol { grid-template-columns: 1fr; }
            .rights-grid { grid-template-columns: 1fr; }
            .header { padding: 14px 18px; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <a href="Home.aspx" class="logo-text">SkillLink</a>
        <nav class="header-nav">
            <a href="Home.aspx">Browse Services</a>
            <a href="Login.aspx" class="cta">Sign In</a>
        </nav>
    </div>

    <!-- HERO BAND -->
    <div class="hero-band">
        <div class="badge"><i class="fas fa-shield-alt"></i> Privacy</div>
        <h1>Privacy Policy</h1>
        <p>Your privacy matters to us. This policy explains what data we collect, how we use it, and the controls you have over your information.</p>
        <div class="last-updated">Last updated: January 1, 2026 &nbsp;·&nbsp; Version 1.0</div>
    </div>

    <!-- MAIN -->
    <div class="page-body">

        <!-- TOC -->
        <div class="toc">
            <div class="toc-title"><i class="fas fa-list" style="margin-right:6px;"></i>Table of Contents</div>
            <ol>
                <li><a href="#overview">Overview</a></li>
                <li><a href="#collection">Data We Collect</a></li>
                <li><a href="#usage">How We Use Your Data</a></li>
                <li><a href="#sharing">Data Sharing</a></li>
                <li><a href="#cookies">Cookies</a></li>
                <li><a href="#security">Security</a></li>
                <li><a href="#retention">Data Retention</a></li>
                <li><a href="#rights">Your Rights</a></li>
                <li><a href="#children">Children's Privacy</a></li>
                <li><a href="#contact">Contact Us</a></li>
            </ol>
        </div>

        <!-- 1. OVERVIEW -->
        <div class="section" id="overview">
            <div class="section-num">01</div>
            <h2>Overview</h2>
            <p>SkillLink ("we", "us", or "our") is committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, store, use, and share information about you when you use our Platform.</p>
            <p>By using SkillLink, you consent to the data practices described in this policy. If you do not agree with this policy, please discontinue your use of the Platform.</p>
            <div class="info-box">
                <i class="fas fa-lock"></i>
                <span>We never sell your personal data to third parties for advertising purposes. Your data is used solely to operate and improve the SkillLink platform.</span>
            </div>
        </div>

        <!-- 2. DATA COLLECTION -->
        <div class="section" id="collection">
            <div class="section-num">02</div>
            <h2>Data We Collect</h2>
            <p>We collect information you provide directly to us, as well as data generated through your use of the Platform.</p>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Data Type</th>
                        <th>Examples</th>
                        <th>How Collected</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td><strong style="color:var(--text);">Account Data</strong></td>
                        <td>Username, email address, password (hashed), name, phone, location</td>
                        <td>Registration form</td>
                    </tr>
                    <tr>
                        <td><strong style="color:var(--text);">Transaction Data</strong></td>
                        <td>Order history, service titles, payment methods, amounts paid</td>
                        <td>Order placement</td>
                    </tr>
                    <tr>
                        <td><strong style="color:var(--text);">Content Data</strong></td>
                        <td>Service listings, project requirements, reviews and ratings</td>
                        <td>Platform activity</td>
                    </tr>
                    <tr>
                        <td><strong style="color:var(--text);">Usage Data</strong></td>
                        <td>Pages visited, search queries, browser type, IP address</td>
                        <td>Automatically collected</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 3. USAGE -->
        <div class="section" id="usage">
            <div class="section-num">03</div>
            <h2>How We Use Your Data</h2>
            <p>We use the information we collect for the following purposes:</p>
            <ul>
                <li>To create and manage your account and provide access to Platform features</li>
                <li>To process orders, payments, and facilitate transactions between Buyers and Sellers</li>
                <li>To send transactional communications such as order confirmations and status updates</li>
                <li>To improve the Platform's functionality, performance, and user experience</li>
                <li>To detect, prevent, and respond to fraud, abuse, or security incidents</li>
                <li>To comply with applicable legal obligations and enforce our Terms of Service</li>
            </ul>
            <p>We do not use your personal data for automated decision-making or profiling that produces legal or similarly significant effects.</p>
        </div>

        <!-- 4. SHARING -->
        <div class="section" id="sharing">
            <div class="section-num">04</div>
            <h2>Data Sharing</h2>
            <p>We do not sell, rent, or trade your personal information. We may share your data only in the following limited circumstances:</p>
            <ul>
                <li><strong style="color:var(--text);">Between Buyers and Sellers:</strong> When an order is placed, relevant order details (project requirements, communication preferences) are shared with the Seller to fulfil the service.</li>
                <li><strong style="color:var(--text);">Service Providers:</strong> We use third-party providers (such as cloud hosting and payment processors) who process data on our behalf under strict data processing agreements.</li>
                <li><strong style="color:var(--text);">Legal Requirements:</strong> We may disclose data if required by law, court order, or government authority.</li>
                <li><strong style="color:var(--text);">Business Transfer:</strong> In the event of a merger or acquisition, your data may be transferred to the acquiring entity.</li>
            </ul>
        </div>

        <!-- 5. COOKIES -->
        <div class="section" id="cookies">
            <div class="section-num">05</div>
            <h2>Cookies</h2>
            <p>SkillLink uses session cookies to maintain your login state while you are using the Platform. These cookies are strictly necessary for the Platform to function and are deleted when you close your browser or log out.</p>
            <p>We currently do not use tracking cookies, analytics cookies, or third-party advertising cookies. If this changes in the future, this policy will be updated accordingly and you will be notified.</p>
            <div class="info-box">
                <i class="fas fa-cookie-bite"></i>
                <span>You can control and delete cookies through your browser settings. Disabling session cookies will prevent you from logging in to the Platform.</span>
            </div>
        </div>

        <!-- 6. SECURITY -->
        <div class="section" id="security">
            <div class="section-num">06</div>
            <h2>Security</h2>
            <p>We take the security of your data seriously. SkillLink implements the following measures to protect your information:</p>
            <ul>
                <li>Passwords are hashed before storage and are never stored in plain text</li>
                <li>All data is transmitted over encrypted HTTPS connections</li>
                <li>The Platform is hosted on Microsoft Azure with enterprise-grade infrastructure security</li>
                <li>Access to user data within the Platform is restricted to authorised administrators only</li>
            </ul>
            <p>However, no method of transmission over the internet or electronic storage is 100% secure. While we strive to protect your data, we cannot guarantee absolute security.</p>
        </div>

        <!-- 7. RETENTION -->
        <div class="section" id="retention">
            <div class="section-num">07</div>
            <h2>Data Retention</h2>
            <p>We retain your personal data for as long as your account is active or as needed to provide the Platform's services. Specifically:</p>
            <ul>
                <li>Account data is retained for the lifetime of your account</li>
                <li>Order records are retained for a minimum of 2 years for financial and legal compliance</li>
                <li>If you delete your account, personal data is removed within 30 days, except where retention is required by law</li>
            </ul>
        </div>

        <!-- 8. RIGHTS -->
        <div class="section" id="rights">
            <div class="section-num">08</div>
            <h2>Your Rights</h2>
            <p>Depending on your location, you may have the following rights regarding your personal data:</p>
            <div class="rights-grid">
                <div class="right-item">
                    <i class="fas fa-eye"></i>
                    <div><strong>Access</strong>Request a copy of the personal data we hold about you.</div>
                </div>
                <div class="right-item">
                    <i class="fas fa-edit"></i>
                    <div><strong>Correction</strong>Update inaccurate or incomplete information via your Profile page.</div>
                </div>
                <div class="right-item">
                    <i class="fas fa-trash-alt"></i>
                    <div><strong>Deletion</strong>Request deletion of your account and associated personal data.</div>
                </div>
                <div class="right-item">
                    <i class="fas fa-download"></i>
                    <div><strong>Portability</strong>Request an export of your data in a machine-readable format.</div>
                </div>
                <div class="right-item">
                    <i class="fas fa-ban"></i>
                    <div><strong>Objection</strong>Object to certain types of processing of your personal data.</div>
                </div>
                <div class="right-item">
                    <i class="fas fa-pause-circle"></i>
                    <div><strong>Restriction</strong>Request that we restrict processing of your data in certain circumstances.</div>
                </div>
            </div>
            <p style="margin-top:16px;">To exercise any of these rights, contact us at <a href="mailto:privacy@skilllink.com" style="color:var(--accent);text-decoration:none;">privacy@skilllink.com</a>. We will respond within 30 days.</p>
        </div>

        <!-- 9. CHILDREN -->
        <div class="section" id="children">
            <div class="section-num">09</div>
            <h2>Children's Privacy</h2>
            <p>SkillLink is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from minors. If you believe a minor has provided us with personal data, please contact us immediately and we will take steps to remove the information.</p>
        </div>

        <div class="divider"></div>

        <!-- 10. CONTACT -->
        <div class="section" id="contact">
            <div class="section-num">10</div>
            <h2>Contact Us</h2>
            <p>If you have any questions, concerns, or requests regarding this Privacy Policy or how we handle your data, please contact our Privacy Team.</p>
        </div>

        <div class="contact-band">
            <h3>Privacy questions or requests?</h3>
            <p>Contact our Privacy Team and we'll respond within 30 days.</p>
            <a href="mailto:privacy@skilllink.com" class="btn-outline">
                <i class="fas fa-shield-alt"></i> privacy@skilllink.com
            </a>
        </div>

    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-bottom">
            <p>© <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
            <div class="footer-links">
                <a href="Terms.aspx">Terms</a>
                <a href="Privacy.aspx">Privacy</a>
                <a href="Home.aspx">Home</a>
            </div>
        </div>
    </footer>

</form>
</body>
</html>
