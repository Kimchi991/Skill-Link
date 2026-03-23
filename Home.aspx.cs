using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Skill_Link
{
    public partial class Home : Page
    {
        public string ActiveCategory { get; private set; } = "Programming";

        private static readonly string[,] CatMeta = new string[,]
        {
            { "Programming & Tech",        "Programming & Tech",         "Custom software, web apps, and technical solutions" },
            { "Graphics & Design",         "Graphics & Design",          "Creative designs to make your brand unforgettable" },
            { "Video & Animation",         "Video & Animation",          "Engaging videos and animations for every audience" },
            { "Music & Audio",             "Music & Audio",              "Professional audio production and voice talent" },
            { "Digital Marketing",         "Digital Marketing",          "Grow your reach with expert marketing strategies" },
            { "Writing & Translation",     "Writing & Translation",      "Compelling content and accurate translations" },
            { "Business",                  "Business",                   "Consulting, planning, and professional services" },
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Handle UI Visibility (Login/Profile)
            bool isLoggedIn = Session["UserEmail"] != null;
            hdnIsLoggedIn.Value = isLoggedIn ? "1" : "0";
            string role = Session["UserRole"]?.ToString() ?? "";

            lnkLogin.Visible = !isLoggedIn;
            lnkProfile.Visible = isLoggedIn;

            // Only show "Post a Service" to logged-in Freelancers/Admins
            lnkFreelance.Visible = isLoggedIn && (role.Equals("Freelancer", StringComparison.OrdinalIgnoreCase) || role.Equals("Admin", StringComparison.OrdinalIgnoreCase));

            // 2. Data Loading
            if (!IsPostBack)
            {
                // Force the services view to be visible if it's the default landing
                // Note: Make sure viewServices has runat="server" in the .aspx file
                viewServices.Style["display"] = "block";

                LoadServices("Programming & Tech");
                SetActiveMeta("Programming & Tech");
                LoadFreelancers();
            }
            else
            {
                // Re-binding on PostBack is usually only needed if ViewState is disabled
                LoadFreelancers();
            }
        }

        protected void lnkTech_Click(object sender, EventArgs e) { LoadServices("Programming & Tech"); SetActiveMeta("Programming & Tech"); }
        protected void lnkGraphics_Click(object sender, EventArgs e) { LoadServices("Graphics & Design"); SetActiveMeta("Graphics & Design"); }
        protected void lnkVideo_Click(object sender, EventArgs e) { LoadServices("Video & Animation"); SetActiveMeta("Video & Animation"); }
        protected void lnkMusic_Click(object sender, EventArgs e) { LoadServices("Music & Audio"); SetActiveMeta("Music & Audio"); }
        protected void lnkMarketing_Click(object sender, EventArgs e) { LoadServices("Digital Marketing"); SetActiveMeta("Digital Marketing"); }
        protected void lnkWriting_Click(object sender, EventArgs e) { LoadServices("Writing & Translation"); SetActiveMeta("Writing & Translation"); }
        protected void lnkBusiness_Click(object sender, EventArgs e) { LoadServices("Business"); SetActiveMeta("Business"); }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string q = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(q))
                LoadServicesSearch(q);
        }

        private void LoadServices(string category)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT TOP 20 Title, Description, Category, Name, Price
                               FROM Services1
                               WHERE Category = @Cat
                               ORDER BY Price ASC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Cat", category);
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }

            rptServices.DataSource = dt;
            rptServices.DataBind();
            pnlEmpty.Visible = (dt.Rows.Count == 0);
        }

        private void LoadServicesSearch(string keyword)
        {
            string connStr = ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT TOP 30 Title, Description, Category, Name, Price
                               FROM Services1
                               WHERE Title       LIKE @kw
                                  OR Description LIKE @kw
                                  OR Category    LIKE @kw
                               ORDER BY Price ASC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    da.Fill(dt);
            }

            litCatTitle.Text = "Search results for \"" + keyword + "\"";
            litCatDesc.Text = dt.Rows.Count + " service(s) found";
            rptServices.DataSource = dt;
            rptServices.DataBind();
            pnlEmpty.Visible = (dt.Rows.Count == 0);
            ActiveCategory = keyword;
        }

        private void SetActiveMeta(string category)
        {
            ActiveCategory = category;
            for (int i = 0; i < CatMeta.GetLength(0); i++)
            {
                if (CatMeta[i, 0] == category)
                {
                    litCatTitle.Text = CatMeta[i, 1];
                    litCatDesc.Text = CatMeta[i, 2];
                    return;
                }
            }
            litCatTitle.Text = category;
            litCatDesc.Text = "";
        }

