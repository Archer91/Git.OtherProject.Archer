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

public partial class setting_supplierTree : System.Web.UI.Page
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
        SqlCommand objCommand = new SqlCommand(@"select SupplierID, Code+','+NAME as Name,(select count(*) FROM Supplier WHERE PID=sc.SupplierID) childnodecount FROM Supplier sc where PID Is Null Order By Code", objConn);
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        PopulateNodes(dt, TreeView1.Nodes);
    }

    private void PopulateSubLevel(string parentSupplierID, TreeNode parentNode)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"select SupplierID,Code+','+NAME as Name,(select count(*) FROM Supplier WHERE PID=sc.SupplierID) childnodecount FROM Supplier sc where PID=@PID Order By Code", objConn);
        objCommand.Parameters.Add("@PID", SqlDbType.VarChar).Value = parentSupplierID;
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        PopulateNodes(dt, parentNode.ChildNodes);
    }


    protected void TreeView1_TreeNodePopulate(object sender, TreeNodeEventArgs e)
    {
        PopulateSubLevel(e.Node.Value, e.Node);
    }

    private void PopulateNodes(DataTable dt, TreeNodeCollection nodes)
    {
        foreach (DataRow dr in dt.Rows)
        {
            TreeNode tn = new TreeNode();
            tn.Text = dr["Name"].ToString();
            tn.Value = dr["SupplierID"].ToString();
            tn.NavigateUrl = "supplierMain.aspx?id=" + dr["SupplierID"].ToString();
            tn.Target = "content";
            nodes.Add(tn);

            //If node has child nodes, then enable on-demand populating
            tn.PopulateOnDemand = ((int)(dr["childnodecount"]) > 0);
        }
    }
}
