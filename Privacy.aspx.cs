using System;
using System.Web.UI;

namespace Skill_Link
{
    public partial class Privacy : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // No auth guard — Privacy Policy is publicly accessible
        }
    }
}
