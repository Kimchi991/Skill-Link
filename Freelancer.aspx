<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Freelancer.aspx.cs" Inherits="Skill_Link.Freelance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Post a Service - SkillLink</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:      #48e5c2;
            --accent-dark: #2abfa0;
            --danger:      #e5484d;
            --warn:        #f59e0b;
            --bg:          #f0f4f8;
            --card:        #ffffff;
            --border:      #e2e8f0;
            --text:        #1a202c;
            --muted:       #64748b;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

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
            background: #1a202c;
            padding: 14px 28px;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 2px 8px rgba(0,0,0,0.18);
        }
        .logo-text {
            font-family: 'Syne', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: var(--accent);
            text-decoration: none;
            letter-spacing: -0.5px;
        }
        .header-right { display: flex; align-items: center; gap: 18px; }
        .header-right a {
            color: #cbd5e1;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.15s;
        }
        .header-right a:hover { color: var(--accent); }

        /* ── HERO BANNER ── */
        .page-hero {
            background: linear-gradient(135deg, #1a202c 0%, #0f4c3a 100%);
            padding: 48px 28px 40px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .page-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse at 70% 50%, rgba(72,229,194,0.12) 0%, transparent 65%);
        }
        .page-hero h1 {
            font-family: 'Syne', sans-serif;
            font-size: 32px;
            font-weight: 800;
            color: #fff;
            position: relative;
            z-index: 1;
            margin-bottom: 8px;
        }
        .page-hero h1 span { color: var(--accent); }
        .page-hero p {
            color: #94a3b8;
            font-size: 15px;
            position: relative;
            z-index: 1;
        }

        /* ── BREADCRUMB ── */
        .breadcrumb {
            max-width: 860px;
            margin: 0 auto;
            padding: 16px 20px 0;
            font-size: 13px;
            color: var(--muted);
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .breadcrumb a { color: var(--muted); text-decoration: none; transition: color 0.15s; }
        .breadcrumb a:hover { color: var(--accent-dark); }
        .breadcrumb i { font-size: 10px; }

        /* ── FORM WRAP ── */
        .form-wrap {
            max-width: 860px;
            margin: 20px auto 60px;
            padding: 0 20px;
        }

        /* ── CARD ── */
        .card {
            background: var(--card);
            border-radius: 16px;
            padding: 28px 32px;
            border: 1px solid var(--border);
            box-shadow: 0 4px 18px rgba(15,23,42,0.06);
            margin-bottom: 22px;
        }
        .card-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border);
        }
        .card-header-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(72,229,194,0.12);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent-dark);
            font-size: 16px;
            flex-shrink: 0;
        }
        .card-header h3 {
            font-family: 'Syne', sans-serif;
            font-size: 16px;
            font-weight: 700;
            color: var(--text);
        }
        .card-header p {
            font-size: 13px;
            color: var(--muted);
            margin-top: 2px;
        }

        /* ── FORM ELEMENTS ── */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        .form-grid.full { grid-template-columns: 1fr; }

        .form-group { display: flex; flex-direction: column; gap: 7px; }
        .form-group label {
            font-size: 12px;
            font-weight: 600;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-group label .required { color: var(--danger); margin-left: 2px; }

        .form-input, .form-select, .form-textarea {
            width: 100%;
            padding: 10px 14px;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-size: 14px;
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            background: #f8fafc;
            transition: border-color 0.15s, background 0.15s, box-shadow 0.15s;
            appearance: none;
        }
        .form-input:focus, .form-select:focus, .form-textarea:focus {
            outline: none;
            border-color: var(--accent);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(72,229,194,0.12);
        }
        .form-textarea {
            resize: vertical;
            min-height: 120px;
            line-height: 1.6;
        }

        /* custom select arrow */
        .select-wrap { position: relative; }
        .select-wrap::after {
            content: '\f107';
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            pointer-events: none;
            font-size: 13px;
        }

        /* price field */
        .price-wrap { position: relative; }
        .price-prefix {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: 700;
            color: var(--accent-dark);
            font-size: 15px;
            pointer-events: none;
        }
        .price-wrap .form-input { padding-left: 30px; }

        /* char counter */
        .field-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 4px;
        }
        .field-hint { font-size: 12px; color: var(--muted); }
        .char-count { font-size: 12px; color: var(--muted); }
        .char-count.warn { color: var(--warn); }

        /* category pills preview */
        .category-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }
        .cat-pill {
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: rgba(72,229,194,0.1);
            color: var(--accent-dark);
            border: 1.5px solid rgba(72,229,194,0.25);
            cursor: pointer;
            transition: all 0.15s;
            user-select: none;
        }
        .cat-pill:hover, .cat-pill.selected {
            background: var(--accent);
            color: #fff;
            border-color: var(--accent);
        }

        /* preview card */
        .preview-card {
            background: linear-gradient(135deg, #f0faf8 0%, #e6f7f3 100%);
            border: 1.5px dashed rgba(72,229,194,0.4);
            border-radius: 12px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        .preview-thumb {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--accent) 0%, #2563eb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: #fff;
            flex-shrink: 0;
        }
        .preview-body { flex: 1; min-width: 0; }
        .preview-title { font-weight: 700; font-size: 15px; color: var(--text); margin-bottom: 4px; }
        .preview-cat   { font-size: 12px; color: var(--muted); margin-bottom: 6px; }
        .preview-price { font-size: 20px; font-weight: 800; color: var(--accent-dark); font-family: 'Syne', sans-serif; }
        .preview-label {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--muted);
            margin-bottom: 10px;
        }

        /* ── ALERT ── */
        .alert {
            padding: 12px 16px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 20px;
            display: none;
            align-items: center;
            gap: 10px;
        }
        .alert.show { display: flex; }
        .alert-success { background: rgba(34,197,94,0.1); color: #16a34a; border: 1px solid rgba(34,197,94,0.25); }
        .alert-error   { background: rgba(229,72,77,0.1);  color: var(--danger); border: 1px solid rgba(229,72,77,0.25); }

        /* ── BUTTONS ── */
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            border: none;
            transition: all 0.15s;
            text-decoration: none;
        }
        .btn-primary { background: var(--accent); color: #fff; }
        .btn-primary:hover { background: var(--accent-dark); transform: translateY(-1px); box-shadow: 0 4px 14px rgba(72,229,194,0.35); }
        .btn-outline { background: transparent; border: 1.5px solid var(--border); color: var(--text); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent-dark); }
        .btn-lg { padding: 13px 32px; font-size: 15px; }

        .action-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        /* ── FOOTER ── */
        .site-footer { background: #1a202c; color: #cbd5e1; padding: 40px 20px 24px; }
        .footer-inner { max-width: 1280px; margin: 0 auto; display: flex; gap: 28px; flex-wrap: wrap; justify-content: space-between; }
        .footer-col { min-width: 160px; flex: 1; margin-bottom: 18px; }
        .footer-col h4 { color: #fff; margin-bottom: 12px; font-family: 'Syne', sans-serif; font-size: 15px; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 8px; }
        .footer-col a { color: #94a3b8; text-decoration: none; font-size: 14px; transition: color 0.15s; }
        .footer-col a:hover { color: var(--accent); }
        .footer-brand .logo { font-family: 'Syne', sans-serif; font-size: 20px; font-weight: 800; color: var(--accent); }
        .footer-brand p { color: #94a3b8; font-size: 13px; margin-top: 8px; line-height: 1.6; }
        .footer-bottom { max-width: 1280px; margin: 22px auto 0; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.06); display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #64748b; flex-wrap: wrap; gap: 10px; }
        .footer-links { display: flex; gap: 14px; }
        .footer-links a { color: #64748b; text-decoration: none; font-size: 13px; }
        .footer-links a:hover { color: var(--accent); }

        /* ── RESPONSIVE ── */
        @media (max-width: 680px) {
            .form-grid { grid-template-columns: 1fr; }
            .card { padding: 20px 18px; }
            .action-row { flex-direction: column-reverse; }
            .action-row .btn { width: 100%; justify-content: center; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- HEADER -->
    <div class="header">
        <a href="Home.aspx" class="logo-text">SkillLink</a>
        <div class="header-right">
            <a href="Home.aspx"><i class="fas fa-search"></i> Browse Services</a>
            <a href="Profile.aspx"><i class="fas fa-user"></i> My Account</a>
        </div>
    </div>

    <!-- HERO -->
    <div class="page-hero">
        <h1>Post a <span>New Service</span></h1>
        <p>Showcase your skills and start earning — fill in the details below.</p>
    </div>

    <!-- BREADCRUMB -->
    <div class="breadcrumb">
        <a href="Home.aspx">Home</a>
        <i class="fas fa-chevron-right"></i>
        <a href="Profile.aspx">My Account</a>
        <i class="fas fa-chevron-right"></i>
        <span style="color:var(--text);font-weight:600;">Post a Service</span>
    </div>

    <!-- FORM -->
    <div class="form-wrap">

        <!-- Alert -->
        <asp:Label ID="lblAlert" runat="server" CssClass="alert" />

        <!-- Service Details Card -->
        <div class="card">
            <div class="card-header">
                <div class="card-header-icon"><i class="fas fa-briefcase"></i></div>
                <div>
                    <h3>Service Details</h3>
                    <p>Describe what you're offering to potential clients</p>
                </div>
            </div>

            <div class="form-grid full" style="margin-bottom:20px;">
                <div class="form-group">
                    <label>Service Title <span class="required">*</span></label>
                    <asp:TextBox ID="txtTitle" runat="server" CssClass="form-input"
                        placeholder="e.g. I will build a full-stack web application"
                        MaxLength="500" onkeyup="updateCounter('title'); updatePreview();" />
                    <div class="field-meta">
                        <span class="field-hint">Be specific and clear — this is the first thing clients see.</span>
                        <span class="char-count" id="counter-title">0 / 500</span>
                    </div>
                </div>
            </div>

            <div class="form-grid full" style="margin-bottom:20px;">
                <div class="form-group">
                    <label>Description <span class="required">*</span></label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-textarea" TextMode="MultiLine"
                        placeholder="Describe your service in detail: what you'll deliver, your process, and what the client can expect..."
                        onkeyup="updatePreview();" />
                    <div class="field-meta">
                        <span class="field-hint">Minimum 50 characters recommended.</span>
                    </div>
                </div>
            </div>

        </div>

        <!-- Category & Pricing Card -->
        <div class="card">
            <div class="card-header">
                <div class="card-header-icon"><i class="fas fa-tags"></i></div>
                <div>
                    <h3>Category &amp; Pricing</h3>
                    <p>Help clients find your service and set your rate</p>
                </div>
            </div>

            <div class="form-grid">
                <div class="form-group">
                    <label>Category <span class="required">*</span></label>
                    <div class="select-wrap">
                        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"
                            onchange="syncCategory();">
                            <asp:ListItem Value="">— Select a category —</asp:ListItem>
                            <asp:ListItem Value="Programming &amp; Tech">Programming &amp; Tech</asp:ListItem>
                            <asp:ListItem Value="Graphics &amp; Design">Graphics &amp; Design</asp:ListItem>
                            <asp:ListItem Value="Video &amp; Animation">Video &amp; Animation</asp:ListItem>
                            <asp:ListItem Value="Music &amp; Audio">Music &amp; Audio</asp:ListItem>
                            <asp:ListItem Value="Writing &amp; Translation">Writing &amp; Translation</asp:ListItem>
                            <asp:ListItem Value="Digital Marketing">Digital Marketing</asp:ListItem>
                            <asp:ListItem Value="Business">Business</asp:ListItem>
                            <asp:ListItem Value="Photography">Photography</asp:ListItem>
                            <asp:ListItem Value="Data &amp; Analytics">Data &amp; Analytics</asp:ListItem>
                            <asp:ListItem Value="Other">Other</asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <!-- quick-pick pills -->
                    <div class="category-pills">
                        <span class="cat-pill" onclick="pickCat(this,'Programming &amp; Tech')"><i class="fas fa-code"></i> Tech</span>
                        <span class="cat-pill" onclick="pickCat(this,'Graphics &amp; Design')"><i class="fas fa-paint-brush"></i> Design</span>
                        <span class="cat-pill" onclick="pickCat(this,'Video &amp; Animation')"><i class="fas fa-video"></i> Video</span>
                        <span class="cat-pill" onclick="pickCat(this,'Music &amp; Audio')"><i class="fas fa-music"></i> Audio</span>
                        <span class="cat-pill" onclick="pickCat(this,'Writing &amp; Translation')"><i class="fas fa-pen-nib"></i> Writing</span>
                        <span class="cat-pill" onclick="pickCat(this,'Digital Marketing')"><i class="fas fa-chart-line"></i> Marketing</span>
                    </div>
                </div>

                <div class="form-group">
                    <label>Starting Price (₱) <span class="required">*</span></label>
                    <div class="price-wrap">
                        <span class="price-prefix">₱</span>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-input"
                            placeholder="0.00" TextMode="Number"
                            onkeyup="updatePreview();" oninput="updatePreview();" />
                    </div>
                    <div class="field-meta">
                        <span class="field-hint">Set a competitive starting rate for your service.</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Live Preview Card -->
        <div class="card">
            <div class="card-header">
                <div class="card-header-icon"><i class="fas fa-eye"></i></div>
                <div>
                    <h3>Live Preview</h3>
                    <p>This is how your service card will appear to clients</p>
                </div>
            </div>

            <p class="preview-label">Service Card Preview</p>
            <div class="preview-card">
                <div class="preview-thumb" id="previewIcon"><i class="fas fa-briefcase"></i></div>
                <div class="preview-body">
                    <div class="preview-title" id="previewTitle">Your service title will appear here</div>
                    <div class="preview-cat"   id="previewCat">Category · Posted just now</div>
                    <div class="preview-price" id="previewPrice">₱ —</div>
                </div>
            </div>
        </div>

        <!-- Action Row -->
        <div class="action-row">
            <a href="Profile.aspx" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Profile</a>
            <asp:Button ID="btnSubmit" runat="server" Text="Publish Service"
                CssClass="btn btn-primary btn-lg"
                OnClick="btnSubmit_Click"
                OnClientClick="return validateForm();" />
        </div>

    </div>

    <!-- FOOTER -->
    <footer class="site-footer">
        <div class="footer-inner">
            <div class="footer-col footer-brand">
                <a class="logo" href="Home.aspx">SkillLink</a>
                <p>Connect with talented professionals — design, marketing, development and more.</p>
            </div>
            <div class="footer-col">
                <h4>Explore</h4>
                <ul>
                    <li><a href="Home.aspx">Home</a></li>
                    <li><a href="Profile.aspx">My Account</a></li>
                </ul>
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
    /* ── character counter ── */
    function updateCounter(field) {
        var box = document.getElementById('<%= txtTitle.ClientID %>');
        var ctr = document.getElementById('counter-title');
        if (!box || !ctr) return;
        var len = box.value.length;
        ctr.textContent = len + ' / 500';
        ctr.className = 'char-count' + (len > 450 ? ' warn' : '');
    }

    /* ── live preview ── */
    var catIcons = {
        'Programming & Tech': 'fa-code',
        'Graphics & Design':  'fa-paint-brush',
        'Video & Animation':  'fa-video',
        'Music & Audio':      'fa-music',
        'Writing & Translation': 'fa-pen-nib',
        'Digital Marketing':  'fa-chart-line',
        'Business':           'fa-briefcase',
        'Photography':        'fa-camera',
        'Data & Analytics':   'fa-database',
        'Other':              'fa-star'
    };

    function updatePreview() {
        var title   = document.getElementById('<%= txtTitle.ClientID %>').value.trim();
        var price   = document.getElementById('<%= txtPrice.ClientID %>').value.trim();
        var catSel  = document.getElementById('<%= ddlCategory.ClientID %>');
        var catVal  = catSel ? catSel.options[catSel.selectedIndex].text : '';

        document.getElementById('previewTitle').textContent = title || 'Your service title will appear here';
        document.getElementById('previewCat').textContent   = (catVal && catVal !== '— Select a category —' ? catVal : 'Category') + ' · Posted just now';
        document.getElementById('previewPrice').textContent = price ? '₱' + parseFloat(price).toLocaleString('en-PH', {minimumFractionDigits:2}) : '₱ —';

        // icon
        var iconKey = catVal && catIcons[catVal] ? catIcons[catVal] : 'fa-briefcase';
        document.getElementById('previewIcon').innerHTML = '<i class="fas ' + iconKey + '"></i>';
    }

    /* ── category quick pills ── */
    function pickCat(el, val) {
        document.querySelectorAll('.cat-pill').forEach(function(p){ p.classList.remove('selected'); });
        el.classList.add('selected');
        var sel = document.getElementById('<%= ddlCategory.ClientID %>');
        for (var i = 0; i < sel.options.length; i++) {
            if (sel.options[i].value === val) { sel.selectedIndex = i; break; }
        }
        updatePreview();
    }

    /* ── keep pills in sync when dropdown changes ── */
    function syncCategory() {
        var sel = document.getElementById('<%= ddlCategory.ClientID %>');
        var val = sel.options[sel.selectedIndex].value;
        document.querySelectorAll('.cat-pill').forEach(function(p) {
            p.classList.toggle('selected', p.getAttribute('onclick').indexOf(val) !== -1);
        });
        updatePreview();
    }

    /* ── client-side validation ── */
    function validateForm() {
        var title = document.getElementById('<%= txtTitle.ClientID %>').value.trim();
        var desc  = document.getElementById('<%= txtDescription.ClientID %>').value.trim();
        var cat   = document.getElementById('<%= ddlCategory.ClientID %>').value;
        var price = document.getElementById('<%= txtPrice.ClientID %>').value.trim();

        if (!title) { alert('Please enter a service title.'); return false; }
        if (!desc)  { alert('Please enter a description.'); return false; }
        if (!cat)   { alert('Please select a category.'); return false; }
        if (!price || isNaN(price) || parseFloat(price) <= 0) { alert('Please enter a valid price.'); return false; }
        return true;
    }

    /* init counter */
    updateCounter('title');
</script>
</body>
</html>
