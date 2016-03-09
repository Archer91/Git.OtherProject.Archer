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

public partial class setting_inventoryDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["id"]) && !String.IsNullOrEmpty(Request.QueryString["ItemID"]))
            {
                FormView1.ChangeMode(FormViewMode.Edit);
                //光标
                Page.SetFocus((TextBox)FormView1.FindControl("OriginalQuantityTextBox"));
            }
        }
    }

    protected string GetWareHouseName(int WareHouseID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select Description FROM WareHouses WHERE WareHouseID =" + WareHouseID;

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
        }
        return "";
    }

    protected void FormView1_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        SqlDataSource1.UpdateParameters["WareHouseID"].DefaultValue = Request.QueryString["id"];
    }
    protected void FormView1_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        RedirectContent();
    }
    protected void FormView1_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        RedirectContent();
    }

    private void RedirectContent()
    {

        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "refreshContent";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.content.location.href=window.parent.content.location.href;";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }

    }
}
