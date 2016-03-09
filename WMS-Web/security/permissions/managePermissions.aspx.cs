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

public partial class Security_permissions_managePermissions : System.Web.Administration.SecurityPage
{
    private const string CURRENT_PATH = "PermissionCurrentPath";

    protected int CurrentPath
    {
        get
        {
            object tempString = (object)Session[CURRENT_PATH];
            return tempString != null ? (int)tempString : 0;
        }
        set
        {
            Session[CURRENT_PATH] = value;
        }
    }


    public void Page_Load()
    {
        if (!IsPostBack)
        {
            CurrentPath = 0;
        }
    }


    protected void TreeNodeSelected(object sender, EventArgs e)
    {
        CurrentPath = Convert.ToInt32(((TreeView)sender).SelectedNode.Value);
        Literal2.Text = "\""+((TreeView)sender).SelectedNode.Text+"\"的访问规则";
        dataGrid.SelectedIndex = -1;
        BindGrid();
    }

    protected override void OnInit(EventArgs e)
    {
        base.OnInit(e);
        if (!IsPostBack)
        {
            // Note: treenodes persist when added in Init, before loadViewState
            string strSQL = "select ID,Title,(select count(*) FROM SiteMap WHERE Parent=sc.ID) childnodecount FROM SiteMap sc where Parent IS Null";
            string strNavigateUrl = "";
            string strTarget = "";
            string strTextField = "Title";
            string strValueField = "ID";

            TreeGenerator.PopulateRootLevel(tv, strSQL, strNavigateUrl, strTarget, strTextField, strValueField);
        }
    }

    protected void TreeView1_TreeNodePopulate(object sender, TreeNodeEventArgs e)
    {
        string strSQL = "select ID,Title,(select count(*) FROM SiteMap WHERE Parent=sc.ID) childnodecount FROM SiteMap sc where Parent=@Parent";
        string strParentField = "@Parent";
        string strNavigateUrl = "";
        string strTarget = "";
        string strTextField = "Title";
        string strValueField = "ID";
        TreeGenerator.PopulateSubLevel(Int32.Parse(e.Node.Value), e.Node, strSQL, strParentField, strNavigateUrl, strTarget, strTextField, strValueField);
    }

    private void BindGrid()
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);

        SqlCommand command = new SqlCommand("proc_GetRolePermissions", connection);
        command.CommandType = CommandType.StoredProcedure;

        SqlParameter parameter = new SqlParameter("@ID", SqlDbType.Int);
        parameter.IsNullable = false;
        parameter.Value = CurrentPath;

        command.Parameters.Add(parameter);

        connection.Open();

        SqlDataAdapter adapter = new SqlDataAdapter();
        adapter.SelectCommand = command;
        DataSet ds = new DataSet();
        adapter.Fill(ds);

        dataGrid.DataSource = ds;
        dataGrid.DataBind();
        connection.Close();
    }

    protected void yesButton_Click(object sender, EventArgs e)
    {
        string roles="";
        bool isAll = true;
        foreach (GridViewRow row in dataGrid.Rows)
        {
            CheckBox chkRight = (CheckBox)row.Cells[1].FindControl("chkRight");
            if (chkRight.Checked)
            {
                Label lblName = (Label)row.Cells[0].FindControl("lblName");
                roles = roles + lblName.Text + ",";
            }
            else
                isAll = false;
        }
        if (roles != "")
        {
            //去掉最后一个“,”
            roles = roles.Substring(0, roles.Length - 1);
        }
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        string strSQL = "";
        if(isAll)
            strSQL = "Update SiteMap Set Roles=Null Where ID=" + CurrentPath;
        else
            strSQL = "Update SiteMap Set Roles='" + roles + "' Where ID=" + CurrentPath;
        SqlCommand command = new SqlCommand(strSQL, connection);
        connection.Open();
        command.ExecuteNonQuery();
        connection.Close();
    }
}
