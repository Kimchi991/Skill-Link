<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="Skill_Link.Booking" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Book a Freelancer - SkillLink</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <style>
        :root {
            --accent:#48e5c2; --accent-dark:#2abfa0;
            --bg:#0d1117; --card:#1c2230;
            --border:rgba(255,255,255,0.07);
            --text:#e2e8f0; --muted:#64748b;
            --danger:#f87171; --success:#4ade80; --warn:#fbbf24;
        }
        *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Helvetica,Arial,sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;flex-direction:column;}
        body::before{content:'';position:fixed;inset:0;background:radial-gradient(ellipse 80% 60% at 20% -10%,rgba(72,229,194,0.08) 0%,transparent 60%),radial-gradient(ellipse 60% 50% at 80% 110%,rgba(37,99,235,0.07) 0%,transparent 60%);pointer-events:none;z-index:0;}
        .header{position:relative;z-index:10;display:flex;justify-content:space-between;align-items:center;padding:16px 28px;border-bottom:1px solid var(--border);background:rgba(13,17,23,0.85);backdrop-filter:blur(12px);}
        .logo-text{font-size:22px;font-weight:800;color:var(--accent);text-decoration:none;letter-spacing:-0.5px;}
        .header-right a{color:#cbd5e1;text-decoration:none;font-size:14px;transition:color 0.15s;}
        .header-right a:hover{color:var(--accent);}
        .page-body{position:relative;z-index:1;flex:1;display:flex;align-items:flex-start;justify-content:center;padding:40px 20px 60px;}
        .booking-wrap{width:100%;max-width:680px;}

        .steps{display:flex;align-items:center;margin-bottom:36px;}
        .step{display:flex;align-items:center;gap:8px;font-size:13px;font-weight:500;color:var(--muted);}
        .step.active{color:var(--accent);}
        .step.done{color:var(--accent-dark);}
        .step-num{width:28px;height:28px;border-radius:50%;border:2px solid var(--muted);display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:700;flex-shrink:0;transition:all 0.2s;}
        .step.active .step-num{border-color:var(--accent);color:var(--accent);}
        .step.done .step-num{border-color:var(--accent-dark);background:var(--accent-dark);color:#062023;}
        .step-line{flex:1;height:1px;background:var(--border);margin:0 8px;}
        .step-line.done{background:var(--accent-dark);}

        .booking-card{background:var(--card);border:1px solid var(--border);border-radius:18px;padding:32px;margin-bottom:20px;}
        .booking-card h2{font-size:20px;font-weight:700;color:#fff;margin-bottom:6px;}
        .booking-card .sub{font-size:13px;color:var(--muted);margin-bottom:24px;}

        .freelancer-summary{display:flex;align-items:center;gap:16px;padding:18px;background:rgba(72,229,194,0.06);border:1px solid rgba(72,229,194,0.15);border-radius:12px;margin-bottom:24px;}
        .fl-avatar-lg{width:56px;height:56px;border-radius:50%;background:linear-gradient(135deg,var(--accent),#2563eb);display:flex;align-items:center;justify-content:center;font-size:22px;font-weight:700;color:#fff;flex-shrink:0;}
        .fl-summary-info h4{font-size:16px;font-weight:700;color:#fff;margin-bottom:3px;}
        .fl-summary-info p{font-size:12px;color:var(--muted);}
        .fl-summary-badge{margin-left:auto;display:inline-flex;align-items:center;gap:6px;background:rgba(72,229,194,0.1);border:1px solid rgba(72,229,194,0.2);color:var(--accent);font-size:11px;font-weight:600;padding:4px 12px;border-radius:20px;}

        .form-group{margin-bottom:18px;}
        .form-group label{display:block;font-size:11px;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:0.6px;margin-bottom:8px;}
        .form-input{width:100%;padding:11px 14px;background:rgba(255,255,255,0.04);border:1px solid var(--border);border-radius:9px;font-size:14px;font-family:inherit;color:var(--text);transition:border-color 0.15s,box-shadow 0.15s;outline:none;}
        .form-input:focus{border-color:var(--accent);box-shadow:0 0 0 3px rgba(72,229,194,0.1);}
        .form-input::placeholder{color:#3d4f66;}
        textarea.form-input{resize:vertical;min-height:110px;}
        input[type="date"].form-input{color-scheme:dark;}

        .pay-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:24px;}
        .pay-card{border:2px solid var(--border);border-radius:12px;padding:16px;cursor:pointer;transition:border-color 0.15s,background 0.15s;display:flex;align-items:center;gap:12px;}
        .pay-card:hover{border-color:rgba(72,229,194,0.4);background:rgba(72,229,194,0.04);}
        .pay-card.selected{border-color:var(--accent);background:rgba(72,229,194,0.08);}
        .pay-icon{font-size:22px;flex-shrink:0;}
        .pay-name{font-size:13px;font-weight:600;color:#fff;}
        .pay-desc{font-size:11px;color:var(--muted);}

        .order-summary{background:rgba(255,255,255,0.03);border:1px solid var(--border);border-radius:12px;padding:20px;margin-bottom:24px;}
        .summary-row{display:flex;justify-content:space-between;font-size:13px;padding:6px 0;border-bottom:1px solid var(--border);}
        .summary-row:last-child{border-bottom:none;font-size:15px;font-weight:700;color:var(--accent);padding-top:12px;}
        .summary-label{color:var(--muted);}
        .summary-val{color:var(--text);font-weight:500;}

        .btn{display:inline-flex;align-items:center;gap:8px;padding:11px 22px;border-radius:9px;font-size:14px;font-weight:600;font-family:inherit;cursor:pointer;border:none;transition:all 0.15s;text-decoration:none;}
        .btn-primary{background:var(--accent);color:#062023;box-shadow:0 4px 18px rgba(72,229,194,0.2);}
        .btn-primary:hover{background:var(--accent-dark);transform:translateY(-1px);}
        .btn-outline{background:transparent;border:1.5px solid var(--border);color:var(--text);}
        .btn-outline:hover{border-color:var(--accent);color:var(--accent);}
        .btn-row{display:flex;gap:12px;justify-content:flex-end;}

        .success-screen{text-align:center;padding:48px 20px;}
        .success-icon{width:80px;height:80px;border-radius:50%;background:rgba(72,229,194,0.12);border:2px solid var(--accent);display:flex;align-items:center;justify-content:center;margin:0 auto 24px;font-size:36px;color:var(--accent);}
        .success-screen h2{font-size:26px;font-weight:800;color:#fff;margin-bottom:8px;}
        .success-screen p{font-size:15px;color:var(--muted);margin-bottom:8px;}
        .booking-ref-box{display:inline-block;background:rgba(72,229,194,0.08);border:1px solid rgba(72,229,194,0.2);border-radius:10px;padding:10px 24px;font-size:18px;font-weight:800;color:var(--accent);margin:16px 0 28px;letter-spacing:1px;}

        .alert{padding:12px 16px;border-radius:8px;font-size:13px;margin-bottom:18px;display:none;}
        .alert.show{display:block;}
        .alert-error{background:rgba(248,113,113,0.1);border:1px solid rgba(248,113,113,0.2);color:var(--danger);}
        .site-footer{position:relative;z-index:1;background:rgba(13,17,23,0.9);border-top:1px solid var(--border);padding:20px;text-align:center;font-size:12px;color:#64748b;}
    </style>
</head>
<body>
<form id="form1" runat="server">

    <asp:HiddenField ID="hdnFreelancerEmail" runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnFreelancerName"  runat="server" ClientIDMode="Static" />
    <asp:HiddenField ID="hdnPaymentMethod"   runat="server" ClientIDMode="Static" Value="GCash" />
    <asp:HiddenField ID="hdnCurrentStep"     runat="server" ClientIDMode="Static" Value="1" />
    <!-- Populated from querystring (service modal path) or computed fallback (freelancer card path). -->
    <asp:HiddenField ID="hdnServiceTitle"    runat="server" ClientIDMode="Static" Value="Direct Booking" />
    <asp:HiddenField ID="hdnServicePackage"  runat="server" ClientIDMode="Static" Value="Custom" />
    <asp:HiddenField ID="hdnTotalAmount"     runat="server" ClientIDMode="Static" Value="0" />

    <div class="header">
        <a href="Home.aspx" class="logo-text">SkillLink</a>
        <div class="header-right">
            <a href="Home.aspx"><i class="fas fa-arrow-left"></i> Back to Browse</a>
        </div>
    </div>

    <div class="page-body">
        <div class="booking-wrap">

            <asp:Label ID="lblError" runat="server" CssClass="alert alert-error" />

            <!-- Steps -->
            <div class="steps">
                <div class="step active" id="stepInd1"><div class="step-num">1</div><span>Details</span></div>
                <div class="step-line" id="stepLine1"></div>
                <div class="step" id="stepInd2"><div class="step-num">2</div><span>Payment</span></div>
                <div class="step-line" id="stepLine2"></div>
                <div class="step" id="stepInd3"><div class="step-num">3</div><span>Confirm</span></div>
            </div>

            <!-- STEP 1: Project Details -->
            <asp:Panel ID="pnlStep1" runat="server">
                <div class="booking-card">
                    <h2>Book a Freelancer</h2>
                    <p class="sub">Tell the freelancer what you need and when</p>

                    <div class="freelancer-summary">
                        <div class="fl-avatar-lg">
                            <asp:Literal ID="litFreelancerInitial" runat="server" />
                        </div>
                        <div class="fl-summary-info">
                            <h4><asp:Literal ID="litFreelancerName" runat="server" /></h4>
                            <p>Freelancer · SkillLink Verified</p>
                        </div>
                        <div class="fl-summary-badge">
                            <i class="fas fa-shield-alt"></i> Verified
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-calendar-alt" style="margin-right:6px;color:var(--accent);"></i>Booking Date</label>
                        <asp:TextBox ID="txtBookingDate" runat="server" CssClass="form-input" TextMode="Date" />
                    </div>

                    <div class="form-group">
                        <label>Project Title</label>
                        <asp:TextBox ID="txtProjectTitle" runat="server" CssClass="form-input" placeholder="e.g. Build a portfolio website" />
                    </div>

                    <div class="form-group">
                        <label>What do you need built?</label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-input" TextMode="MultiLine"
                            placeholder="Describe your project — goals, features, design preferences, tech stack if any..." />
                    </div>

                    <div class="form-group">
                        <label>Additional Notes <span style="font-weight:400;text-transform:none;color:var(--muted);">(optional)</span></label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-input" TextMode="MultiLine"
                            placeholder="Anything else the freelancer should know..." />
                    </div>

                    <div class="btn-row">
                        <asp:Button ID="btnStep1Next" runat="server" Text="Continue →" CssClass="btn btn-primary" OnClick="btnStep1Next_Click" />
                    </div>
                </div>
            </asp:Panel>

            <!-- STEP 2: Payment -->
            <asp:Panel ID="pnlStep2" runat="server" Visible="false">
                <div class="booking-card">
                    <h2>Payment Method</h2>
                    <p class="sub">Choose how you want to pay for this booking</p>

                    <div class="pay-grid">
                        <div class="pay-card selected" id="payGcash" onclick="selectPayment('GCash', this)">
                            <div class="pay-icon">💙</div>
                            <div><div class="pay-name">GCash</div><div class="pay-desc">Pay via GCash</div></div>
                        </div>
                        <div class="pay-card" id="payMaya" onclick="selectPayment('Maya', this)">
                            <div class="pay-icon">💚</div>
                            <div><div class="pay-name">Maya</div><div class="pay-desc">Pay via Maya</div></div>
                        </div>
                        <div class="pay-card" id="payBank" onclick="selectPayment('Bank Transfer', this)">
                            <div class="pay-icon">🏦</div>
                            <div><div class="pay-name">Bank Transfer</div><div class="pay-desc">Direct bank transfer</div></div>
                        </div>
                        <div class="pay-card" id="payCash" onclick="selectPayment('Cash', this)">
                            <div class="pay-icon">💵</div>
                            <div><div class="pay-name">Cash</div><div class="pay-desc">Pay in person</div></div>
                        </div>
                    </div>

                    <div class="order-summary">
                        <div class="summary-row">
                            <span class="summary-label">Freelancer</span>
                            <span class="summary-val" id="sumFreelancer">-</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Project</span>
                            <span class="summary-val" id="sumProject">-</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Booking Date</span>
                            <span class="summary-val" id="sumDate">-</span>
                        </div>
                        <div class="summary-row">
                            <span class="summary-label">Payment</span>
                            <span class="summary-val" id="sumPayment">GCash</span>
                        </div>
                    </div>

                    <div class="btn-row">
                        <asp:Button ID="btnStep2Back" runat="server" Text="← Back" CssClass="btn btn-outline" OnClick="btnStep2Back_Click" />
                        <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm Booking" CssClass="btn btn-primary" OnClick="btnConfirmBooking_Click" />
                    </div>
                </div>
            </asp:Panel>

            <!-- STEP 3: Success -->
            <asp:Panel ID="pnlStep3" runat="server" Visible="false">
                <div class="booking-card">
                    <div class="success-screen">
                        <div class="success-icon"><i class="fas fa-check"></i></div>
                        <h2>Booking Confirmed!</h2>
                        <p>Your booking request has been sent to the freelancer.</p>
                        <p style="font-size:13px;color:var(--muted);">They will accept or reject within 24 hours.</p>
                        <div class="booking-ref-box"><asp:Literal ID="litBookingRef" runat="server" /></div>
                        <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
                            <a href="Profile.aspx?tab=bookings" class="btn btn-primary">
                                <i class="fas fa-calendar-check"></i> View My Bookings
                            </a>
                            <a href="Home.aspx" class="btn btn-outline">
                                <i class="fas fa-search"></i> Browse More
                            </a>
                        </div>
                    </div>
                </div>
            </asp:Panel>

        </div>
    </div>

    <footer class="site-footer">
        <p>© <%= DateTime.Now.Year %> SkillLink. All rights reserved.</p>
    </footer>

</form>
<script>
    window.addEventListener('DOMContentLoaded', function () {
        var today = new Date().toISOString().split('T')[0];
        var dateField = document.getElementById('<%= txtBookingDate.ClientID %>');
        if (dateField) dateField.min = today;

        updateStepIndicator(parseInt(document.getElementById('hdnCurrentStep').value) || 1);

        var savedPay = document.getElementById('hdnPaymentMethod').value;
        if (savedPay) {
            var payMap = { 'GCash':'payGcash','Maya':'payMaya','Bank Transfer':'payBank','Cash':'payCash' };
            var payEl = document.getElementById(payMap[savedPay]);
            if (payEl) {
                document.querySelectorAll('.pay-card').forEach(function(c){ c.classList.remove('selected'); });
                payEl.classList.add('selected');
            }
        }
    });

    function selectPayment(name, el) {
        document.querySelectorAll('.pay-card').forEach(function(c){ c.classList.remove('selected'); });
        el.classList.add('selected');
        document.getElementById('hdnPaymentMethod').value = name;
        document.getElementById('sumPayment').textContent = name;
    }

    function updateStepIndicator(step) {
        for (var i = 1; i <= 3; i++) {
            var ind  = document.getElementById('stepInd' + i);
            var line = document.getElementById('stepLine' + i);
            if (ind) ind.className = 'step' + (i < step ? ' done' : i === step ? ' active' : '');
            if (line) line.className = 'step-line' + (i < step ? ' done' : '');
        }
    }

    function updateSummary() {
        var name    = document.getElementById('hdnFreelancerName').value;
        var project = document.getElementById('<%= txtProjectTitle.ClientID %>').value;
        var date    = document.getElementById('<%= txtBookingDate.ClientID %>').value;
        var payment = document.getElementById('hdnPaymentMethod').value;

        document.getElementById('sumFreelancer').textContent = name || '-';
        document.getElementById('sumProject').textContent = project || '-';
        document.getElementById('sumDate').textContent = date || '-';
        document.getElementById('sumPayment').textContent = payment || 'GCash';
    }
</script>
</body>
</html>