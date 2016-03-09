using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class Security_security : System.Web.Administration.SecurityPage
{

    public void Page_Load()
    {
        if (!IsPostBack)
        {
            UpdateProviderUI();
        }
    }

    private void UpdateProviderUI()
    {
        try
        {
            int total = 0;
            MembershipUserCollection users = (MembershipUserCollection)Membership.GetAllUsers();
            string[] roles = null;
            try
            {
                roles = Roles.GetAllRoles();
            }
            catch
            {
                // will throw if roles not enabled
            }

            userCount.Text = users.Count.ToString();
            if (roles != null)
            {
                roleCount.Text = roles.Length.ToString();
            }
            else
            {
                roleCount.Text = "0";
            }
            roleCount.Visible = true;
            waLink5.Visible = true;
        }
        catch (Exception e)
        {
            Response.Write("有错误发生，请服务器管理员。");
        }
    }
}
