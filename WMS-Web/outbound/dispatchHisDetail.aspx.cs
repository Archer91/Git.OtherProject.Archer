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

public partial class outbound_dispatchHisDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    decimal priceTotal = 0;
    /// <summary>
    /// 查询里面的发料历史明细金额合计
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 0; i < 2; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity")) * Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "StandardPrice"));

        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[6].Text = "金额总计:";
            // for the Footer, display the running totals
            e.Row.Cells[7].Text = priceTotal.ToString("c");

            e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }

    private bool isAccepted = false;

    private bool getIsAccepted(string DeliveryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select IsReviewed From DeliveryMain Where DeliveryID=" + DeliveryID;

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();

        SqlDataReader reader = command.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                return Convert.ToBoolean(reader[0].ToString());
            }
        }
        finally
        {
            reader.Close();
        }
        return false;
    }

    protected void GridView4_DataBound(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(Request.QueryString["id"]))
        {
            string strDeliveryID = Request.QueryString["id"];
            isAccepted = Convert.ToBoolean(getIsAccepted(strDeliveryID));
            ((CommandField)GridView4.Columns[8]).ShowEditButton = !isAccepted;
            GridView4.Columns[9].Visible = !isAccepted;
            if (!isAccepted)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
                string strQuery = "";

                strQuery = "SELECT ItemID FROM [Inventory] Where [Inventory].IsDeleted=0" +
                   " And [Inventory].WareHouseID in (Select WareHouseID From DeliveryMain Where DeliveryID=" + strDeliveryID
                    + ") And [Inventory].ItemID Not In (Select ItemID From DeliveryDetail Where DeliveryID=" + strDeliveryID + ")";

                SqlDataAdapter adapter = new SqlDataAdapter(strQuery, con);
                DataSet ds = new DataSet();
                adapter.Fill(ds);

                if (GridView4.FooterRow != null)
                {

                    DropDownList drpItem = (DropDownList)GridView4.FooterRow.FindControl("drpItem");
                    drpItem.DataSource = ds.Tables[0];
                    drpItem.DataBind();
                    drpItem.Visible = true;
                    LinkButton LinkButtonEditAdd = (LinkButton)GridView4.FooterRow.FindControl("LinkButtonEditAdd");
                    LinkButtonEditAdd.Visible = true;
                }
            }

        }
    }

    protected void GridView4_RowEditing(object sender, GridViewEditEventArgs e)
    {

        GridView myGridView = (GridView)sender;
        myGridView.EditIndex = e.NewEditIndex;
        myGridView.DataBind();

        //光标，后面想想怎么默认全部选中
        GridViewRow editRow = myGridView.Rows[e.NewEditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtQuantity"));
    }

    protected void LinkButtonEditAdd_Click(object sender, EventArgs e)
    {
        DropDownList drpItem = (DropDownList)GridView4.FooterRow.FindControl("drpItem");
        string ItemID = drpItem.SelectedValue;
        string strDeliveryID = Request.QueryString["id"];

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "";

        strQuery = "INSERT INTO DeliveryDetail VALUES(" + strDeliveryID + ",'" + ItemID + "',0)";
        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        command.ExecuteNonQuery();

        //列表GridView
        GridView4.EditIndex = 0;
        GridView4.DataBind();

        //光标
        GridViewRow editRow = GridView4.Rows[GridView4.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtQuantity"));

    }

}
