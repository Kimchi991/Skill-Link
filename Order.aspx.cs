using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Order : Page
    {
        // ── Exposed to ASPX ───────────────────────────────────────────────────
        public int BasePrice { get; private set; } = 0;
        public int SelectedPkg { get; private set; } = 0;
        public string SuccessOrderRef { get; private set; } = "";

        // ── Page Load ─────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserEmail"] == null)
            {
                Response.Redirect("~/Login.aspx?returnUrl=Order.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadServiceDetails();
            }
        }

        // ── Load service info ─────────────────────────────────────────────────
        private void LoadServiceDetails()
        {
            string serviceIdParam = Request.QueryString["serviceId"];
            int serviceId;

            if (!string.IsNullOrEmpty(serviceIdParam) && int.TryParse(serviceIdParam, out serviceId))
            {
                LoadServiceFromDB(serviceId);
            }
            else
            {
                string title = Request.QueryString["title"] ?? "Service";
                string seller = Request.QueryString["seller"] ?? "Freelancer";
                string category = Request.QueryString["category"] ?? "General";
                int price = 0;
                int.TryParse(Request.QueryString["price"] ?? "0", out price);

                litServiceTitle.Text = Server.HtmlEncode(title);
                litSellerName.Text = Server.HtmlEncode(seller);
                litCategory.Text = Server.HtmlEncode(category);
                BasePrice = price;

                // Store raw seller value (email) in hidden field — no HtmlEncode
                hdnSellerEmail.Value = seller;

                int pkg = 0;
                int.TryParse(Request.QueryString["pkg"] ?? "0", out pkg);
                SelectedPkg = Math.Min(Math.Max(pkg, 0), 2);

                SetPackagePrices(price);
            }
        }

        private void LoadServiceFromDB(int serviceId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT Title, Name, Category, Price FROM Services1 WHERE ServiceID = @Id", conn);
                    cmd.Parameters.AddWithValue("@Id", serviceId);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string rawSellerEmail = reader["Name"].ToString(); // Services1.Name = seller's email

                            litServiceTitle.Text = Server.HtmlEncode(reader["Title"].ToString());
                            litSellerName.Text = Server.HtmlEncode(rawSellerEmail);
                            litCategory.Text = Server.HtmlEncode(reader["Category"].ToString());
                            BasePrice = Convert.ToInt32(reader["Price"]);

                            // Store raw seller email in hidden field — used by btnPlaceOrder_Click
                            hdnSellerEmail.Value = rawSellerEmail;

                            SetPackagePrices(BasePrice);
                        }
                        else
                        {
                            Response.Redirect("~/Home.aspx");
                        }
                    }
                }
            }
            catch
            {
                Response.Redirect("~/Home.aspx");
            }
        }

        private void SetPackagePrices(int basePrice)
        {
            litPriceBasic.Text = string.Format("{0:N0}", basePrice);
            litPriceStandard.Text = string.Format("{0:N0}", basePrice * 2);
            litPricePremium.Text = string.Format("{0:N0}", basePrice * 3);
        }

        // ── Place Order ───────────────────────────────────────────────────────
        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            string userEmail = Session["UserEmail"].ToString();
            string package = hdnPackage.Value;
            string paymentMethod = hdnPaymentMethod.Value;
            int totalPrice = 0;
            int.TryParse(hdnPrice.Value, out totalPrice);

            string projectTitle = txtProjectTitle.Text.Trim();
            string requirements = txtRequirements.Text.Trim();
            string notes = txtNotes.Text.Trim();
            string deadline = txtDeadline.Text.Trim();
            string communication = ddlComm.SelectedValue;

            // ── Server-side validation ────────────────────────────────────────
            if (string.IsNullOrWhiteSpace(projectTitle))
            {
                ShowError(lblPayError, "Project title is required.");
                return;
            }
            if (requirements.Length < 20)
            {
                ShowError(lblPayError, "Please provide more detail in your requirements (at least 20 characters).");
                return;
            }
            if (string.IsNullOrWhiteSpace(paymentMethod))
            {
                ShowError(lblPayError, "Please select a payment method.");
                return;
            }

            // ── Resolve seller email & username reliably ──────────────────────
            // Use hdnSellerEmail (set during LoadServiceFromDB) — raw, no HtmlEncoding
            string sellerRaw = hdnSellerEmail.Value.Trim();
            string sellerEmail = sellerRaw;
            string sellerUsername = sellerRaw;

            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // Try matching by email first, then by username, then by email prefix
                    SqlCommand findSeller = new SqlCommand(
                        @"SELECT Email, Username FROM Account 
                          WHERE Email = @Val 
                             OR Username = @Val
                             OR Email LIKE @ValPrefix", conn);
                    findSeller.Parameters.AddWithValue("@Val", sellerRaw);
                    findSeller.Parameters.AddWithValue("@ValPrefix", sellerRaw + "@%");
                    conn.Open();
                    using (SqlDataReader r = findSeller.ExecuteReader())
                    {
                        if (r.Read())
                        {
                            sellerEmail = r["Email"].ToString();
                            sellerUsername = r["Username"].ToString();
                        }
                    }
                }
            }
            catch { /* keep fallback values */ }

            // ── Generate unique order reference ──────────────────────────────
            string orderRef = "SL-" + DateTime.Now.ToString("yyyyMMdd") + "-" +
                              new Random().Next(1000, 9999).ToString();

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string sql = @"INSERT INTO Orders 
                                   (OrderRef, UserEmail, ServiceTitle, SellerName, SellerEmail, Package,
                                    ProjectTitle, Requirements, Notes, Deadline, Communication,
                                    PaymentMethod, TotalAmount, Status, OrderDate)
                                   VALUES
                                   (@OrderRef, @UserEmail, @ServiceTitle, @SellerName, @SellerEmail, @Package,
                                    @ProjectTitle, @Requirements, @Notes, @Deadline, @Communication,
                                    @PaymentMethod, @TotalAmount, @Status, @OrderDate)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@OrderRef", orderRef);
                    cmd.Parameters.AddWithValue("@UserEmail", userEmail);
                    cmd.Parameters.AddWithValue("@ServiceTitle", litServiceTitle.Text);
                    cmd.Parameters.AddWithValue("@SellerName", sellerUsername);
                    cmd.Parameters.AddWithValue("@SellerEmail", sellerEmail);   // always real email now
                    cmd.Parameters.AddWithValue("@Package", package);
                    cmd.Parameters.AddWithValue("@ProjectTitle", projectTitle);
                    cmd.Parameters.AddWithValue("@Requirements", requirements);
                    cmd.Parameters.AddWithValue("@Notes", string.IsNullOrEmpty(notes)
                                                                      ? (object)DBNull.Value : notes);
                    cmd.Parameters.AddWithValue("@Deadline", string.IsNullOrEmpty(deadline)
                                                                      ? (object)DBNull.Value
                                                                      : (object)DateTime.Parse(deadline));
                    cmd.Parameters.AddWithValue("@Communication", communication);
                    cmd.Parameters.AddWithValue("@PaymentMethod", paymentMethod);
                    cmd.Parameters.AddWithValue("@TotalAmount", totalPrice);
                    cmd.Parameters.AddWithValue("@Status", "Pending");
                    cmd.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                    cmd.ExecuteNonQuery();
                }

                // Store in session so Profile.aspx auto-opens Orders tab
                Session["LastOrderRef"] = orderRef;

                litOrderRef.Text = orderRef;
                SuccessOrderRef = orderRef;
                hdnOrderRef.Value = orderRef;
            }
            catch (Exception ex)
            {
                ShowError(lblPayError, "Error placing order: " + ex.Message);
            }
        }

        // ── Helper ────────────────────────────────────────────────────────────
        private void ShowError(System.Web.UI.WebControls.Label lbl, string msg)
        {
            lbl.Text = "<i class='fas fa-exclamation-circle'></i> " + msg;
            lbl.CssClass = "alert alert-error show";
        }
    }
}
