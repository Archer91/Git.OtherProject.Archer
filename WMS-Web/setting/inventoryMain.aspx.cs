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

public partial class setting_inventoryMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["id"] != "" && Request.QueryString["id"] != null)
            {
                string strID = Request.QueryString["id"];
                string WareHouseName = GetWareHouseName(Convert.ToInt32(strID));
                lblTitle.Text = "\"" + WareHouseName + "\"仓库物资";
            }
            else
            {
                divAll.Visible = false;
            }
        }
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.detail.location.href='inventoryDetail.aspx';";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
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

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        RedirectDetail();
    }

    private void RedirectDetail()
    {

        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "refreshDetail";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.detail.location.href='inventoryDetail.aspx?id=" + Request.QueryString["id"] + "&ItemID=" + GridView1.SelectedDataKey.Value + "'";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }

    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Center;

            for (int i = 4; i < 9; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            bool isDeleted = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsDeleted"));
            if (isDeleted)
                e.Row.BackColor = System.Drawing.Color.LightGray;
        }

    }

    protected void GridView1_PageIndexChanged(object sender, EventArgs e)
    {
        setNoSelect(GridView1);
    }

    private void setNoSelect(GridView myGridView)
    {
        myGridView.SelectedIndex = -1;
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "clearDetail";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.detail.location.href='inventoryDetail.aspx';";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
    }

    protected void GridView1_Sorted(object sender, EventArgs e)
    {
        setNoSelect(GridView1);
    }

    protected void GridView2_DataBound(object sender, EventArgs e)
    {
        setNoSelect(GridView2);
    }
 
    protected void radioButtonDetails_CheckedChanged(Object sender, System.EventArgs e)
    {
        if (radioBrowserDetails.Checked)
        {
            GridView1.DataBind();
            GridView1.Visible = true;
            GridView2.Visible = false;
        }
        else if (radioInsertDetails.Checked)
        {
            GridView1.Visible = false;
            GridView2.DataBind();
            GridView2.Visible = true;
        }
    }

    /// <summary>
    /// 选中物资记录，添加该记录，暂时将期初数量设为0，切换到浏览页面，默认编辑模式
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {
        InsertInventory(GridView2.SelectedRow.Cells[1].Text);

        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());

        //列表GridView
        //GridView1.PageIndex = GridView1.PageCount - 1;
        //GridView1.SelectedIndex = GridView1.Rows.Count - 1;
        //逆序查询，让最新插入的放在第一个
        GridView1.SelectedIndex = 0;
        RedirectDetail();
    }

    private void InsertInventory(string strItemID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Insert Into Inventory ([ItemID], [WareHouseID]) Values ('" + strItemID + "'," + Request.QueryString["id"] + ")";

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        command.ExecuteNonQuery();
    }

    protected void btnAuto_Click(object sender, EventArgs e)
    {
        for (int i = GridView2.Rows.Count - 1; i >= 0; i--)
        {
            InsertInventory(GridView2.Rows[i].Cells[1].Text);
        }
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;
        btnAuto.Enabled = false;
        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());
    }

    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // add the UnitPrice to the running total variables
            for (int i = 3; i < 6; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
        }
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        SqlDataSource2.FilterParameters["ItemID"].DefaultValue = ItemIDTextBox.Text + "%";
    }
}
