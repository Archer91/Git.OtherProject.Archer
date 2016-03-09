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

public partial class outbound_print : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != "" && Request.QueryString["id"] != null)
        {
            string strID = Request.QueryString["id"];
            readDelivery(strID);
        }
    }

    private void readDelivery(string DeliveryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select WareHouses.Description as WareHouseName, DepartName," +
            "ProjectCategories.Name As ProjectName,DeliveryDate From DeliveryMain " +
            "Join WareHouses On (DeliveryMain.WareHouseID=WareHouses.WareHouseID) " +
            "Join Accounts_Department On (DeliveryMain.DepartmentID=Accounts_Department.DepartmentID) " +
            "Join ProjectCategories On (DeliveryMain.ProjectCategoryID=ProjectCategories.ProjectCategoryID) " +
            "Where DeliveryID=" + DeliveryID;
        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        SqlDataReader reader = command.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                lblOrgan.Text = Application["Organ"].ToString();
                lblDeliveryID.Text = DeliveryID;
                lblWareHouse.Text = reader[0].ToString();
                lblDeliveryDate.Text = ((DateTime)reader[3]).ToString("yyyy-MM-dd");
                lblDepartment.Text = reader[1].ToString();
                lblProject.Text = reader[2].ToString();
                readDeliveryDetail(DeliveryID);
                readDeliveryEnd(DeliveryID);
            }
        }
        finally
        {
            reader.Close();
            con.Close();
        }
    }

    private void readDeliveryDetail(string DeliveryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "SELECT [Items].ItemID, [Items].Name, [Items].Specification," +
                " [Items].Unit, [Items].StandardPrice, [DeliveryDetail].[Quantity]," +
                " [Items].StandardPrice*[DeliveryDetail].[Quantity]" +
                " FROM [DeliveryDetail], [Items]" +
                " WHERE [DeliveryDetail].[DeliveryID] = " + DeliveryID +
                " AND [DeliveryDetail].ItemID = [Items].ItemID Order By DeliveryDetailID Desc";

        SqlCommand command = new SqlCommand(strQuery, con);
        SqlDataAdapter adapter = new SqlDataAdapter(command);
        DataTable dt = new DataTable();
        adapter.Fill(dt);

        decimal totalMoney = 0;
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            TableRow rowDetail = new TableRow();
            rowDetail.BackColor = System.Drawing.Color.White;
            TableCell cellDetailNo = new TableCell();
            cellDetailNo.Text = Convert.ToString(i + 1);
            rowDetail.Cells.Add(cellDetailNo);

            for (int j = 0; j < 3; j++)
            {
                TableCell cellDetail = new TableCell();
                cellDetail.Text = dt.Rows[i][j].ToString();
                rowDetail.Cells.Add(cellDetail);
            }

            TableCell cellUnit = new TableCell();
            cellUnit.Text = dt.Rows[i][3].ToString();
            cellUnit.HorizontalAlign = HorizontalAlign.Center;
            rowDetail.Cells.Add(cellUnit);

            TableCell cellDetailPrice = new TableCell();
            cellDetailPrice.Text = String.Format("{0:C}", dt.Rows[i][4]);
            cellDetailPrice.HorizontalAlign = HorizontalAlign.Right;
            rowDetail.Cells.Add(cellDetailPrice);

            TableCell cellDetailQuantity = new TableCell();
            cellDetailQuantity.Text = dt.Rows[i][5].ToString();
            cellDetailQuantity.HorizontalAlign = HorizontalAlign.Right;
            rowDetail.Cells.Add(cellDetailQuantity);

            TableCell cellDetailSum = new TableCell();
            cellDetailSum.Text = String.Format("{0:C}", dt.Rows[i][6]);
            cellDetailSum.HorizontalAlign = HorizontalAlign.Right;
            rowDetail.Cells.Add(cellDetailSum);

            totalMoney += Convert.ToDecimal(dt.Rows[i][6]);

            tblDetail.Rows.Add(rowDetail);
        }

        for (int i = dt.Rows.Count; i < 5; i++)
        {
            TableRow rowDetail = new TableRow();
            rowDetail.BackColor = System.Drawing.Color.White;
            TableCell cellDetailNo = new TableCell();
            cellDetailNo.Text = Convert.ToString(i + 1);
            rowDetail.Cells.Add(cellDetailNo);
            for (int j = 0; j < 7; j++)
            {
                TableCell cellDetail = new TableCell();
                rowDetail.Cells.Add(cellDetail);
            }
            tblDetail.Rows.Add(rowDetail);
        }

        TableRow rowDetailSum = new TableRow();
        rowDetailSum.BackColor = System.Drawing.Color.White;
        TableCell cellDetailSummary = new TableCell();
        cellDetailSummary.ColumnSpan = 3;
        cellDetailSummary.Text = "页小计";
        cellDetailSummary.HorizontalAlign = HorizontalAlign.Center;
        rowDetailSum.Cells.Add(cellDetailSummary);
        tblDetail.Rows.Add(rowDetailSum);

        TableCell cellDetailMoney = new TableCell();
        cellDetailMoney.Text = String.Format("{0:C}", totalMoney);
        cellDetailMoney.HorizontalAlign = HorizontalAlign.Right;
        rowDetailSum.Cells.Add(cellDetailMoney);
        tblDetail.Rows.Add(rowDetailSum);

        TableCell cellDetailTotalDesc = new TableCell();
        cellDetailTotalDesc.ColumnSpan = 2;
        cellDetailTotalDesc.Text = "合计";
        cellDetailTotalDesc.HorizontalAlign = HorizontalAlign.Center;
        rowDetailSum.Cells.Add(cellDetailTotalDesc);
        tblDetail.Rows.Add(rowDetailSum);

        TableCell cellDetailTotal = new TableCell();
        cellDetailTotal.ColumnSpan = 2;
        cellDetailTotal.Text = String.Format("{0:C}", totalMoney);
        cellDetailTotal.HorizontalAlign = HorizontalAlign.Right;
        rowDetailSum.Cells.Add(cellDetailTotal);
        tblDetail.Rows.Add(rowDetailSum);

        con.Close();
    }

    private void readDeliveryEnd(string DeliveryID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select ReceiverName,UserName,ReviewerID From DeliveryMain Where DeliveryID=" + DeliveryID;

        SqlCommand command = new SqlCommand(strQuery, con);
        con.Open();
        SqlDataReader reader = command.ExecuteReader();
        try
        {
            while (reader.Read())
            {
                lblReceiver.Text = reader[0].ToString();
                lblUser.Text = reader[1].ToString();
                lblReviewer.Text = reader[2].ToString();
                lblCurrent.Text = this.User.Identity.Name;
            }
        }
        finally
        {
            reader.Close();
            con.Close();
        }
    }

}
