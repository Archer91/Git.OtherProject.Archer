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

public partial class report_costAnalyst : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BeginDateTextBox.Text = DateTime.Now.AddMonths(-1).ToShortDateString();
            EndDateTextBox.Text = DateTime.Now.ToShortDateString();

            Calendar1.TextBoxId = BeginDateTextBox.ClientID;
            Calendar2.TextBoxId = EndDateTextBox.ClientID;

            SqlDataSource2.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
            SqlDataSource2.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;
            SqlDataSource5.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
            SqlDataSource5.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;
        }
    }

    protected void btnRefresh_Click(object sender, EventArgs e)
    {
        SqlDataSource2.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
        SqlDataSource2.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;

        SqlDataSource5.SelectParameters["EndDate"].DefaultValue = EndDateTextBox.Text;
        SqlDataSource5.SelectParameters["BeginDate"].DefaultValue = BeginDateTextBox.Text;

        string strSupplierName = "";
        if (DropDownList1.SelectedItem.Text != "所有单位")
        {
            strSupplierName = "'" + DropDownList1.SelectedItem.Text + "'";
        }
        else
        {
            for (int i = 0; i < DropDownList1.Items.Count; i++)
                strSupplierName += "'" + DropDownList1.Items[i].Text + "',";

            if (strSupplierName != "")
            {
                //去掉最后一个“,”
                strSupplierName = strSupplierName.Substring(0, strSupplierName.Length - 1);
            }
        }
        SqlDataSource2.FilterParameters["SupplierName"].DefaultValue = strSupplierName;
        SqlDataSource5.FilterParameters["SupplierName"].DefaultValue = strSupplierName;

    }
    protected void chkToggle_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkToggle = (CheckBox)sender;
        GridView1.AllowPaging = !GridView1.AllowPaging;
    }
}
