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

public partial class inventory_currentMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        imgSearch_Click(imgSearch,new ImageClickEventArgs(0,0));
    }

    protected void imgSearch_Click(object sender, ImageClickEventArgs e)
    {
        string strOption = drpFilterOption.SelectedValue;
        string strFilter = ItemIDTextBox.Text + "%";

        if (strOption == "ItemID")
            strFilter = "And [Items].ItemID Like '" + strFilter + "'";
        else if (strOption == "Name")
            strFilter = "And [Items].Name Like '%" + strFilter + "'";
        else
            strFilter = "And [Items].Specification Like '%" + strFilter + "'";

        SqlDataSource2.SelectCommand += strFilter;
        SqlDataSource2.SelectParameters["WareHouseID"].DefaultValue = DropDownList1.SelectedValue;
    }

    protected void chkToggle_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkToggle = (CheckBox)sender;
        GridView2.AllowPaging = !GridView2.AllowPaging;
    }

    decimal priceTotal = 0;

    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // add the UnitPrice to the running total variables
            for (int i = 5; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Amount"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            // for the Footer, display the running totals
            e.Row.Cells[7].Text = priceTotal.ToString("c");
            for (int i = 5; i < 8; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }
}
