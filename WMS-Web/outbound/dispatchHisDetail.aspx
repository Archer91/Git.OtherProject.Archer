<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dispatchHisDetail.aspx.cs" Inherits="outbound_dispatchHisDetail" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script> 
    <link href="../JScripts/lock.css" rel="stylesheet" type="text/css" />
</head>
<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, 
                [DeliveryDetail].[Quantity], [Inventory].[Quantity] As Inventory, [DeliveryDetail].[Quantity]+[Inventory].[Quantity] AS CompareInventory
                FROM [DeliveryDetail], [Items], [Inventory]
                WHERE ([DeliveryDetail].[DeliveryID] = @DeliveryID) AND ([DeliveryDetail].ItemID = [Inventory].ItemID)
                AND [DeliveryDetail].ItemID = [Items].ItemID AND 
                [Inventory].WareHouseID in (Select WareHouseID From DeliveryMain Where DeliveryID=@DeliveryID)  Order By DeliveryDetailID Desc"
            UpdateCommand="sp_updateDeliveryDetail" UpdateCommandType="StoredProcedure" 
            DeleteCommand="sp_deleteDeliveryDetail" DeleteCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="DeliveryID" QueryStringField="id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:QueryStringParameter Name="DeliveryID" QueryStringField="id" Type="Int32" />
                <asp:Parameter Name="ItemID" Type="string" />
                <asp:Parameter Name="Quantity" Type="decimal" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:QueryStringParameter Name="DeliveryID" QueryStringField="id" Type="Int32" />
                <asp:Parameter Name="ItemID" Type="string" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <div > 
            <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging="False" Width=98%  DataKeyNames="ItemID"
                DataSourceID="SqlDataSource5" OnRowDataBound="GridView4_RowDataBound" ShowFooter=true 
                OnDataBound="GridView4_DataBound" OnRowEditing="GridView4_RowEditing">
                <Columns>
                    <asp:TemplateField HeaderText="物资编号" SortExpression="ItemID">
                        <ItemTemplate>
                            <%# Eval("ItemID")%>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:DropDownList ID="drpItem" runat="server" DataTextField="ItemID" DataValueField="ItemID"
                                onkeyup="dropKeyUp()" onkeypress="catch_press(this);" Visible="false">
                            </asp:DropDownList>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="物资名称" SortExpression="Name">
                        <ItemTemplate>
                            <%# Eval("Name")%>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:LinkButton ID="LinkButtonEditAdd" runat="server" Visible="false"
                                Text="快速添加" OnClick="LinkButtonEditAdd_Click">
                            </asp:LinkButton>
                        </FooterTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" ReadOnly="true"/>
                    <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" ReadOnly="true"/>
                    <asp:TemplateField HeaderText="实发数量" SortExpression="Quantity">
                        <ItemTemplate>
                            <%# Eval("Quantity") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtQuantity" runat="server" Width="60px" Text='<%# Bind("Quantity") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtQuantity"
                                ErrorMessage="请输入数量！" ValidationGroup="QuantityEditValid" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtQuantity"
                                Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityEditValid"></asp:RegularExpressionValidator>
                            <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="超过库存！" 
                                ValueToCompare='<%# Eval("CompareInventory")%>' ControlToValidate="txtQuantity" Operator="LessThanEqual" 
                                Type=Double ValidationGroup="QuantityEditValid" Display="Dynamic"></asp:CompareValidator>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="库存" SortExpression="Inventory">
                        <ItemTemplate>
                            <%# Eval("Inventory")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true"/>
                    <asp:TemplateField HeaderText="发料金额" SortExpression="TotalPrice">
                        <ItemTemplate>
                            <%# String.Format("{0:C}", Convert.ToDecimal(Eval("Quantity")) * Convert.ToDecimal(Eval("StandardPrice")))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField CancelText="取消" 
                        DeleteText="删除" EditText="编辑" InsertText="插入" NewText="新增" 
                        SelectText="选取" UpdateText="确认" ValidationGroup="QuantityEditValid" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDeleteOne" Runat="server" 
                                OnClientClick="return confirm('确定删除该条记录？');"
                                CommandName="Delete">删除</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </sk:myGridView>
        </div>
    </form>
</body>
</html>
