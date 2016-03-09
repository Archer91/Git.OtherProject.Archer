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

public partial class report_turnOverMain : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BeginDateTextBox.Text = DateTime.Now.AddYears(-1).ToShortDateString();
            EndDateTextBox.Text = DateTime.Now.ToShortDateString();
            Calendar1.TextBoxId = BeginDateTextBox.ClientID;
            Calendar2.TextBoxId = EndDateTextBox.ClientID;

            SqlDataSource4.SelectParameters["EndDate"].DefaultValue = DateTime.Now.ToShortDateString();
            SqlDataSource4.SelectParameters["BeginDate"].DefaultValue = DateTime.Now.AddYears(-1).ToShortDateString();
        }
    }

    protected void imgSearch_Click(object sender, ImageClickEventArgs e)
    {
        SqlDataSource4.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
        SqlDataSource4.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;
        SqlDataSource4.FilterParameters["ItemID"].DefaultValue = ItemIDTextBox.Text + "%";
    }
}
