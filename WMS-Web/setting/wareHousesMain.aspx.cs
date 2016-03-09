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

public partial class setting_wareHousesMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["id"]))
            {
                FormViewWareHouses.ChangeMode(FormViewMode.Edit);
            }
        }

    }

    //Insert new SparesCategory into specific WareHouse
    private void insertWareHouseItemCategories(int wareHouseID, int sparesCategoryID)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand("INSERT INTO [WareHouseSparesCatogries] ([WareHouseID], [SparesCategoryID]) VALUES (@WareHouseID, @SparesCategoryID)", objConn);
        objCommand.Parameters.Add("@WareHouseID", SqlDbType.Int).Value = wareHouseID;
        objCommand.Parameters.Add("@SparesCategoryID", SqlDbType.Int).Value = sparesCategoryID;
        objCommand.ExecuteNonQuery();
    }

    protected void btnInsert_Click(object sender, EventArgs e)
    {
        FormViewWareHouses.ChangeMode(FormViewMode.Insert);
    }

    protected void FormViewWareHouses_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        DropDownList drpParentWareHouseID = FormViewWareHouses.FindControl("drpParentWareHouseID") as DropDownList;
        SqlWareHousesDetails.InsertParameters["ParentWareHouseID"].DefaultValue = drpParentWareHouseID.SelectedValue;

        SqlWareHousesDetails.InsertParameters["IsActive"].DefaultValue = Convert.ToString(((CheckBox)FormViewWareHouses.FindControl("Checkbox1")).Checked);
        SqlWareHousesDetails.InsertParameters["IsExceptionAllowed"].DefaultValue = Convert.ToString(((CheckBox)FormViewWareHouses.FindControl("Checkbox2")).Checked);

        string strInsertID = hidLeftID.Value;

        if (strInsertID != "")
        {
            //去掉最后一个“,”
            strInsertID = strInsertID.Substring(0, strInsertID.Length - 1);
        }
        SqlWareHousesDetails.InsertParameters["InsertIDList"].DefaultValue = strInsertID;
    }
    protected void FormViewWareHouses_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        hidLeftID.Value = "";
        RedirectTree();
    }
    protected void FormViewWareHouses_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        RedirectTree();
    }

    protected void FormViewWareHouses_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        hidInsertID.Value = "";
        hidDeleteID.Value = "";
        RedirectTree();
    }

    private void RedirectTree()
    {
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.tree.location.reload();";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
    }

    protected void FormViewWareHouses_ItemUpdating(object sender, FormViewUpdateEventArgs e)
    {
        string strInsertID = hidInsertID.Value;

        if (strInsertID != "")
        {
            //去掉最后一个“,”
            strInsertID = strInsertID.Substring(0, strInsertID.Length - 1);
        }
        SqlWareHousesDetails.UpdateParameters["InsertIDList"].DefaultValue = strInsertID;
        
        strInsertID = hidDeleteID.Value;
        if (strInsertID != "")
        {
            //去掉最后一个“,”
            strInsertID = strInsertID.Substring(0, strInsertID.Length - 1);
        } 
        SqlWareHousesDetails.UpdateParameters["DeleteIDList"].DefaultValue = strInsertID;
    }
}
