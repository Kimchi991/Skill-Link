using System;
using System.Globalization;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Booking : Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "";
            if (role.Equals("Freelancer", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Home.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string freelancerEmail = Request.QueryString["freelancer"] ?? "";
                string freelancerName = Request.QueryString["name"] ?? freelancerEmail;

                hdnFreelancerEmail.Value = freelancerEmail;
                hdnFreelancerName.Value = freelancerName;

                litFreelancerName.Text = Server.HtmlEncode(freelancerName);
                litFreelancerInitial.Text = freelancerName.Length > 0
                    ? freelancerName.Substring(0, 1).ToUpper() : "?";

                // Bookings can be started from two different entry points:
                // 1) Service modal "Continue" => querystring includes title/pkg/price.
                // 2) Freelancer card "Book" => querystring only includes freelancer/name.
                string serviceTitle = Request.QueryString["title"] ?? "";
                string servicePkg = Request.QueryString["pkg"] ?? "";
                string priceStr = Request.QueryString["price"] ?? "";

                if (!string.IsNullOrWhiteSpace(serviceTitle))
                    hdnServiceTitle.Value = serviceTitle;
                else
                    hdnServiceTitle.Value = "Direct Booking";

                hdnServicePackage.Value = !string.IsNullOrWhiteSpace(servicePkg) ? servicePkg : "Custom";

                // TotalAmount: use passed price if available; otherwise fallback to "lowest service price"
                // in Services1 for this freelancer.
                decimal totalAmount = 0m;
                bool hasPassedPrice =
                    !string.IsNullOrWhiteSpace(priceStr) &&
                    decimal.TryParse(priceStr, NumberStyles.Any, CultureInfo.InvariantCulture, out totalAmount) &&
                    totalAmount > 0m;

                if (!hasPassedPrice)
                {
                    try
                    {
                        using (SqlConnection conn = new SqlConnection(ConnStr))
                        {
                            // Services1.Name stores the seller's email. When coming from a
                            // freelancer card the querystring may pass a username instead,
                            // so JOIN Account to match by username OR email either way.
                            SqlCommand cmd = new SqlCommand(
                                @"SELECT TOP 1 s.Price
                                  FROM Services1 s
                                  JOIN Account a ON a.Email = s.Name
                                  WHERE (a.Username = @Val OR a.Email = @Val OR s.Name = @Val)
                                    AND s.Price IS NOT NULL
                                  ORDER BY s.Price ASC", conn);
                            cmd.Parameters.AddWithValue("@Val", freelancerEmail);
                            conn.Open();
                            object result = cmd.ExecuteScalar();
                            if (result != null && result != DBNull.Value)
                                totalAmount = Convert.ToDecimal(result, CultureInfo.InvariantCulture);
                        }
                    }
                    catch
                    {
                        // Keep totalAmount = 0 in worst case; the UI will still work.
                    }
                }

                hdnTotalAmount.Value = totalAmount.ToString(CultureInfo.InvariantCulture);

                ShowStep(1);
            }
        }

        // ── STEP 1 → 2 ────────────────────────────────────────────────────────
        protected void btnStep1Next_Click(object sender, EventArgs e)
        {
            string dateStr = txtBookingDate.Text.Trim();
            string projTitle = txtProjectTitle.Text.Trim();
            string desc = txtDescription.Text.Trim();

            if (string.IsNullOrWhiteSpace(dateStr))
            {
                ShowError("Please select a booking date.");
                ShowStep(1);
                return;
            }

            DateTime bookingDate;
            if (!DateTime.TryParse(dateStr, out bookingDate) || bookingDate.Date < DateTime.Today)
            {
                ShowError("Please select a valid future date.");
                ShowStep(1);
                return;
            }

            if (string.IsNullOrWhiteSpace(projTitle))
            {
                ShowError("Please enter a project title.");
                ShowStep(1);
                return;
            }

            if (string.IsNullOrWhiteSpace(desc))
            {
                ShowError("Please describe what you need built.");
                ShowStep(1);
                return;
            }

            hdnCurrentStep.Value = "2";

            // Trigger summary update on client
            ScriptManager.RegisterStartupScript(this, this.GetType(), "updateSum",
                "updateSummary();", true);

            ShowStep(2);
        }

        // ── STEP 2 → 1 ────────────────────────────────────────────────────────
        protected void btnStep2Back_Click(object sender, EventArgs e)
        {
            hdnCurrentStep.Value = "1";
            ShowStep(1);
        }

        // ── STEP 2 → CONFIRM ──────────────────────────────────────────────────
        protected void btnConfirmBooking_Click(object sender, EventArgs e)
        {
            string clientEmail = Session["UserEmail"].ToString();
            string freelancerEmail = hdnFreelancerEmail.Value.Trim();
            string freelancerName = hdnFreelancerName.Value.Trim();
            string paymentMethod = hdnPaymentMethod.Value.Trim();
            string projectTitle = txtProjectTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string notes = txtNotes.Text.Trim();
            string dateStr = txtBookingDate.Text.Trim();

            if (string.IsNullOrWhiteSpace(freelancerEmail))
            {
                ShowError("Freelancer information is missing. Please go back and try again.");
                ShowStep(2);
                return;
            }

            DateTime bookingDate;
            if (!DateTime.TryParse(dateStr, out bookingDate))
            {
                ShowError("Invalid booking date. Please go back and try again.");
                ShowStep(2);
                return;
            }

            if (string.IsNullOrWhiteSpace(paymentMethod))
                paymentMethod = "GCash";

            // Resolve freelancer email if name was passed instead
            if (!freelancerEmail.Contains("@"))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            "SELECT TOP 1 Email FROM Account WHERE Username = @u OR Email LIKE @prefix",
                            conn);
                        cmd.Parameters.AddWithValue("@u", freelancerEmail);
                        cmd.Parameters.AddWithValue("@prefix", freelancerEmail + "@%");
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                            freelancerEmail = result.ToString();
                    }
                }
                catch { }
            }

            string bookingRef = "BK-" + DateTime.Now.ToString("yyyyMMdd") + "-" +
                                Guid.NewGuid().ToString("N").Substring(0, 8).ToUpper();

            try
            {
                decimal totalAmount = 0m;
                decimal.TryParse(hdnTotalAmount.Value, NumberStyles.Any, CultureInfo.InvariantCulture, out totalAmount);
                if (totalAmount < 0m) totalAmount = 0m;

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = @"INSERT INTO Bookings
                                    (BookingRef, ClientEmail, FreelancerEmail, ServiceTitle,
                                     ProjectTitle, Description, BookingDate,
                                     Package, TotalAmount, PaymentMethod,
                                     Status, CreatedAt, Notes)
                                  VALUES
                                    (@BookingRef, @ClientEmail, @FreelancerEmail, @ServiceTitle,
                                     @ProjectTitle, @Description, @BookingDate,
                                     @Package, @TotalAmount, @PaymentMethod,
                                     'Pending', @CreatedAt, @Notes)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@BookingRef", bookingRef);
                    cmd.Parameters.AddWithValue("@ClientEmail", clientEmail);
                    cmd.Parameters.AddWithValue("@FreelancerEmail", freelancerEmail);
                    cmd.Parameters.AddWithValue("@ServiceTitle", hdnServiceTitle.Value);
                    cmd.Parameters.AddWithValue("@ProjectTitle", projectTitle);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@BookingDate", bookingDate.Date);
                    cmd.Parameters.AddWithValue("@Package", hdnServicePackage.Value);
                    cmd.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                    cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                    cmd.Parameters.AddWithValue("@Notes",
                        string.IsNullOrEmpty(notes) ? (object)DBNull.Value : notes);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Session["LastBookingRef"] = bookingRef;
                litBookingRef.Text = bookingRef;
                hdnCurrentStep.Value = "3";
                ShowStep(3);
            }
            catch (Exception ex)
            {
                ShowError("Error saving booking: " + ex.Message);
                ShowStep(2);
            }
        }

        // ── HELPERS ───────────────────────────────────────────────────────────
        private void ShowStep(int step)
        {
            pnlStep1.Visible = (step == 1);
            pnlStep2.Visible = (step == 2);
            pnlStep3.Visible = (step == 3);

            ScriptManager.RegisterStartupScript(this, this.GetType(), "stepInd",
                string.Format("updateStepIndicator({0});", step), true);

            if (step == 2)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "updateSum",
                    "updateSummary();", true);
            }
        }

        private void ShowError(string message)
        {
            lblError.Text = "<i class='fas fa-exclamation-circle' style='margin-right:6px;'></i>" + message;
            lblError.CssClass = "alert alert-error show";
        }
    }
}