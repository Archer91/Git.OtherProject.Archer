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

public partial class outbound_dispatchConfirm : System.Web.UI.Page
{
    decimal priceTotal = 0;     //本次发料金额总计

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BeginDateTextBox.Text = DateTime.Now.AddDays(-DateTime.Now.Day + 1).ToShortDateString();
            EndDateTextBox.Text = DateTime.Now.ToShortDateString();
            Calendar2.TextBoxId = BeginDateTextBox.ClientID;
            Calendar3.TextBoxId = EndDateTextBox.ClientID;

            SqlDataSource4.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
            SqlDataSource4.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;
            SqlDataSource4.SelectParameters["ReceiverName"].DefaultValue = this.User.Identity.Name;

            SqlDataSource4.FilterExpression = "";
        }
    }

    protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 1; i < 7; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            DataRowView rowView = (DataRowView)e.Row.DataItem;
            bool state = Convert.ToBoolean(rowView["IsAccepted"]);
            ((LinkButton)e.Row.FindControl("btnUpdate")).Visible = !state;
        }
    }

    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 0; i < 2; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 7; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity")) * Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "StandardPrice"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[5].Text = "金额总计:";
            // for the Footer, display the running totals
            e.Row.Cells[6].Text = priceTotal.ToString("c");

            for (int i = 2; i < 7; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        SqlDataSource4.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
        SqlDataSource4.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;

        if (DropDownList1.SelectedValue != "0")
        {
            SqlDataSource4.FilterParameters["WareHouseName"].DefaultValue = DropDownList1.SelectedItem.Text.Replace("|- ","");
            SqlDataSource4.FilterExpression = "WareHouseName='{0}'";
        }
        else
            SqlDataSource4.FilterExpression = "";
    }

}
