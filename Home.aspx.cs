using System;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

namespace Skill_Link
{
    public partial class Home : BasePage  // Inherit from BasePage for DB helpers
    {
        public string activeCategory { get; private set; } = "Programming";  // Lowercase literal property

        // Category metadata array - used by updateCategoryMeta
        private static readonly string[,] categoryMetadata = new string[,]
        {
            { "Programming & Tech",        "Programming & Tech",         "Custom software, web apps, and technical solutions" },
            { "Graphics & Design",         "Graphics & Design",          "Creative designs to make your brand unforgettable" },
            { "Video & Animation",         "Video & Animation",          "Engaging videos and animations for every audience" },
            { "Music & Audio",             "Music & Audio",              "Professional audio production and voice talent" },
            { "Digital Marketing",         "Digital Marketing",          "Grow your reach with expert marketing strategies" },
            { "Writing & Translation",     "Writing & Translation",      "Compelling content and accurate translations" },
            { "Business",                  "Business",                   "Consulting, planning, and professional services" },
        };

        protected void Page_Load(object sender, EventArgs e)  // loadPage hooks via override if needed
        {
            // Handle login state visibility
            bool hasValidSession = Session["UserEmail"] != null;
            hdnIsLoggedIn.Value = hasValidSession ? "1" : "0";
            string userRole = Session["UserRole"]?.ToString() ?? "";

            lnkLogin.Visible = !hasValidSession;
            lnkProfile.Visible = hasValidSession;
            lnkFreelance.Visible = hasValidSession && (userRole.Equals("Freelancer", StringComparison.OrdinalIgnoreCase) || userRole.Equals("Admin", StringComparison.OrdinalIgnoreCase));

            if (!IsPostBack)
            {
                // Single load for default view - no more duplication!
                string defaultCategory = "Programming & Tech";
                loadServicesByCategory(defaultCategory);  // Literal: loads services for specific category
                updateCategoryMeta(defaultCategory);      // Literal: updates UI meta for category
                loadFreelancers();                       // Literal: loads top freelancers
                viewServices.Style["display"] = "block"; // Match original comment reference
            }
            else
            {
                // Postback rebind only freelancers (services persist via ViewState)
                loadFreelancers();
            }
        }

        // Unified category handler - DRY for all 7 buttons
        private void handleCategoryClick(string category)  // Merge all lnk*_Click
        {
            loadServicesByCategory(category);
            updateCategoryMeta(category);
        }

        // Direct event handlers call unified handler
        protected void lnkTech_Click(object sender, EventArgs e) => handleCategoryClick("Programming & Tech");
        protected void lnkGraphics_Click(object sender, EventArgs e) => handleCategoryClick("Graphics & Design");
        protected void lnkVideo_Click(object sender, EventArgs e) => handleCategoryClick("Video & Animation");
        protected void lnkMusic_Click(object sender, EventArgs e) => handleCategoryClick("Music & Audio");
        protected void lnkMarketing_Click(object sender, EventArgs e) => handleCategoryClick("Digital Marketing");
        protected void lnkWriting_Click(object sender, EventArgs e) => handleCategoryClick("Writing & Translation");
        protected void lnkBusiness_Click(object sender, EventArgs e) => handleCategoryClick("Business");

        protected void handleSearch(object sender, EventArgs e)  // Renamed from btnSearch_Click
        {
            string searchKeyword = txtSearch.Text.Trim();
            if (!string.IsNullOrEmpty(searchKeyword))
                loadServicesBySearch(searchKeyword);  // Literal: searches services
        }

