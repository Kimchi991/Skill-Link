using System;
using System.Globalization;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Booking : Page
    {
        private string ConnStr => ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string title = Request.QueryString["title"];
                string price = Request.QueryString["price"];
                string freelancer = Request.QueryString["freelancer"];

                if (!string.IsNullOrEmpty(title))
                {
                    hdnServiceTitle.Value = title;
                    hdnTotalAmount.Value = price;
                    litServiceTitleDisplay.Text = title;
                    litFreelancerName.Text = freelancer;
                    litFinalPrice.Text = string.Format("{0:N0}", decimal.TryParse(price, out var p) ? p : 0m);
                }
                else
                {
                    Response.Redirect("Home.aspx");
                }
            }
        }

        // STEP 1 -> 2 (Confirmation to Project Details)
        protected void btnStep1Next_Click(object sender, EventArgs e)
        {
            ShowStep(2);
        }

        // STEP 2 -> 3 (Details to Timeline)
        protected void btnStep2Next_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtProjectTitle.Text) || string.IsNullOrWhiteSpace(txtDescription.Text))
            {
                lblError.Text = "Please fill in all project details.";
                lblError.Visible = true;
                return;
            }
            lblError.Visible = false;
            ShowStep(3);
        }

        // STEP 3 -> 4 (Timeline to Summary)
        protected void btnStep3Next_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtBookingDate.Text))
            {
                lblError.Text = "Please select a delivery date.";
                lblError.Visible = true;
                return;
            }
            lblError.Visible = false;
            ShowStep(4);
        }

        // STEP 4 -> BACK TO 3
        protected void btnBack_Click(object sender, EventArgs e)
        {
            ShowStep(3);
        }

        // STEP 4 -> 5 (CONFIRM & SAVE TO DATABASE)
        protected void btnConfirmBooking_Click(object sender, EventArgs e)
        {
            string bookingRef  = "BK-" + DateTime.Now.Ticks.ToString().Substring(10);
            string clientEmail = Session["UserEmail"]?.ToString() ?? "Guest@SkillLink.com";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = @"INSERT INTO Bookings (BookingRef, ClientEmail, FreelancerEmail, ServiceTitle, ProjectTitle, Description, BookingDate, Package, TotalAmount, Status, CreatedAt)
                                   VALUES (@ref, @email, @freelancer, @title, @pTitle, @desc, @date, @pkg, @amount, 'Pending', GETDATE())";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ref", bookingRef);
                    cmd.Parameters.AddWithValue("@email", clientEmail);
                    cmd.Parameters.AddWithValue("@title", hdnServiceTitle.Value);
                    cmd.Parameters.AddWithValue("@pTitle", txtProjectTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@desc", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@date", DateTime.TryParse(txtBookingDate.Text, out var bd) ? bd : DateTime.Today);
                    cmd.Parameters.AddWithValue("@amount", decimal.TryParse(hdnTotalAmount.Value, out var amt) ? amt : 0m);
                    cmd.Parameters.AddWithValue("@freelancer", Request.QueryString["freelancer"] ?? "");
                    cmd.Parameters.AddWithValue("@pkg", Request.QueryString["pkg"] ?? "Custom");

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                litBookingRef.Text = bookingRef;
                ShowStep(5);
            }
            catch (Exception ex)
            {
                lblError.Text = "Save Error: " + ex.Message;
                lblError.Visible = true;
            }
        }

        private void ShowStep(int step)
        {
            pnlStep1.Visible = (step == 1);
            pnlStep2.Visible = (step == 2);
            pnlStep3.Visible = (step == 3);
            pnlStep4.Visible = (step == 4);
            pnlStep5.Visible = (step == 5);
            hdnCurrentStep.Value = step.ToString();
        }
    }
}