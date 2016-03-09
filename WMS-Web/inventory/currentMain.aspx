<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="currentMain.aspx.cs" Inherits="inventory_currentMain" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript">
    function KeyDown(){ 
        if (window.event.keyCode == 13) //Enter
        {
            event.returnValue=false;
            event.cancel = true;
            //alert(event.srcElement.type);
            if (event.srcElement.type == 'text' || event.srcElement.type == 'select-one')
            {
                var oCurrentElement = document.getElementById("imgSearch");
                oCurrentElement.click();
            }
	        return false;
        }
    }
    </script>
</head>
<body oncontextmenu="event.returnValue=false" onkeydown="KeyDown()">
    <form id="form1" runat="server">

<table width=100%>
    <tr>
    <td width=100% height="20" background="../images/headerbg.gif">����ѯ</td>
    </tr>
    <tr>
    <td width=100%>
        ѡ��ֿ�:
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT 0 AS WareHouseID,'���вֿ�' AS Description, 'NULL->0' AS Label Union SELECT [WareHouseID], REPLICATE ('|- ', [Level]) + [Description] AS Description, Label FROM dbo.GetWareHouseTreeInfo() order by [Label]"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1"
            DataTextField="Description" DataValueField="WareHouseID">
        </asp:DropDownList>
        <asp:DropDownList ID="drpFilterOption" runat="server">
            <asp:ListItem Text="���ʱ��" Value="ItemID" Selected="True"></asp:ListItem>
            <asp:ListItem Text="��������" Value="Name"></asp:ListItem>
            <asp:ListItem Text="����ͺ�" Value="Specification"></asp:ListItem>
        </asp:DropDownList>
        <asp:TextBox ID="ItemIDTextBox" runat="server" Text='<%#DateTime.Now.ToShortDateString()%>' Width="100px"/>
        <asp:ImageButton ID="imgSearch" runat="server" ImageUrl="~/images/search_y.gif" AlternateText="��ѯ" OnClick="imgSearch_Click" />
        (����ֻ�������ʱ�ŵ�ǰ��λ����ģ����ѯ)
    </td>
    </tr>
    <tr>
    <td width=100%>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [Items].ItemID, [WareHouses].Description AS WareHouseName, [Items].Name, [Items].Specification, [Items].Unit, 
               [Items].StandardPrice, [Inventory].Quantity, [Items].StandardPrice*[Inventory].Quantity as Amount
               FROM [Items] Join [Inventory] ON ([Items].ItemID = [Inventory].ItemID ) 
               Join [WareHouses] ON ([Inventory].WareHouseID = [WareHouses].WareHouseID)
               Where [Inventory].IsDeleted=0
               And [Inventory].WareHouseID in (SELECT WareHouseID FROM dbo.GetWareSubtreeInfo(@WareHouseID)) " >
            <SelectParameters>
                <asp:Parameter Name="WareHouseID" Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>   
        <sk:myGridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="ItemID" DataSourceID="SqlDataSource2"
            Width=98% AllowPaging="True" AllowSorting="True" ShowFooter="true" OnRowDataBound="GridView2_RowDataBound">
        <Columns>
            <asp:TemplateField HeaderText="���ʱ��" SortExpression="ItemID">
                <itemtemplate>
                    <asp:Label runat="server" Text='<%# Bind("ItemID") %>' id="Label1"></asp:Label>
                </itemtemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="WareHouseName" HeaderText="���ڲֿ�" SortExpression="WareHouseName"></asp:BoundField>
            <asp:BoundField DataField="Name" HeaderText="��������" SortExpression="Name"></asp:BoundField>
            <asp:BoundField DataField="Specification" HeaderText="����ͺ�" SortExpression="Specification"></asp:BoundField>
            <asp:BoundField DataField="Unit" HeaderText="������λ" SortExpression="Unit"></asp:BoundField>
            <asp:BoundField DataField="StandardPrice" HeaderText="����" SortExpression="StandardPrice" HtmlEncode= False DataFormatString="{0:C}" >
            </asp:BoundField>
            <asp:BoundField DataField="Quantity" HeaderText="���п��" SortExpression="Quantity">
            </asp:BoundField>
            <asp:BoundField DataField="Amount" HeaderText="���" SortExpression="Amount" HtmlEncode= False DataFormatString="{0:C}" >
            </asp:BoundField>
        </Columns>
        </sk:myGridView> 
    </td>
    </tr>
</table>

    </form>
</body>
</html>
