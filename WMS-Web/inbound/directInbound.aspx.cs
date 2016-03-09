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

public partial class inbound_directInbound : System.Web.UI.Page
{
    public enum SearchType
    {
        NotSet = -1,
        Browser = 1,
        Insert = 0
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        Message.Text = "";
        if (Session["ReceiptTable"] == null)
        {
            DataTable myTable = new DataTable();
            myTable.Columns.Add(new DataColumn("ReceiptItemsID", typeof(string)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsName", typeof(string)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsSpecification", typeof(string)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsUnit", typeof(string)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsStandardPrice", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsExpectedQuantity", typeof(int)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsPrice", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("ReceiptItemsQuantity", typeof(int)));
            Session["ReceiptTable"] = myTable;
        }
        if (!IsPostBack)
        {
            radioInsert.Checked = true;

            DropDownList DropChecker = ((DropDownList)FormView1.FindControl("DropChecker"));
            MembershipUserCollection users = Membership.GetAllUsers();
            DropChecker.DataSource = users;
            DropChecker.DataBind();

            SqlDataSource SqlDataSource2 = FormView1.FindControl("SqlDataSource2") as SqlDataSource;
            SqlDataSource2.SelectParameters["UserName"].DefaultValue = this.User.Identity.Name;

            TextBox ReceiptDateTextBox = FormView1.FindControl("ReceiptDateTextBox") as TextBox;
            OboutInc.Calendar.Calendar CalendarReceiptDate = FormView1.FindControl("CalendarReceiptDate") as OboutInc.Calendar.Calendar;
            CalendarReceiptDate.TextBoxId = ReceiptDateTextBox.ClientID;
        }
    }

    protected void Page_Unload(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["ReceiptTable"] != null)
        {
            Session["ReceiptTable"] = null;
        }
    }

    protected void radioButton_CheckedChanged(Object sender, System.EventArgs e)
    {
        if (radioInsert.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Insert;
        }
        else if (radioBrowser.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Browser;
        }
    }

