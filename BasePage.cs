using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace Skill_Link
{
    public abstract class BasePage : Page
    {
        protected string getConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["SkillLinkDB"].ConnectionString;
        }

        /// <summary>Check if user rated specific order (Phase 4)</summary>
        protected bool hasRatedOrder(string orderRef, string raterEmail)
        {
            return Convert.ToInt32(getScalar(
                @"SELECT COUNT(*) FROM ServiceRatings 
                  WHERE OrderRef = @p0 AND RaterEmail = @p1", orderRef, raterEmail)) > 0;
        }

        /// <summary>Update booking status with payment mock (Phase 2)</summary>
        protected void updateBookingStatus(string bookingRef, string newStatus)
        {
            executeNonQuery(
                @"UPDATE Bookings SET Status = @p1 WHERE BookingRef = @p0", 
                bookingRef, newStatus);
        }

        /// <summary>Get chat messages between users (Phase 5)</summary>
        protected DataTable getChatMessages(string user1, string user2)
        {
            return queryDataTable(
                @"SELECT * FROM ChatMessages 
                  WHERE (FromUser = @p0 AND ToUser = @p1) OR (FromUser = @p1 AND ToUser = @p0)
                  ORDER BY Timestamp", user1, user2);
        }

        /// <summary>Send chat message (Phase 5)</summary>
        protected void sendChatMessage(string fromUser, string toUser, string message)
        {
            executeNonQuery(
                @"INSERT INTO ChatMessages (FromUser, ToUser, Message, Timestamp) 
                  VALUES (@p0, @p1, @p2, GETDATE())", fromUser, toUser, message);
        }

        protected DataTable queryDataTable(string sql, params object[] parameters)
        {
            DataTable dataTable = new DataTable();
            using (SqlConnection connection = new SqlConnection(getConnectionString()))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                // Bind parameters @p0, @p1...
                for (int index = 0; index < parameters.Length; index++)
                    command.Parameters.AddWithValue("@" + index, parameters[index] ?? DBNull.Value);
                connection.Open();
                // Fill table from query results
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    adapter.Fill(dataTable);
            }
            return dataTable;
        }

        protected string getScalarValue(string sql, params object[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(getConnectionString()))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                for (int index = 0; index < parameters.Length; index++)
                    command.Parameters.AddWithValue("@" + index, parameters[index] ?? DBNull.Value);
                connection.Open();
                object result = command.ExecuteScalar();
                // Return empty string for null/DBNull to avoid casting issues
                return result != null && result != DBNull.Value ? result.ToString() : "";
            }
        }

        protected void executeNonQuery(string sql, params object[] parameters)
        {
            using (SqlConnection connection = new SqlConnection(getConnectionString()))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                for (int index = 0; index < parameters.Length; index++)
                    command.Parameters.AddWithValue("@" + index, parameters[index] ?? DBNull.Value);
                connection.Open();
                command.ExecuteNonQuery();
            }
        }

        protected void showUserError(Label errorLabel, string message)
        {
            if (errorLabel != null)
            {
                errorLabel.Text = "<i class='fas fa-exclamation-circle'></i> " + message;
                errorLabel.CssClass = "alert alert-error show";
            }
        }

        protected void logError(Exception exception)
        {
            // Production: use proper logging (NLog/Serilog)
            // Dev: write to event log or console
            System.Diagnostics.Debug.WriteLine("Error: " + exception.Message);
        }
    }
}
