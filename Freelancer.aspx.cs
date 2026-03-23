using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Freelance : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not authenticated
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Block Client role from posting services
            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "";
            if (role.Equals("Client", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Home.aspx");
                return;
            }
        }

        // ── Publish Service ────────────────────────────────────────────────────
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string title       = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string category    = ddlCategory.SelectedValue;
            string name        = Session["UserEmail"]?.ToString() ?? "";
            string priceText   = txtPrice.Text.Trim();

            // ── Server-side validation ──────────────────────────────────────
            if (string.IsNullOrWhiteSpace(title))
            {
                ShowAlert("Please enter a service title.", "alert alert-error show");
                return;
            }
            if (string.IsNullOrWhiteSpace(description))
            {
                ShowAlert("Please enter a service description.", "alert alert-error show");
                return;
            }
            if (string.IsNullOrWhiteSpace(category))
            {
                ShowAlert("Please select a category.", "alert alert-error show");
                return;
            }
            if (!decimal.TryParse(priceText, out decimal price) || price <= 0)
            {
                ShowAlert("Please enter a valid price greater than 0.", "alert alert-error show");
                return;
            }

            // ── Insert into dbo.Services1 ───────────────────────────────────
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Columns: Title, Description, Category, Name, Price
                    string query = @"INSERT INTO Services1 (Title, Description, Category, Name, Price)
                                     VALUES (@Title, @Description, @Category, @Name, @Price)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@Title",       title);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@Category",    category);
                    cmd.Parameters.AddWithValue("@Name",        name);
                    cmd.Parameters.AddWithValue("@Price",       price);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Success — clear fields and show message
                txtTitle.Text       = "";
                txtDescription.Text = "";
                ddlCategory.SelectedIndex = 0;
                txtPrice.Text       = "";

                ShowAlert("✓ Your service has been published successfully! <a href='Profile.aspx' style='color:inherit;text-decoration:underline;margin-left:8px;'>View in My Account →</a>",
                          "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowAlert("Error publishing service: " + ex.Message, "alert alert-error show");
            }
        }

        // ── Helper ─────────────────────────────────────────────────────────────
        private void ShowAlert(string message, string cssClass)
        {
            lblAlert.Text     = message;
            lblAlert.CssClass = cssClass;
        }
    }
}
