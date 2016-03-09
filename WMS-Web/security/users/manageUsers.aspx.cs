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
using System.Data.SqlClient;

public partial class Security_users_manageUsers : System.Web.Administration.SecurityPage
{

    protected const string DATA_SOURCE = "WebAdminDataSource";
    protected const string DATA_SOURCE_ROLES = "WebAdminDataSourceRoles";

    public void SetDataSourceRoles(object v)
    {
        Session[DATA_SOURCE_ROLES] = v;
    }

    public void SetDataSource(object v)
    {
        Session[DATA_SOURCE] = (MembershipUserCollection)v;
    }

    public void BindGrid(bool displayUsersNotCreated)
    {
        DataGrid.DataSource = Session[DATA_SOURCE];
        DataGrid.DataBind();
        if (DataGrid.Rows.Count == 0)
        {
            if (displayUsersNotCreated)
            {
                noUsers.Visible = true;
            }
            else
            {
                notFoundUsers.Visible = true;
            }
        }
    }

    public void IndexChanged(object sender, GridViewPageEventArgs e)
    {
        DataGrid.PageIndex = e.NewPageIndex;
        BindGrid(false);
    }

    public void Page_Load()
    {
        noUsers.Visible = false;
        if (!IsPostBack)
        {
            PopulateRepeaterDataSource();
            AlphabetRepeater.DataBind();

            int total = 0;
            MembershipUserCollection users = Membership.GetAllUsers(0, Int32.MaxValue, out total);
            foreach (MembershipUser user in users)
            {
                user.Comment = getUserDepartment(user.UserName);
            }
            string[] roles = null;
            roles = Roles.GetAllRoles();

            SetDataSourceRoles(roles);
            SetDataSource(users);
            BindGrid(true);
        }
    }

    private string getUserDepartment(string strUserName)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select DepartName FROM Accounts_Department WHERE DepartmentID in (Select DepartmentID From Accounts_DepartmentUsers Where UserName ='" + strUserName + "')";

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        SqlDataReader reader = command.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                return reader[0].ToString();
            }
        }
        finally
        {
            reader.Close();
            con.Close();
        }
        return "";
    }

    public void ButtonClick(object sender, EventArgs e)
    {
        LinkButton button = (LinkButton)sender;
        string userName = button.CommandArgument;
        SetCurrentUser(userName);
    }

    public void EnabledChanged(object sender, EventArgs e)
    {
        CheckBox checkBox = (CheckBox)sender;
        GridViewRow item = (GridViewRow)checkBox.Parent.Parent;
        Label label = (Label)item.FindControl("UserNameLink");
        string userID = label.Text;
        MembershipUser user = Membership.GetUser(userID, false);
        user.IsApproved = checkBox.Checked;

        string typeFullName = "System.Web.Security.MembershipUser, " + typeof(HttpContext).Assembly.GetName().ToString(); ;
        Type tempType = Type.GetType(typeFullName);

        Membership.UpdateUser(user);
    }

    public void LinkButtonClick(object sender, CommandEventArgs e)
    {
        if (e.CommandName.Equals("EditUser"))
        {
            CurrentUser = ((string)e.CommandArgument);
            // do not prepend ~/ to this path since it is not at the root
            Response.Redirect("editUser.aspx");
        }
        if (e.CommandName.Equals("DeleteUser"))
        {
            UserID.Text = (string)e.CommandArgument;
            AreYouSure.Text = String.Format((string)GetLocalResourceObject("AreYouSure"), UserID.Text);
            SetDisplayUI(true);
        }
    }

    protected void No_Click(object sender, EventArgs e)
    {
        SetDisplayUI(false);
    }

    protected void PopulateRepeaterDataSource()
    {
        PopulateRepeaterDataSource(AlphabetRepeater);
    }

    public void RedirectToAddUser(object sender, EventArgs e)
    {
        CurrentUser = null;
        // do not prepend ~/ to this path since it is not at the root
        Response.Redirect("adduser.aspx");
    }

    public void RetrieveLetter(object sender, RepeaterCommandEventArgs e)
    {
        MembershipUserCollection users = null;
        RetrieveLetter(sender, e, DataGrid, (string)GetGlobalResourceObject("GlobalResources", "All"), users);
        SetDataSource(DataGrid.DataSource);
        BindGrid(false);
        RolePlaceHolder.Visible = DataGrid.Rows.Count != 0;
    }

    protected void RoleMembershipChanged(object sender, EventArgs e)
    {
        try
        {
            CheckBox box = (CheckBox)sender;
            // Array manipulation because cannot use Roles static method (need different appPath).
            string u = CurrentUser;
            string role = box.Text;

            if (box.Checked)
            {
                Roles.AddUsersToRoles(new string[] { u }, new string[] { role });
            }
            else
            {
                Roles.RemoveUsersFromRoles(new string[] { u }, new string[] { role });
            }
        }
        catch
        {
            // Ignore, e.g., user is already in role.
        }
    }

    public void SearchForUsers(object sender, EventArgs e)
    {
        SearchForUsers(sender, e, AlphabetRepeater, DataGrid, SearchByDropDown, TextBox1);
        SetDataSource(DataGrid.DataSource);
        BindGrid(false);
        RolePlaceHolder.Visible = DataGrid.Rows.Count != 0;
    }

    protected void SetCurrentUser(string s)
    {
        CurrentUser = s;

        CheckBoxRepeater.DataSource = Session[DATA_SOURCE_ROLES];
        CheckBoxRepeater.DataBind();
        if (CheckBoxRepeater.Items.Count > 0)
        {
            AddToRole.Text = String.Format((string)GetLocalResourceObject("AddToRoles2"), s);
        }
        else
        {
            AddToRole.Text = (string)GetLocalResourceObject("NoRolesDefined");
        }
        multiView1.ActiveViewIndex = 1;
    }

    protected string GetToolTip(string resourceName, string itemName)
    {
        string tempString = (string)GetLocalResourceObject(resourceName);
        return String.Format((string)GetGlobalResourceObject("GlobalResources", "ToolTipFormat"), tempString, itemName);
    }

    protected void Yes_Click(object sender, EventArgs e)
    {
        Membership.DeleteUser(UserID.Text, true);

        int total = 0;
        MembershipUserCollection users = Membership.GetAllUsers( 0, Int32.MaxValue, out total);
        string[] roles = null;
        roles = Roles.GetAllRoles();

        SetDataSource(users);
        SetDataSourceRoles(roles);
        BindGrid(true);

        PopulateRepeaterDataSource();
        AlphabetRepeater.DataBind();

        SetDisplayUI(false);
    }

    private void SetDisplayUI(bool showConfirmation)
    {
        if (showConfirmation)
        {
            confirmation.Visible = true;
        }
        else
        {
            confirmation.Visible = false;
        }
    }
}