        // Loads services filtered by exact category match
        // Phase 4: Enhanced with price min/max, rating filters
        private void loadServicesByCategory(string category, decimal? minPrice = null, decimal? maxPrice = null, int? minRating = null)
        {
            try
            {
                string sql = @"SELECT TOP 20 s.Title, s.Description, s.Category, s.Name, s.Price,
                                     ISNULL(AVG(CAST(COALESCE(sr.Rating, 0) AS FLOAT)), 0) AS AvgRating
                               FROM Services1 s
                               LEFT JOIN ServiceRatings sr ON sr.ServiceID = s.ServiceID
                               WHERE s.Category = @p0";

                var parameters = new List<object> { category };
                if (minPrice.HasValue) { sql += " AND s.Price >= @p" + parameters.Count; parameters.Add(minPrice.Value); }
                if (maxPrice.HasValue) { sql += " AND s.Price <= @p" + parameters.Count; parameters.Add(maxPrice.Value); }
                if (minRating.HasValue) { sql += " AND ISNULL(AVG(CAST(COALESCE(sr.Rating, 0) AS FLOAT)), 0) >= @p" + parameters.Count; parameters.Add(minRating.Value); }

                sql += " GROUP BY s.ServiceID, s.Title, s.Description, s.Category, s.Name, s.Price ORDER BY s.Price ASC";

                DataTable servicesData = queryDataTable(sql, parameters.ToArray());

                rptServices.DataSource = servicesData;
                rptServices.DataBind();
                pnlEmpty.Visible = servicesData.Rows.Count == 0;
            }
            catch (Exception dbError)
            {
                logError(dbError);
                showUserError(lblServicesError, "Services temporarily unavailable. Please refresh.");
            }
        }

