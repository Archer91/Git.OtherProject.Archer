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

public partial class Security_roles_manageSingleRole : System.Web.Administration.SecurityPage
{
    private const string DATA_SOURCE = "WebAdminDataSource";

    public void SetDataSource(object v)
    {
        Session[DATA_SOURCE] = v;
    }

    public void BindGrid(bool displayUsersNotFound)
    {
        dataGrid.DataSource = Session[DATA_SOURCE];
        dataGrid.DataBind();
        if (dataGrid.Rows.Count == 0)
        {
            if (displayUsersNotFound)
            {
                notFoundUsers.Visible = true;
            }
        }
    }

    public void IndexChanged(object sender, GridViewPageEventArgs e)
    {
        dataGrid.PageIndex = e.NewPageIndex;
        BindGrid(false);
    }

    public void EnabledChanged(object sender, EventArgs e)
    {
        CheckBox checkBox = (CheckBox)sender;
        GridViewRow gvr = (GridViewRow)checkBox.Parent.Parent;
        Label label = (Label)gvr.FindControl("userNameLink");
        string userName = label.Text;
        string currentRoleName = CurrentRole;
        if (checkBox.Checked)
        {

            if (!Roles.IsUserInRole(userName, currentRoleName))
            {
                Roles.AddUsersToRoles(new string[] { userName }, new string[] { currentRoleName });
            }
        }
        else
        {
            if (Roles.IsUserInRole(userName, currentRoleName))
            {
                Roles.RemoveUsersFromRoles(new string[] { userName }, new string[] { currentRoleName });
            }
        }
    }

    public void Page_Load()
    {
        if (!IsPostBack)
        {
            PopulateRepeaterDataSource();
            repeater.DataBind();
            string currentRoleName = CurrentRole;
            roleName.Text = currentRoleName;

            string[] muc = Roles.GetUsersInRole(currentRoleName);
            MembershipUserCollection Coll = new MembershipUserCollection();
            // no Role method for returning a MembershipUserCollection.
            MembershipUser OneUser = null;
            foreach (string username in muc)
            {
                try
                {
                    OneUser = Membership.GetUser(username, false);
                }
                catch
                {
                    // eat it
                }
                if (OneUser != null)
                {
                    Coll.Add(OneUser);
                }
            }
            SetDataSource(Coll);
            BindGrid(false);
        }

    }


    protected void PopulateRepeaterDataSource()
    {
        PopulateRepeaterDataSource(repeater);
    }

    protected override void OnPreRender(EventArgs e)
    {
        base.OnPreRender(e);
        if (dataGrid.Rows.Count == 0)
        {
            containerTable.Visible = false;
        }
        else
        {
            containerTable.Visible = true;
        }
    }

    public void RedirectToAddUser(object sender, EventArgs e)
    {
        // do not prepend ~/ to this path since it is not at the root
        Response.Redirect("./users/adduser.aspx");
    }

    public void RetrieveLetter(object sender, RepeaterCommandEventArgs e)
    {
        RetrieveLetter(sender, e, dataGrid, (string)GetLocalResourceObject("All"));
        SetDataSource(dataGrid.DataSource);
        BindGrid(true);
    }

    public void SearchForUsers(object sender, EventArgs e)
    {
        SearchForUsers(sender, e, repeater, dataGrid, dropDown1, textBox1);
        SetDataSource(dataGrid.DataSource);
        BindGrid(true);
        //multiView1.ActiveViewIndex = 0;
    }
}
