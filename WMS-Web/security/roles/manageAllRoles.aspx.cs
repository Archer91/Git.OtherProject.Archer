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

public partial class Security_roles_manageAllRoles : System.Web.Administration.SecurityPage
{
    public void AddRole(object sender, EventArgs e)
    {
        if (!textBox1.Text.Equals(string.Empty))
        {
            try
            {
                Roles.CreateRole(textBox1.Text);
                textBox1.Text = string.Empty;
            }
            catch (Exception ex)
            {
                errorMessage.Text = ex.Message;
                errorMessage.Visible = true;
            }
            BindGrid();
        }
    }

    protected void BindGrid()
    {
        string[] arr = Roles.GetAllRoles();
        dataGrid.DataSource = arr;

        int currentPage = dataGrid.PageIndex;
        int count = arr.Length;
        int pageSize = dataGrid.PageSize;
        if (count > 0 && currentPage == count / pageSize && count % pageSize == 0)
        {
            dataGrid.PageIndex -= 1;
        }
        dataGrid.DataBind();
        dataGrid.Visible = (dataGrid.Rows.Count > 0);
    }

    protected string GetToolTip(string resourceName, string itemName)
    {
        string tempString = (string)GetLocalResourceObject(resourceName);
        return String.Format((string)GetGlobalResourceObject("GlobalResources", "ToolTipFormat"), tempString, itemName);
    }

    public void IndexChanged(object sender, GridViewPageEventArgs e)
    {
        dataGrid.PageIndex = e.NewPageIndex;
        BindGrid();
    }

    public void LinkButtonClick(object sender, CommandEventArgs e)
    {
        if (e.CommandName.Equals("ManageRole"))
        {
            CurrentRole = (string)e.CommandArgument;
            // do not prepend ~/ to this path since it is not at the root
            Response.Redirect("manageSingleRole.aspx");
        }
        if (e.CommandName.Equals("DeleteRole"))
        {
            RoleName.Text = (string)e.CommandArgument;
            SetDisplayUI(true);
        }
    }


    protected void No_Click(object sender, EventArgs e)
    {
        SetDisplayUI(false);
    }


    public void Page_Load()
    {
        if (!IsPostBack)
        {
            BindGrid();
        }
    }

    protected void Yes_Click(object sender, EventArgs e)
    {
        if (Roles.RoleExists(RoleName.Text))
        {
            Roles.DeleteRole(RoleName.Text, false);
        }

        BindGrid();
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
