using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace Skill_Link
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If user already has a valid session, skip login
            if (!IsPostBack && Session["UserEmail"] != null)
            {
                Response.Redirect("~/Home.aspx");
            }
        }

        // ── SHA-256 password hashing ──────────────────────────────────────────
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        // ── Basic client-side-safe email format check ─────────────────────────
        private bool IsValidEmail(string email)
        {
            return Regex.IsMatch(email,
                @"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                RegexOptions.IgnoreCase);
        }

        // ── Show an error message on the label ───────────────────────────────
        private void ShowError(System.Web.UI.WebControls.Label lbl, string message)
        {
            lbl.Text = "<i class='fas fa-exclamation-circle'></i> " + message;
            lbl.CssClass = "alert alert-error show";
        }

        private void ShowSuccess(System.Web.UI.WebControls.Label lbl, string message)
        {
            lbl.Text = "<i class='fas fa-check-circle'></i> " + message;
            lbl.CssClass = "alert alert-success show";
        }

        // ── LOGIN ─────────────────────────────────────────────────────────────
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;   // do NOT trim passwords

            // ── Server-side validation ──
            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                ShowError(lblLoginError, "Please enter both email and password.");
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError(lblLoginError, "Please enter a valid email address.");
                return;
            }

            if (password.Length < 6)
            {
                ShowError(lblLoginError, "Password must be at least 6 characters.");
                return;
            }

            string hashedPassword = HashPassword(password);
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Fetch user with role
                    string query = @"SELECT Email, Username, Role
                                     FROM Account
                                     WHERE Email    = @Email
                                       AND Password = @Password";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Password", hashedPassword);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Store useful session data
                            Session["UserEmail"] = reader["Email"].ToString();
                            Session["UserUsername"] = reader["Username"].ToString();
                            Session["UserRole"] = reader["Role"].ToString();

                            string role = reader["Role"].ToString();

                            // Redirect based on role
                            // Redirect based on role
                            if (role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
                            {
                                Response.Redirect("~/Admin.aspx", false);
                            }
                            else if (role.Equals("Freelancer", StringComparison.OrdinalIgnoreCase))
                            {
                                Response.Redirect("~/Profile.aspx?tab=services", false);
                            }
                            else
                            {
                                // Client and any legacy roles go to Home
                                Response.Redirect("~/Home.aspx", false);
                            }

                            Context.ApplicationInstance.CompleteRequest();
                        }
                        else
                        {
                            ShowError(lblLoginError, "Invalid email or password. Please try again.");
                        }
                    }
                }
            }
            catch (SqlException)
            {
                ShowError(lblLoginError, "A server error occurred. Please try again later.");
            }
        }

        // ── REGISTER (redirect) ───────────────────────────────────────────────
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Create.aspx");
        }

        protected void txtPassword_TextChanged(object sender, EventArgs e)
        {

        }
    }
}
