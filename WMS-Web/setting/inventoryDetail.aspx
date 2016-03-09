<%@ Page Language="C#" AutoEventWireup="true" CodeFile="inventoryDetail.aspx.cs" Inherits="setting_inventoryDetail" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script>
</head>
<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            DeleteCommand="UPDATE [Inventory] SET [IsDeleted] = 1 WHERE [InventoryID] = @InventoryID" 
            SelectCommand="SELECT * FROM [Inventory] WHERE ([ItemID] = @ItemID AND [WareHouseID] = @WareHouseID)" 
            UpdateCommand="UPDATE [Inventory] SET [ItemID] = @ItemID, [WareHouseID] = @WareHouseID, [OriginalQuantity] = @OriginalQuantity, [LowestInventory] = @LowestInventory, [ReorderInventory] = @ReorderInventory, [HighestInventory] = @HighestInventory, [ABCCategory] = @ABCCategory, [TurnOver] = @TurnOver, [Quantity] = @OriginalQuantity, [Position] = @Position, [IsDeleted] = @IsDeleted WHERE [InventoryID] = @InventoryID">
            <SelectParameters>
                <asp:QueryStringParameter Name="ItemID" QueryStringField="ItemID"
                    Type="String" />
                <asp:QueryStringParameter Name="WareHouseID" QueryStringField="id" Type="String" />
            </SelectParameters>            
            <DeleteParameters>
                <asp:Parameter Name="InventoryID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="ItemID" Type="String" />
                <asp:Parameter Name="WareHouseID" Type="Int32" />
                <asp:Parameter Name="OriginalQuantity" Type="Decimal" />
                <asp:Parameter Name="LowestInventory" Type="Decimal" />
                <asp:Parameter Name="ReorderInventory" Type="Decimal" />
                <asp:Parameter Name="HighestInventory" Type="Decimal" />
                <asp:Parameter Name="ABCCategory" Type="String" />
                <asp:Parameter Name="TurnOver" Type="Decimal" />
                <asp:Parameter Name="Quantity" Type="Decimal" />
                <asp:Parameter Name="Position" Type="String" />
                <asp:Parameter Name="IsDeleted" Type="Boolean" />
                <asp:Parameter Name="InventoryID" Type="Int32" />
            </UpdateParameters>
        </asp:SqlDataSource>
        <asp:FormView ID="FormView1" runat="server" DataKeyNames="InventoryID" DataSourceID="SqlDataSource1"
            DefaultMode=Insert OnItemDeleted="FormView1_ItemDeleted" OnItemUpdated="FormView1_ItemUpdated" 
            OnItemUpdating="FormView1_ItemUpdating">
            <EditItemTemplate>
                <table width=100%>
                    <tr>
                        <td align=left>所在仓库:</td>
                        <td><asp:TextBox ID="WareHouseIDTextBox" runat="server" Enabled="false" Text=<%# GetWareHouseName(Convert.ToInt32(Request.QueryString["id"]))%>>
                        </asp:TextBox></td>
                        <td align=left>物资编号:</td>
                        <td><asp:TextBox ID="ItemIDTextBox" runat="server" Enabled="false" Text=<%# Bind("ItemID")%>>
                        </asp:TextBox></td>
                        <td align=left>期初库存:</td>
                        <td><asp:TextBox ID="OriginalQuantityTextBox" runat="server" Text=<%# Bind("OriginalQuantity")%>>
                        </asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="OriginalQuantityTextBox"
                            ErrorMessage="请输入数量！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="OriginalQuantityTextBox"
                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align=left>最低库存:</td>
                        <td><asp:TextBox ID="LowestInventoryTextBox" runat="server" Text=<%# Bind("LowestInventory")%>>
                        </asp:TextBox></td>
                        <td align=left>最优库存:</td>
                        <td><asp:TextBox ID="ReorderInventoryTextBox" runat="server" Text=<%# Bind("ReorderInventory")%>>
                        </asp:TextBox></td>
                        <td align=left>最高库存:</td>
                        <td><asp:TextBox ID="HighestInventoryTextBox" runat="server" Text=<%# Bind("HighestInventory")%>>
                        </asp:TextBox></td>
                    </tr>
                    <tr>
                        <td align=left>ABC分类:</td>
                        <td><asp:TextBox ID="ABCCategoryTextBox" runat="server" Text=<%# Bind("ABCCategory")%>>
                        </asp:TextBox></td>
                        <td align=left>最低周转率:</td>
                        <td><asp:TextBox ID="TurnOverTextBox" runat="server" Text=<%# Bind("TurnOver")%>>
                        </asp:TextBox></td>
                        <td align=left>四号定位:</td>
                        <td>            
                            <asp:TextBox ID="PositionTextBox" runat="server" Text=<%# Bind("Position")%>/>
                        </td>
                    </tr>
                    <tr>
                        <td align=left>删除标记:</td>
                        <td><asp:CheckBox ID="IsDeletedCheckBox" runat="server" Checked=<%# Bind("IsDeleted") %> /></td>
                    </tr>
                    <tr><td colspan=3 align=right>              
                        <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" ValidationGroup="QuantityValid"
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
    </form>
</body>
</html>
