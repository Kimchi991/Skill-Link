<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="Skill_Link.Booking" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Booking | Skill-Link</title>
    <link href="css/style.css" rel="stylesheet" />
</head>
<body class="dark-theme">
    <form id="form1" runat="server">
        <div class="booking-container">
            
            <asp:HiddenField ID="hdnFreelancerEmail" runat="server" />
            <asp:HiddenField ID="hdnFreelancerName" runat="server" />
            <asp:HiddenField ID="hdnServiceTitle" runat="server" />
            <asp:HiddenField ID="hdnServicePackage" runat="server" />
            <asp:HiddenField ID="hdnTotalAmount" runat="server" />
            <asp:HiddenField ID="hdnPaymentMethod" runat="server" />
            <asp:HiddenField ID="hdnCurrentStep" runat="server" Value="1" />

            <asp:Label ID="lblError" runat="server" CssClass="alert" />

            <asp:Panel ID="pnlStep1" runat="server">
                <h2>Step 1: Project Details</h2>
                <asp:Literal ID="litFreelancerName" runat="server" />
                <asp:Literal ID="litFreelancerInitial" runat="server" />
                
                <asp:TextBox ID="txtBookingDate" runat="server" TextMode="Date" />
                <asp:TextBox ID="txtProjectTitle" runat="server" placeholder="Project Title" />
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" placeholder="Description" />
                
                <asp:Button ID="btnStep1Next" runat="server" Text="Next" OnClick="btnStep1Next_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlStep2" runat="server" Visible="false">
                <h2>Step 2: Confirm Booking</h2>
                <asp:TextBox ID="txtNotes" runat="server" TextMode="MultiLine" placeholder="Additional Notes" />
                <asp:Button ID="btnStep2Back" runat="server" Text="Back" OnClick="btnStep2Back_Click" />
                <asp:Button ID="btnConfirmBooking" runat="server" Text="Confirm" OnClick="btnConfirmBooking_Click" />
            </asp:Panel>

            <asp:Panel ID="pnlStep3" runat="server" Visible="false">
                <h2>Booking Successful!</h2>
                Reference: <asp:Literal ID="litBookingRef" runat="server" />
            </asp:Panel>

        </div>
    </form>
</body>
</html>