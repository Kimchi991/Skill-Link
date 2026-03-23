using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace Skill_Link
{
    public partial class Admin : Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString; }
        }

        private string CurrentUser
        {
            get { return Session["UserEmail"] != null ? Session["UserEmail"].ToString() : null; }
        }

        // ══════════════════════════════════════════════════════════════════════
        // PAGE LOAD — redirect if not admin
        // ══════════════════════════════════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            // Not logged in → login page
            if (CurrentUser == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            // Check role from DB
            string role = GetScalar(
                "SELECT ISNULL(Role,'') FROM Account WHERE Email=@p0", CurrentUser);

            if (!role.Equals("Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("~/Home.aspx");
                return;
            }

            // Set sidebar display name
            string username = GetScalar(
                "SELECT ISNULL(Username, Email) FROM Account WHERE Email=@p0", CurrentUser);
            litAdminName.Text = Server.HtmlEncode(username);
            litAdminInitial.Text = username.Length > 0
                                   ? username.Substring(0, 1).ToUpper() : "A";

            if (!IsPostBack)
            {
                LoadDashboard();
                LoadUsers("");
                LoadServices("");
                LoadOrders("", "");
                hfActiveSection.Value = "dashboard";
            }
            // On postback the hidden field value is preserved automatically by ViewState,
            // so the JS DOMContentLoaded handler restores the correct section.
        }

        // ══════════════════════════════════════════════════════════════════════
        // DASHBOARD
        // ══════════════════════════════════════════════════════════════════════
        private void LoadDashboard()
        {
            litTotalUsers.Text = GetScalar("SELECT COUNT(*) FROM Account");
            litTotalServices.Text = GetScalar("SELECT COUNT(*) FROM Services1");
            litTotalOrders.Text = GetScalar("SELECT COUNT(*) FROM Orders");

            // Platform earnings: 5% commission on all completed orders
            string earnings = GetScalar(
                "SELECT ISNULL(SUM(TotalAmount * 0.05), 0) FROM Orders WHERE Status='Completed'");
            litTotalEarnings.Text = "₱" + string.Format("{0:N2}",
                decimal.TryParse(earnings, out decimal earn) ? earn : 0);

            // Pending commission (orders not yet completed)
            string pendingEarn = GetScalar(
                "SELECT ISNULL(SUM(TotalAmount * 0.05), 0) FROM Orders WHERE Status NOT IN ('Completed','Cancelled')");
            litPendingEarnings.Text = "₱" + string.Format("{0:N2}",
                decimal.TryParse(pendingEarn, out decimal pend) ? pend : 0);

            // Recent 5 users
            DataTable dtUsers = Query(
                "SELECT TOP 5 Username, Email, ISNULL(Role,'Member') AS Role FROM Account ORDER BY Email DESC");
            rptRecentUsers.DataSource = dtUsers;
            rptRecentUsers.DataBind();

            // Recent 5 services
            DataTable dtSvc = Query(
                "SELECT TOP 5 Title, Category, Price FROM Services1 ORDER BY ServiceID DESC");
            rptRecentServices.DataSource = dtSvc;
            rptRecentServices.DataBind();
        }

        // ══════════════════════════════════════════════════════════════════════
        // MANAGE USERS
        // ══════════════════════════════════════════════════════════════════════
        private void LoadUsers(string search)
        {
            DataTable dt;
            if (string.IsNullOrWhiteSpace(search))
            {
                dt = Query(
                    @"SELECT Username, Email, ISNULL(FirstName,'') AS FirstName,
                             ISNULL(LastName,'') AS LastName,
                             ISNULL(Role,'Member') AS Role,
                             ISNULL(Phone,'') AS Phone
                      FROM   Account ORDER BY Username");
            }
            else
            {
                dt = Query(
                    @"SELECT Username, Email, ISNULL(FirstName,'') AS FirstName,
                             ISNULL(LastName,'') AS LastName,
                             ISNULL(Role,'Member') AS Role,
                             ISNULL(Phone,'') AS Phone
                      FROM   Account
                      WHERE  Username LIKE @p1 OR Email LIKE @p1
                      ORDER  BY Username",
                    null, "%" + search + "%");
            }

            rptUsers.DataSource = dt;
            rptUsers.DataBind();
            pnlNoUsers.Visible = dt.Rows.Count == 0;
        }

        protected void txtUserSearch_TextChanged(object sender, EventArgs e)
        {
            LoadUsers(txtUserSearch.Text.Trim());
        }

        protected void rptUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string email = e.CommandArgument.ToString();

            if (e.CommandName == "DeleteUser")
            {
                if (email.Equals(CurrentUser, StringComparison.OrdinalIgnoreCase))
                {
                    ShowMessage(lblUserAlert, "You cannot delete your own account.", "alert alert-error show");
                    return;
                }
                try
                {
                    Execute("DELETE FROM Account WHERE Email=@p0", email);
                    ShowMessage(lblUserAlert, "User deleted successfully.", "alert alert-success show");
                }
                catch (Exception ex)
                {
                    ShowMessage(lblUserAlert, "Error: " + ex.Message, "alert alert-error show");
                }
            }
            else if (e.CommandName == "MakeAdmin")
            {
                try
                {
                    Execute("UPDATE Account SET Role='Admin' WHERE Email=@p0", email);
                    ShowMessage(lblUserAlert, "User role updated to Admin.", "alert alert-success show");
                }
                catch (Exception ex)
                {
                    ShowMessage(lblUserAlert, "Error: " + ex.Message, "alert alert-error show");
                }
            }

            LoadUsers(txtUserSearch.Text.Trim());
        }

        // ══════════════════════════════════════════════════════════════════════
        // MANAGE SERVICES
        // ══════════════════════════════════════════════════════════════════════
        private void LoadServices(string search)
        {
            DataTable dt;
            if (string.IsNullOrWhiteSpace(search))
            {
                dt = Query(
                    @"SELECT ServiceID, Title, Description, Category, Name, Price
                      FROM   Services1 ORDER BY ServiceID DESC");
            }
            else
            {
                dt = Query(
                    @"SELECT ServiceID, Title, Description, Category, Name, Price
                      FROM   Services1
                      WHERE  Title LIKE @p1 OR Category LIKE @p1 OR Name LIKE @p1
                      ORDER  BY ServiceID DESC",
                    null, "%" + search + "%");
            }

            rptServices.DataSource = dt;
            rptServices.DataBind();
            pnlNoServices.Visible = dt.Rows.Count == 0;
        }

        protected void txtServiceSearch_TextChanged(object sender, EventArgs e)
        {
            LoadServices(txtServiceSearch.Text.Trim());
        }

        protected void rptServices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteService") return;
            int id;
            if (!int.TryParse(e.CommandArgument.ToString(), out id)) return;

            try
            {
                Execute("DELETE FROM Services1 WHERE ServiceID=@p0", id);
                ShowMessage(lblServiceAlert, "Service deleted successfully.", "alert alert-success show");
            }
            catch (Exception ex)
            {
                ShowMessage(lblServiceAlert, "Error: " + ex.Message, "alert alert-error show");
            }
            LoadServices(txtServiceSearch.Text.Trim());
        }

        // ══════════════════════════════════════════════════════════════════════
        // MANAGE ORDERS
        // ══════════════════════════════════════════════════════════════════════

        /// <summary>
        /// Loads orders directly from dbo.Orders.
        /// Columns used: OrderID, OrderRef, UserEmail, ServiceTitle, SellerName,
        ///   Package, ProjectTitle, TotalAmount, Status, OrderDate, Deadline,
        ///   PaymentMethod, SellerEmail.
        /// </summary>
        private void LoadOrders(string search, string status)
        {
            string sql =
                @"SELECT OrderID,
                         OrderRef,
                         UserEmail,
                         ServiceTitle,
                         SellerName,
                         SellerEmail,
                         Package,
                         ProjectTitle,
                         TotalAmount,
                         CAST(TotalAmount * 0.10 AS INT) AS Commission,
                         ISNULL(Status, 'Pending') AS Status,
                         OrderDate,
                         Deadline,
                         PaymentMethod
                  FROM   Orders
                  WHERE  1=1";

            // Status filter
            if (!string.IsNullOrWhiteSpace(status))
                sql += " AND Status = @p1";

            // Keyword search across ref, emails, service title, seller, project
            if (!string.IsNullOrWhiteSpace(search))
            {
                string param = !string.IsNullOrWhiteSpace(status) ? "@p2" : "@p1";
                sql += $" AND (OrderRef LIKE {param}" +
                       $" OR UserEmail LIKE {param}" +
                       $" OR ServiceTitle LIKE {param}" +
                       $" OR SellerName LIKE {param}" +
                       $" OR ProjectTitle LIKE {param})";
            }

            sql += " ORDER BY OrderID DESC";

            DataTable dt;
            if (!string.IsNullOrWhiteSpace(status) && !string.IsNullOrWhiteSpace(search))
                dt = Query(sql, null, status, "%" + search + "%");
            else if (!string.IsNullOrWhiteSpace(status))
                dt = Query(sql, null, status);
            else if (!string.IsNullOrWhiteSpace(search))
                dt = Query(sql, null, "%" + search + "%");
            else
                dt = Query(sql);

            rptOrders.DataSource = dt;
            rptOrders.DataBind();
            pnlNoOrders.Visible = dt.Rows.Count == 0;
        }

        protected void txtOrderSearch_TextChanged(object sender, EventArgs e)
        {
            LoadOrders(txtOrderSearch.Text.Trim(), ddlOrderStatus.SelectedValue);
        }

        protected void ddlOrderStatus_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders(txtOrderSearch.Text.Trim(), ddlOrderStatus.SelectedValue);
        }

        protected void rptOrders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int orderId;
            if (!int.TryParse(e.CommandArgument.ToString(), out orderId)) return;

            try
            {
                switch (e.CommandName)
                {
                    case "SetCompleted":
                        Execute("UPDATE Orders SET Status='Completed' WHERE OrderID=@p0", orderId);
                        ShowMessage(lblOrderAlert, "Order #" + orderId + " marked as Completed.", "alert alert-success show");
                        break;

                    case "SetCancelled":
                        Execute("UPDATE Orders SET Status='Cancelled' WHERE OrderID=@p0", orderId);
                        ShowMessage(lblOrderAlert, "Order #" + orderId + " marked as Cancelled.", "alert alert-success show");
                        break;

                    case "DeleteOrder":
                        Execute("DELETE FROM Orders WHERE OrderID=@p0", orderId);
                        ShowMessage(lblOrderAlert, "Order #" + orderId + " deleted.", "alert alert-success show");
                        break;
                }
            }
            catch (Exception ex)
            {
                ShowMessage(lblOrderAlert, "Error: " + ex.Message, "alert alert-error show");
            }

            LoadOrders(txtOrderSearch.Text.Trim(), ddlOrderStatus.SelectedValue);
        }

        // ══════════════════════════════════════════════════════════════════════
        // LOGOUT
        // ══════════════════════════════════════════════════════════════════════
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

        // ══════════════════════════════════════════════════════════════════════
        // DB HELPERS
        // ══════════════════════════════════════════════════════════════════════

        /// <summary>SELECT → DataTable. Use @p0, @p1… as placeholders.</summary>
        private DataTable Query(string sql, params object[] args)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                for (int i = 0; i < args.Length; i++)
                    if (args[i] != null)
                        cmd.Parameters.AddWithValue("@p" + i, args[i]);
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }
            return dt;
        }

        /// <summary>SELECT single value → string.</summary>
        private string GetScalar(string sql, params object[] args)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                for (int i = 0; i < args.Length; i++)
                    cmd.Parameters.AddWithValue("@p" + i, args[i] ?? DBNull.Value);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null && result != DBNull.Value
                       ? result.ToString() : "";
            }
        }

        /// <summary>INSERT / UPDATE / DELETE. Use @p0, @p1… as placeholders.</summary>
        private void Execute(string sql, params object[] args)
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                for (int i = 0; i < args.Length; i++)
                    cmd.Parameters.AddWithValue("@p" + i, args[i] ?? DBNull.Value);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // ── UI message helper ─────────────────────────────────────────────────
        private void ShowMessage(Label lbl, string msg, string css)
        {
            lbl.Text = msg; lbl.CssClass = css;
        }
    }
}
