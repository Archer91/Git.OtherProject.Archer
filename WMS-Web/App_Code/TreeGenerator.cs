using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;


/// <summary>
/// Summary description for TreeGenerator
/// </summary>
public class TreeGenerator
{
	public TreeGenerator()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static void PopulateRootLevel(TreeView myTreeView, string strSQL, string strNavigateUrl, string strTarget, string strTextField, string strValueField)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(strSQL, objConn);
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        objConn.Close();
        PopulateNodes(dt, myTreeView.Nodes, strNavigateUrl, strTarget, strTextField, strValueField);
    }

    public static void PopulateSubLevel(int parentid, TreeNode parentNode, string strSubSQL, string strParentField, string strNavigateUrl, string strTarget, string strTextField, string strValueField)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(strSubSQL, objConn);
        objCommand.Parameters.Add(strParentField, SqlDbType.Int).Value = parentid;
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        objConn.Close();
        PopulateNodes(dt, parentNode.ChildNodes, strNavigateUrl, strTarget, strTextField, strValueField);
    }

    public static void PopulateSubLevel2(string parentid, TreeNode parentNode, string strSubSQL, string strParentField, string strNavigateUrl, string strTarget, string strTextField, string strValueField)
    {
        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(strSubSQL, objConn);
        objCommand.Parameters.Add(strParentField, SqlDbType.VarChar).Value = parentid;
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        objConn.Close();
        PopulateNodes(dt, parentNode.ChildNodes, strNavigateUrl, strTarget, strTextField, strValueField);
    }
    
    private static void PopulateNodes(DataTable dt, TreeNodeCollection nodes, string strNavigateUrl, string strTarget, string strTextField, string strValueField)
    {
        foreach (DataRow dr in dt.Rows)
        {
            TreeNode tn = new TreeNode();
            tn.Text = dr[strTextField].ToString();
            tn.Value = dr[strValueField].ToString();
            if (!String.IsNullOrEmpty(strNavigateUrl))
                tn.NavigateUrl = strNavigateUrl + tn.Value;
            if (strNavigateUrl == "../dispatchQueryMain.aspx?type=Repair&id=")
                tn.NavigateUrl += "|"; 
            if (!String.IsNullOrEmpty(strTarget))
                tn.Target = strTarget;
            nodes.Add(tn);

            //If node has child nodes, then enable on-demand populating
            tn.PopulateOnDemand = ((int)(dr["childnodecount"]) > 0);

            if ((int)(dr["childnodecount"]) == 0 && strNavigateUrl == "../dispatchQueryMain.aspx?type=Repair&id=" )
            {
                PopulateSubjectNodes(tn.Value, tn.ChildNodes);
            }
        }
    }

    private static void PopulateSubjectNodes(String RepairID, TreeNodeCollection nodes)
    {
        string strYear = DateTime.Now.ToString("yyyy");

        string connectionString = ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection objConn = new SqlConnection(connectionString);
        SqlCommand objCommand = new SqlCommand(@"SELECT DISTINCT drs.SubjectID AS SubjectID, s.Name AS Name FROM DepRepSubRelations AS drs JOIN Subject AS s ON (drs.SubjectID=s.SubjectNo) WHERE drs.SDATE LIKE @SDATE + '%' AND drs.RepairID=@RepairID ORDER BY drs.SubjectID", objConn);
        objCommand.Parameters.Add("@RepairID", SqlDbType.Int).Value = RepairID;
        objCommand.Parameters.Add("@SDATE", SqlDbType.Char).Value = strYear;
        SqlDataAdapter da = new SqlDataAdapter(objCommand);
        DataTable dt = new DataTable();
        da.Fill(dt);
        objConn.Close();
        foreach (DataRow dr in dt.Rows)
        {
            TreeNode tn = new TreeNode();
            tn.Text = dr["Name"].ToString();
            tn.Value = dr["SubjectID"].ToString();
            tn.NavigateUrl = "../dispatchQueryMain.aspx?type=Repair&id=" + RepairID + "|" + dr["SubjectID"].ToString();
            tn.Target = "content";
            nodes.Add(tn);
        }
    }
}