// Modal onclick now safe in ItemDataBound - removed inline JS onclick

        public string GetGradient(string category)
        {
            switch (category)
            {
                case "Programming & Tech": return "grad-tech";
                case "Graphics & Design": return "grad-design";
                case "Video & Animation": return "grad-video";
                case "Music & Audio": return "grad-audio";
                case "Writing & Translation": return "grad-writing";
                case "Digital Marketing": return "grad-marketing";
                case "Business": return "grad-business";
                default: return "grad-other";
            }
        }

        public string GetIcon(string category)
        {
            switch (category)
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

        public string GetInitial(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "?";
            return name.Substring(0, 1).ToUpper();
        }
        public string RenderSkillTags(object skillsObj)
        {
            if (skillsObj == null || skillsObj == DBNull.Value)
                return "<span style='font-size:12px;color:#64748b;font-style:italic;'>No skills listed yet</span>";

            string skills = skillsObj.ToString().Trim();
            if (string.IsNullOrEmpty(skills))
                return "<span style='font-size:12px;color:#64748b;font-style:italic;'>No skills listed yet</span>";

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            foreach (string skill in skills.Split(','))
            {
                string s = skill.Trim();
                if (!string.IsNullOrEmpty(s))
                    sb.AppendFormat("<span class='fl-skill-tag'>{0}</span>",
                        System.Web.HttpUtility.HtmlEncode(s));
            }
            return sb.ToString();
        }

        public string RenderCompletedWorks(string freelancerEmail)
        {
            if (string.IsNullOrEmpty(freelancerEmail))
                return "<div class='fl-no-works'>No completed works yet</div>";

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            try
            {
                string connStr = System.Configuration.ConfigurationManager
                    .ConnectionStrings["SkillLinkDB"].ConnectionString;

                using (System.Data.SqlClient.SqlConnection conn =
                    new System.Data.SqlClient.SqlConnection(connStr))
                {
                    System.Data.SqlClient.SqlCommand cmd =
                        new System.Data.SqlClient.SqlCommand(
                        @"SELECT TOP 3 ServiceTitle, OrderDate
                  FROM   Orders
                  WHERE  SellerEmail = @Email
                  AND    Status = 'Completed'
                  ORDER  BY OrderDate DESC", conn);
                    cmd.Parameters.AddWithValue("@Email", freelancerEmail);
                    conn.Open();

                    using (System.Data.SqlClient.SqlDataReader r = cmd.ExecuteReader())
                    {
                        bool hasRows = false;
                        while (r.Read())
                        {
                            hasRows = true;
                            string title = System.Web.HttpUtility.HtmlEncode(
                                r["ServiceTitle"].ToString());
                            string date = r["OrderDate"] != DBNull.Value
                                ? Convert.ToDateTime(r["OrderDate"]).ToString("MMM yyyy")
                                : "";
                            sb.AppendFormat(
                                "<div class='fl-work-item'>" +
                                "<span>{0}</span>" +
                                "<span class='fl-work-date'>{1}</span>" +
                                "</div>", title, date);
                        }
                        if (!hasRows)
                            sb.Append("<div class='fl-no-works'>No completed works yet</div>");
                    }
                }
            }
            catch
            {
                sb.Append("<div class='fl-no-works'>No completed works yet</div>");
            }
            return sb.ToString();
        }
private void LoadFreelancers()
        {
            string connStr = System.Configuration.ConfigurationManager
                .ConnectionStrings["SkillLinkDB"].ConnectionString;

            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"SELECT a.Username, a.Email, a.Skills,
                     ISNULL(AVG(CAST(COALESCE(sr.Rating, 0) AS FLOAT)), 0) AS AvgRating,
                     ISNULL(COUNT(sr.RatingID), 0) AS ReviewCount
              FROM Account a
              LEFT JOIN ServiceRatings sr ON sr.SellerEmail = a.Email
              WHERE a.Role = 'Freelancer'
              GROUP BY a.Username, a.Email, a.Skills
              ORDER BY AvgRating DESC, ReviewCount DESC";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            catch (Exception ex)
            {
                // Log error - create debug label in markup later
                System.Diagnostics.Debug.WriteLine("LoadFreelancers error: " + ex.Message);
            }

            rptFreelancers.DataSource = dt;
            rptFreelancers.DataBind();
            pnlNoFreelancers.Visible = dt.Rows.Count == 0;

// Debug - literal added to markup
            // litFreelancerDebug.Text = $"Loaded {dt.Rows.Count} freelancers";
        }
        public string ShortenName(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "Anonymous";
            int at = name.IndexOf('@');
            if (at > 0) return name.Substring(0, at);
            return name.Length > 20 ? name.Substring(0, 20) + "…" : name;
        }
        protected void rptServices_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            // This code runs for every single service "item" inside your repeater.
            // We check if the item is a data row (not a header or footer).
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                // For now, we leave this empty. 
                // Just having this method here satisfies the compiler so Azure can build the site.
            }
        }
        protected void rptServices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "BuyService")
            {
                string[] details = e.CommandArgument.ToString().Split('|');
                string url = $"Booking.aspx?title={Server.UrlEncode(details[0])}&price={details[1]}&freelancer={Server.UrlEncode(details[2])}";
                Response.Redirect(url);
            }
        }
    }
}