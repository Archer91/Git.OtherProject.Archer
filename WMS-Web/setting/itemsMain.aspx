<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="itemsMain.aspx.cs" Inherits="setting_itemsMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>

    <script>
    function autoGetCategoryID(oTextbox)
    {
        var len = oTextbox.value.length;
        var idTextbox = oTextbox.id;
        var targetTextbox = idTextbox.substring(0,idTextbox.length-1)+"3";
        var oTargetTextbox = document.getElementById(targetTextbox);
        if (len<5)
        {
            oTargetTextbox.value = oTextbox.value;
        }
        else
        {
            oTargetTextbox.value = oTextbox.value.substring(0,4);
        }
    }
    
    function getCategoryID(oTextbox)
    {
        document.getElementById("hidCategoryID").value = oTextbox.value;
        return true;
    }
    </script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:HiddenField ID="hidCategoryID" runat="server" />
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            DeleteCommand="sp_deleteItemsByID" DeleteCommandType="StoredProcedure"
            InsertCommand="INSERT INTO [Items] ([ItemID], [ItemCategoryID], [Name], [EconomicBatch], [Specification], [StandardPrice], [Unit], 
                [Description], [IsDeleted]) VALUES (@ItemID, @ItemCategoryID, @Name, 
                @EconomicBatch, @Specification, @StandardPrice, @Unit, 
                @Description, @IsDeleted)"
            SelectCommand="SELECT * FROM [Items] WHERE ([ItemID] = @ItemID)" 
            UpdateCommand="UPDATE [Items] SET [Name] = @Name, [ItemCategoryID] = @ItemCategoryID, [EconomicBatch] = @EconomicBatch, 
                [Specification] = @Specification, [StandardPrice] = @StandardPrice, [Unit] = @Unit,
                [Description] = @Description,[IsDeleted]=@IsDeleted WHERE [ItemID] = @ItemID">
            <DeleteParameters>
                <asp:Parameter Name="ItemID" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="ItemCategoryID" Type="String" />
                <asp:Parameter Name="EconomicBatch" Type="Int32" />
                <asp:Parameter Name="Specification" Type="String" />
                <asp:Parameter Name="StandardPrice" Type="Decimal" />
                <asp:Parameter Name="Unit" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="ItemID" Type="String" />
                <asp:Parameter Name="IsDeleted" Type="Boolean" />
            </UpdateParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="GridView1" Name="ItemID" PropertyName="SelectedValue"
                    Type="String" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="ItemID" Type="String" />
                <asp:Parameter Name="ItemCategoryID" Type="String" />
                <asp:Parameter Name="Name" Type="String" />
                <asp:Parameter Name="EconomicBatch" Type="Int32" />
                <asp:Parameter Name="Specification" Type="String" />
                <asp:Parameter Name="StandardPrice" Type="Decimal" />
                <asp:Parameter Name="Unit" Type="String" />
                <asp:Parameter Name="Description" Type="String" />
                <asp:Parameter Name="IsDeleted" Type="Boolean" />                
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="ItemID" DefaultMode=Insert
            DataSourceID="SqlDataSource2" OnItemDeleted="FormView1_ItemDeleted" OnItemInserted="FormView1_ItemInserted" 
            OnItemUpdated="FormView1_ItemUpdated" >
            <InsertItemTemplate>
                <table width=100%>
                    <tr>
                        <td align=left>物资编号:</td>
                        <td><asp:TextBox ID="TextBox1" runat="server" Text=<%# Bind("ItemID")%> onKeyUp="autoGetCategoryID(this);">
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1"
                            ErrorMessage="请输入编号！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
                        </td>
                        <td align=left>物资名称:</td>
                        <td><asp:TextBox ID="TextBox2" runat="server" Text=<%# Bind("Name")%>>
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2"
                            ErrorMessage="请输入名称！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
                        </td>
                        <td align=left>物资种类:</td>
                        <td><asp:TextBox ID="TextBox3" runat="server" Text=<%# Bind("ItemCategoryID")%>>
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="TextBox3"
                            ErrorMessage="请输入种类！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
                        </td>
                    </tr>
                    <tr>
                        <td align=left>经济批量:</td>
                        <td><asp:TextBox ID="TextBox4" runat="server" Text=<%# Bind("EconomicBatch")%>>
                        </asp:TextBox>
                        </td>
                        <td align=left>规格型号:</td>
                        <td><asp:TextBox ID="TextBox5" runat="server" Text=<%# Bind("Specification")%>>
                        </asp:TextBox></td>
                        <td align=left>标准单价:</td>
                        <td><asp:TextBox ID="TextBox6" runat="server" Text=<%# Bind("StandardPrice")%>>
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="TextBox6"
                            ErrorMessage="请输入标准单价！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
                        </td>
                    </tr>
                    <tr>
                        <td align=left>计量单位:</td>
                        <td><asp:TextBox ID="TextBox7" runat="server" Text=<%# Bind("Unit")%>>
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="TextBox7"
                            ErrorMessage="请输入计量单位！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
                        </td>
                        <td align=left>删除标记:</td>
                        <td><asp:CheckBox ID="CheckBox2" runat="server" Checked=<%# Bind("IsDeleted") %> /></td>
                    </tr>
                    <tr>
                        <td align=left>备注:</td>
                        <td colspan=5><asp:TextBox ID="TextBox10" runat="server" Width=100% Text=<%# Bind("Description")%>>
                        </asp:TextBox></td>
                    </tr>
                    <tr><td colspan=3 align=right>              
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" ValidationGroup="QuantityValid" CommandName="Insert"
                            Text="保存"  OnClientClick="return getCategoryID(FormView1_TextBox3);">
                        </asp:LinkButton>
                        </td>
                        <td></td>
                        <td colspan=2 align=left>
                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                            Text="取消">
                        </asp:LinkButton>
                        </td></tr>
                </table>
            </InsertItemTemplate>
            <EditItemTemplate>
                <table width=100%>
                    <tr>
                        <td align=left>物资编号:</td>
                        <td><asp:TextBox ID="TextBox1" runat="server" Enabled="false" Text=<%# Bind("ItemID")%>>
                        </asp:TextBox></td>
                        <td align=left>物资名称:</td>
                        <td><asp:TextBox ID="TextBox2" runat="server" Text=<%# Bind("Name")%>>
                        </asp:TextBox></td>
                        <td align=left>物资种类:</td>
                        <td><asp:TextBox ID="TextBox3" runat="server" Enabled="false" Text=<%# Bind("ItemCategoryID")%>>
                        </asp:TextBox></td>
                    </tr>
                    <tr>
                        <td align=left>经济批量:</td>
                        <td><asp:TextBox ID="TextBox4" runat="server" Text=<%# Bind("EconomicBatch")%>>
                        </asp:TextBox>
                        </td>
                        <td align=left>规格型号:</td>
                        <td><asp:TextBox ID="TextBox5" runat="server" Text=<%# Bind("Specification")%>>
                        </asp:TextBox></td>
                        <td align=left>标准单价:</td>
                        <td><asp:TextBox ID="TextBox6" runat="server" Text=<%# Bind("StandardPrice")%>>
                        </asp:TextBox></td>
                    </tr>
                    <tr>
                        <td align=left>计量单位:</td>
                        <td><asp:TextBox ID="TextBox7" runat="server" Text=<%# Bind("Unit")%>>
                        </asp:TextBox>
                        </td>
                        <td align=left>删除标记:</td>
                        <td><asp:CheckBox ID="CheckBox2" runat="server" Checked=<%# Bind("IsDeleted") %> /></td>
                    </tr>
                    <tr>
                        <td align=left>备注:</td>
                        <td colspan=5><asp:TextBox ID="TextBox10" runat="server" Width=100% Text=<%# Bind("Description")%>>
                        </asp:TextBox></td>
                    </tr>
                    <tr><td colspan=3 align=right>              
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" ValidationGroup="QuantityValid" CommandName="Update"
                            Text="保存更改">
                        </asp:LinkButton>
                        </td>
                        <td></td>
                        <td align=left>
                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                            Text="取消">
                        </asp:LinkButton>
                        </td>
                        <td align=right>
                            <asp:LinkButton ID="LinkButton1" Runat="server" 
                                OnClientClick="return confirm('确定删除该条记录？');"
                                CommandName="Delete">删除</asp:LinkButton>
                        </td>
                        </tr>
                </table>
            </EditItemTemplate>
        </asp:FormView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [ItemID], [Name], [Specification], [Unit], [StandardPrice],[IsDeleted] FROM [Items] WHERE [ItemCategoryID] in (Select ItemCategoryID From dbo.GetItemCategoryTreeInfo(@ItemCategoryID))">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemCategoryID" QueryStringField="id" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ItemID"
            DataSourceID="SqlDataSource1" Width=100% AllowPaging="True" AllowSorting="true" 
            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" >
            <Columns>   
                <asp:CommandField ShowSelectButton="True" SelectText="详情" />
                <asp:CheckBoxField DataField="IsDeleted" HeaderText="删除标记" SortExpression="IsDeleted"/>
                <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID" />
                <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name" />
                <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" />
                <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" />
                <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" />
            </Columns>
        </sk:myGridView>
    </form>
</body>
</html>
