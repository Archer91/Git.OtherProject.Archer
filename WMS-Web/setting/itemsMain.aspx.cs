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

public partial class setting_itemsMain : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["type"] == "0")
            SqlDataSource1.SelectCommand = "SELECT [ItemID], [Name], [Specification], [Unit], [StandardPrice],[IsDeleted] FROM [items] WHERE [ItemCategoryID] in (Select ItemCategoryID From dbo.GetItemCategoryTreeInfo(@ItemCategoryID))";
        else
            SqlDataSource1.SelectCommand = "SELECT [ItemID], [Name], [Specification], [Unit], [StandardPrice],[IsDeleted] FROM [items] WHERE [ItemID] like @ItemCategoryID+'%'";
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        FormView1.ChangeMode(FormViewMode.Edit);
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Center;
            e.Row.Cells[5].HorizontalAlign = HorizontalAlign.Right;
            e.Row.Cells[6].HorizontalAlign = HorizontalAlign.Right;

            bool isDeleted = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsDeleted"));
            if (isDeleted)
                e.Row.BackColor = System.Drawing.Color.LightGray;
        }

    }

    protected void FormView1_ItemDeleted(object sender, FormViewDeletedEventArgs e)
    {
        GridView1.DataBind();
    }
    protected void FormView1_ItemInserted(object sender, FormViewInsertedEventArgs e)
    {
        GridView1.DataBind();
    }
    protected void FormView1_ItemUpdated(object sender, FormViewUpdatedEventArgs e)
    {
        GridView1.DataBind();
    }
}