        // Loads services matching search keyword
        private void loadServicesBySearch(string keyword)
        {
            try
            {
                DataTable searchResults = queryDataTable(
                    @"SELECT TOP 30 Title, Description, Category, Name, Price
                      FROM Services1
                      WHERE Title LIKE @p0 OR Description LIKE @p0 OR Category LIKE @p0
                      ORDER BY Price ASC", "%" + keyword + "%");

                litCatTitle.Text = "Search results for \"" + keyword + "\"";
                litCatDesc.Text = searchResults.Rows.Count + " service(s) found";
                rptServices.DataSource = searchResults;
                rptServices.DataBind();
                pnlEmpty.Visible = searchResults.Rows.Count == 0;
                activeCategory = keyword;  // Now used consistently
            }
            catch (Exception searchError)
            {
                logError(searchError);
                showUserError(lblServicesError, "Search failed. Try different keywords.");
            }
        }

        // Updates litCatTitle/litCatDesc from category metadata array
        private void updateCategoryMeta(string category)
        {
            activeCategory = category;
            for (int row = 0; row < categoryMetadata.GetLength(0); row++)
            {
                if (categoryMetadata[row, 0] == category)
                {
                    litCatTitle.Text = categoryMetadata[row, 1];
                    litCatDesc.Text = categoryMetadata[row, 2];
                    return;
                }
            }
            // Fallback for unknown category
            litCatTitle.Text = category;
            litCatDesc.Text = "";
        }

        // Loads freelancers with ratings (non-silent now)
        private void loadFreelancers()
        {
            try
            {
                DataTable freelancersData = queryDataTable(
                    @"SELECT a.Username, a.Email, a.Skills,
                     ISNULL(AVG(CAST(COALESCE(sr.Rating, 0) AS FLOAT)), 0) AS AvgRating,
                     ISNULL(COUNT(sr.RatingID), 0) AS ReviewCount
              FROM Account a
              LEFT JOIN ServiceRatings sr ON sr.SellerEmail = a.Email
              WHERE a.Role = 'Freelancer'
              GROUP BY a.Username, a.Email, a.Skills
              ORDER BY AvgRating DESC, ReviewCount DESC");

                rptFreelancers.DataSource = freelancersData;
                rptFreelancers.DataBind();
                pnlNoFreelancers.Visible = freelancersData.Rows.Count == 0;
            }
            catch (Exception freelancersError)
            {
                logError(freelancersError);
                showUserError(lblFreelancersError, "Freelancers list unavailable. Please refresh.");
            }
        }

        // UI Rendering helpers (Literal names)
        public string getGradientClass(string category)
        {
            // Literal switch - could extract to data-driven but switch is fine for 7 items
            return category switch
            {
                "Programming & Tech" => "grad-tech",
                "Graphics & Design" => "grad-design",
                "Video & Animation" => "grad-video",
                "Music & Audio" => "grad-audio",
                "Writing & Translation" => "grad-writing",
                "Digital Marketing" => "grad-marketing",
                "Business" => "grad-business",
                _ => "grad-other"
            };
        }

        public string getIconClass(string category)
        {
            return category switch
            {
                "Programming & Tech" => "fas fa-code",
                "Graphics & Design" => "fas fa-paint-brush",
                "Video & Animation" => "fas fa-video",
                "Music & Audio" => "fas fa-music",
                "Writing & Translation" => "fas fa-pen-nib",
                "Digital Marketing" => "fas fa-chart-line",
                "Business" => "fas fa-briefcase",
                _ => "fas fa-star"
            };
        }

        public string getInitials(string name)
        {
            return string.IsNullOrWhiteSpace(name) ? "?" : name.Substring(0, 1).ToUpper();
        }

        public string renderSkillTags(object skillsObject)
        {
            if (skillsObject == null || skillsObject == DBNull.Value || string.IsNullOrWhiteSpace(skillsObject.ToString()))
                return "<span style='font-size:12px;color:#64748b;font-style:italic;'>No skills listed yet</span>";

            string[] skillsArray = skillsObject.ToString().Trim().Split(',');
            System.Text.StringBuilder tagsBuilder = new System.Text.StringBuilder();
            foreach (string skill in skillsArray)
            {
                string trimmedSkill = skill.Trim();
                if (!string.IsNullOrEmpty(trimmedSkill))
                    tagsBuilder.AppendFormat("<span class='fl-skill-tag'>{0}</span>", System.Web.HttpUtility.HtmlEncode(trimmedSkill));
            }
            return tagsBuilder.ToString();
        }

        public string renderCompletedWorks(string freelancerEmail)
        {
            if (string.IsNullOrEmpty(freelancerEmail))
                return "<div class='fl-no-works'>No completed works yet</div>";

            System.Text.StringBuilder worksHtml = new System.Text.StringBuilder();
            try
            {
                DataTable worksData = queryDataTable(
                    @"SELECT TOP 3 ServiceTitle, OrderDate
                      FROM Orders
                      WHERE SellerEmail = @p0 AND Status = 'Completed'
                      ORDER BY OrderDate DESC", freelancerEmail);

                bool hasWork = false;
                foreach (DataRow row in worksData.Rows)
                {
                    hasWork = true;
                    string title = System.Web.HttpUtility.HtmlEncode(row["ServiceTitle"].ToString());
                    string dateStr = row["OrderDate"] != DBNull.Value 
                        ? Convert.ToDateTime(row["OrderDate"]).ToString("MMM yyyy") : "";
                    worksHtml.AppendFormat("<div class='fl-work-item'><span>{0}</span><span class='fl-work-date'>{1}</span></div>", title, dateStr);
                }
                if (!hasWork)
                    worksHtml.Append("<div class='fl-no-works'>No completed works yet</div>");
            }
            catch (Exception worksError)
            {
                logError(worksError);
                worksHtml.Append("<div class='fl-no-works'>Error loading works</div>");
            }
            return worksHtml.ToString();
        }

        public string shortenName(string fullName)
        {
            if (string.IsNullOrWhiteSpace(fullName)) return "Anonymous";
            int atIndex = fullName.IndexOf('@');
            if (atIndex > 0) return fullName.Substring(0, atIndex);
            return fullName.Length > 20 ? fullName.Substring(0, 20) + "…" : fullName;
        }

        public string getDisplayPrice(object priceObject)
        {
            if (priceObject == null || priceObject == DBNull.Value || Convert.ToDecimal(priceObject) == 0)
                return "Contact<br>for Quote";
            decimal priceValue = Convert.ToDecimal(priceObject);
            return string.Format("₱{0:N0}", priceValue) + "<small>starting at</small>";
        }

        // Event handlers - fixed silent fails
        protected void rptServices_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                try
                {
                    // Safe data binding for modal/ratings
                    var itemData = e.Item.DataItem;
                    if (itemData != null)
                    {
                        DataBinder.Eval(itemData, "Title")?.ToString();
                        DataBinder.Eval(itemData, "Description")?.ToString();
                    }
                }
                catch (Exception bindError)
                {
                    logError(bindError);
                    // No user-visible action needed for bind error
                }
            }
        }

        protected void rptServices_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "BuyService")
            {
                string[] serviceDetails = e.CommandArgument.ToString().Split('|');
                string redirectUrl = $"Booking.aspx?title={Server.UrlEncode(serviceDetails[0])}&price={serviceDetails[1]}&freelancer={Server.UrlEncode(serviceDetails[2])}";
                Response.Redirect(redirectUrl);
            }
        }
    }
}

