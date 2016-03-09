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

public partial class Security_users_addUser : System.Web.Administration.SecurityPage
{
    public void CreatedUser(object sender, EventArgs e)
    {
        activeUser.Visible = false;
        panel1.Enabled = false;
        UpdateRoleMembership(createUser.UserName);
    }

    public void CreatingUser(object sender, EventArgs e)
    {
        createUser.DisableCreatedUser = !activeUser.Checked;
    }

    public void Page_Load()
    {
        if (!IsPostBack)
        {
            PopulateCheckboxes();
        }
    }

    protected void PopulateCheckboxes()
    {
        checkBoxRepeater.DataSource = (string[])Roles.GetAllRoles();
        checkBoxRepeater.DataBind();
        if (checkBoxRepeater.Items.Count > 0)
        {
            selectRolesLabel.Text = "选择角色";
        }
        else
        {
            selectRolesLabel.Text = "尚未定义角色";
        }
    }

    protected void SendingPasswordMail(object sender, MailMessageEventArgs e)
    {
        e.Cancel = true;
    }

    protected void UpdateRoleMembership(string u)
    {
        if (String.IsNullOrEmpty(u))
        {
            return;
        }
        foreach (RepeaterItem i in checkBoxRepeater.Items)
        {
            CheckBox c = (CheckBox)i.FindControl("checkbox1");
            UpdateRoleMembership(u, c);
        }
    }

    protected void UpdateRoleMembership(string u, CheckBox box)
    {
        // Array manipulation because cannot use Roles static method (need different appPath).
        string role = box.Text;

        if (box.Checked && !Roles.IsUserInRole(u, role))
        {
            Roles.AddUsersToRoles(new string[] { u }, new string[] { role });
        }
        else if (!box.Checked && Roles.IsUserInRole(u, role))
        {
            Roles.RemoveUsersFromRoles(new string[] { u }, new string[] { role });
        }
    }
    protected void createUser_ActiveStepChanged(object sender, EventArgs e)
    {
        if (createUser.ActiveStepIndex==1)
        {
            Label lblSuccess = createUser.CompleteStep.ContentTemplateContainer.FindControl("lblSuccess") as Label;

            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
            string strQuery = "Select UserNo From aspnet_Users Where UserName='" + createUser.UserName + "'";

            SqlCommand command = new SqlCommand(strQuery, con);
            con.Open();
            SqlDataReader reader = command.ExecuteReader();

            if (reader.Read())
            {
                lblSuccess.Text = "成功创建新账号<b>" + reader[0].ToString()+"</b>";
            }
            reader.Close();
        }
    }
}
