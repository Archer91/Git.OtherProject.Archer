<%@ Page Language="C#" AutoEventWireup="true" CodeFile="departmentMain.aspx.cs" Inherits="setting_departmentMain" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>" 
        DeleteCommand="DELETE FROM [Accounts_Department] WHERE [DepartmentID] = @DepartmentID"
        InsertCommand="INSERT INTO Accounts_Department VALUES (@DepartName, @ParentDepartID, @Description)"
        SelectCommand="SELECT * FROM [Accounts_Department] WHERE DepartmentID=@DepartmentID" 
        UpdateCommand="UPDATE [Accounts_Department] SET [DepartName] = @DepartName, [ParentDepartID] = @ParentDepartID, [Description] = @Description WHERE [DepartmentID] = @DepartmentID">
        <DeleteParameters>
            <asp:Parameter Name="DepartmentID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="DepartmentID" Type="Int32" />
            <asp:Parameter Name="DepartName" Type="String" />
            <asp:Parameter Name="ParentDepartID" Type="Int32" DefaultValue=0/>
            <asp:Parameter Name="Description" Type="String" />
        </UpdateParameters>
        <SelectParameters>
            <asp:QueryStringParameter Name="DepartmentID" QueryStringField="id"
                Type="Int32" />
        </SelectParameters>        
        <InsertParameters>
            <asp:Parameter Name="DepartmentID" Type="Int32" />
            <asp:Parameter Name="DepartName" Type="String" />
            <asp:Parameter Name="ParentDepartID" Type="Int32" DefaultValue=0 />
            <asp:Parameter Name="Description" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>
    
    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="DepartmentID"
        DataSourceID="SqlDataSource1" OnItemInserted="DetailsView1_ItemInserted"
        OnItemUpdated="DetailsView1_ItemInserted" OnItemDeleted="DetailsView1_ItemInserted" 
        OnItemInserting="DetailsView1_ItemInserting" OnItemUpdating="DetailsView1_ItemUpdating">
        <Fields>
            <asp:BoundField DataField="DepartName" HeaderText="名称" SortExpression="DepartName" />
            <asp:TemplateField HeaderText="上级部门" SortExpression="ParentDepartID">
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("ParentDepartID") %>' Visible="False"></asp:Label>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                        SelectCommand="sp_Accounts_getParentDepartment" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="Label1" Name="ParentDepartID" PropertyName="Text"
                                Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                        DataTextField="Column2" DataValueField="Column1">
                    </asp:DropDownList>
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("ParentDepartID") %>' Visible="False"></asp:Label>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                        SelectCommand="sp_Accounts_getParentDepartment" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="Label1" Name="ParentDepartID" PropertyName="Text"
                                Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                        DataTextField="Column2" DataValueField="Column1" Enabled=false>
                    </asp:DropDownList>
                </ItemTemplate>
                <InsertItemTemplate>
                    <asp:SqlDataSource ID="SqlDataSourceInsert" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                        SelectCommand="sp_Accounts_getParentDepartment" SelectCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:Parameter Name="ParentDepartID" DefaultValue=0 Type="Int32" />
                        </SelectParameters>
                    </asp:SqlDataSource>                
                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSourceInsert"
                        DataTextField="Column2" DataValueField="Column1">
                    </asp:DropDownList>
                </InsertItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Description" HeaderText="备注" SortExpression="Description" />
            <asp:CommandField ShowEditButton="True" ShowInsertButton="True" CancelText="取消" DeleteText="删除" EditText="编辑" InsertText="插入" NewText="新建" UpdateText="确认" />
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:LinkButton ID="btnEditUser" Runat="server" PostBackUrl=<%# "departUser.aspx?DepartID="+Eval("DepartmentID") %>>编辑人员</asp:LinkButton>
                </ItemTemplate>
                <EditItemTemplate>
                </EditItemTemplate>
                <InsertItemTemplate>
                </InsertItemTemplate>
                <ItemStyle HorizontalAlign="Right" />
            </asp:TemplateField>                  
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
