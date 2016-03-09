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

public partial class Security_users_editUser : System.Web.Administration.SecurityPage
{
    protected Exception currentRequestException;

    protected void AddAnother_Click(object sender, EventArgs e)
    {
        ResetUI();
        SetDisplayUI(false);
    }

    public void Cancel(object sender, EventArgs e)
    {
        ClearTextBoxes();
    }

    protected void ClearTextBoxes()
    {
        UserID.Text = String.Empty;
        UserID.Enabled = true;
        Password.Text = String.Empty;
        ConfirmPassword.Text = String.Empty;
        Description.Text = String.Empty;
    }

    protected void OK_Click(object sender, EventArgs e)
    {
        ReturnToPreviousPage(sender, e);
    }

    public void Page_Load()
    {
        string userName = CurrentUser;
        if (!IsPostBack)
        {
            PopulateCheckboxes();
            UserID.Text = userName;
            UserID.Enabled = false;

            MembershipUser mu = Membership.GetUser(userName, false);
            if (mu == null)
            {
                return; // Review: scenarios where this happens.
            }
            //Email.Text = mu.Email;
            ActiveUser.Checked = mu.IsApproved;
            string comment = mu.Comment;
            string notSet = (string)GetLocalResourceObject("NotSet");
            Description.Text = comment == null || comment == string.Empty ? notSet : mu.Comment;
        }
    }

    protected void PopulateCheckboxes()
    {
        CheckBoxRepeater.DataSource = Roles.GetAllRoles();
        CheckBoxRepeater.DataBind();
        if (CheckBoxRepeater.Items.Count > 0)
        {
            SelectRolesLabel.Text = (string)GetLocalResourceObject("SelectRoles");
        }
        else
        {
            SelectRolesLabel.Text = (string)GetLocalResourceObject("NoRolesDefined");
        }
    }

    public void ResetUI()
    {
        ClearTextBoxes();
    }

    protected void ServerCustomValidate(object sender, ServerValidateEventArgs e)
    {
        if (currentRequestException == null)
        {
            e.IsValid = true;
            return;
        }
        CustomValidator v = (CustomValidator)sender;
        v.ErrorMessage = currentRequestException.Message;
        e.IsValid = false;
    }

    public void SaveClick(object sender, EventArgs e)
    {
        UpdateUser(sender, e);
    }

    protected void UpdateRoleMembership(string u)
    {
        if (u == null || u.Equals(String.Empty))
        {
            return;
        }
        foreach (RepeaterItem i in CheckBoxRepeater.Items)
        {
            CheckBox c = (CheckBox)i.FindControl("checkbox1");
            UpdateRoleMembership(u, c);
        }
        // Clear the checkboxes
        CurrentUser = null;
        PopulateCheckboxes();
    }

    protected void UpdateRoleMembership(string u, CheckBox box)
    {
        // Array manipulation because cannot use Roles static method (need different appPath).
        string role = box.Text;

        bool boxChecked = box.Checked;
        bool userInRole = Roles.IsUserInRole(u, role);
        try
        {
            if (boxChecked && !userInRole)
            {
                Roles.AddUsersToRoles(new string[] { u }, new string[] { role });
            }
            else if (!boxChecked && userInRole)
            {
                Roles.RemoveUsersFromRoles(new string[] { u }, new string[] { role });
            }
        }
        catch (Exception ex)
        {
            PlaceholderValidator.IsValid = false;
            PlaceholderValidator.ErrorMessage = ex.Message;
        }
    }

    public void UpdateUser(object sender, EventArgs e)
    {
        if (!Page.IsValid)
        {
            return;
        }
        string userIDText = UserID.Text;
        //string emailText = Email.Text;
        string passwordText = Password.Text;
        string notSet = (string)GetLocalResourceObject("NotSet");
        try
        {
            MembershipUser mu = Membership.GetUser(UserID.Text, false);
            //mu.Email = Email.Text;
            string oldPassword = mu.GetPassword();
            mu.ChangePassword(oldPassword, passwordText);
            if (
                Description.Text != null && !Description.Text.Equals(notSet))
            {
                mu.Comment = Description.Text;
            }

            mu.IsApproved = ActiveUser.Checked;

            string typeFullName = "System.Web.Security.MembershipUser, " + typeof(HttpContext).Assembly.GetName().ToString(); ;
            Type tempType = Type.GetType(typeFullName);

            Membership.UpdateUser(mu);
            UpdateRoleMembership(userIDText);
        }
        catch (Exception ex)
        {
            PlaceholderValidator.IsValid = false;
            PlaceholderValidator.ErrorMessage = ex.Message;
            return;
        }

        // Go to confirmation
        DialogMessage.Text = String.Format((string)GetLocalResourceObject("Successful"), userIDText);
        AddAnother.Visible = false;
        SetDisplayUI(true);

        ResetUI();
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
