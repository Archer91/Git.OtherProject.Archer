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

public partial class setting_departUser : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["DepartID"] != "" && Request.QueryString["DepartID"] != null)
            {
                string strID = Request.QueryString["DepartID"];
                string strDepartName = GetDepartName(Convert.ToInt32(strID));
                if (strDepartName != "")
                {
                    ltrTitle.Text = "����\"" + strDepartName + "\"����Ա�б�";

                    //��䡰��δ���κΰ������Ա���б�
                    MembershipUserCollection users = Membership.GetAllUsers();

                    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
                    string strQuery = "Select UserName FROM Accounts_DepartmentUsers";

                    SqlCommand command = new SqlCommand(strQuery, con);
                    con.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        users.Remove(reader[0].ToString());
                    }

                    ListSparesCatogries.DataSource = users;
                    ListSparesCatogries.DataBind();

                    con.Close();

                    //��䡰��������Ա���б�

                    strQuery = "Select UserName FROM Accounts_DepartmentUsers Where DepartmentID = " + strID;

                    command.CommandText = strQuery;

                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = command;

                    con.Open();

                    DataSet ds = new DataSet();
                    adapter.Fill(ds);

                    ListWareHouseSparesCatogries.DataSource = ds;
                    ListWareHouseSparesCatogries.DataBind();

                    con.Close();

                }
                else
                {
                    Response.Write("����Ĳ�����");
                    Response.End();
                }
            }
            else
            {
                Response.Write("����Ĳ�����");
                Response.End();
            }
        }
    }

    private string GetDepartName(int DepartID)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);
        string strQuery = "Select DepartName FROM Accounts_Department WHERE DepartmentID =" + DepartID;

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
            reader.Close();con.Close();
        }
        return "";
    }
    protected void InsertButton_Click(object sender, EventArgs e)
    {
        string strInsertID = hidInsertID.Value;

        if (strInsertID != "")
        {
            //ȥ�����һ����,��
            strInsertID = strInsertID.Substring(0, strInsertID.Length - 1);
        }

        string strDeleteID = hidDeleteID.Value;
        if (strDeleteID != "")
        {
            //ȥ�����һ����,��
            strDeleteID = strDeleteID.Substring(0, strDeleteID.Length - 1);
        }

        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["MySqlProviderConnection"].ConnectionString);

        SqlCommand command = new SqlCommand("sp_updateDepartmentUsers " + Request.QueryString["DepartID"] + ",'" + strInsertID + "','" + strDeleteID + "'", con);
        
        string strMessage = "";

        try
        {
            con.Open();
            command.ExecuteNonQuery();
            //�ɹ�
            strMessage = "�ɹ����ĳ�Ա�б�";
        }
        catch (SqlException ex)
        {
            strMessage = "�������ݿ����Ӽ�¼ʱ���������±༭���档";
        }
        finally
        {
            con.Close();
        }

        // Get a ClientScriptManager reference from the Page class.
        ClientScriptManager cs = Page.ClientScript;
        Type cstype = this.GetType();
        String csname = "PopupScript";

        // Check to see if the startup script is already registered.
        if (!cs.IsStartupScriptRegistered(cstype, csname))
        {
            String cstext = "alert('" + strMessage + "'); window.location = 'departmentMain.aspx?id="+Request.QueryString["DepartID"]+"';";
            cs.RegisterStartupScript(cstype, csname, cstext, true);
        }

    }

    protected void InsertCancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("departmentMain.aspx?id="+Request.QueryString["DepartID"]);
    }
}
