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

public partial class setting_projectMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (String.IsNullOrEmpty(Request.QueryString["id"]))
            DetailsView1.DefaultMode = DetailsViewMode.Insert;
    }

    protected void DetailsView1_ItemInserted(object sender, EventArgs e)
    {
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.tree.location=window.parent.tree.location;";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
    }

    protected void DetailsView1_ItemUpdating(object sender, DetailsViewUpdateEventArgs e)
    {
        SqlDataSource1.UpdateParameters["ParentID"].DefaultValue = ((DropDownList)DetailsView1.FindControl("DropDownList1")).SelectedValue;
    }

    protected void DetailsView1_ItemInserting(object sender, DetailsViewInsertEventArgs e)
    {
        SqlDataSource1.InsertParameters["ParentID"].DefaultValue = ((DropDownList)DetailsView1.FindControl("DropDownList1")).SelectedValue;
    }
}
