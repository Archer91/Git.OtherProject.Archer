<%@ Page Language="C#" AutoEventWireup="true" CodeFile="supplierMain.aspx.cs" Inherits="setting_supplierMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>" 
            DeleteCommand="DELETE FROM [Supplier] WHERE [SupplierID] = @SupplierID" 
            InsertCommand="INSERT INTO [Supplier] ([NAME], [SPELL], [CODE], [PID],[ADDRESS], [POSTCODE], [BANKID], [BANKCODE], [LINKMAN], [EMAIL], [TEL], [FAX],
                [REMARK]) VALUES (@NAME, @SPELL, @CODE, @PID, 
                @ADDRESS, @POSTCODE, @BANKID, @BANKCODE, @LINKMAN, @EMAIL, @TEL, @FAX,@REMARK)" 
            SelectCommand="SELECT * FROM [Supplier] WHERE ([SupplierID] = @SupplierID)" 
            UpdateCommand="UPDATE [Supplier] SET [NAME] = @NAME, [SPELL] = @SPELL, [CODE] = @CODE, 
                [PID] = @PID, [ADDRESS] = @ADDRESS, [POSTCODE] = @POSTCODE, 
                [BANKID] = @BANKID, [BANKCODE] = @BANKCODE, [LINKMAN] = @LINKMAN, [EMAIL] = @EMAIL, [TEL] = @TEL, [FAX] = @FAX,
                [REMARK] = @REMARK WHERE [SupplierID] = @SupplierID">
            <DeleteParameters>
                <asp:Parameter Name="SupplierID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="NAME" Type="String" />
                <asp:Parameter Name="SPELL" Type="String" />
                <asp:Parameter Name="CODE" Type="String" />
                <asp:Parameter Name="PID" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="POSTCODE" Type="String" />
                <asp:Parameter Name="BANKID" Type="String" />
                <asp:Parameter Name="BANKCODE" Type="String" />
                <asp:Parameter Name="LINKMAN" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="TEL" Type="String" />
                <asp:Parameter Name="FAX" Type="String" />
                <asp:Parameter Name="REMARK" Type="String" />
                <asp:Parameter Name="SupplierID" Type="Int32" />
            </UpdateParameters>
            <SelectParameters>
                <asp:QueryStringParameter DefaultValue="0" Name="SupplierID" QueryStringField="id" Type="String" />
            </SelectParameters>
            <InsertParameters>
                <asp:Parameter Name="NAME" Type="String" />
                <asp:Parameter Name="SPELL" Type="String" />
                <asp:Parameter Name="CODE" Type="String" />
                <asp:Parameter Name="PID" Type="String" />
                <asp:Parameter Name="ADDRESS" Type="String" />
                <asp:Parameter Name="POSTCODE" Type="String" />
                <asp:Parameter Name="BANKID" Type="String" />
                <asp:Parameter Name="BANKCODE" Type="String" />
                <asp:Parameter Name="LINKMAN" Type="String" />
                <asp:Parameter Name="EMAIL" Type="String" />
                <asp:Parameter Name="TEL" Type="String" />
                <asp:Parameter Name="FAX" Type="String" />
                <asp:Parameter Name="REMARK" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT null as SupplierID,'无' as Name Union SELECT SupplierID,Code+','+NAME as Name FROM [Supplier]">
        </asp:SqlDataSource>
        <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" DataKeyNames="SupplierID"
            DefaultMode=Insert DataSourceID="SqlDataSource1" OnItemUpdated="DetailsView1_ItemUpdated">
            <Fields>
                <asp:BoundField DataField="CODE" HeaderText="编码" SortExpression="CODE" />
                <asp:BoundField DataField="NAME" HeaderText="名称" SortExpression="NAME" />
                <asp:BoundField DataField="SPELL" HeaderText="简拼" SortExpression="SPELL" />
                <asp:TemplateField HeaderText="属于" SortExpression="PID">
                    <EditItemTemplate>
                        <asp:DropDownList onchange="window.focus();" ID="drpPID" runat="server" DataSourceID="SqlDataSource4"
                            DataTextField="Name" DataValueField="SupplierID" SelectedValue='<%# Bind("PID") %>'>
                        </asp:DropDownList>
                    </EditItemTemplate>
                    <InsertItemTemplate>
                        <asp:DropDownList onchange="window.focus();" ID="drpPID" runat="server" DataSourceID="SqlDataSource4"
                            DataTextField="Name" DataValueField="SupplierID" SelectedValue='<%# Bind("PID") %>'>
                        </asp:DropDownList>
                    </InsertItemTemplate>
                </asp:TemplateField>                
                <asp:BoundField DataField="ADDRESS" HeaderText="地址" SortExpression="ADDRESS" />
                <asp:BoundField DataField="POSTCODE" HeaderText="邮编" SortExpression="POSTCODE" />
                <asp:BoundField DataField="BANKID" HeaderText="开户银行" SortExpression="BANKID" />
                <asp:BoundField DataField="BANKCODE" HeaderText="银行账号" SortExpression="BANKCODE" />
                <asp:BoundField DataField="LINKMAN" HeaderText="联系人" SortExpression="LINKMAN" />
                <asp:BoundField DataField="EMAIL" HeaderText="EMAIL" SortExpression="EMAIL" />
                <asp:BoundField DataField="TEL" HeaderText="电话" SortExpression="TEL" />
                <asp:BoundField DataField="FAX" HeaderText="传真" SortExpression="FAX" />
                <asp:BoundField DataField="REMARK" HeaderText="备注" SortExpression="REMARK" />
                <asp:CommandField ShowEditButton="True" ShowInsertButton="True" UpdateText="确认" CausesValidation="true" ValidationGroup="QuantityValid" />
            </Fields>
        </asp:DetailsView>        
    </form>
</body>
</html>
