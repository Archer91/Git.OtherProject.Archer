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

public partial class inbound_inboundHisDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    decimal priceTotal = 0;

    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 0; i < 2; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            // determine the value of the UnitsInStock field
            decimal Margin = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Price")) - Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "StandardPrice"));
            if (Margin < 0)
                // color the background of the row yellow
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            else if (Margin > 0)
                e.Row.BackColor = System.Drawing.Color.LightPink;

            priceTotal += Convert.ToInt32(DataBinder.Eval(e.Row.DataItem, "Quantity")) * Margin;
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[6].Text = "料差总计:";
            // for the Footer, display the running totals
            e.Row.Cells[7].Text = priceTotal.ToString("c");

            for (int i = 2; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }
    }

    protected void GridView4_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GridViewRow updateRow = myGridView.Rows[e.RowIndex];

        SqlDataSource5.UpdateParameters["Price"].DefaultValue = ((TextBox)updateRow.FindControl("txtPrice")).Text;
        SqlDataSource5.UpdateParameters["Quantity"].DefaultValue = ((TextBox)updateRow.FindControl("txtQuantity")).Text;
    }

    private bool isAccepted = false;

    private bool getIsAccepted(string strReceiptID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select IsReviewed From ReceiptMain Where ReceiptID='" + strReceiptID + "'";

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
            string strReceiptID = Request.QueryString["id"];
            isAccepted = Convert.ToBoolean(getIsAccepted(strReceiptID));
            ((CommandField)GridView4.Columns[8]).ShowEditButton = !isAccepted;
            GridView4.Columns[9].Visible = !isAccepted;
            if (!isAccepted)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
                string strQuery = "";

                strQuery = "SELECT ItemID FROM [Items] Where [Items].ItemID Not In (Select ItemID From ReceiptDetail Where ReceiptID='" + strReceiptID + "')";

                SqlDataAdapter adapter = new SqlDataAdapter(strQuery, con);
                DataSet ds = new DataSet();
                adapter.Fill(ds);

                if (ds.Tables[0].Rows.Count != 0 && GridView4.FooterRow != null)
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

    protected void LinkButtonEditAdd_Click(object sender, EventArgs e)
    {
        DropDownList drpItem = (DropDownList)GridView4.FooterRow.FindControl("drpItem");
        string ItemID = drpItem.SelectedValue;
        string strReceiptID = Request.QueryString["id"];

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "";

        strQuery = "sp_insertEditReceiptDetail";
        SqlCommand command = new SqlCommand(strQuery, con);
        command.CommandType = CommandType.StoredProcedure;
        SqlParameter parameter = command.Parameters.Add("@strReceiptID", SqlDbType.VarChar, 20);
        parameter.Value = strReceiptID;

        parameter = command.Parameters.Add("@ItemID", SqlDbType.VarChar, 20);
        parameter.Value = ItemID;

        con.Open();
        command.ExecuteNonQuery();

        //列表GridView
        GridView4.EditIndex = 0;
        GridView4.DataBind();

        //光标
        GridViewRow editRow = GridView4.Rows[GridView4.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtPrice"));
    }
}
