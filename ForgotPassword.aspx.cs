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

            // Always show success — never reveal whether the email exists
            // (prevents account enumeration attacks)
            //
            // TODO when real email sending is ready:
            //   1. Look up Account WHERE Email = @email
            //   2. Generate token: Guid.NewGuid().ToString("N")
            //   3. Save to PasswordResetTokens (Token, Email, Expiry = DateTime.Now.AddHours(1))
            //   4. Send email via SMTP/SendGrid with link:
            //      ResetPassword.aspx?token={token}

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
