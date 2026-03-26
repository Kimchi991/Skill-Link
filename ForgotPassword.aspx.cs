using System;
using System.Text.RegularExpressions;
using System.Web.UI;

namespace Skill_Link
{
    public partial class ForgotPassword : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserEmail"] != null)
                Response.Redirect("~/Home.aspx");
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrWhiteSpace(email))
            {
                ShowError("Please enter your email address.");
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError("Please enter a valid email address.");
                return;
            }

            // Phase 5: Mock reset logic (no real SMTP needed)
            string token = Guid.NewGuid().ToString("N")[..12];  // Short token

            // Simulate save to DB (real app: INSERT PasswordResetTokens)
            executeNonQuery(
                @"INSERT INTO PasswordResetTokens (Email, Token, Expiry) 
                  VALUES (@p0, @p1, DATEADD(HOUR, 1, GETDATE()))", 
                email, token);

            // Mock success message with token (real: email link)
            litResetInfo.Text = $"Reset token: <strong>{token}</strong><br/>Valid 1 hour. Use on ResetPassword.aspx";

            pnlForm.Visible = false;
            pnlSuccess.Visible = true;
            litEmail.Text = Server.HtmlEncode(email);
        }

        private bool IsValidEmail(string email)
        {
            return Regex.IsMatch(email,
                @"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                RegexOptions.IgnoreCase);
        }

        private void ShowError(string message)
        {
            lblError.Text = "<i class='fas fa-exclamation-circle'></i> " + message;
            lblError.CssClass = "alert alert-error show";
        }
    }
}
