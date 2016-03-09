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

    decimal priceTotal = 0;     //���η��Ͻ���ܼ�

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
    /// ɾ��Session�е�CheckTable����������һ��СƱ�г���
    /// ע���ж�IsPostBack������ÿ��PostBack��ɾ��
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
        //һ���������������ť�����ֿ⡱�����б������������Է�ֹ�û�����ĳһ�ֿ������
        //һЩ��¼��Ȼ�󻻳������ֿ������ӣ����´������ݲ�����ͬ��������������Ҳ������
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

    ///ToDo:Ӧ�������ʵ�ʱ����Calendar��ʧ�Ĵ��룬�����û��ֶ��ı�TextBox���ݵ�ʱ��
    ///�����������OnTextChanged�¼��������á�
    ///���⣬��Calendar�ؼ���̬��SelectedDate��ʾ��ʱ���·�ҳ�治�ԡ�

    ///��ȡ�ֿ�ID���Ա��ѯ�òֿ���Է��ŵ�����  
    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        //��ȡĬ��ѡ�еĲֿ�ID
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;
    }

    /// <summary>
    /// ��Items��Inventory���в���ض��ֿ��е����м�¼��
    /// Ȼ���GridView2��
    /// ToDo:�������������ѯ����С��Χ��
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
        //�õ��Ѿ����ӵ������б����ٳ���
        DataTable myTable = Session["CheckTable"] as DataTable;
        string strCheckItemsID = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strCheckItemsID += "'" + myTable.Rows[i][0] + "',";
        }
        if (strCheckItemsID != "")
        {
            //ȥ�����һ����,��
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
    /// ���ڿ����Ϊ0�����ϸ��辯�棺��ɫΪ��ɫ��
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
    /// ѡ�����ʼ�¼����Ӹü�¼����ʱ������������Ϊ0���л������ҳ�棬Ĭ�ϱ༭ģʽ
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

        //�б�GridView
        GridView myGridView1 = myGridView.Parent.Parent.FindControl("GridView1") as GridView;
        myGridView1.EditIndex = 0;
        myGridView1.DataBind();

        //���
        GridViewRow editRow = myGridView1.Rows[myGridView1.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtCheckQuantity"));
    }

    /// <summary>
    /// �û���û�б���СƱ֮ǰ����ϸ������Ϣ��ʱ��д�����ݿ⣬
    /// �ȴ���һDataTable�С�
    /// �ȱ༭��ɱ����ʱ��
    /// �ô洢����������ӱ��¼�Ĳ��룬�Ա�֤���������Ժ�һ����
    /// </summary>
    /// <param name="ItemsID"></param>
    private void AddCheck(GridViewRow addItemsRow)
    {
        DataTable myTable = Session["CheckTable"] as DataTable;
        DataRow dr = myTable.NewRow();

        //DataRowView rowView = (DataRowView)addItemsRow.DataItem;
        //nnd����һ���ǡ����ϡ����ӡ��ӵ�2������
        dr[0] = addItemsRow.Cells[1].Text;
        dr[1] = addItemsRow.Cells[2].Text;
        dr[2] = addItemsRow.Cells[3].Text;
        dr[3] = addItemsRow.Cells[4].Text;
        dr[4] = Convert.ToDecimal(addItemsRow.Cells[5].Text);
        dr[5] = Convert.ToDecimal(addItemsRow.Cells[6].Text);
        /*string strScript = "";
        strScript = "<script>";
        strScript = strScript + "prompt('������ʵ��������','0');";
        strScript = strScript + "</script>";
        Response.Write(strScript);*/
        //dr[6] = 0;
        dr[7] = 0;
        //ʣ������ʱ���ڳ�ʼ���
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
    /// VS2005 �޷��Զ�Paging�����Ա�����ʵ�֡�
    /// ͬ��μ�protected void GetWarehouseItems(GridView myGridView)
    /// ע���ڷ�ҳ֮ǰ��������ָ��DataSource������հס�
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

        //��꣬����������ôĬ��ȫ��ѡ��
        GridViewRow editRow = myGridView.Rows[e.NewEditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtCheckQuantity"));
    }


    /// <summary>
    /// ��ע���������ڻ�ȡ��ɾ��GridViewRowĳһCell���ı��ķ�����
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable myTable = Session["CheckTable"] as DataTable;
        GridView myGridView = (GridView)sender;
        GridViewRow delRow = myGridView.Rows[e.RowIndex];

        //���ڿ����ں������sorting�Ĺ��ܣ����Բ��ܼ򵥵���GridView��e.RowIndex����Session��CheckTable��index
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

        //���ڿ����ں������sorting�Ĺ��ܣ����Բ��ܼ򵥵���GridView��e.RowIndex����Session��CheckTable��index
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
    /// ���ø�ʽ������Ҫ���ǽ��ϼƲ���֤�Ƿ񳬳�����
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
            e.Row.Cells[8].Text = "����ܼ�:";
            // for the Footer, display the running totals
            e.Row.Cells[9].Text = priceTotal.ToString("c");

            e.Row.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            hidPriceAtlast.Value = priceTotal.ToString();
            priceTotal = 0;
        }

    }

    private bool isAccepted = false;

    //��ʵ�ϣ� Ӧ���� int DeliveryID������ʡ������ת��
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
    /// ��ѯ����Ķ��������ʷ��ϸ���ϼ�
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
            e.Row.Cells[7].Text = "����ܼ�:";
            // for the Footer, display the running totals
            e.Row.Cells[8].Text = priceTotal.ToString("c");

            for (int i = 2; i < 9; i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }

    }

    /// <summary>
    /// ȡ��֮ǰ�����Session��CheckTable��
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
    /// ���淢�ϼ�¼
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

        //�õ��Ѿ����ӵ������б�
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
            //ȥ�����һ����,��
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
            Message.Text = "�ɹ���Ӽ�¼��";
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
                String cstext = "alert('�������ݿ����Ӽ�¼ʱ���������±༭���档');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }

            Message.Text = "�������ݿ����Ӽ�¼ʱ����";
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

        //�б�GridView
        GridView4.EditIndex = 0;
        GridView4.DataBind();

        //���
        GridViewRow editRow = GridView4.Rows[GridView4.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtQuantity"));

    }
    protected void GridView3_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        GridView4.DataBind();
    }

    /// <summary>
    /// ���ݵ��ճ�����ά�޶����ʾ�ڷ�����ϸ����
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
                //�տ�ʼ��ԭ��
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

