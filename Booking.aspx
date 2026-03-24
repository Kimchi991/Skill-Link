<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="Skill_Link.Booking" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Secure Booking | Skill-Link</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <link href="css/style.css" rel="stylesheet" />
    <style>
        body.dark-theme {
            background-color: #020617;
            margin: 0;
            font-family: 'Inter', sans-serif;
            overflow: hidden; /* Prevents double scrollbars */
        }

        /* The "Invisible Back Page" Fix */
        .booking-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100vh;
            background: rgba(2, 6, 23, 0.7); /* Transparent layer */
            backdrop-filter: blur(12px); /* Blurs the Home page behind it */
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .glass-card {
            background: rgba(15, 23, 42, 0.9);
            border: 1px solid rgba(45, 212, 191, 0.3);
            box-shadow: 0 0 40px rgba(0, 0, 0, 0.6), 0 0 20px rgba(45, 212, 191, 0.2);
            padding: 30px;
            border-radius: 24px;
            width: 90%;
            max-width: 500px;
            color: #f8fafc;
        }

        .neon-text {
            color: #2dd4bf;
            text-shadow: 0 0 10px rgba(45, 212, 191, 0.4);
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .step-indicator {
            color: #94a3b8;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
            display: block;
        }

        .form-group { margin-bottom: 20px; }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #94a3b8;
            font-size: 0.9rem;
        }

        .cyber-input {
            width: 100%;
            background: rgba(30, 41, 59, 0.5);
            border: 1px solid #334155;
            border-radius: 10px;
            padding: 12px;
            color: #fff;
            box-sizing: border-box;
            transition: 0.3s;
        }

        .cyber-input:focus {
            border-color: #2dd4bf;
            outline: none;
            box-shadow: 0 0 10px rgba(45, 212, 191, 0.2);
        }

        .btn-neon {
            background: #2dd4bf;
            color: #020617;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: bold;
            width: 100%;
            cursor: pointer;
            text-transform: uppercase;
            transition: 0.3s;
        }

        .btn-neon:hover {
            box-shadow: 0 0 20px rgba(45, 212, 191, 0.5);
            transform: translateY(-2px);
        }

        .btn-outline {
            background: transparent;
            border: 1px solid #334155;
            color: #94a3b8;
            margin-top: 10px;
        }
        /* ── Booking Payment Cards ── */
        .pay-card {
            background: rgba(30,41,59,0.5);
            border: 1.5px solid #334155;
            border-radius: 14px;
            padding: 16px 12px;
            cursor: pointer;
            transition: all 0.25s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            text-align: center;
        }
        .pay-card:hover { border-color: #2dd4bf; background: rgba(45,212,191,0.07); }
        .pay-card.selected { border-color: #2dd4bf; background: rgba(45,212,191,0.15); box-shadow: 0 0 14px rgba(45,212,191,0.2); }
        .pay-card.selected .pay-check { opacity: 1 !important; }

        /* ── Booking Spinner Overlay ── */
       .pay-card {
            background: rgba(30,41,59,0.5);
            border: 1.5px solid #334155;
            border-radius: 14px;
            padding: 16px 12px;
            cursor: pointer;
            transition: all 0.25s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            text-align: center;
        }
        .pay-card:hover { border-color: #2dd4bf; background: rgba(45,212,191,0.07); }
        .pay-card.selected { border-color: #2dd4bf; background: rgba(45,212,191,0.15); box-shadow: 0 0 14px rgba(45,212,191,0.2); }
        .pay-card.selected .pay-check { opacity: 1 !important; }
        #bookingSpinner {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(2,6,23,0.9);
            backdrop-filter: blur(14px);
            z-index: 99999;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 18px;
        }
        #bookingSpinner .b-ring {
            width: 56px; height: 56px;
            border: 4px solid rgba(45,212,191,0.2);
            border-top-color: #2dd4bf;
            border-radius: 50%;
            animation: bspin 0.9s linear infinite;
        }
        @keyframes bspin { to { transform: rotate(360deg); } }
    </style>
</head>
<body class="dark-theme">
    <form id="form1" runat="server">
        
        <
            class="booking-overlay">
            <div class="glass-card">
                
                <asp:HiddenField ID="hdnServiceTitle" runat="server" />
                <asp:HiddenField ID="hdnTotalAmount" runat="server" />
                <asp:HiddenField ID="hdnCurrentStep" runat="server" Value="1" />
                <asp:HiddenField ID="hdnPaymentMethod" runat="server" Value="" />

                <asp:Label ID="lblError" runat="server" ForeColor="#ef4444" Visible="false" />

                <asp:Panel ID="pnlStep1" runat="server">
                    <span class="step-indicator">Step 1 of 5</span>
                    <h2 class="neon-text">Confirm Booking</h2>
                    <p>You are booking <strong><asp:Literal ID="litFreelancerName" runat="server" /></strong> for:</p>
                    <div style="background: rgba(45, 212, 191, 0.1); padding: 15px; border-radius: 10px; border-left: 4px solid #2dd4bf;">
                         <asp:Literal ID="litServiceTitleDisplay" runat="server" />
                    </div>
                    <br />
                    <asp:Button ID="btnStep1Next" runat="server" Text="Continue" OnClick="btnStep1Next_Click" CssClass="btn-neon" />
                </asp:Panel>

                <asp:Panel ID="pnlStep2" runat="server" Visible="false">
                    <span class="step-indicator">Step 2 of 5</span>
                    <h2 class="neon-text">Project Scope</h2>
                    <div class="form-group">
                        <label>Project Title</label>
                        <asp:TextBox ID="txtProjectTitle" runat="server" CssClass="cyber-input" placeholder="e.g. Modern Logo for My Brand" />
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" CssClass="cyber-input" placeholder="Describe what you need..." />
                    </div>
                    <asp:Button ID="btnStep2Next" runat="server" Text="Next: Timeline" OnClick="btnStep2Next_Click" CssClass="btn-neon" />
                </asp:Panel>

                <asp:Panel ID="pnlStep3" runat="server" Visible="false">
                    <span class="step-indicator">Step 3 of 5</span>
                    <h2 class="neon-text">Delivery Date</h2>
                    <div class="form-group">
                        <label>Preferred Completion Date</label>
                        <asp:TextBox ID="txtBookingDate" runat="server" TextMode="Date" CssClass="cyber-input" />
                    </div>
                    <asp:Button ID="btnStep3Next" runat="server" Text="Next: Summary" OnClick="btnStep3Next_Click" CssClass="btn-neon" />
                </asp:Panel>

                <%-- REPLACE WITH THIS --%>
                <asp:Panel ID="pnlStep4" runat="server" Visible="false">
                    <span class="step-indicator">Step 4 of 5</span>
                    <h2 class="neon-text">Payment Method</h2>

                    <div style="display:flex;justify-content:space-between;align-items:center;background:rgba(45,212,191,0.08);border:1px solid rgba(45,212,191,0.2);border-radius:10px;padding:12px 16px;margin-bottom:20px;">
                        <span style="color:#94a3b8;font-size:0.85rem;">Total Due</span>
                        <span style="color:#2dd4bf;font-weight:bold;">₱<asp:Literal ID="litFinalPrice" runat="server" /></span>
                    </div>

                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:16px;">
                        <div class="pay-card" id="card-gcash" onclick="selectBookingPayment('GCash',this)">
                            <i class="fas fa-mobile-alt" style="font-size:1.5rem;color:#00a3ff;"></i>
                            <span style="font-weight:600;font-size:0.9rem;color:#f8fafc;">GCash</span>
                            <span class="pay-check" style="font-size:0.75rem;color:#2dd4bf;opacity:0;transition:opacity 0.2s;">✓ Selected</span>
                        </div>
                        <div class="pay-card" id="card-maya" onclick="selectBookingPayment('Maya',this)">
                            <i class="fas fa-wallet" style="font-size:1.5rem;color:#22c55e;"></i>
                            <span style="font-weight:600;font-size:0.9rem;color:#f8fafc;">Maya</span>
                            <span class="pay-check" style="font-size:0.75rem;color:#2dd4bf;opacity:0;transition:opacity 0.2s;">✓ Selected</span>
                        </div>
                        <div class="pay-card" id="card-bank" onclick="selectBookingPayment('Bank Transfer',this)">
                            <i class="fas fa-university" style="font-size:1.5rem;color:#fbbf24;"></i>
                            <span style="font-weight:600;font-size:0.9rem;color:#f8fafc;">Bank Transfer</span>
                            <span class="pay-check" style="font-size:0.75rem;color:#2dd4bf;opacity:0;transition:opacity 0.2s;">✓ Selected</span>
                        </div>
                        <div class="pay-card" id="card-cash" onclick="selectBookingPayment('Cash',this)">
                            <i class="fas fa-money-bill-wave" style="font-size:1.5rem;color:#a855f7;"></i>
                            <span style="font-weight:600;font-size:0.9rem;color:#f8fafc;">Cash</span>
                            <span class="pay-check" style="font-size:0.75rem;color:#2dd4bf;opacity:0;transition:opacity 0.2s;">✓ Selected</span>
                        </div>
                    </div>

                    <div id="bookingPayValidation" style="display:none;color:#ef4444;font-size:0.82rem;margin-bottom:10px;">
                        ⚠ Please select a payment method to continue.
                    </div>

                    <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm &amp; Place Order"
                        OnClick="btnConfirmBooking_Click" CssClass="btn-neon"
                        OnClientClick="return bookingSimulatePayment();" />
                    <asp:Button ID="btnBack" runat="server" Text="Wait, Go Back"
                        OnClick="btnBack_Click" CssClass="btn-neon btn-outline" />
                </asp:Panel>

                <asp:Panel ID="pnlStep5" runat="server" Visible="false" style="text-align:center;">
                    <i class="fas fa-check-circle" style="font-size: 3rem; color: #2dd4bf; margin-bottom: 15px;"></i>
                    <h2 class="neon-text">Success!</h2>
                    <p>Reference: <asp:Literal ID="litBookingRef" runat="server" /></p>
                    <a href="Home.aspx" class="btn-neon" style="display:block; text-decoration:none;">Back to Home</a>
                </asp:Panel>

                <<div id="bookingSpinner">
                    <div class="b-ring"></div>
                    <p style="color:#2dd4bf;font-weight:600;font-size:1rem;" id="bSpinMethod">Processing...</p>
                    <p style="color:#64748b;font-size:0.85rem;" id="bSpinAmount"></p>
                </div>

                <script>
                    function selectBookingPayment(method, el) {
                        document.querySelectorAll('.pay-card').forEach(function (c) { c.classList.remove('selected'); });
                        el.classList.add('selected');
                        document.getElementById('<%= hdnPaymentMethod.ClientID %>').value = method;
                        document.getElementById('bookingPayValidation').style.display = 'none';
                    }

                    function bookingSimulatePayment() {
                        var method = document.getElementById('<%= hdnPaymentMethod.ClientID %>').value;
                        if (!method) {
                            document.getElementById('bookingPayValidation').style.display = 'block';
                            return false;
                        }
                        var spinner = document.getElementById('bookingSpinner');
                        spinner.style.display = 'flex';
                        document.getElementById('bSpinMethod').textContent = 'Processing via ' + method + '...';
                        document.getElementById('bSpinAmount').textContent = '₱' + parseFloat(document.getElementById('<%= hdnTotalAmount.ClientID %>').value || 0).toLocaleString();
                        setTimeout(function () { document.getElementById('form1').submit(); }, 2500);
                        return false;
                    }
                </script>
    </form>
</body>
</html>