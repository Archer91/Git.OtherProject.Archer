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

public partial class setting_wareHousesTree : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            PopulateRootLevel();
    }

    private void PopulateRootLevel()
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"select WareHouseID,WareHouseCode+','+Description As Description,(select count(*) FROM WareHouses WHERE ParentWareHouseID=sc.WareHouseID) childnodecount FROM WareHouses sc where ParentWareHouseID=0", objConn);
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
            tn.NavigateUrl = "WareHousesMain.aspx?id=" + dr["WareHouseID"].ToString();
            tn.Target = "content";
            nodes.Add(tn);

            //If node has child nodes, then enable on-demand populating
            tn.PopulateOnDemand = ((int)(dr["childnodecount"]) > 0);
        }
    }

}
