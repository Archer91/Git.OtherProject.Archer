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

public partial class inventory_check : System.Web.UI.Page
{
    public enum SearchType
    {
        NotSet = -1,
        Browser = 0,
        Insert = 1
    }

    decimal priceTotal = 0;     //本次发料金额总计

    protected void Page_Load(object sender, EventArgs e)
    {
        Message.Text = "";
        if (Session["CheckTable"] == null)
        {
            DataTable myTable = new DataTable();
            myTable.Columns.Add(new DataColumn("CheckItemsID", typeof(string)));
            myTable.Columns.Add(new DataColumn("CheckItemsName", typeof(string)));
            myTable.Columns.Add(new DataColumn("CheckItemsSpecification", typeof(string)));
            myTable.Columns.Add(new DataColumn("CheckItemsUnit", typeof(string)));
            myTable.Columns.Add(new DataColumn("CheckItemsStandardPrice", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("CheckItemsInventory", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("CheckQuantity", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("CheckItemsExtra", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("CheckItemsExtraMoney", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("CheckItemsReason", typeof(int)));
            Session["CheckTable"] = myTable;
        }
        if (!IsPostBack)
        {
            radioBrowser.Checked = true;

            SqlDataSource SqlDataSource2 = FormView1.FindControl("SqlDataSource2") as SqlDataSource;
            SqlDataSource2.SelectParameters["UserName"].DefaultValue = this.User.Identity.Name;

            TextBox DeliveryDateTextBox = FormView1.FindControl("CheckDateTextBox") as TextBox;
            OboutInc.Calendar.Calendar Calendar1 = FormView1.FindControl("Calendar1") as OboutInc.Calendar.Calendar;
            Calendar1.TextBoxId = DeliveryDateTextBox.ClientID;
        }
    }

    /// <summary>
    /// 删除Session中的CheckTable，避免在下一张小票中出现
    /// 注意判断IsPostBack，否则每次PostBack都删除
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Unload(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["CheckTable"] != null)
        {
            Session["CheckTable"] = null;
        }
    }

    protected void radioButton_CheckedChanged(Object sender, System.EventArgs e)
    {
        if (radioBrowser.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Browser;
        }
        else if (radioInsert.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Insert;
            GridView3.DataBind();
        }
    }

    protected void radioButtonDetails_CheckedChanged(Object sender, System.EventArgs e)
    {
        RadioButton radioBtn = (RadioButton)sender;
        RadioButton radioBrowserDetails = radioBtn.Parent.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = radioBtn.Parent.FindControl("radioInsertDetails") as RadioButton;

        HtmlTableRow trList = radioBtn.Parent.Parent.FindControl("trList") as HtmlTableRow;
        HtmlTableRow TrNew = radioBtn.Parent.Parent.FindControl("TrNew") as HtmlTableRow;

        if (radioBrowserDetails.Checked)
        {
            GridView myGridView = (GridView)trList.FindControl("GridView1");
            GetCheckItems(myGridView);
            trList.Visible = true;
            TrNew.Visible = false;
        }
        else if (radioInsertDetails.Checked)
        {
            trList.Visible = false;
            GridView myGridView = (GridView)TrNew.FindControl("GridView2");
            GetWarehouseItems(myGridView);
            TrNew.Visible = true;
        }
        //一旦点击“新增”按钮，“仓库”下拉列表马上锁定，以防止用户先用某一仓库添加了
        //一些记录，然后换成其他仓库继续添加，导致错误数据产生。同理，其他公共数据也锁定。
        ((TextBox)TrNew.Parent.FindControl("CheckDateTextBox")).Enabled = false;
        ((OboutInc.Calendar.Calendar)TrNew.Parent.FindControl("Calendar1")).DatePickerButtonText = "";
        //((TextBox)TrNew.Parent.FindControl("CheckIDTextBox")).Enabled = false;
        ((DropDownList)TrNew.Parent.FindControl("DropDownList1")).Enabled = false;
        ((Button)TrNew.Parent.FindControl("btnAuto")).Enabled = false;
        ((LinkButton)FormView1.FindControl("InsertButton")).Enabled = true;
        ((TextBox)FormView1.FindControl("ItemIDTextBox")).Enabled = true;
        ((LinkButton)FormView1.FindControl("LinkButtonSearch")).Enabled = true;
    }

    protected void imgCalendar_Click(object sender, ImageClickEventArgs e)
    {
        Calendar myCalendar = ((ImageButton)sender).Parent.FindControl("Calendar1") as Calendar;
        TextBox txtDate = myCalendar.Parent.FindControl("CheckDateTextBox") as TextBox;
        if (myCalendar != null)
        {
            try
            {
                myCalendar.SelectedDate = DateTime.Parse(txtDate.Text);
            }
            catch (System.FormatException eFormat)
            {

            }
            myCalendar.Visible = !myCalendar.Visible;
        }
    }
    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {
        Calendar myCalendar = (Calendar)sender;
        if (myCalendar != null)
        {
            myCalendar.Visible = !myCalendar.Visible;
            TextBox txtDate = myCalendar.Parent.FindControl("CheckDateTextBox") as TextBox;
            if (txtDate != null)
                txtDate.Text = myCalendar.SelectedDate.ToShortDateString();
        }
    }

    ///ToDo:应该增加适当时候让Calendar消失的代码，例如用户手动改变TextBox内容的时候，
    ///但是试验表明OnTextChanged事件不起作用。
    ///另外，给Calendar控件动态赋SelectedDate显示的时候月份页面不对。

    ///获取仓库ID，以便查询该仓库可以发放的物料  
    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        //获取默认选中的仓库ID
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;
    }

    /// <summary>
    /// 从Items和Inventory表中查出特定仓库中的所有记录，
    /// 然后和GridView2绑定
    /// ToDo:后面加上条件查询以缩小范围。
    /// </summary>
    /// <param name="myGridView"></param>
    protected void GetWarehouseItems(GridView myGridView)
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
        DataTable myTable = Session["CheckTable"] as DataTable;
        string strCheckItemsID = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strCheckItemsID += "'" + myTable.Rows[i][0] + "',";
        }
        if (strCheckItemsID != "")
        {
            //去掉最后一个“,”
            strCheckItemsID = strCheckItemsID.Substring(0, strCheckItemsID.Length - 1);
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [Inventory].Quantity" +
               " FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID ) Where [Inventory].WareHouseID = " +
               Convert.ToInt32(hidWareHouseID.Value) + " And " + strFilter + " And [Items].ItemID Not In (" + strCheckItemsID + ")" +
               " Order by [Items].Name, [Items].Specification";
        }
        else
        {
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [Inventory].Quantity" +
               " FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID ) Where [Inventory].WareHouseID = " +
               Convert.ToInt32(hidWareHouseID.Value) + " And " + strFilter +
               " Order by [Items].Name, [Items].Specification";
        }

        SqlDataAdapter adapter = new SqlDataAdapter(strQuery, con);
        DataSet ds = new DataSet();
        adapter.Fill(ds);

        myGridView.DataSource = ds.Tables[0];
        myGridView.DataBind();
    }

    /// <summary>
    /// 对于库存量为0的物料给予警告：颜色为黄色。
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // determine the value of the UnitsInStock field
            decimal unitsInStock =
             Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem,
             "Quantity"));
            if (unitsInStock == 0)
                e.Row.BackColor = System.Drawing.Color.Yellow;
            if (unitsInStock < 0)
                e.Row.BackColor = System.Drawing.Color.LightPink;
        }
    }

    /// <summary>
    /// 选中物资记录，添加该记录，暂时将发料数量设为0，切换到浏览页面，默认编辑模式
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView2_SelectedIndexChanged(object sender, EventArgs e)
    {
        GridView myGridView = (GridView)sender;
        //AddCheck(myGridView.SelectedValue.ToString());
        AddCheck(myGridView.SelectedRow);

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
        Page.SetFocus((TextBox)editRow.FindControl("txtCheckQuantity"));
    }

    /// <summary>
    /// 用户在没有保存小票之前，详细发料信息暂时不写入数据库，
    /// 先存在一DataTable中。
    /// 等编辑完成保存的时候，
    /// 用存储过程完成主从表记录的插入，以保证数据完整性和一致性
    /// </summary>
    /// <param name="ItemsID"></param>
    private void AddCheck(GridViewRow addItemsRow)
    {
        DataTable myTable = Session["CheckTable"] as DataTable;
        DataRow dr = myTable.NewRow();

        //DataRowView rowView = (DataRowView)addItemsRow.DataItem;
        //nnd，第一列是“发料”链接。从第2列起算
        dr[0] = addItemsRow.Cells[1].Text;
        dr[1] = addItemsRow.Cells[2].Text;
        dr[2] = addItemsRow.Cells[3].Text;
        dr[3] = addItemsRow.Cells[4].Text;
        dr[4] = Convert.ToDecimal(addItemsRow.Cells[5].Text);
        dr[5] = Convert.ToDecimal(addItemsRow.Cells[6].Text);
        /*string strScript = "";
        strScript = "<script>";
        strScript = strScript + "prompt('请输入实发数量：','0');";
        strScript = strScript + "</script>";
        Response.Write(strScript);*/
        //dr[6] = 0;
        dr[7] = 0;
        //剩余库存暂时等于初始库存
        dr[8] = dr[5];
        dr[9] = "0";
        myTable.Rows.InsertAt(dr, 0);
        Session["CheckTable"] = myTable;
    }

    private void GetCheckItems(GridView myGridView)
    {
        DataTable myTable = Session["CheckTable"] as DataTable;
        myGridView.DataSource = myTable;
        myGridView.DataBind();
    }

    /// <summary>
    /// VS2005 无法自动Paging，所以必须编程实现。
    /// 同理参见protected void GetWarehouseItems(GridView myGridView)
    /// 注意在翻页之前必须重新指定DataSource，否则空白。
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetCheckItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetWarehouseItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }


    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetCheckItems(myGridView);
        myGridView.EditIndex = e.NewEditIndex;
        myGridView.DataBind();

        //光标，后面想想怎么默认全部选中
        GridViewRow editRow = myGridView.Rows[e.NewEditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtCheckQuantity"));
    }


    /// <summary>
    /// 请注意这里用于获取待删除GridViewRow某一Cell中文本的方法。
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable myTable = Session["CheckTable"] as DataTable;
        GridView myGridView = (GridView)sender;
        GridViewRow delRow = myGridView.Rows[e.RowIndex];

        //由于可能在后面加入sorting的功能，所以不能简单地用GridView的e.RowIndex代表Session中CheckTable的index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i][0].ToString();
            if (strTemp == ((Label)delRow.Cells[1].FindControl("lblCheckItemsID")).Text)
            {
                myTable.Rows[i].Delete();
                break;
            }
        }

        Session["CheckTable"] = myTable;
        GetCheckItems(myGridView);
    }


    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetCheckItems(myGridView);
        myGridView.EditIndex = -1;
        myGridView.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GridViewRow updateRow = myGridView.Rows[e.RowIndex];
        DataTable myTable = Session["CheckTable"] as DataTable;

        //由于可能在后面加入sorting的功能，所以不能简单地用GridView的e.RowIndex代表Session中CheckTable的index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i]["CheckItemsID"].ToString();
            if (strTemp == ((Label)updateRow.Cells[1].FindControl("lblCheckItemsID")).Text)
            {
                TextBox txtCheckQuantity = (TextBox)updateRow.FindControl("txtCheckQuantity");
                myTable.Rows[i]["CheckQuantity"] = Convert.ToDecimal(txtCheckQuantity.Text);
                myTable.Rows[i]["CheckItemsExtra"] = Convert.ToDecimal(myTable.Rows[i]["CheckQuantity"]) - Convert.ToDecimal(myTable.Rows[i]["CheckItemsInventory"]);
                myTable.Rows[i]["CheckItemsExtraMoney"] = Convert.ToDecimal(myTable.Rows[i]["CheckItemsExtra"]) * Convert.ToDecimal(myTable.Rows[i]["CheckItemsStandardPrice"]);
                DropDownList drpCheckItemsReason = (DropDownList)updateRow.FindControl("drpCheckItemsReason");
                myTable.Rows[i]["CheckItemsReason"] = Convert.ToInt32(drpCheckItemsReason.SelectedValue);
                break;
            }
        }

        Session["CheckTable"] = myTable;

        GetCheckItems(myGridView);
        myGridView.EditIndex = -1;
        myGridView.DataBind();
        Page.SetFocus((TextBox)FormView1.FindControl("ItemIDTextBox"));
    }

    /// <summary>
    /// 设置格式，更主要的是金额合计并验证是否超出定额
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // add the UnitPrice to the running total variables
            for (int i = 5; i < 12; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "CheckItemsExtraMoney"));            
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[8].Text = "金额总计:";
            // for the Footer, display the running totals
            e.Row.Cells[9].Text = priceTotal.ToString("c");

            e.Row.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            hidPriceAtlast.Value = priceTotal.ToString();
            priceTotal = 0;
        }

    }

    private bool isAccepted = false;

    //事实上， 应该是 int DeliveryID，但是省得类型转换
    private bool getIsAccepted(string DeliveryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select IsReviewed From InventoryCheckMain Where InventoryCheckID=" + DeliveryID;

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
        if (GridView3.SelectedValue != null)
        {
            string strDeliveryID = GridView3.SelectedValue.ToString();
            isAccepted = Convert.ToBoolean(getIsAccepted(strDeliveryID));
            ((CommandField)GridView4.Columns[10]).ShowEditButton = !isAccepted;
            GridView4.Columns[11].Visible = !isAccepted;
            if (!isAccepted)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
                string strQuery = "";

                strQuery = "SELECT ItemID FROM [Inventory] Where [Inventory].IsDeleted=0" +
                   " And [Inventory].WareHouseID in (Select WareHouseID From InventoryCheckMain Where InventoryCheckID=" + strDeliveryID
                    + ") And [Inventory].ItemID Not In (Select ItemID From InventoryCheckDetail Where InventoryCheckID=" + strDeliveryID + ")";

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

    /// <summary>
    /// 查询里面的对外调拨历史明细金额合计
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView4_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            for (int i = 0; i < 2; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Left;
            for (int i = 2; i < 9; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            e.Row.Cells[9].HorizontalAlign = HorizontalAlign.Left;

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

    /// <summary>
    /// 取消之前先清空Session的CheckTable表
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void InsertCancelButton_Click(object sender, EventArgs e)
    {
        if (Session["CheckTable"] != null)
        {
            Session["CheckTable"] = null;
        }
        Response.Redirect("check.aspx");
    }

    /// <summary>
    /// 保存发料记录
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        TextBox CheckDateTextBox = FormView1.FindControl("CheckDateTextBox") as TextBox;
        DateTime CheckDate;
        try
        {
            CheckDate = DateTime.Parse(CheckDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            CheckDate = DateTime.Now;
        }
        SqlDataSource1.InsertParameters["CheckDate"].DefaultValue = CheckDate.ToShortDateString();

        DropDownList drpWareHouseID = FormView1.FindControl("DropDownList1") as DropDownList;
        TextBox DescriptionTextBox = FormView1.FindControl("DescriptionTextBox") as TextBox;

        SqlDataSource1.InsertParameters["WareHouseID"].DefaultValue = drpWareHouseID.SelectedValue;
        SqlDataSource1.InsertParameters["UserName"].DefaultValue = this.User.Identity.Name;
        SqlDataSource1.InsertParameters["Description"].DefaultValue = DescriptionTextBox.Text;

        //得到已经增加的物资列表
        DataTable myTable = Session["CheckTable"] as DataTable;
        string strCheckItemsID = "";
        string strCheckItemsInventory = "";
        string strCheckItemsQuantity = "";
        string strCheckItemsReason = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strCheckItemsID += myTable.Rows[i][0] + ",";
            strCheckItemsInventory += myTable.Rows[i][5] + ",";
            strCheckItemsQuantity += myTable.Rows[i][6] + ",";
            strCheckItemsReason += myTable.Rows[i][9] + ",";
        }
        if (strCheckItemsID != "")
        {
            //去掉最后一个“,”
            strCheckItemsID = strCheckItemsID.Substring(0, strCheckItemsID.Length - 1);
            strCheckItemsInventory = strCheckItemsInventory.Substring(0, strCheckItemsInventory.Length - 1);
            strCheckItemsQuantity = strCheckItemsQuantity.Substring(0, strCheckItemsQuantity.Length - 1);
            strCheckItemsReason = strCheckItemsReason.Substring(0, strCheckItemsReason.Length - 1);     
        }

        SqlDataSource1.InsertParameters["ItemsIDList"].DefaultValue = strCheckItemsID;
        SqlDataSource1.InsertParameters["InventoryList"].DefaultValue = strCheckItemsInventory;
        SqlDataSource1.InsertParameters["QuantityList"].DefaultValue = strCheckItemsQuantity;
        SqlDataSource1.InsertParameters["ReasonList"].DefaultValue = strCheckItemsReason;
    }

    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception == null)
        {
            Message.Text = "成功添加记录。";
            if (Session["CheckTable"] != null)
            {
                Session["CheckTable"] = null;
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
                String cstext = "alert('在往数据库增加记录时出错，请重新编辑保存。');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }

            Message.Text = "在往数据库增加记录时出错。";
            //e.ExceptionHandled = true;
        }

    }

    protected void GridView3_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        SqlDataSource4.UpdateParameters["ReviewerName"].DefaultValue = this.User.Identity.Name;
    }

    protected void GridView3_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView rowView = (DataRowView)e.Row.DataItem;
            bool state = Convert.ToBoolean(rowView["IsReviewed"]);
            ((LinkButton)e.Row.FindControl("btnReview")).Visible = !state;
            ((LinkButton)e.Row.FindControl("btnDelete")).Visible = !state;
        }

    }

    protected void GridView3_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        GridView3.SelectedIndex = -1;
    }

    protected void LinkButtonEditAdd_Click(object sender, EventArgs e)
    {
        DropDownList drpItem = (DropDownList)GridView4.FooterRow.FindControl("drpItem");
        string ItemID = drpItem.SelectedValue;
        string strDeliveryID = GridView3.SelectedValue.ToString();

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "";

        strQuery = "sp_insertEditCheckDetail";
        SqlCommand command = new SqlCommand(strQuery, con);
        command.CommandType = CommandType.StoredProcedure;
        SqlParameter parameter = command.Parameters.Add("@InventoryCheckID", SqlDbType.Int);
        parameter.Value = strDeliveryID;

        parameter = command.Parameters.Add("@ItemID", SqlDbType.VarChar, 20);
        parameter.Value = ItemID;

        con.Open();
        command.ExecuteNonQuery();

        //列表GridView
        GridView4.EditIndex = 0;
        GridView4.DataBind();

        //光标
        GridViewRow editRow = GridView4.Rows[GridView4.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtQuantity"));

    }
    protected void GridView3_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        GridView4.DataBind();
    }

    /// <summary>
    /// 根据当日车辆和维修定额，显示在发料明细表中
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAuto_Click(object sender, EventArgs e)
    {
        DropDownList DropDownList1 = FormView1.FindControl("DropDownList1") as DropDownList;
        int WareHouseID = Convert.ToInt32(DropDownList1.SelectedValue);

        TextBox CheckDateTextBox = FormView1.FindControl("CheckDateTextBox") as TextBox;
        DateTime CheckDate;
        try
        {
            CheckDate = DateTime.Parse(CheckDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            CheckDate = DateTime.Now;
        }

        DataTable myTable = Session["CheckTable"] as DataTable;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [Inventory].Quantity" +
                " FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID )" +
                " WHERE [Inventory].WareHouseID=" + WareHouseID;
        SqlCommand command = new SqlCommand(strQuery, con);

        con.Open();
        SqlDataReader reader = command.ExecuteReader();

        try
        {
            while (reader.Read())
            {
                DataRow dr = myTable.NewRow();
                for (int i = 0; i < 6; i++)
                {
                    dr[i] = reader[i];
                }
                dr[6] = dr[5];
                dr[7] = Convert.ToDecimal(dr[6]) - Convert.ToDecimal(dr[5]);
                dr[8] = Convert.ToDecimal(dr[4]) * Convert.ToDecimal(dr[7]);
                //刚开始无原因
                dr[9] = "0";
                myTable.Rows.InsertAt(dr,0);
            }
        }
        finally
        {
            reader.Close();
        }

        Session["CheckTable"] = myTable;

        GetCheckItems((GridView)FormView1.FindControl("GridView1"));

        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());
    }

    protected void GridView4_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GridViewRow updateRow = myGridView.Rows[e.RowIndex];

        SqlDataSource5.UpdateParameters["InventoryReasonID"].DefaultValue = ((DropDownList)updateRow.FindControl("drpCheckItemsReason")).SelectedValue;
    }

    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        radioBrowserDetails.Checked = false;
        radioInsertDetails.Checked = true;
        radioButtonDetails_CheckedChanged(radioInsertDetails, new EventArgs());
    }
}

