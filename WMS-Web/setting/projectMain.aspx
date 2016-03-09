<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="projectMain.aspx.cs" Inherits="setting_projectMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>

</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            DeleteCommand="DELETE FROM [projectCategories] WHERE [projectCategoryID] = @projectCategoryID"
            InsertCommand="INSERT INTO [projectCategories] ([Name], [ParentID], [Unit]) VALUES (@Name, @ParentID, @Unit)"
            SelectCommand="SELECT * FROM [projectCategories] WHERE ([projectCategoryID] = @projectCategoryID)"
            UpdateCommand="UPDATE [projectCategories] SET [Name] = @Name, [ParentID] = @ParentID, [Unit] = @Unit WHERE [projectCategoryID] = @projectCategoryID">
            <DeleteParameters>
                <asp:Parameter Name="projectCategoryID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="ParentID" Type="Int32" />
                <asp:Parameter Name="Unit" Type="String" />
                <asp:Parameter Name="projectCategoryID" Type="Int32" />
            </UpdateParameters>
            <SelectParameters>
                <asp:QueryStringParameter Name="projectCategoryID" QueryStringField="id"
                    Type="Int32" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="ParentID" Type="Int32" />
                <asp:Parameter Name="Unit" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="projectCategoryID"
            DataSourceID="SqlDataSource1" OnItemInserted="DetailsView1_ItemInserted"
            OnItemUpdated="DetailsView1_ItemInserted" OnItemDeleted="DetailsView1_ItemInserted" OnItemInserting="DetailsView1_ItemInserting" OnItemUpdating="DetailsView1_ItemUpdating">
            <Fields>
                <asp:BoundField DataField="Name" HeaderText="项目名称" SortExpression="Name" />
                <asp:TemplateField HeaderText="上级项目" SortExpression="ParentID">
                    <EditItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ParentID") %>' Visible="False"></asp:Label>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                            SelectCommand="sp_getParentPlan" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Label1" Name="ParentID" PropertyName="Text"
                                    Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                            DataTextField="Column2" DataValueField="Column1">
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:SqlDataSource ID="SqlDataSourceInsert" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                            SelectCommand="sp_getParentPlan" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:Parameter Name="ParentID" DefaultValue=0 Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceInsert"
                            DataTextField="Column2" DataValueField="Column1">
                        </asp:DropDownList>
                    </InsertItemTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ParentID") %>' Visible="False"></asp:Label>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                            SelectCommand="sp_getParentPlan" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:ControlParameter ControlID="Label1" Name="ParentID" PropertyName="Text"
                                    Type="Int32" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                            DataTextField="Column2" DataValueField="Column1" Enabled=false>
                        </asp:DropDownList>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" />
                <asp:CommandField ShowEditButton="True" ShowInsertButton="True" CancelText="取消" DeleteText="删除" EditText="编辑" InsertText="插入" NewText="新建" UpdateText="确认" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" Runat="server" 
                            OnClientClick="return confirm('确定删除该条记录？');"
                            CommandName="Delete">删除</asp:LinkButton>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Right" />
                </asp:TemplateField>      
            </Fields>
        </asp:DetailsView>
    </form>
</body>
</html>
