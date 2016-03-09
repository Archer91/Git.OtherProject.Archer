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

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack && Request.Cookies["UserInfo"] != null)
            ((TextBox)Login1.FindControl("UserNo")).Text = HttpUtility.UrlDecode(Request.Cookies["UserInfo"].Values["UserNo"]);
    }
    protected void Login1_LoggedIn(object sender, EventArgs e)
    {
        HttpCookie UserInfoCookie = new HttpCookie("UserInfo");
        UserInfoCookie.Values["UserNo"] = HttpUtility.UrlEncode(((TextBox)Login1.FindControl("UserNo")).Text);
        UserInfoCookie.Expires = DateTime.Now.AddYears(1);
        Response.Cookies.Add(UserInfoCookie);
    }
    protected void LoginButton_Click(object sender, EventArgs e)
    {
        SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString);
        SqlCommand cmd = null;
        try
        {
            con.Open();
            string selectQry = "Select UserName From aspnet_Users u Where u.UserNo='" + ((TextBox)Login1.FindControl("UserNo")).Text + "'";
            cmd = new SqlCommand(selectQry, con);
            SqlDataReader rdr = cmd.ExecuteReader();
            if (rdr.Read())
                ((TextBox)Login1.FindControl("UserName")).Text=rdr[0].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {
            cmd.Dispose();
            con.Close();
        }
    }
}
