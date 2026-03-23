using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Skill_Link
{
    public partial class Profile : Page
    {
        public string DefaultTab { get; private set; } = "profile";

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

            string email = Session["UserEmail"].ToString();

            if (!IsPostBack)
            {
                LoadProfile(email);
                LockFields();

                string tab = Request.QueryString["tab"];
                if (!string.IsNullOrEmpty(tab))
                    DefaultTab = tab;
                else if (Session["LastBookingRef"] != null)
                {
                    DefaultTab = "bookings";
                    Session.Remove("LastBookingRef");
                }
                else if (Session["LastOrderRef"] != null)
                {
                    DefaultTab = "orders";
                    Session.Remove("LastOrderRef");
                }
            }
            else
            {
                litName.Text = Session["UserUsername"] != null
                                ? Session["UserUsername"].ToString()
                                : txtName.Text;
                litEmail.Text = email;
            }

            // Control tab visibility based on role  ← MUST BE INSIDE Page_Load
            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "Client";
            bool isFreelancer = role.Equals("Freelancer", StringComparison.OrdinalIgnoreCase);
            bool isClient = role.Equals("Client", StringComparison.OrdinalIgnoreCase);

            pnlNavServices.Visible = isFreelancer;
            pnlNavReceived.Visible = isFreelancer;
            pnlNavBookingRequests.Visible = isFreelancer;
            pnlNavOrders.Visible = isClient;
            pnlNavBookings.Visible = isClient;

            // Always reload data on every request
            LoadMyServices(email);
            LoadMyOrders(email);
            LoadOrdersReceived(email);
            LoadMyReviews(email);
            LoadMyBookings(email);
            LoadBookingRequests(email);

        }  // ← closing brace of Page_Load

        // ══════════════════════════════════════════════════════════════════════
        // PROFILE
        // ══════════════════════════════════════════════════════════════════════
        private void LoadProfile(string email)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT Username, Email, FirstName, LastName, DOB, Phone,
                             Country, City, PostalCode, ISNULL(Skills,'') AS Skills
                      FROM   Account WHERE Email = @Email", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                using (SqlDataReader r = cmd.ExecuteReader(CommandBehavior.CloseConnection))
                {
                    if (r.Read())
                    {
                        txtName.Text = r["Username"].ToString();
                        txtEmail.Text = r["Email"].ToString();
                        txtFirstName.Text = r["FirstName"].ToString();
                        txtLastName.Text = r["LastName"].ToString();
                        txtDOB.Text = r["DOB"].ToString();
                        txtPhone.Text = r["Phone"].ToString();
                        txtSkills.Text = r["Skills"].ToString();
                        txtCountry.Text = r["Country"].ToString();
                        txtCity.Text = r["City"].ToString();
                        txtPostalCode.Text = r["PostalCode"].ToString();
                        litName.Text = r["Username"].ToString();
                        litEmail.Text = r["Email"].ToString();
                        litRole.Text = Session["UserRole"] != null ? Session["UserRole"].ToString() : "Member";
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // MY SERVICES
        // ══════════════════════════════════════════════════════════════════════
        private void LoadMyServices(string email)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(
                    @"SELECT ServiceID, Title, Description, Category, Price
                      FROM   Services1 WHERE Name = @Email
                      ORDER  BY ServiceID DESC", conn);
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }
            rptMyServices.DataSource = dt;
            rptMyServices.DataBind();
            pnlNoServices.Visible = (dt.Rows.Count == 0);
            lblServiceCount.Text = dt.Rows.Count > 0 ? dt.Rows.Count + " service(s)" : "";
        }

        protected void rptMyServices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteService") return;
            string email = Session["UserEmail"].ToString();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Services1 WHERE ServiceID = @Id AND Name = @Email", conn);
                    cmd.Parameters.AddWithValue("@Id", Convert.ToInt32(e.CommandArgument));
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblServiceMsg, "Service deleted successfully.", "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblServiceMsg, "Error: " + ex.Message, "alert alert-error show");
            }
            LoadMyServices(email);
        }

        // ══════════════════════════════════════════════════════════════════════
        // ORDERS RECEIVED
        // ══════════════════════════════════════════════════════════════════════
        private void LoadOrdersReceived(string email)
        {
            string username = "";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT ISNULL(Username,'') FROM Account WHERE Email = @Email", conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        username = result.ToString();
                }
            }
            catch { }

            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT OrderRef,
                                 UserEmail,
                                 ServiceTitle,
                                 ProjectTitle,
                                 Requirements,
                                 ISNULL(Notes,'')         AS Notes,
                                 Package,
                                 TotalAmount,
                                 ISNULL(Status,'Pending') AS Status,
                                 OrderDate,
                                 Deadline,
                                 ISNULL(Communication,'') AS Communication
                          FROM   Orders
                          WHERE  SellerEmail = @Email
                             OR  SellerName  = @Username
                          ORDER  BY OrderDate DESC", conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Username", username);
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblReceivedMsg,
                    "Error loading received orders: " + ex.Message,
                    "alert alert-error show");
                return;
            }

            rptReceived.DataSource = dt;
            rptReceived.DataBind();

            int count = dt.Rows.Count;
            int pending = 0;
            foreach (DataRow row in dt.Rows)
                if (row["Status"].ToString() == "Pending") pending++;

            pnlNoReceived.Visible = (count == 0);
            lblReceivedCount.Text = count > 0 ? count + " request(s)" : "";
            lblReceivedBadge.Text = pending > 0 ? pending.ToString() : "";
            lblReceivedBadge.Visible = pending > 0;
        }

        protected void rptReceived_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            HandleOrderAction(e.CommandName, e.CommandArgument.ToString(),
                              Session["UserEmail"].ToString());
        }

        protected void btnOrderAction_Click(object sender, EventArgs e)
        {
            string cmd = hdnOrderCmd.Value;
            string orderRef = hdnOrderRef.Value;
            string email = Session["UserEmail"].ToString();
            if (!string.IsNullOrEmpty(cmd) && !string.IsNullOrEmpty(orderRef))
                HandleOrderAction(cmd, orderRef, email);
        }

        private void HandleOrderAction(string commandName, string orderRef, string email)
        {
            try
            {
                string newStatus = "", msg = "";
                switch (commandName)
                {
                    case "AcceptOrder": newStatus = "In Progress"; msg = "Order accepted!"; break;
                    case "RejectOrder": newStatus = "Rejected"; msg = "Order rejected. Client will be refunded."; break;
                    case "DeliverOrder": newStatus = "Delivered"; msg = "Work delivered! Waiting for client confirmation."; break;
                    default: return;
                }
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "UPDATE Orders SET Status = @Status WHERE OrderRef = @Ref", conn);
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@Ref", orderRef);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblReceivedMsg, msg, "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblReceivedMsg, "Error: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "received";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "setTimeout(function(){ showTab('received','navReceived'); }, 100);", true);
        }

        // ══════════════════════════════════════════════════════════════════════
        // MY ORDERS — with Confirm Delivery support
        // ══════════════════════════════════════════════════════════════════════
        private void LoadMyOrders(string email)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT OrderRef, ServiceTitle, SellerName, SellerEmail, Package,
                                 TotalAmount, Status, OrderDate, Deadline
                          FROM   Orders WHERE UserEmail = @Email
                          ORDER  BY OrderDate DESC", conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblMsg, "Error loading orders: " + ex.Message, "alert alert-error show");
            }
            rptOrders.DataSource = dt;
            rptOrders.DataBind();
            pnlNoOrders.Visible = (dt.Rows.Count == 0);
            lblOrderCount.Text = dt.Rows.Count > 0 ? dt.Rows.Count + " order(s)" : "";
        }

        // ── NEW: handles ConfirmDelivery from rptOrders ───────────────────────
        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "ConfirmDelivery") return;

            string orderRef = e.CommandArgument.ToString();
            string userEmail = Session["UserEmail"].ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    // Double-guard: must belong to this buyer AND be in Delivered state
                    // Prevents tampering with another user's order via forged CommandArgument
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Orders
                          SET    Status = 'Completed'
                          WHERE  OrderRef  = @Ref
                          AND    UserEmail = @Email
                          AND    Status    = 'Delivered'", conn);
                    cmd.Parameters.AddWithValue("@Ref", orderRef);
                    cmd.Parameters.AddWithValue("@Email", userEmail);
                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();

                    if (rows > 0)
                        ShowMessage(lblOrderMsg,
                            "Order <strong>" + Server.HtmlEncode(orderRef) + "</strong> confirmed and marked as Completed!",
                            "alert alert-success show");
                    else
                        ShowMessage(lblOrderMsg,
                            "Could not confirm this order. It may have already been updated.",
                            "alert alert-error show");
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblOrderMsg, "Error: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "orders";
            LoadMyOrders(userEmail);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "setTimeout(function(){ showTab('orders','navOrders'); }, 100);", true);
        }

        // ══════════════════════════════════════════════════════════════════════
        // MY REVIEWS
        // ══════════════════════════════════════════════════════════════════════
        private void LoadMyReviews(string email)
        {
            string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "Client";
            bool isFreelancer = role.Equals("Freelancer", StringComparison.OrdinalIgnoreCase);

            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    // Freelancer sees reviews written ABOUT them (ReviewType = 'freelancer')
                    // Client sees reviews written ABOUT them (ReviewType = 'client')
                    string sql = isFreelancer
                        ? @"SELECT sr.RaterEmail AS ReviewerEmail,
                                   ISNULL(o.ServiceTitle, sr.Review) AS ServiceTitle,
                                   sr.Rating,
                                   sr.Review    AS Comment,
                                   sr.CreatedAt
                            FROM   ServiceRatings sr
                            LEFT   JOIN Orders o ON o.OrderRef = sr.OrderRef
                            WHERE  sr.SellerEmail = @Email
                            AND    ISNULL(sr.ReviewType,'freelancer') = 'freelancer'
                            ORDER  BY sr.CreatedAt DESC"
                        : @"SELECT sr.RaterEmail AS ReviewerEmail,
                           ISNULL(o.ServiceTitle, sr.Review) AS ServiceTitle,
                                   sr.Rating,
                                   sr.Review    AS Comment,
                                   sr.CreatedAt
                            FROM   ServiceRatings sr
                            LEFT   JOIN Orders o ON o.OrderRef = sr.OrderRef
                            WHERE  sr.SellerEmail = @Email
                            AND    sr.ReviewType = 'client'
                            ORDER  BY sr.CreatedAt DESC";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch
            {
                pnlNoReviews.Visible = true;
                pnlReviewSummary.Visible = false;
                return;
            }

            int count = dt.Rows.Count;
            pnlNoReviews.Visible = (count == 0);
            pnlReviewSummary.Visible = (count > 0);
            lblReviewCount.Text = count > 0 ? count + " review(s)" : "";

            if (count > 0)
            {
                double avg = 0;
                foreach (DataRow r in dt.Rows) avg += Convert.ToInt32(r["Rating"]);
                avg = Math.Round(avg / count, 1);

                pnlSidebarRating.Visible = true;
                pnlSidebarNoRating.Visible = false;
                litSidebarScore.Text = avg.ToString("0.0");
                litSidebarCount.Text = count + (count == 1 ? " review" : " reviews");
                litSidebarStars.Text = RenderStars((int)Math.Round(avg));
                litAvgRating.Text = avg.ToString("0.0");
                litAvgStars.Text = RenderStarsFull(avg);
                litReviewCount.Text = count + (count == 1 ? " review" : " reviews");

                int[] counts = new int[6];
                foreach (DataRow r in dt.Rows) counts[Convert.ToInt32(r["Rating"])]++;

                System.Text.StringBuilder bars = new System.Text.StringBuilder();
                for (int s = 5; s >= 1; s--)
                {
                    double pct = count > 0 ? (counts[s] * 100.0 / count) : 0;
                    bars.AppendFormat(
                        "<div class=\"review-bar-row\">" +
                        "<span class=\"bar-label\">{0}<i class=\"fas fa-star\" style=\"font-size:10px;color:#f59e0b;margin-left:2px;\"></i></span>" +
                        "<div class=\"bar-track\"><div class=\"bar-fill\" style=\"width:{1}%;\"></div></div>" +
                        "<span class=\"bar-count\">{2}</span>" +
                        "</div>", s, pct.ToString("0"), counts[s]);
                }
                litBreakdownBars.Text = bars.ToString();
            }
            else
            {
                pnlSidebarRating.Visible = false;
                pnlSidebarNoRating.Visible = true;
                litReviewCount.Text = "0 reviews";
                litAvgRating.Text = "-";
                litAvgStars.Text = RenderStars(0);
                litBreakdownBars.Text = "";
            }

            rptReviews.DataSource = dt;
            rptReviews.DataBind();

            int recentCount = 0;
            foreach (DataRow r in dt.Rows)
                if (r["CreatedAt"] != DBNull.Value &&
                    Convert.ToDateTime(r["CreatedAt"]) >= DateTime.Now.AddDays(-7))
                    recentCount++;

            lblReviewBadge.Text = recentCount > 0 ? recentCount.ToString() : "";
            lblReviewBadge.Visible = recentCount > 0;
        }

        // ══════════════════════════════════════════════════════════════════════
        // RATING SUBMIT
        // ══════════════════════════════════════════════════════════════════════
        protected void btnSubmitRating_Click(object sender, EventArgs e)
        {
            string reviewerEmail = Session["UserEmail"].ToString();
            string orderRef = hdnRateOrderRef.Value.Trim();
            string sellerEmail = hdnRateSeller.Value.Trim();
            string serviceTitle = hdnRateService.Value.Trim();
            string comment = hdnRateComment.Value.Trim();

            int rating = 0;
            if (!int.TryParse(hdnRateRating.Value, out rating) || rating < 1 || rating > 5)
            {
                ShowMessage(lblOrderMsg, "Please select a star rating (1–5).", "alert alert-error show");
                DefaultTab = "orders";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                    "setTimeout(function(){ showTab('orders','navOrders'); }, 100);", true);
                return;
            }

            if (HasRated(orderRef, reviewerEmail))
            {
                ShowMessage(lblOrderMsg, "You have already submitted a review for this order.", "alert alert-error show");
                DefaultTab = "orders";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                    "setTimeout(function(){ showTab('orders','navOrders'); }, 100);", true);
                return;
            }

            if (!sellerEmail.Contains("@"))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        SqlCommand cmd = new SqlCommand(
                            "SELECT TOP 1 Email FROM Account WHERE Username = @u OR Email LIKE @prefix", conn);
                        cmd.Parameters.AddWithValue("@u", sellerEmail);
                        cmd.Parameters.AddWithValue("@prefix", sellerEmail + "@%");
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                            sellerEmail = result.ToString();
                    }
                }
                catch { }
            }

            int serviceId = 0;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT TOP 1 ServiceID FROM Services1 WHERE Title = @Title", conn);
                    cmd.Parameters.AddWithValue("@Title", serviceTitle);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        serviceId = Convert.ToInt32(result);
                }
            }
            catch { }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO ServiceRatings
                            (OrderRef, ServiceID, RaterEmail, SellerEmail, Rating, Review, CreatedAt)
                          VALUES
                            (@OrderRef, @ServiceID, @RaterEmail, @SellerEmail, @Rating, @Review, @CreatedAt)",
                        conn);
                    cmd.Parameters.AddWithValue("@OrderRef", orderRef);
                    cmd.Parameters.AddWithValue("@ServiceID", serviceId);
                    cmd.Parameters.AddWithValue("@RaterEmail", reviewerEmail);
                    cmd.Parameters.AddWithValue("@SellerEmail", sellerEmail);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Review",
                        string.IsNullOrEmpty(comment) ? (object)DBNull.Value : comment);
                    cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblOrderMsg,
                    "Thank you! Your review has been submitted successfully.",
                    "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblOrderMsg, "Error saving review: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "orders";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "showTab('orders','navOrders');", true);
        }
        protected void btnSubmitClientRating_Click(object sender, EventArgs e)
        {
            string reviewerEmail = Session["UserEmail"].ToString();
            string orderRef = hdnClientRateOrderRef.Value.Trim();
            string clientEmail = hdnClientRateClient.Value.Trim();
            string serviceTitle = hdnClientRateService.Value.Trim();
            string comment = hdnClientRateComment.Value.Trim();

            int rating = 0;
            if (!int.TryParse(hdnClientRateRating.Value, out rating) || rating < 1 || rating > 5)
            {
                ShowMessage(lblReceivedMsg, "Please select a star rating (1–5).", "alert alert-error show");
                DefaultTab = "received";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                    "setTimeout(function(){ showTab('received','navReceived'); }, 100);", true);
                return;
            }

            if (HasRatedClient(orderRef, reviewerEmail))
            {
                ShowMessage(lblReceivedMsg, "You have already submitted a review for this client.", "alert alert-error show");
                DefaultTab = "received";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                    "setTimeout(function(){ showTab('received','navReceived'); }, 100);", true);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"INSERT INTO ServiceRatings
                    (OrderRef, ServiceID, RaterEmail, SellerEmail, Rating, Review, CreatedAt, ReviewType)
                  VALUES
                    (@OrderRef, 0, @RaterEmail, @ClientEmail, @Rating, @Review, @CreatedAt, 'client')",
                        conn);
                    cmd.Parameters.AddWithValue("@OrderRef", orderRef);
                    cmd.Parameters.AddWithValue("@RaterEmail", reviewerEmail);
                    cmd.Parameters.AddWithValue("@ClientEmail", clientEmail);
                    cmd.Parameters.AddWithValue("@Rating", rating);
                    cmd.Parameters.AddWithValue("@Review",
                        string.IsNullOrEmpty(comment) ? (object)DBNull.Value : comment);
                    cmd.Parameters.AddWithValue("@CreatedAt", DateTime.Now);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblReceivedMsg,
                    "Thank you! Your review for this client has been submitted.",
                    "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblReceivedMsg, "Error saving review: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "received";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "showTab('received','navReceived');", true);
        }

        // ══════════════════════════════════════════════════════════════════════
        // HAS RATED
        // ══════════════════════════════════════════════════════════════════════
        public bool HasRated(string orderRef, string reviewerEmail)
        {
            if (string.IsNullOrEmpty(orderRef) || string.IsNullOrEmpty(reviewerEmail))
                return false;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(1) FROM ServiceRatings WHERE OrderRef=@Ref AND RaterEmail=@Email",
                        conn);
                    cmd.Parameters.AddWithValue("@Ref", orderRef);
                    cmd.Parameters.AddWithValue("@Email", reviewerEmail);
                    conn.Open();
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch { return false; }
        }
        public bool HasRatedClient(string orderRef, string reviewerEmail)
        {
            if (string.IsNullOrEmpty(orderRef) || string.IsNullOrEmpty(reviewerEmail))
                return false;
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(1) FROM ServiceRatings WHERE OrderRef=@Ref AND RaterEmail=@Email AND ReviewType='client'",
                        conn);
                    cmd.Parameters.AddWithValue("@Ref", orderRef);
                    cmd.Parameters.AddWithValue("@Email", reviewerEmail);
                    conn.Open();
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch { return false; }
        }

        // ══════════════════════════════════════════════════════════════════════
        // RENDER / STATUS HELPERS
        // ══════════════════════════════════════════════════════════════════════
        public string RenderStars(int rating)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            for (int i = 1; i <= 5; i++)
                sb.Append(i <= rating
                    ? "<i class=\"fas fa-star\" style=\"color:#f59e0b;\"></i>"
                    : "<i class=\"fas fa-star\" style=\"color:#e2e8f0;\"></i>");
            return sb.ToString();
        }

        private string RenderStarsFull(double avg)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            for (int i = 1; i <= 5; i++)
            {
                if (avg >= i)
                    sb.Append("<i class=\"fas fa-star\" style=\"color:#f59e0b;\"></i>");
                else if (avg >= i - 0.5)
                    sb.Append("<i class=\"fas fa-star-half-alt\" style=\"color:#f59e0b;\"></i>");
                else
                    sb.Append("<i class=\"far fa-star\" style=\"color:#e2e8f0;\"></i>");
            }
            return sb.ToString();
        }

        public string GetStatusBadge(string status)
        {
            switch (status)
            {
                case "Pending": return "badge badge-pending";
                case "In Progress": return "badge badge-ongoing";
                case "Delivered": return "badge badge-active";
                case "Completed": return "badge badge-completed";
                case "Cancelled": return "badge badge-inactive";
                case "Rejected": return "badge badge-inactive";
                case "Revision": return "badge badge-ongoing";
                default: return "badge badge-inactive";
            }
        }

        public string GetStatusIcon(string status)
        {
            switch (status)
            {
                case "Pending": return "fas fa-clock";
                case "In Progress": return "fas fa-spinner";
                case "Delivered": return "fas fa-box-open";
                case "Completed": return "fas fa-check-circle";
                case "Cancelled": return "fas fa-times-circle";
                case "Revision": return "fas fa-redo";
                default: return "fas fa-circle";
            }
        }

        public string FormatDate(object val)
        {
            if (val == null || val == DBNull.Value) return "-";
            DateTime dt;
            return DateTime.TryParse(val.ToString(), out dt) ? dt.ToString("MMM d, yyyy") : "-";
        }

        public string GetServiceGradientClass(string c)
        {
            switch (c)
            {
                case "Programming & Tech": return "svc-grad-tech";
                case "Graphics & Design": return "svc-grad-design";
                case "Video & Animation": return "svc-grad-video";
                case "Music & Audio": return "svc-grad-audio";
                case "Writing & Translation": return "svc-grad-writing";
                case "Digital Marketing": return "svc-grad-marketing";
                case "Business": return "svc-grad-business";
                default: return "svc-grad-other";
            }
        }

        public string GetServiceIcon(string c)
        {
            switch (c)
            {
                case "Programming & Tech": return "fas fa-code";
                case "Graphics & Design": return "fas fa-paint-brush";
                case "Video & Animation": return "fas fa-video";
                case "Music & Audio": return "fas fa-music";
                case "Writing & Translation": return "fas fa-pen-nib";
                case "Digital Marketing": return "fas fa-chart-line";
                case "Business": return "fas fa-briefcase";
                default: return "fas fa-star";
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // LOCK / UNLOCK
        // ══════════════════════════════════════════════════════════════════════
        private void LockFields()
        {
            txtName.ReadOnly = txtFirstName.ReadOnly = txtLastName.ReadOnly =
            txtDOB.ReadOnly = txtPhone.ReadOnly =
            txtCountry.ReadOnly = txtCity.ReadOnly = txtPostalCode.ReadOnly =
            txtEmail.ReadOnly = true;
        }

        private void UnlockFields()
        {
            txtName.ReadOnly = txtFirstName.ReadOnly = txtLastName.ReadOnly =
            txtDOB.ReadOnly = txtPhone.ReadOnly =
            txtCountry.ReadOnly = txtCity.ReadOnly = txtPostalCode.ReadOnly = false;
            txtEmail.ReadOnly = true;
        }

        // ══════════════════════════════════════════════════════════════════════
        // BUTTON HANDLERS
        // ══════════════════════════════════════════════════════════════════════
        protected void btnEdit_Click(object sender, EventArgs e)
        {
            UnlockFields();
            btnEdit.Visible = false;
            btnSave.Visible = btnCancel.Visible = true;
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            LoadProfile(Session["UserEmail"].ToString());
            LockFields();
            btnSave.Visible = btnCancel.Visible = false;
            btnEdit.Visible = true;
            ShowMessage(lblMsg, "", "");
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string email = Session["UserEmail"].ToString();
            try
            {
                string newUsername = txtName.Text.Trim();
                string newFirstName = txtFirstName.Text.Trim();
                string newLastName = txtLastName.Text.Trim();
                string newDOB = txtDOB.Text.Trim();
                string newPhone = txtPhone.Text.Trim();
                string newSkills = txtSkills.Text.Trim();
                string newCountry = txtCountry.Text.Trim();
                string newCity = txtCity.Text.Trim();
                string newPostalCode = txtPostalCode.Text.Trim();

                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Account
                          SET Username   = @U,
                              FirstName  = @FN,
                              LastName   = @LN,
                              DOB        = @D,
                              Phone      = @Ph,
                              Skills     = @Sk,
                              Country    = @Co,
                              City       = @Ci,
                              PostalCode = @PC
                          WHERE Email = @E", conn);
                    cmd.Parameters.AddWithValue("@U", newUsername);
                    cmd.Parameters.AddWithValue("@FN", newFirstName);
                    cmd.Parameters.AddWithValue("@LN", newLastName);
                    cmd.Parameters.AddWithValue("@D", newDOB);
                    cmd.Parameters.AddWithValue("@Ph", newPhone);
                    cmd.Parameters.AddWithValue("@Sk", newSkills);
                    cmd.Parameters.AddWithValue("@Co", newCountry);
                    cmd.Parameters.AddWithValue("@Ci", newCity);
                    cmd.Parameters.AddWithValue("@PC", newPostalCode);
                    cmd.Parameters.AddWithValue("@E", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                Session["UserUsername"] = newUsername;
                LoadProfile(email);
                LockFields();
                btnSave.Visible = btnCancel.Visible = false;
                btnEdit.Visible = true;
                ShowMessage(lblMsg, "Profile updated successfully!", "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblMsg, "Error: " + ex.Message, "alert alert-error show");
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
        // ══════════════════════════════════════════════════════════════════════
        // MY BOOKINGS (Client)
        // ══════════════════════════════════════════════════════════════════════
        private void LoadMyBookings(string email)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT BookingRef, ServiceTitle, FreelancerEmail, Package,
                         BookingDate, TotalAmount, Status, CreatedAt
                  FROM   Bookings
                  WHERE  ClientEmail = @Email
                  ORDER  BY CreatedAt DESC", conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblBookingMsg, "Error loading bookings: " + ex.Message, "alert alert-error show");
                return;
            }

            rptMyBookings.DataSource = dt;
            rptMyBookings.DataBind();
            pnlNoBookings.Visible = (dt.Rows.Count == 0);
            lblBookingCount.Text = dt.Rows.Count > 0 ? dt.Rows.Count + " booking(s)" : "";

            int pending = 0;
            foreach (DataRow row in dt.Rows)
                if (row["Status"].ToString() == "Pending") pending++;

            lblBookingBadge.Text = pending > 0 ? pending.ToString() : "";
            lblBookingBadge.Visible = pending > 0;
        }

        protected void rptMyBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "CancelBooking") return;
            string email = Session["UserEmail"].ToString();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Bookings SET Status = 'Cancelled'
                  WHERE  BookingRef = @Ref AND ClientEmail = @Email
                  AND    Status = 'Pending'", conn);
                    cmd.Parameters.AddWithValue("@Ref", e.CommandArgument.ToString());
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblBookingMsg, "Booking cancelled successfully.", "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblBookingMsg, "Error: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "bookings";
            LoadMyBookings(email);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "setTimeout(function(){ showTab('bookings','navBookings'); }, 100);", true);
        }

        // ══════════════════════════════════════════════════════════════════════
        // BOOKING REQUESTS (Freelancer)
        // ══════════════════════════════════════════════════════════════════════
        private void LoadBookingRequests(string email)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"SELECT BookingRef, ClientEmail, ServiceTitle, ProjectTitle,
                         BookingDate, Package, TotalAmount, Status, CreatedAt
                  FROM   Bookings
                  WHERE  FreelancerEmail = @Email
                  ORDER  BY CreatedAt DESC", conn);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblBookingRequestMsg, "Error loading requests: " + ex.Message, "alert alert-error show");
                return;
            }

            rptBookingRequests.DataSource = dt;
            rptBookingRequests.DataBind();
            pnlNoBookingRequests.Visible = (dt.Rows.Count == 0);
            lblBookingRequestCount.Text = dt.Rows.Count > 0 ? dt.Rows.Count + " request(s)" : "";

            int pending = 0;
            foreach (DataRow row in dt.Rows)
                if (row["Status"].ToString() == "Pending") pending++;

            lblBookingRequestBadge.Text = pending > 0 ? pending.ToString() : "";
            lblBookingRequestBadge.Visible = pending > 0;
        }

        protected void rptBookingRequests_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string email = Session["UserEmail"].ToString();
            string bookingRef = e.CommandArgument.ToString();
            string newStatus = "";
            string msg = "";

            switch (e.CommandName)
            {
                case "AcceptBooking":
                    newStatus = "Accepted";
                    msg = "Booking accepted! The client has been notified.";
                    break;
                case "RejectBooking":
                    newStatus = "Rejected";
                    msg = "Booking rejected.";
                    break;
                case "CompleteBooking":
                    newStatus = "Completed";
                    msg = "Booking marked as Completed!";
                    break;
                default:
                    return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        @"UPDATE Bookings SET Status = @Status
                  WHERE  BookingRef = @Ref
                  AND    FreelancerEmail = @Email", conn);
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@Ref", bookingRef);
                    cmd.Parameters.AddWithValue("@Email", email);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMessage(lblBookingRequestMsg, msg, "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblBookingRequestMsg, "Error: " + ex.Message, "alert alert-error show");
            }

            DefaultTab = "bookingrequests";
            LoadBookingRequests(email);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchTab",
                "setTimeout(function(){ showTab('bookingrequests','navBookingRequests'); }, 100);", true);
        }


        private void ShowMessage(Label lbl, string msg, string css)
        {
            lbl.Text = msg;
            lbl.CssClass = css;
        }
    }
}
