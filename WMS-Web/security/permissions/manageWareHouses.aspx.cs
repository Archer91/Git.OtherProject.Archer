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

public partial class Security_permissions_manageWareHouses : System.Web.Administration.SecurityPage
{
    private const string CURRENT_PATH = "PermissionCurrentPath";

    protected int CurrentPath
    {
        get
        {
            object tempString = (object)Session[CURRENT_PATH];
            return tempString != null ? (int)tempString : 0;
        }
        set
        {
            Session[CURRENT_PATH] = value;
        }
    }


    public void Page_Load()
    {
        if (!IsPostBack)
        {
            CurrentPath = 0;

            MembershipUserCollection users = Membership.GetAllUsers();
            foreach (MembershipUser user in users)
                ListUsers.Items.Add(user.UserName);

        }
    }
}
