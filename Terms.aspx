<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Terms.aspx.cs" Inherits="Skill_Link.Terms" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Terms of Service - SkillLink</title>
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
                radial-gradient(ellipse 70% 50% at 80% -10%, rgba(72,229,194,0.05) 0%, transparent 60%),
                radial-gradient(ellipse 60% 50% at 10% 110%, rgba(37,99,235,0.05) 0%, transparent 60%);
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
            background: rgba(13,17,23,0.9);
            backdrop-filter: blur(12px);
            position: sticky;
            top: 0;
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
            background: linear-gradient(180deg, rgba(72,229,194,0.04) 0%, transparent 100%);
        }
        .hero-band .badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: rgba(72,229,194,0.08);
            border: 1px solid rgba(72,229,194,0.2);
            color: var(--accent);
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
            color: var(--accent);
            min-width: 22px;
        }
        .toc ol li a {
            font-size: 13px;
            color: var(--muted);
            text-decoration: none;
            transition: color 0.15s;
        }
        .toc ol li a:hover { color: var(--accent); }

        /* ── SECTIONS ── */
        .section {
            margin-bottom: 44px;
            scroll-margin-top: 80px;
        }
        .section-num {
            font-size: 11px;
            font-weight: 700;
            color: var(--accent);
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
            background: var(--accent);
            flex-shrink: 0;
            margin-top: 7px;
        }

        /* ── INFO BOX ── */
        .info-box {
            background: rgba(72,229,194,0.05);
            border: 1px solid rgba(72,229,194,0.18);
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
        .info-box i { color: var(--accent); font-size: 16px; margin-top: 2px; flex-shrink: 0; }

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
        .contact-band p {
            font-size: 14px;
            color: var(--muted);
            margin-bottom: 20px;
        }
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
        <div class="badge"><i class="fas fa-file-contract"></i> Legal</div>
        <h1>Terms of Service</h1>
        <p>By using SkillLink, you agree to the following terms. Please read them carefully before creating an account or placing an order.</p>
        <div class="last-updated">Last updated: January 1, 2026 &nbsp;·&nbsp; Version 1.0</div>
    </div>

    <!-- MAIN -->
    <div class="page-body">

        <!-- TOC -->
        <div class="toc">
            <div class="toc-title"><i class="fas fa-list" style="margin-right:6px;"></i>Table of Contents</div>
            <ol>
                <li><a href="#acceptance">Acceptance of Terms</a></li>
                <li><a href="#services">Use of Services</a></li>
                <li><a href="#accounts">User Accounts</a></li>
                <li><a href="#conduct">User Conduct</a></li>
                <li><a href="#payments">Payments &amp; Fees</a></li>
                <li><a href="#ip">Intellectual Property</a></li>
                <li><a href="#disputes">Disputes</a></li>
                <li><a href="#termination">Termination</a></li>
                <li><a href="#liability">Limitation of Liability</a></li>
                <li><a href="#contact">Contact Us</a></li>
            </ol>
        </div>

        <!-- 1. ACCEPTANCE -->
        <div class="section" id="acceptance">
            <div class="section-num">01</div>
            <h2>Acceptance of Terms</h2>
            <p>Welcome to SkillLink. These Terms of Service ("Terms") govern your access to and use of the SkillLink platform, including our website, mobile applications, and all associated services (collectively, the "Platform").</p>
            <p>By registering an account, browsing, posting a service, or placing an order on SkillLink, you confirm that you have read, understood, and agree to be legally bound by these Terms. If you do not agree with any part of these Terms, you must not use the Platform.</p>
            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                <span>These Terms form a legally binding agreement between you and SkillLink. We recommend saving or printing a copy for your records.</span>
            </div>
        </div>

        <!-- 2. USE OF SERVICES -->
        <div class="section" id="services">
            <div class="section-num">02</div>
            <h2>Use of Services</h2>
            <p>SkillLink is an online marketplace that connects freelancers ("Sellers") with clients ("Buyers") for the purpose of buying and selling digital and professional services.</p>
            <p>You may use SkillLink only for lawful purposes and in accordance with these Terms. You agree not to use the Platform:</p>
            <ul>
                <li>In any way that violates applicable local, national, or international law or regulation</li>
                <li>To transmit unsolicited or unauthorised advertising or promotional material</li>
                <li>To impersonate any person or entity, or misrepresent your affiliation with any person or entity</li>
                <li>To engage in any conduct that restricts or inhibits anyone's use or enjoyment of the Platform</li>
                <li>To attempt to gain unauthorised access to any part of the Platform or its related systems</li>
            </ul>
        </div>

        <!-- 3. ACCOUNTS -->
        <div class="section" id="accounts">
            <div class="section-num">03</div>
            <h2>User Accounts</h2>
            <p>To access certain features of SkillLink, you must register for an account. When creating an account, you agree to provide accurate, current, and complete information.</p>
            <p>You are responsible for:</p>
            <ul>
                <li>Maintaining the confidentiality of your account credentials</li>
                <li>All activities that occur under your account</li>
                <li>Notifying us immediately of any unauthorised use of your account</li>
                <li>Ensuring your account information remains accurate and up to date</li>
            </ul>
            <p>SkillLink reserves the right to suspend or terminate accounts that violate these Terms or that have been inactive for an extended period.</p>
        </div>

        <!-- 4. CONDUCT -->
        <div class="section" id="conduct">
            <div class="section-num">04</div>
            <h2>User Conduct</h2>
            <p>All users of SkillLink — whether Buyers or Sellers — are expected to interact with each other professionally and respectfully. The following conduct is strictly prohibited:</p>
            <ul>
                <li>Posting false, misleading, or fraudulent service listings</li>
                <li>Harassing, threatening, or intimidating other users</li>
                <li>Sharing another user's personal information without consent</li>
                <li>Circumventing the SkillLink platform to arrange payments outside the system</li>
                <li>Leaving fake or manipulated reviews or ratings</li>
                <li>Uploading or distributing malicious software, viruses, or harmful code</li>
            </ul>
            <p>Violations may result in immediate account suspension and, where applicable, legal action.</p>
        </div>

        <!-- 5. PAYMENTS -->
        <div class="section" id="payments">
            <div class="section-num">05</div>
            <h2>Payments &amp; Fees</h2>
            <p>All transactions on SkillLink are conducted through the Platform's secure checkout system. Buyers agree to pay the full listed price for the selected service package at the time of order placement.</p>
            <p>SkillLink charges a <strong style="color:var(--accent);">5% platform fee</strong> on all completed transactions. This fee is included in the total displayed to the Buyer at checkout and is automatically deducted from the Seller's payout.</p>
            <ul>
                <li>Payments are held in escrow until the order is marked as Completed</li>
                <li>Sellers receive their payout after the Buyer confirms delivery</li>
                <li>Refunds are handled on a case-by-case basis in accordance with our Refund Policy</li>
                <li>SkillLink is not responsible for taxes, duties, or levies that may apply in your jurisdiction</li>
            </ul>
            <div class="info-box">
                <i class="fas fa-shield-alt"></i>
                <span>All payments are protected by SkillLink's Money-Back Guarantee. If a Seller fails to deliver, you are entitled to a full refund.</span>
            </div>
        </div>

        <!-- 6. IP -->
        <div class="section" id="ip">
            <div class="section-num">06</div>
            <h2>Intellectual Property</h2>
            <p>Upon full payment and order completion, the Seller grants the Buyer a non-exclusive licence to use the delivered work for its intended commercial or personal purpose, unless otherwise agreed between the parties in writing.</p>
            <p>Sellers warrant that all work delivered is original, does not infringe on any third-party intellectual property rights, and that they hold all necessary rights to deliver such work.</p>
            <p>All trademarks, logos, and brand elements of SkillLink are the exclusive property of SkillLink and may not be used without prior written consent.</p>
        </div>

        <!-- 7. DISPUTES -->
        <div class="section" id="disputes">
            <div class="section-num">07</div>
            <h2>Disputes</h2>
            <p>In the event of a dispute between a Buyer and Seller, both parties are encouraged to resolve the issue through direct communication via the SkillLink messaging system.</p>
            <p>If a resolution cannot be reached, either party may escalate the dispute to SkillLink Support. SkillLink will act as a neutral mediator and reserves the right to make a final determination, including issuing refunds or suspending accounts.</p>
            <p>SkillLink's decision in any dispute mediation is final and binding within the scope of the Platform.</p>
        </div>

        <!-- 8. TERMINATION -->
        <div class="section" id="termination">
            <div class="section-num">08</div>
            <h2>Termination</h2>
            <p>You may delete your SkillLink account at any time by contacting support. Upon termination, your right to access the Platform ceases immediately.</p>
            <p>SkillLink reserves the right to suspend or permanently terminate your account, without notice, if:</p>
            <ul>
                <li>You breach any provision of these Terms</li>
                <li>Your conduct is determined to be harmful to other users or the Platform</li>
                <li>We are required to do so by law or regulatory authority</li>
            </ul>
            <p>Pending orders and financial obligations at the time of termination will be handled in accordance with applicable policies.</p>
        </div>

        <!-- 9. LIABILITY -->
        <div class="section" id="liability">
            <div class="section-num">09</div>
            <h2>Limitation of Liability</h2>
            <p>To the fullest extent permitted by law, SkillLink shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the Platform.</p>
            <p>SkillLink acts solely as a marketplace facilitator and is not a party to any agreement between Buyers and Sellers. We do not guarantee the quality, safety, legality, or accuracy of any service listings.</p>
            <p>Our total liability to you for any claim arising under these Terms shall not exceed the total fees paid by you to SkillLink in the six months preceding the claim.</p>
        </div>

        <div class="divider"></div>

        <!-- 10. CONTACT -->
        <div class="section" id="contact">
            <div class="section-num">10</div>
            <h2>Contact Us</h2>
            <p>If you have questions about these Terms, please reach out to our support team.</p>
        </div>

        <div class="contact-band">
            <h3>Questions about our Terms?</h3>
            <p>Our support team is available to help clarify anything in this document.</p>
            <a href="mailto:support@skilllink.com" class="btn-outline">
                <i class="fas fa-envelope"></i> support@skilllink.com
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
    <a href="Terms.aspx">Terms.aspx</a>

</form>
</body>
</html>
