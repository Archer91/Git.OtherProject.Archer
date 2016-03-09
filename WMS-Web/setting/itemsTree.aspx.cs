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

public partial class consume_itemsTree : System.Web.UI.Page
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
        SqlCommand objCommand = new SqlCommand(@"select ItemCategoryID,(ItemCategoryID + ',' + Description) As Description,(select count(*) FROM ItemCategories WHERE ParentID=sc.ItemCategoryID) childnodecount FROM ItemCategories sc where ParentID IS NULL", objConn);
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        PopulateNodes(dt, TreeView1.Nodes);
    }

    private void PopulateSubLevel(string parentid, TreeNode parentNode)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"select ItemCategoryID,(ItemCategoryID + ',' + Description) As Description,(select count(*) FROM ItemCategories WHERE ParentID=sc.ItemCategoryID) childnodecount FROM ItemCategories sc where ParentID=@ParentID", objConn);
        objCommand.Parameters.Add("@ParentID", SqlDbType.VarChar).Value = parentid;
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
            tn.Text = dr["Description"].ToString();
            tn.Value = dr["ItemCategoryID"].ToString();
            tn.NavigateUrl = "itemsMain.aspx?type=0&id=" + dr["ItemCategoryID"].ToString();
            tn.Target = "content";
            nodes.Add(tn);

            //If node has child nodes, then enable on-demand populating
            tn.PopulateOnDemand = ((int)(dr["childnodecount"]) > 0);
        }
    }

    protected void LinkButtonSearch_Click(object sender, EventArgs e)
    {
        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "window.parent.content.location.href='itemsMain.aspx?type=1&id=" + ItemIDTextBox.Text + "';";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }
    }
}
