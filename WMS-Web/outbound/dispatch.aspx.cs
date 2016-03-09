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

public partial class outbound_Dispatch : System.Web.UI.Page
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
        if (Session["DeliveryTable"] == null)
        {
            DataTable myTable = new DataTable();
            myTable.Columns.Add(new DataColumn("DeliveryItemsID", typeof(string)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsName", typeof(string)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsSpecification", typeof(string)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsUnit", typeof(string)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsStandardPrice", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsInventory", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("DeliveryQuantity", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsMoney", typeof(decimal)));
            myTable.Columns.Add(new DataColumn("DeliveryItemsLeftInventory", typeof(decimal)));
            Session["DeliveryTable"] = myTable;
        }
        if (!IsPostBack)
        {
            radioBrowser.Checked = true;
            TextBox DeliveryDateTextBox = FormView1.FindControl("DeliveryDateTextBox") as TextBox;
            OboutInc.Calendar.Calendar Calendar1 = FormView1.FindControl("Calendar1") as OboutInc.Calendar.Calendar;
            Calendar1.TextBoxId = DeliveryDateTextBox.ClientID;

            SqlDataSource SqlDataSource2 = FormView1.FindControl("SqlDataSource2") as SqlDataSource;
            SqlDataSource2.SelectParameters["UserName"].DefaultValue = this.User.Identity.Name;
        }

        //Response.Write(this.User.Identity.Name);
        //Response.End();

    }

    /// <summary>
    /// ɾ��Session�е�DeliveryTable����������һ��СƱ�г���
    /// ע���ж�IsPostBack������ÿ��PostBack��ɾ��
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Unload(object sender, EventArgs e)
    {
        if (!IsPostBack && Session["DeliveryTable"] != null)
        {
            Session["DeliveryTable"] = null;
        }
    }

    protected void radioButton_CheckedChanged(Object sender, System.EventArgs e)
    {
        if (radioBrowser.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Browser;
            //InsertCancelButton_Click(radioBrowser,new EventArgs());
        }
        else if (radioInsert.Checked)
        {
            MultiView1.ActiveViewIndex = (int)SearchType.Insert;
        }
    }

    protected void radioButtonDetails_CheckedChanged(Object sender, System.EventArgs e)
    {
        RadioButton radioBtn = (RadioButton)sender;
        RadioButton radioBrowserDetails = radioBtn.Parent.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = radioBtn.Parent.FindControl("radioInsertDetails") as RadioButton;
        DropDownList DropDownList1 = FormView1.FindControl("DropDownList1") as DropDownList;
        DropDownList DrpProjectCategory = FormView1.FindControl("DrpProjectCategory") as DropDownList;
        DropDownList DrpUser = FormView1.FindControl("DrpUser") as DropDownList;

        if (DropDownList1.Items.Count == 0)
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScript";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('û���������µĲֿ⣬��û��Ȩ�޷������ʡ�');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }

        if (DrpUser.Items.Count==0)
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScript";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('û��ѡ�������ˡ�');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }
        if (DrpProjectCategory.Items.Count == 0)
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScript";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('û��������Ŀ��');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }
        int ProjectCategoryID = Convert.ToInt32(DrpProjectCategory.SelectedValue);

        //�Ƿ����ӽڵ㣿
        if (IsNode(ProjectCategoryID))
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScript";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('��ѡ��һ�������������Ŀ��');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            radioInsertDetails.Checked = false;
            radioBrowserDetails.Checked = true;
            return;
        }

        HtmlTableRow trList = radioBtn.Parent.Parent.FindControl("trList") as HtmlTableRow;
        HtmlTableRow TrNew = radioBtn.Parent.Parent.FindControl("TrNew") as HtmlTableRow;

        if (radioBrowserDetails.Checked)
        {
            GridView myGridView = (GridView)trList.FindControl("GridView1");
            GetDeliveryItems(myGridView);
            trList.Visible = true;
            TrNew.Visible = false;
        }
        else if (radioInsertDetails.Checked)
        {
            trList.Visible = false;
            GridView myGridView = (GridView)TrNew.FindControl("GridView2");
            GetWarehouseItems(myGridView);
            TrNew.Visible = true;

            //һ���������������ť�����ֿ⡱�����б������������Է�ֹ�û�����ĳһ�ֿ������
            //һЩ��¼��Ȼ�󻻳������ֿ������ӣ����´������ݲ�����ͬ��������������Ҳ������
            ((TextBox)TrNew.Parent.FindControl("DeliveryDateTextBox")).Enabled = false;
            ((OboutInc.Calendar.Calendar)TrNew.Parent.FindControl("Calendar1")).DatePickerButtonText = "";
            //((TextBox)TrNew.Parent.FindControl("DeliveryIDTextBox")).Enabled = false;
            ((DropDownList)TrNew.Parent.FindControl("DrpProjectCategory")).Enabled = false;
            ((DropDownList)TrNew.Parent.FindControl("DropDownList1")).Enabled = false;
            ((DropDownList)TrNew.Parent.FindControl("DropDownList2")).Enabled = false;
            ((DropDownList)TrNew.Parent.FindControl("DrpUser")).Enabled = false;
            ((LinkButton)FormView1.FindControl("InsertButton")).Enabled = true;
            ((TextBox)FormView1.FindControl("ItemIDTextBox")).Enabled = true;
            ((LinkButton)FormView1.FindControl("LinkButtonSearch")).Enabled = true;
        }
    }

    private bool IsNode(int ProjectCategoryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select ProjectCategoryID FROM ProjectCategories WHERE ParentID =" + ProjectCategoryID;

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        SqlDataReader reader = command.ExecuteReader();
        return reader.HasRows;
    }

    /// <summary>
    /// ȡ��֮ǰ�����Session��DeliveryTable��
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void InsertCancelButton_Click(object sender, EventArgs e)
    {
        if (Session["DeliveryTable"] != null)
        {
            Session["DeliveryTable"] = null;
        }
        //Response.Redirect("Delivery.aspx");
        //���Ա�����ǰ��״̬
        ((TextBox)FormView1.FindControl("DeliveryDateTextBox")).Enabled = true;
        ((OboutInc.Calendar.Calendar)FormView1.FindControl("Calendar1")).DatePickerButtonText = "<img src=\"../images/calendar.gif\"/>";
        ((DropDownList)FormView1.FindControl("DrpProjectCategory")).Enabled = true;
        ((DropDownList)FormView1.FindControl("DropDownList1")).Enabled = true;
        ((DropDownList)FormView1.FindControl("DropDownList2")).Enabled = true;
        ((DropDownList)FormView1.FindControl("DrpUser")).Enabled = true;
        ((LinkButton)FormView1.FindControl("InsertButton")).Enabled = false;
        ((TextBox)FormView1.FindControl("ItemIDTextBox")).Enabled = false;
        ((LinkButton)FormView1.FindControl("LinkButtonSearch")).Enabled = false;

        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;
        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());

        ((GridView)FormView1.FindControl("GridView1")).DataBind();
    }

    protected void FormView1_ItemInserting(object sender, FormViewInsertEventArgs e)
    {
        TextBox DeliveryDateTextBox = FormView1.FindControl("DeliveryDateTextBox") as TextBox;
        DateTime DeliveryDate;
        try
        {
            DeliveryDate = DateTime.Parse(DeliveryDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            DeliveryDate = DateTime.Now;
        }
        SqlDataSource1.InsertParameters["DeliveryDate"].DefaultValue = DeliveryDate.ToShortDateString();

        DropDownList drpProjectCategory = FormView1.FindControl("DrpProjectCategory") as DropDownList;
        DropDownList drpWareHouseID = FormView1.FindControl("DropDownList1") as DropDownList;
        DropDownList drpDepartmentID = FormView1.FindControl("DropDownList2") as DropDownList;
        DropDownList DrpReceiverName = FormView1.FindControl("DrpUser") as DropDownList;
        TextBox DescriptionTextBox = FormView1.FindControl("DescriptionTextBox") as TextBox;

        SqlDataSource1.InsertParameters["ProjectCategoryID"].DefaultValue = drpProjectCategory.SelectedValue;
        SqlDataSource1.InsertParameters["WareHouseID"].DefaultValue = drpWareHouseID.SelectedValue;
        SqlDataSource1.InsertParameters["UserName"].DefaultValue = this.User.Identity.Name;
        SqlDataSource1.InsertParameters["Description"].DefaultValue = DescriptionTextBox.Text;
        SqlDataSource1.InsertParameters["DepartmentID"].DefaultValue = drpDepartmentID.SelectedValue;
        SqlDataSource1.InsertParameters["ReceiverName"].DefaultValue = DrpReceiverName.SelectedValue;

        //�õ��Ѿ����ӵ������б�
        DataTable myTable = Session["DeliveryTable"] as DataTable;
        string strDeliveryItemsID = "";
        string strDeliveryItemsQuantity = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strDeliveryItemsID += myTable.Rows[i][0] + ",";
            strDeliveryItemsQuantity += myTable.Rows[i][6] + ",";
        }
        if (strDeliveryItemsID != "")
        {
            //ȥ�����һ����,��
            strDeliveryItemsID = strDeliveryItemsID.Substring(0, strDeliveryItemsID.Length - 1);
            strDeliveryItemsQuantity = strDeliveryItemsQuantity.Substring(0, strDeliveryItemsQuantity.Length - 1);
        }

        SqlDataSource1.InsertParameters["ItemsIDList"].DefaultValue = strDeliveryItemsID;
        SqlDataSource1.InsertParameters["QuantityList"].DefaultValue = strDeliveryItemsQuantity;
    }

    string insertedDeliveryID="";

    protected void SqlDataSource1_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        insertedDeliveryID = e.Command.Parameters["@DeliveryID"].Value.ToString();
    }

    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        if (e.Exception == null)
        {
            if (Session["DeliveryTable"] != null)
            {
                Session["DeliveryTable"] = null;
            }

            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScriptSuccess";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('�ɹ���Ӽ�¼��');if(confirm('�Ƿ��ӡ���ϵ���')) window.open('print.aspx?id=" + insertedDeliveryID + "','_blank','fullscreen=0,menubar=no,location=no,scrollbars=auto,resizable=yes,status=yes');"
                    +"window.location.href=window.location.href";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }

        }
        else
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScriptFail";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('�������ݿ����Ӽ�¼ʱ���������±༭���档');window.location.href=window.location.href";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }

            //e.ExceptionHandled = true;
        }

    }

    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        //��ȡĬ��ѡ�еĲֿ�ID
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;        
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidWareHouseID.Value = ((DropDownList)sender).SelectedValue;
    }

    protected void DrpUser_DataBound(object sender, EventArgs e)
    {
        Label lblMoney = FormView1.FindControl("lblMoney") as Label;
        string UserName = ((DropDownList)sender).SelectedValue;
        string strDepartID = GetDepartmentID(UserName);
        DropDownList DropDownList2 = FormView1.FindControl("DropDownList2") as DropDownList;
        DropDownList2.SelectedIndex = DropDownList2.Items.IndexOf(DropDownList2.Items.FindByValue(strDepartID));

        TextBox DeliveryDateTextBox = FormView1.FindControl("DeliveryDateTextBox") as TextBox;
        DateTime DeliveryDate;
        try
        {
            DeliveryDate = DateTime.Parse(DeliveryDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            DeliveryDate = DateTime.Now;
        }
    }

    /// <summary>
    /// ��Items��Inventory���в���ض��ֿ��е����м�¼��
    /// Ȼ���GridView2��
    /// ToDo:�������������ѯ����С��Χ��
    /// </summary>
    /// <param name="myGridView"></param>
    protected void GetWarehouseItems(GridView myGridView)
    {
        DataSet ds = GetWarehouseItemsToDataSet();
        myGridView.DataSource = ds.Tables[0];
        myGridView.DataBind();
    }

    private DataSet GetWarehouseItemsToDataSet()
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
        DataTable myTable = Session["DeliveryTable"] as DataTable;
        string strDeliveryItemsID = "";
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            strDeliveryItemsID += "'" + myTable.Rows[i][0] + "',";
        }
        if (strDeliveryItemsID != "")
        {
            //ȥ�����һ����,��
            strDeliveryItemsID = strDeliveryItemsID.Substring(0, strDeliveryItemsID.Length - 1);
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [Inventory].Quantity" +
               " FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID ) Where [Inventory].IsDeleted=0" +
               " And [Inventory].WareHouseID = " +
               Convert.ToInt32(hidWareHouseID.Value) + " And " + strFilter + " And [Items].ItemID Not In (" + strDeliveryItemsID + ")" +
               " Order by [Items].Name, [Items].Specification";
        }
        else
        {
            strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [Inventory].Quantity" +
               " FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID ) Where [Inventory].IsDeleted=0" +
               " And [Inventory].WareHouseID = " +
               Convert.ToInt32(hidWareHouseID.Value) + " And " + strFilter +
               " Order by [Items].Name, [Items].Specification";
        }

        SqlDataAdapter adapter = new SqlDataAdapter(strQuery, con);
        DataSet ds = new DataSet();
        adapter.Fill(ds);

        return ds;
    }

    private string GetDepartmentID(string UserName)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select DepartmentID FROM Accounts_DepartmentUsers WHERE UserName ='" + UserName + "'";

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        SqlDataReader reader = command.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                return reader[0].ToString();
            }
        }
        finally
        {
            reader.Close();
        }
        return "0";
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
        GetDeliveryItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }

    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetDeliveryItems(myGridView);
        myGridView.EditIndex = e.NewEditIndex;
        myGridView.DataBind();

        //��꣬����������ôĬ��ȫ��ѡ��
        GridViewRow editRow = myGridView.Rows[e.NewEditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtDeliveryItemsQuantity"));
    }

    /// <summary>
    /// ��ע���������ڻ�ȡ��ɾ��GridViewRowĳһCell���ı��ķ�����
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        DataTable myTable = Session["DeliveryTable"] as DataTable;
        GridView myGridView = (GridView)sender;
        GridViewRow delRow = myGridView.Rows[e.RowIndex];

        //���ڿ����ں������sorting�Ĺ��ܣ����Բ��ܼ򵥵���GridView��e.RowIndex����Session��DeliveryTable��index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i][0].ToString();
            if (strTemp == ((Label)delRow.Cells[1].FindControl("lblDeliveryItemsID")).Text)
            {
                myTable.Rows[i].Delete();
                break;
            }            
        }

        Session["DeliveryTable"] = myTable;
        GetDeliveryItems(myGridView);
    }

    protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetDeliveryItems(myGridView);
        myGridView.EditIndex = -1;
        myGridView.DataBind();
    }

    protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GridViewRow updateRow = myGridView.Rows[e.RowIndex];
        DataTable myTable = Session["DeliveryTable"] as DataTable;

        //���ڿ����ں������sorting�Ĺ��ܣ����Բ��ܼ򵥵���GridView��e.RowIndex����Session��DeliveryTable��index
        for (int i = 0; i < myTable.Rows.Count; i++)
        {
            string strTemp = myTable.Rows[i]["DeliveryItemsID"].ToString();
            if (strTemp == ((Label)updateRow.Cells[1].FindControl("lblDeliveryItemsID")).Text)
            {
                TextBox txtDeliveryItemsQuantity = (TextBox)updateRow.FindControl("txtDeliveryItemsQuantity");
                myTable.Rows[i]["DeliveryQuantity"] = Convert.ToDecimal(txtDeliveryItemsQuantity.Text);
                myTable.Rows[i]["DeliveryItemsMoney"] = Convert.ToDecimal(myTable.Rows[i]["DeliveryQuantity"]) * Convert.ToDecimal(myTable.Rows[i]["DeliveryItemsStandardPrice"]);
                myTable.Rows[i]["DeliveryItemsLeftInventory"] = Convert.ToDecimal(myTable.Rows[i]["DeliveryItemsInventory"]) - Convert.ToDecimal(myTable.Rows[i]["DeliveryQuantity"]);
                break;
            }
        }

        Session["DeliveryTable"] = myTable;

        GetDeliveryItems(myGridView);
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
            for (int i=5;i<12;i++)
                e.Row.Cells[i].HorizontalAlign = HorizontalAlign.Right;

            priceTotal += Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "DeliveryItemsMoney"));
        }
        else if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Cells[7].Text = "����ܼ�:";
            // for the Footer, display the running totals
            e.Row.Cells[8].Text = priceTotal.ToString("c");
            
            e.Row.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Font.Bold = true;

            priceTotal = 0;
        }
        
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
            decimal unitsInStock = Convert.ToDecimal(DataBinder.Eval(e.Row.DataItem, "Quantity"));
            if (unitsInStock == 0)
                // color the background of the row yellow
                e.Row.BackColor = System.Drawing.Color.Yellow;
            if (unitsInStock < 0)
                // color the background of the row yellow
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
        //AddDelivery(myGridView.SelectedValue.ToString());
        AddDelivery(myGridView.SelectedRow);
        myGridView.SelectedIndex = -1;

        RadioButton radioBrowserDetails = myGridView.Parent.Parent.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = myGridView.Parent.Parent.FindControl("radioInsertDetails") as RadioButton;
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());

        //�б�GridView
        GridView myGridView1 = myGridView.Parent.Parent.FindControl("GridView1") as GridView;
        //myGridView1.PageIndex = myGridView1.PageCount - 1;
        //myGridView1.EditIndex = myGridView1.Rows.Count - 1;
        myGridView1.EditIndex = 0;
        myGridView1.DataBind();

        //���
        GridViewRow editRow = myGridView1.Rows[myGridView1.EditIndex];
        Page.SetFocus((TextBox)editRow.FindControl("txtDeliveryItemsQuantity"));
    }

    /// <summary>
    /// �û���û�б���СƱ֮ǰ����ϸ������Ϣ��ʱ��д�����ݿ⣬
    /// �ȴ���һDataTable�С�
    /// �ȱ༭��ɱ����ʱ��
    /// �ô洢����������ӱ��¼�Ĳ��룬�Ա�֤���������Ժ�һ����
    /// </summary>
    /// <param name="ItemsID"></param>
    private void AddDelivery(GridViewRow addItemsRow)
    {
        DataTable myTable = Session["DeliveryTable"] as DataTable;
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
        myTable.Rows.InsertAt(dr, 0);
        Session["DeliveryTable"] = myTable;
    }

    protected void GridView2_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView myGridView = (GridView)sender;
        GetWarehouseItems(myGridView);
        myGridView.PageIndex = e.NewPageIndex;
        myGridView.DataBind();
    }


    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        radioBrowserDetails.Checked = false;
        radioInsertDetails.Checked = true;
        radioButtonDetails_CheckedChanged(radioInsertDetails, new EventArgs());
    }
    /// <summary>
    /// ���ݵ��ճ��������������ʾ�ڷ�����ϸ����
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAuto_Click(object sender, EventArgs e)
    {
        DropDownList DrpProjectCategory = FormView1.FindControl("DrpProjectCategory") as DropDownList;
        int ProjectCategoryID = Convert.ToInt32(DrpProjectCategory.SelectedValue);

        if (IsNode(ProjectCategoryID))
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScriptProject";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('��ѡ��һ�������������Ŀ��');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            return;
        }
        DropDownList DrpDepartmentID = FormView1.FindControl("DropDownList2") as DropDownList;
        int DepartmentID = Convert.ToInt32(DrpDepartmentID.SelectedValue);

        DropDownList DropDownList1 = FormView1.FindControl("DropDownList1") as DropDownList;
        int WareHouseID = Convert.ToInt32(DropDownList1.SelectedValue);

        TextBox DeliveryDateTextBox = FormView1.FindControl("DeliveryDateTextBox") as TextBox;
        DateTime DeliveryDate;
        try
        {
            DeliveryDate = DateTime.Parse(DeliveryDateTextBox.Text);
        }
        catch (System.FormatException eFormat)
        {
            DeliveryDate = DateTime.Now;
        }

        DataTable myTable = Session["DeliveryTable"] as DataTable;
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "SELECT Quantity From RepairDetail Where [RepairDetail].RepairID in (Select [RepairMain].RepairID From RepairMain Where RepairDate='"
            + DeliveryDate.ToShortDateString() + "')" +
            " AND ProjectCategoryID=" + ProjectCategoryID;
        SqlCommand command = new SqlCommand(strQuery, con);

        con.Open();
        SqlDataReader reader = command.ExecuteReader();

        //�����ж��Ƿ������Ŀ��������¼
        if (!reader.HasRows)
        {
            // Get a ClientScriptManager reference from the Page class.
            ClientScriptManager cs = Page.ClientScript;
            Type cstype = this.GetType();
            String csname = "PopupScriptNoProject";

            // Check to see if the startup script is already registered.
            if (!cs.IsStartupScriptRegistered(cstype, csname))
            {
                String cstext = "alert('����û���ƶ�������¼����������¼��û�и���Ŀ��');";
                cs.RegisterStartupScript(cstype, csname, cstext, true);
            }
            con.Close();
            return;
        }
        else
        {
            con.Close();
        }

        strQuery = "Select * From dbo.GetDeliveryRatioByCategoryID(" + ProjectCategoryID + "," + DepartmentID + "," + WareHouseID + ",'" + DeliveryDate.ToShortDateString() + "')";
        command = new SqlCommand(strQuery, con);

        con.Open();
        reader = command.ExecuteReader();

        try
        {
            while (reader.Read())
            {
                DataRow dr = myTable.NewRow();
                for (int i = 0; i < 7; i++)
                {
                    dr[i] = reader[i];
                }
                dr[7] = Convert.ToDecimal(dr[4]) * Convert.ToDecimal(dr[6]);
                //dr[7] = 0;
                dr[8] = Convert.ToInt32(dr[5]) - Convert.ToDecimal(dr[6]);
                //dr[8] = 0;
                myTable.Rows.InsertAt(dr, 0);
            }
        }
        finally
        {
            reader.Close();
        }

        Session["DeliveryTable"] = myTable;

        GetDeliveryItems((GridView)FormView1.FindControl("GridView1"));

        RadioButton radioBrowserDetails = FormView1.FindControl("radioBrowserDetails") as RadioButton;
        RadioButton radioInsertDetails = FormView1.FindControl("radioInsertDetails") as RadioButton;
        radioBrowserDetails.Checked = true;
        radioInsertDetails.Checked = false;

        radioButtonDetails_CheckedChanged(radioBrowserDetails, new EventArgs());
    }

    private void GetDeliveryItems(GridView myGridView)
    {
        DataTable myTable = Session["DeliveryTable"] as DataTable;
        myGridView.DataSource = myTable;
        myGridView.DataBind();
    }

}
