using System;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Terms : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No auth guard — Terms is publicly accessible
        }
    }
}