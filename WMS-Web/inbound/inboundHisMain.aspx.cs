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

public partial class inbound_inboundHisMain : System.Web.UI.Page
{
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

            SqlDataSource4.FilterExpression = "";
        }

        if (DropDownList1.SelectedValue == "0")
            SqlDataSource4.FilterExpression = "";

    }

    protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 1; i < 7; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;

            DataRowView rowView = (DataRowView)e.Row.DataItem;
            bool state = Convert.ToBoolean(rowView["IsReviewed"]);
            ((LinkButton)e.Row.FindControl("btnUpdate")).Visible = !state;
            ((LinkButton)e.Row.FindControl("btnDelete")).Visible = !state;
        }
    }

    protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        SqlDataSource4.UpdateParameters["ReviewerID"].DefaultValue = this.User.Identity.Name;
    }

    protected void GridView3_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        RedirectDetail("window.parent.detail.location.href");
    }

    protected void GridView3_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        RedirectDetail("'inboundHisDetail.aspx'");
    }

    protected void btnModify_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Update ReceiptMain Set IsReviewed=0,ReviewerID='' Where ReceiptID=" + GridView3.DataKeys[((GridViewRow)((LinkButton)sender).Parent.Parent).DataItemIndex].Value;

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        command.ExecuteNonQuery();

        GridView3.DataBind();
        RedirectDetail("window.parent.detail.location.href");
    }

    private void RedirectDetail(string href)
    {

        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "refreshDetail";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.detail.location.href=" + href + ";";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
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
        {
            SqlDataSource4.FilterParameters["WareHouseName"].DefaultValue = "";
            SqlDataSource4.FilterExpression = "WareHouseName LIKE '{0}'+ '%'";
        }
    }
}
