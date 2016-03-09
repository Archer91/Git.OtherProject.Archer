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

public partial class setting_supplierMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!Page.IsPostBack && !String.IsNullOrEmpty(Request.QueryString["id"]))
        {
            DetailsView1.ChangeMode(DetailsViewMode.Edit);
        }
    }
    protected void DetailsView1_ItemUpdated(object sender, DetailsViewUpdatedEventArgs e)
    {
        string strMessage = "";
        if (e.Exception == null)
        {
            strMessage = "成功更新记录。";
        }
        else
        {
            strMessage = "在往数据库更新记录时出错，请重新编辑保存。";
            e.ExceptionHandled = true;
        }
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "alert('" + strMessage + "');";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
        RedirectTree();
    }

    private void RedirectTree()
    {
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "refreshTree";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.tree.location.reload();";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
    }
}
