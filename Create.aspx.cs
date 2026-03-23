using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace Skill_Link
{
    public partial class Create : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["UserEmail"] != null)
            {
                Response.Redirect("~/Home.aspx");
            }
        }

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

        private bool IsValidEmail(string email)
        {
            return Regex.IsMatch(email,
                @"^[^@\s]+@[^@\s]+\.[^@\s]+$",
                RegexOptions.IgnoreCase);
        }

        private bool IsValidUsername(string username)
        {
            return Regex.IsMatch(username, @"^[a-zA-Z0-9_]{3,20}$");
        }

        private void ShowError(string message)
        {
            lblError.Text = "<i class='fas fa-exclamation-circle'></i> " + message;
            lblError.CssClass = "alert alert-error show";
        }

        private void ShowSuccess(string message)
        {
            lblSuccess.Text = "<i class='fas fa-check-circle'></i> " + message;
            lblSuccess.CssClass = "alert alert-success show";
        }

        protected void btnCreateAccount_Click(object sender, EventArgs e)
        {
            string username = txtNewUsername.Text.Trim();
            string email = txtNewEmail.Text.Trim();
            string password = txtNewPassword.Text;
            string confirm = txtConfirmPassword.Text;
            string role = hdnRole.Value.Trim();

            // ── Validation ────────────────────────────────────────────────────
            if (string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password))
            {
                ShowError("All fields are required.");
                return;
            }

            if (!IsValidUsername(username))
            {
                ShowError("Username must be 3–20 characters and contain only letters, numbers, or underscores.");
                return;
            }

            if (!IsValidEmail(email))
            {
                ShowError("Please enter a valid email address.");
                return;
            }

            if (password.Length < 6)
            {
                ShowError("Password must be at least 6 characters long.");
                return;
            }

            if (password != confirm)
            {
                ShowError("Passwords do not match.");
                return;
            }

            if (role != "Freelancer" && role != "Client")
            {
                ShowError("Please select a role to continue.");
                return;
            }


            string hashedPassword = HashPassword(password);
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Check duplicate email
                    SqlCommand cmdCheckEmail = new SqlCommand(
                        "SELECT COUNT(*) FROM Account WHERE Email = @Email", conn);
                    cmdCheckEmail.Parameters.AddWithValue("@Email", email);
                    if ((int)cmdCheckEmail.ExecuteScalar() > 0)
                    {
                        ShowError("An account with this email already exists. <a href='Login.aspx' style='color:inherit;text-decoration:underline;'>Sign in instead?</a>");
                        return;
                    }

                    // Check duplicate username
                    SqlCommand cmdCheckUsername = new SqlCommand(
                        "SELECT COUNT(*) FROM Account WHERE Username = @Username", conn);
                    cmdCheckUsername.Parameters.AddWithValue("@Username", username);
                    if ((int)cmdCheckUsername.ExecuteScalar() > 0)
                    {
                        ShowError("This username is already taken. Please choose a different one.");
                        return;
                    }

                    // ── INSERT — includes all NOT NULL columns ────────────────
                    string insert = @"INSERT INTO Account
                                        (Username, Email, Password, FirstName, LastName, Role)
                                      VALUES
                                        (@Username, @Email, @Password, @FirstName, @LastName, @Role)";

                    SqlCommand cmdInsert = new SqlCommand(insert, conn);
                    cmdInsert.Parameters.AddWithValue("@Username", username);
                    cmdInsert.Parameters.AddWithValue("@Email", email);
                    cmdInsert.Parameters.AddWithValue("@Password", hashedPassword);
                    cmdInsert.Parameters.AddWithValue("@FirstName", "");
                    cmdInsert.Parameters.AddWithValue("@LastName", "");
                    cmdInsert.Parameters.AddWithValue("@Role", role);
                    cmdInsert.ExecuteNonQuery();
                }

                // Auto-login after registration
                Session["UserEmail"] = email;
                Session["UserUsername"] = username;
                Session["UserRole"] = role;

                if (role == "Freelancer")
                    Response.Redirect("~/Profile.aspx?tab=services", false);
                else
                    Response.Redirect("~/Home.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                ShowError("A server error occurred: " + ex.Message);
            }
        }

        protected void btnBackToLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Login.aspx");
        }
    }
}
