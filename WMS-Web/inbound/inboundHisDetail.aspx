<%@ Page Language="C#" AutoEventWireup="true" CodeFile="inboundHisDetail.aspx.cs" Inherits="inbound_inboundHisDetail" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script> 
    <link href="../JScripts/lock.css" rel="stylesheet" type="text/css" />
</head>
<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [ReceiptDetail].Quantity, [ReceiptDetail].Price, [ReceiptDetail].ReceiptDetailID
             FROM [ReceiptDetail] Join [Items] ON ([ReceiptDetail].ItemID = [Items].ItemID ) WHERE ([ReceiptDetail].ReceiptID = @ReceiptID) ORDER BY [ReceiptDetail].ReceiptDetailID DESC"
            UpdateCommand="sp_updateReceiptDetail" UpdateCommandType="storedProcedure" 
            DeleteCommand="sp_deleteReceiptDetail" DeleteCommandType="storedProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="ReceiptID" QueryStringField="id" Type="Int32" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ReceiptDetailID" Type="Int32" />
                <asp:Parameter Name="Price" Type="decimal" />
                <asp:Parameter Name="Quantity" Type="decimal" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="ReceiptDetailID" Type="Int32" />
            </DeleteParameters>
        </asp:SqlDataSource>
        <div class="divGridView100">
        <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging="true" Width="98%" DataKeyNames="ReceiptDetailID"
            DataSourceID="SqlDataSource5" OnRowDataBound="GridView4_RowDataBound" ShowFooter="true" OnDataBound="GridView4_DataBound" OnRowUpdating="GridView4_RowUpdating">
            <Columns>
                <asp:TemplateField HeaderText="物资编号" SortExpression="ItemID" FooterStyle-HorizontalAlign="left">
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
                <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" ReadOnly="true" />
                <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" ReadOnly="true" />
                <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= "false" DataFormatString="{0:C}" ReadOnly="true" />
                <asp:TemplateField HeaderText="实际单价" SortExpression="Price">
                    <ItemTemplate>
                        <%# String.Format("{0:C}", Eval("Price"))%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtPrice" runat="server" Width="50" Text='<%# Bind("Price") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPrice"
                            ErrorMessage="请输入实际单价！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPrice"
                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="实收数量" SortExpression="Quantity">
                    <ItemTemplate>
                        <%# Eval("Quantity")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtQuantity" runat="server" Width=40 Text='<%# Bind("Quantity") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtQuantity"
                            ErrorMessage="请输入实收数量！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtQuantity"
                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                    </EditItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="料差" SortExpression="Margin">
                    <ItemTemplate>
                        <%# String.Format("{0:C}", (Convert.ToDecimal(Eval("Price")) - Convert.ToDecimal(Eval("StandardPrice")))*Convert.ToDecimal(Eval("Quantity")))%>
                    </ItemTemplate>
                </asp:TemplateField>
                            
                <asp:CommandField ShowEditButton="True" CancelText="取消" 
                    DeleteText="删除" EditText="编辑" InsertText="插入" NewText="新增" 
                    SelectText="选取" UpdateText="确认" ValidationGroup="QuantityValid" />
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" Runat="server" 
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