    protected void radioButtonDetails_CheckedChanged(Object sender, System.EventArgs e)
    {
        RadioButton radioBtn = (RadioButton)sender;
        RadioButton radioBrowserDetails = radioBtn.Parent.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = radioBtn.Parent.FindControl("radioInsertDetails") as RadioButton;

        TextBox ReceivingCodeTextBox = FormView1.FindControl("ReceivingCodeTextBox") as TextBox;

        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        if (ReceivingCodeTextBox.Text == "")
        {
            String cstext = "alert('请填写料单号！');";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }

        HtmlTableRow trList = radioBtn.Parent.Parent.FindControl("trList") as HtmlTableRow;
        HtmlTableRow TrNew = radioBtn.Parent.Parent.FindControl("TrNew") as HtmlTableRow;

        if (radioBrowserDetails.Checked)
        {
            GridView myGridView = (GridView)trList.FindControl("GridView1");
            GetReceiptItems(myGridView);
            trList.Visible = true;
            TrNew.Visible = false;
        }
        else if (radioInsertDetails.Checked)
        {
            trList.Visible = false;
            GridView myGridView = (GridView)TrNew.FindControl("GridView2");
            GetReceiptPlanItems(myGridView);
            TrNew.Visible = true;
        }
        ((TextBox)TrNew.Parent.FindControl("ReceiptDateTextBox")).Enabled = false;
        ((OboutInc.Calendar.Calendar)TrNew.Parent.FindControl("CalendarReceiptDate")).DatePickerButtonText = "";
        ((DropDownList)TrNew.Parent.FindControl("DropDownList1")).Enabled = false;
        ((DropDownList)TrNew.Parent.FindControl("DropChecker")).Enabled = false;
        ((DropDownList)TrNew.Parent.FindControl("DrpSupplier")).Enabled = false;
        ((TextBox)TrNew.Parent.FindControl("ContractIDTextBox")).Enabled = false;
        ((TextBox)FormView1.FindControl("ReceivingCodeTextBox")).Enabled = false;
        ((TextBox)FormView1.FindControl("FreightTextBox")).Enabled = false;
        ((TextBox)FormView1.FindControl("DescriptionTextBox")).Enabled = false;
        ((LinkButton)FormView1.FindControl("InsertButton")).Enabled = true;
        ((TextBox)FormView1.FindControl("ItemIDTextBox")).Enabled = true;
        ((LinkButton)FormView1.FindControl("LinkButtonSearch")).Enabled = true;
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        TextBox ReceiptDateTextBox = FormView1.FindControl("ReceiptDateTextBox") as TextBox;
        DateTime ReceiptDate;
        try
        {
            ReceiptDate = DateTime.Parse(ReceiptDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            ReceiptDate = DateTime.Now;
        }
        SqlDataSource1.InsertParameters["ArriveDate"].DefaultValue = ReceiptDate.ToShortDateString();


        DropDownList DropChecker = FormView1.FindControl("DropChecker") as DropDownList;
        DropDownList DrpSupplier = FormView1.FindControl("DrpSupplier") as DropDownList;
        DropDownList DropDownList1 = FormView1.FindControl("DropDownList1") as DropDownList;
        TextBox ReceivingCodeTextBox = FormView1.FindControl("ReceivingCodeTextBox") as TextBox;
        TextBox FreightTextBox = FormView1.FindControl("FreightTextBox") as TextBox;
        TextBox DescriptionTextBox = FormView1.FindControl("DescriptionTextBox") as TextBox;

        SqlDataSource1.InsertParameters["ReceiverID"].DefaultValue = this.User.Identity.Name;
        SqlDataSource1.InsertParameters["CheckerID"].DefaultValue = DropChecker.SelectedValue;
        SqlDataSource1.InsertParameters["SupplierID"].DefaultValue = DrpSupplier.SelectedValue;
        SqlDataSource1.InsertParameters["WareHouseID"].DefaultValue = DropDownList1.SelectedValue;
        SqlDataSource1.InsertParameters["Freight"].DefaultValue = FreightTextBox.Text;
        SqlDataSource1.InsertParameters["Description"].DefaultValue = DescriptionTextBox.Text;
        SqlDataSource1.InsertParameters["ReceivingCode"].DefaultValue = ReceivingCodeTextBox.Text;

        //得到已经增加的物资列表
        DataTable myTable = Session["ReceiptTable"] as DataTable;
        string strReceiptItemsID = "";
        string strReceiptItemsPrice = "";
        string strReceiptItemsQuantity = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strReceiptItemsID += myTable.Rows[i][0] + ",";
            strReceiptItemsPrice += myTable.Rows[i][6] + ",";
            strReceiptItemsQuantity += myTable.Rows[i][7] + ",";
        }
        if (strReceiptItemsID != "")
        {
            //去掉最后一个“,”
            strReceiptItemsID = strReceiptItemsID.Substring(0, strReceiptItemsID.Length - 1);
            strReceiptItemsPrice = strReceiptItemsPrice.Substring(0, strReceiptItemsPrice.Length - 1);
            strReceiptItemsQuantity = strReceiptItemsQuantity.Substring(0, strReceiptItemsQuantity.Length - 1);
        }

        SqlDataSource1.InsertParameters["ItemsIDList"].DefaultValue = strReceiptItemsID;
        SqlDataSource1.InsertParameters["PriceList"].DefaultValue = strReceiptItemsPrice;
        SqlDataSource1.InsertParameters["QuantityList"].DefaultValue = strReceiptItemsQuantity;
    }

    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception == null)
        {
            if (Session["ReceiptTable"] != null)
            {
                Session["ReceiptTable"] = null;
            }

            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScriptSuccess";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('成功添加记录。');window.location.href=window.location.href";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
        }
        else
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScript";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('在往数据库增加记录时出错，请重新编辑保存。');window.location.href=window.location.href";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }

            Message.Text = "在往数据库增加记录时出错。";
            //e.ExceptionHandled = true;
        }


    }

    protected void InsertCancelButton_Click(object sender, EventArgs e)
    {
        if (Session["ReceiptTable"] != null)
        {
            Session["ReceiptTable"] = null;
        }
        Response.Redirect("directInbound.aspx");
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetReceiptItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetReceiptItems(myGridView);
        myGridView.EditIndex = e.NewEditIndex;
        myGridView.DataBind();

        //光标，后面想想怎么默认全部选中
        GridViewRow editRow = myGridView.Rows[e.NewEditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtReceiptItemsPrice"));
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable myTable = Session["ReceiptTable"] as DataTable;
        GridView myGridView = (GridView)sender;
        GridViewRow delRow = myGridView.Rows[e.RowIndex];

        //由于可能在后面加入sorting的功能，所以不能简单地用GridView的e.RowIndex代表Session中DispatchTable的index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i][0].ToString();
            if (strTemp == ((Label)delRow.Cells[1].FindControl("lblReceiptItemsID")).Text)
            {
                myTable.Rows[i].Delete();
                break;
            }
        }

        Session["ReceiptTable"] = myTable;
        GetReceiptItems(myGridView);
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetReceiptItems(myGridView);
        myGridView.EditIndex = -1;
        myGridView.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GridViewRow updateRow = myGridView.Rows[e.RowIndex];
        DataTable myTable = Session["ReceiptTable"] as DataTable;

        //由于可能在后面加入sorting的功能，所以不能简单地用GridView的e.RowIndex代表Session中ReceiptTable的index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i]["ReceiptItemsID"].ToString();
            if (strTemp == ((Label)updateRow.Cells[1].FindControl("lblReceiptItemsID")).Text)
            {
                TextBox txtReceiptItemsPrice = (TextBox)updateRow.FindControl("txtReceiptItemsPrice");
                myTable.Rows[i]["ReceiptItemsPrice"] = txtReceiptItemsPrice.Text;
                TextBox txtReceiptItemsQuantity = (TextBox)updateRow.FindControl("txtReceiptItemsQuantity");
                myTable.Rows[i]["ReceiptItemsQuantity"] = txtReceiptItemsQuantity.Text;
                break;
            }
        }

        Session["ReceiptTable"] = myTable;

        GetReceiptItems(myGridView);
        myGridView.EditIndex = -1;
        myGridView.DataBind();

        Page.SetFocus((TextBox)FormView1.FindControl("ItemIDTextBox"));
    }

    decimal priceTotal = 0;
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // add the UnitPrice to the running total variables
            for (int i = 5; i < 9; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "ReceiptItemsPrice")) * Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "ReceiptItemsQuantity"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[7].Text = "金额总计:";
            // for the Footer, display the running totals
            e.Row.Cells[8].Text = priceTotal.ToString("c");

            e.Row.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetReceiptPlanItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }

    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView myGridView = (GridView)sender;
        AddReceipt(myGridView.SelectedRow);
        myGridView.SelectedIndex = -1;

        RadioButton radioBrowserDetails = myGridView.Parent.Parent.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = myGridView.Parent.Parent.FindControl("radioInsertDetails") as RadioButton;
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());

        //列表GridView
        GridView myGridView1 = myGridView.Parent.Parent.FindControl("GridView1") as GridView;
        myGridView1.EditIndex = 0;
        myGridView1.DataBind();

        //光标
        GridViewRow editRow = myGridView1.Rows[myGridView1.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtReceiptItemsPrice"));
    }

    private void GetReceiptItems(GridView myGridView)
    {
        DataTable myTable = Session["ReceiptTable"] as DataTable;
        myGridView.DataSource = myTable;
        myGridView.DataBind();
    }

    protected void GetReceiptPlanItems(GridView myGridView)
    {
        DataSet ds = GetReceiptPlanItemsToDataSet();
        myGridView.DataSource = ds.Tables[0];
        if (ds.Tables[0].Rows.Count < 100)
            myGridView.AllowPaging = false;
        else
            myGridView.AllowPaging = true;
        myGridView.DataBind();
    }

    private DataSet GetReceiptPlanItemsToDataSet()
    {
        DropDownList drpFilterOption = FormView1.FindControl("drpFilterOption") as DropDownList;
        string strOption = drpFilterOption.SelectedValue;

        TextBox ItemIDTextBox = FormView1.FindControl("ItemIDTextBox") as TextBox;
        string strFilter = ItemIDTextBox.Text + "%";

        if (strOption == "ItemID")
            strFilter = "[Items].ItemID Like '" + strFilter + "'";
        else if (strOption == "Name")
            strFilter = "[Items].Name Like '%" + strFilter + "'";
        else
            strFilter = "[Items].Specification Like '%" + strFilter + "'";

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "";
        //得到已经增加的物资列表，不再出现
        DataTable myTable = Session["ReceiptTable"] as DataTable;
        string strReceiptItemsID = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strReceiptItemsID += "'" + myTable.Rows[i][0] + "',";
        }
        if (strReceiptItemsID != "")
        {
            //去掉最后一个“,”
            strReceiptItemsID = strReceiptItemsID.Substring(0, strReceiptItemsID.Length - 1);
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, 0 AS Quantity" +
               " FROM [Items] Where " + strFilter + " AND (ItemID Not In (" + strReceiptItemsID + "))";
        }
        else
        {
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, 0 AS Quantity" +
               " FROM [Items] Where " + strFilter;
        }

        SqlDataAdapter adapter = new SqlDataAdapter(strQuery, con);
        DataSet ds = new DataSet();
        adapter.Fill(ds);

        return ds;
    }

    private void AddReceipt(GridViewRow addItemsRow)
    {
        DataTable myTable = Session["ReceiptTable"] as DataTable;
        DataRow dr = myTable.NewRow();

        //DataRowView rowView = (DataRowView)addItemsRow.DataItem;
        //nnd，第一列是“接收”链接。从第2列起算
        dr[0] = addItemsRow.Cells[1].Text;
        dr[1] = addItemsRow.Cells[2].Text;
        dr[2] = addItemsRow.Cells[3].Text;
        dr[3] = addItemsRow.Cells[4].Text;
        dr[4] = Convert.ToDecimal(addItemsRow.Cells[5].Text);
        dr[5] = Convert.ToDecimal(addItemsRow.Cells[6].Text);
        dr[6] = dr[4];
        dr[7] = dr[5];

        myTable.Rows.InsertAt(dr, 0);
        Session["ReceiptTable"] = myTable;
    }


    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        radioBrowserDetails.Checked = false;
        radioInsertDetails.Checked = true;
        radioButtonDetails_CheckedChanged(radioInsertDetails, new EventArgs());
    }


    protected void btnAuto_Click(object sender, EventArgs e)
    {
        TextBox ReceivingCodeTextBox = FormView1.FindControl("ReceivingCodeTextBox") as TextBox;
        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;

        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        if (ReceivingCodeTextBox.Text == "")
        {
            String cstext = "alert('请填写料单号！');";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }

        TextBox ReceiptDateTextBox = FormView1.FindControl("ReceiptDateTextBox") as TextBox;
        DateTime ReceiptDate;
        try
        {
            ReceiptDate = DateTime.Parse(ReceiptDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            ReceiptDate = DateTime.Now;
        }

        String strReceiptDate = ReceiptDate.ToShortDateString();

        DataTable myTable = Session["ReceiptTable"] as DataTable;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);

        string strQuery = "SELECT [Items].ItemID,[Items].Name,[Items].Specification,[Items].Unit,[Items].StandardPrice,[ProcurePlanDetail].Quantity,[ProcurePlanDetail].EstimatePrice" +
            " FROM [Items] Join [ProcurePlanDetail] ON ([Items].ItemID = [ProcurePlanDetail].ItemID) WHERE [ProcurePlanDetail].PlanID IN (Select PlanID From ProcurePlanMain Where ('" + strReceiptDate + "' BETWEEN PlanStartDate AND PlanStopDate) AND IsReviewed=1 AND IsFinished=0)";

        SqlCommand command = new SqlCommand(strQuery, con);

        con.Open();
        SqlDataReader reader = command.ExecuteReader();

        try
        {
            while (reader.Read())
            {
                DataRow dr = myTable.NewRow();
                for (int i = 0; i < 7; i++)
                {
                    dr[i] = reader[i];
                }
                dr[7] = reader[5];
                myTable.Rows.InsertAt(dr, 0);
            }
        }
        finally
        {
            reader.Close();
        }

        Session["ReceiptTable"] = myTable;

        GetReceiptItems((GridView)FormView1.FindControl("GridView1"));

        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());
    }
}
