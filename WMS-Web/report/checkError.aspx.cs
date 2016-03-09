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

public partial class report_checkError : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BeginDateTextBox.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            EndDateTextBox.Text = DateTime.Now.ToShortDateString();
            Calendar1.TextBoxId = BeginDateTextBox.ClientID;
            Calendar2.TextBoxId = EndDateTextBox.ClientID;

            SqlDataSource2.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
            SqlDataSource2.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;
        }
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        SqlDataSource2.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
        SqlDataSource2.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;

        string strWareHouse = "";
        if (DropDownList1.SelectedItem.Text != "所有仓库")
        {
            strWareHouse = DropDownList1.SelectedItem.Text;
            strWareHouse = strWareHouse.Replace("|- ", "");
            SqlDataSource2.FilterParameters["WareHouseName"].DefaultValue = "'" + strWareHouse + "'";
        }
        else
        {
            for (int i = 0; i < DropDownList1.Items.Count; i++)
                strWareHouse += "'" + DropDownList1.Items[i].Text.Replace("|- ", "") + "',";

            if (strWareHouse != "")
            {
                //去掉最后一个“,”
                strWareHouse = strWareHouse.Substring(0, strWareHouse.Length - 1);
            }

            SqlDataSource2.FilterParameters["WareHouseName"].DefaultValue = strWareHouse;
        }
    }

    private decimal countTotal = 0;
    private decimal errorTotal = 0;

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            countTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "TotalQuantity"));
            errorTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "ErrorQuantity"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            for (int i = 3; i < 6; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            e.Row.Cells[3].Text = "总计:";
            // for the Footer, display the running totals
            e.Row.Cells[4].Text = String.Format("{0:F2}",countTotal);
            e.Row.Cells[5].Text = String.Format("{0:F2}",errorTotal);
            e.Row.Cells[6].Text = String.Format("{0:F2}%",(errorTotal / countTotal)*100);
            e.Row.Font.Bold = true;

            countTotal = 0;
            errorTotal = 0;
        }

    }

    private decimal priceTotal = 0;
    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 0; i < 2; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 10; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += (Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "RealQuantity")) - Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "InventoryQuantity"))) * Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "StandardPrice"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[7].Text = "金额总计:";
            // for the Footer, display the running totals
            e.Row.Cells[8].Text = priceTotal.ToString("c");

            for (int i = 2; i < 9; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }

    protected void chkToggle_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkToggle = (CheckBox)sender;
        GridView1.AllowPaging = !GridView1.AllowPaging;
    }
}
