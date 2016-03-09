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
using System.Text;
using System.Web.Hosting;
using System.Data.SqlClient;

public partial class Security_permissions_createPermission : System.Web.Administration.SecurityPage
{

    private int CurrentPath = 0;

    public void AddPermissionRule(int currentPath, ListControl roles, CheckBox roleRadio, CheckBox allUsersRadio, CheckBox grantRadio, CheckBox denyRadio)
    {
        string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString;
        SqlConnection connection = new SqlConnection(connectionString);
        SqlCommand command = new SqlCommand("proc_UpdateSiteMap", connection);
        command.CommandType = CommandType.StoredProcedure;
        connection.Open();

        if (roleRadio.Checked) 
        {
            //rule.Roles.Add(roles.SelectedItem.Text);
        }
        else if (allUsersRadio.Checked) 
        {
            //rule.Users.Add ("*");
        }
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

            //生产项目
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

    public void Page_Load()
    {
        if (!IsPostBack)
        {
            roles.DataSource = Roles.GetAllRoles();
            roles.DataBind();
            if (roles.Items.Count == 0)
            {
                ListItem item = new ListItem((string)GetLocalResourceObject("NoRoles"));
                roles.Items.Add(item);
                roles.Enabled = false;
                roleRadio.Enabled = false;
                roleRadio.Checked = false;
            }
        }
        HighlightSelectedNode(tv.Nodes[0], CurrentPath);
    }

    protected bool HighlightSelectedNode(TreeNode node, int path)
    {
        bool foundIt = false;
        foreach (TreeNode childNode in node.ChildNodes)
        {
            if (Convert.ToInt32(childNode.Value) == path)
            {
                childNode.Selected = true;
                foundIt = true;
                break;
            }
        }
        return foundIt;
    }


    protected void TreeNodeSelected(object sender, EventArgs e)
    {
        CurrentPath = Convert.ToInt32(((TreeView)sender).SelectedNode.Value);
    }

    protected void UpdateAndReturnToPreviousPage(object sender, EventArgs e)
    {
        ClearUserCollection();
        if (!IsRuleValid(placeholderValidator, roleRadio, roles))
        {
            return;
        }
        AddPermissionRule(CurrentPath, roles, roleRadio, allUsersRadio, grantRadio, denyRadio);
        ReturnToPreviousPage(sender, e);
    }
}
