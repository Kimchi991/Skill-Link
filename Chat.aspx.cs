using System;
using System.Web.UI;
using System.Data;

namespace Skill_Link
{
    public partial class Chat : BasePage  // Inherit BasePage for DB helpers (Phase 5)
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string currentUser = Session["UserEmail"]?.ToString();
            if (string.IsNullOrEmpty(currentUser))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string otherUser = Request.QueryString["user"] ?? "";
            if (string.IsNullOrEmpty(otherUser))
            {
                showUserError(lblError, "No chat partner specified.");
                return;
            }

            litChatTitle.Text = otherUser;
            hdnOtherUser.Value = otherUser;

            if (!IsPostBack)
            {
                loadMessages(currentUser, otherUser);
            }
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            string currentUser = Session["UserEmail"]?.ToString();
            string otherUser = hdnOtherUser.Value;
            string message = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(message))
            {
                showUserError(lblError, "Message cannot be empty.");
                return;
            }

            // Phase 5: Send message using BasePage helper
            sendChatMessage(currentUser, otherUser, message);
            txtMessage.Text = "";  // Clear input

            loadMessages(currentUser, otherUser);  // Reload
        }

        private void loadMessages(string user1, string user2)
        {
            // Phase 5: Load messages using BasePage helper
            DataTable messages = getChatMessages(user1, user2);
            rptMessages.DataSource = messages;
            rptMessages.DataBind();

            pnlNoMessages.Visible = messages.Rows.Count == 0;
        }

        // UI helper: Format timestamp
        public string formatTime(object timestampObj)
        {
            if (timestampObj == null || timestampObj == DBNull.Value) return "";
            DateTime dt = Convert.ToDateTime(timestampObj);
            return dt.ToString("HH:mm");
        }

        // UI helper: My message?
        public string isMyMessage(string fromUser)
        {
            string current = Session["UserEmail"]?.ToString() ?? "";
            return fromUser == current ? "my-message" : "their-message";
        }
    }
}
