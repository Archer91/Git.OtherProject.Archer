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

public partial class Security_permissions_wareHousesTree : System.Web.UI.Page
{
    private string[] strUserWareHouses;

    protected void Page_Load(object sender, EventArgs e)
    {
        getUserWareHouses(Request.QueryString["id"]);

        if (!IsPostBack)
        {
            PopulateRootLevel();
        }
    }

    private void getUserWareHouses(string UserName)
    {
        string strTemp = "";

        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"select WareHouseID FROM UserWareHouses WHERE UserName='" + UserName+"'", objConn);
        objConn.Open();

        SqlDataReader reader = objCommand.ExecuteReader();
        if(reader.HasRows)
        {
            while (reader.Read())
            {
                strTemp += reader[0].ToString() + ",";
            }
        }
        reader.Close(); 
        objConn.Close();
        strUserWareHouses = strTemp.Split(',');
    }

    private void PopulateRootLevel()
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        //SqlCommand objCommand = new SqlCommand(@"Select 0 as WareHouseID, '对所有仓库有权' as Description, 0 as childnodecount Union select WareHouseID,WareHouseCode+','+Description As Description,(select count(*) FROM WareHouses WHERE ParentWareHouseID=sc.WareHouseID) childnodecount FROM WareHouses sc where ParentWareHouseID=0", objConn);
        //改为显示成一级就好
        SqlCommand objCommand = new SqlCommand(@"Select 0 as WareHouseID, '对所有仓库有权' as Description, 0 as childnodecount Union select WareHouseID,WareHouseCode+' '+Description As Description,0 as childnodecount FROM WareHouses sc", objConn);
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        PopulateNodes(dt, TreeView1.Nodes);
    }

    private void PopulateSubLevel(int parentid, TreeNode parentNode)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"select WareHouseID,WareHouseCode+','+Description As Description,(select count(*) FROM WareHouses WHERE ParentWareHouseID=sc.WareHouseID) childnodecount FROM WareHouses sc where ParentWareHouseID=@ParentWareHouseID", objConn);
        objCommand.Parameters.Add("@ParentWareHouseID", SqlDbType.Int).Value = parentid;
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        PopulateNodes(dt, parentNode.ChildNodes);
    }


    protected void TreeView1_TreeNodePopulate(object sender, TreeNodeEventArgs e)
    {
        PopulateSubLevel(Int32.Parse(e.Node.Value), e.Node);
    }

    private void PopulateNodes(DataTable dt, TreeNodeCollection nodes)
    {
        foreach (DataRow dr in dt.Rows)
        {
            TreeNode tn = new TreeNode();
            tn.Text = dr["Description"].ToString();
            tn.Value = dr["WareHouseID"].ToString();
            tn.SelectAction = TreeNodeSelectAction.None;
            if(strUserWareHouses!=null)
                if (Array.IndexOf(strUserWareHouses, tn.Value)!=-1)
                    tn.Checked = true;
            nodes.Add(tn);
            
            //If node has child nodes, then enable on-demand populating
            tn.PopulateOnDemand = ((int)(dr["childnodecount"]) > 0);
        }
    }

    protected void yesButton_Click(object sender, EventArgs e)
    {
        string strWareHouses = "";

        foreach (TreeNode tn in TreeView1.CheckedNodes)
        {
            if (tn.Value == "0")
            {
                strWareHouses = "0,";
                break;
            }
            strWareHouses = strWareHouses + tn.Value + ",";
        }
        if (strWareHouses != "")
        {
            //去掉最后一个“,”
            strWareHouses = strWareHouses.Substring(0, strWareHouses.Length - 1);
        }

        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        SqlCommand command = new SqlCommand("sp_setWareHousesPermission", connection);
        command.CommandType = CommandType.StoredProcedure;

        SqlParameter parameter = command.Parameters.Add("@UserName", SqlDbType.VarChar,30);
        parameter.Value = Request.QueryString["id"];

        parameter = command.Parameters.Add("@strWareHouses", SqlDbType.VarChar, 2000);
        parameter.Value = strWareHouses;

        connection.Open();
        command.ExecuteNonQuery();
        connection.Close();
    }

}
