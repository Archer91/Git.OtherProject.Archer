<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="inventoryMain.aspx.cs" Inherits="setting_inventoryMain" %>
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script>
    <script type="text/javascript">
        function readDetail(intID,strItemID)
        {
            var oCurrentElement = event.srcElement;
            var table = document.getElementById("GridView1");
            var rows = table.getElementsByTagName("tr");
            for (var i=0;i<rows.length;i++)
            {
                rows[i].style.color = "#000000";
            }
            oCurrentElement.parentNode.parentNode.style.color="red";
            window.parent.detail.location.href="inventoryDetail.aspx?id="+intID+"&ItemID="+strItemID;
        }
    </script>
</head>
<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <div align=center>
            <asp:Label ID="lblTitle" runat="server" CssClass="title2"></asp:Label>
        </div>
        <div id="divAll" runat="server">
        <asp:RadioButton ID="radioBrowserDetails" runat="server" autopostback="true" 
          GroupName="SearchType" 
          Text="���" 
          OnCheckedChanged="radioButtonDetails_CheckedChanged" Checked=true />
        <asp:RadioButton ID="radioInsertDetails" runat="server" autopostback="true" 
          GroupName="SearchType" 
          Text="����"
          OnCheckedChanged="radioButtonDetails_CheckedChanged" />
        <asp:Label ID="Label1" runat="server" Width=50pt></asp:Label>
        <asp:Button ID="btnAuto" runat="server" Text="���������ŵ���������" OnClientClick="JavaScript: return confirm('��ȷ�϶���ÿ������ŵ�����������');" OnClick="btnAuto_Click" />
        &nbsp;&nbsp;���ʱ��:
        <asp:TextBox ID="ItemIDTextBox" runat="server" Width="100px"/>
        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="ˢ��" OnClick="btnRefresh_Click" />

        <br /> <br />
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [Items].[ItemID], [Name], [Specification], [Unit], [StandardPrice], 
                [Inventory].[IsDeleted],[Inventory].[OriginalQuantity],ReorderInventory,Quantity FROM [Items],[Inventory] 
                WHERE [WareHouseID]=@WareHouseID
                AND [Items].[ItemID]=[Inventory].[ItemID]
                Order By [InventoryID] DESC"
                FilterExpression="ItemID like '{0}'">
            <SelectParameters>
                <asp:QueryStringParameter Name="WareHouseID" QueryStringField="id" Type="String" />
            </SelectParameters>
            <FilterParameters>
                <asp:Parameter Name="ItemID" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="ItemID"
            DataSourceID="SqlDataSource2" Width=100% AllowPaging="True" AllowSorting="true"
            OnSelectedIndexChanged="GridView1_SelectedIndexChanged" OnRowDataBound="GridView1_RowDataBound" 
            OnPageIndexChanged="GridView1_PageIndexChanged" OnSorted="GridView1_Sorted">
            <Columns>
                <asp:TemplateField HeaderText="���ʱ��" SortExpression="ItemID">
                    <ItemTemplate>
                        <div style="color:#265CC0;cursor:hand;" onclick="readDetail('<%=Request.QueryString["id"] %>','<%# Eval("ItemID") %>');">
                        <%# Eval("ItemID") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CheckBoxField DataField="IsDeleted" HeaderText="ɾ�����" SortExpression="IsDeleted"/>
                <asp:BoundField DataField="Name" HeaderText="��������" SortExpression="Name" />
                <asp:BoundField DataField="Specification" HeaderText="����ͺ�" SortExpression="Specification" />
                <asp:BoundField DataField="Unit" HeaderText="������λ" SortExpression="Unit" />
                <asp:BoundField DataField="StandardPrice" HeaderText="��׼����" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" />
                <asp:BoundField DataField="OriginalQuantity" HeaderText="�ڳ����" SortExpression="OriginalQuantity"/>
                <asp:BoundField DataField="ReorderInventory" HeaderText="���ſ��" SortExpression="ReorderInventory"/>
                <asp:BoundField DataField="Quantity" HeaderText="���п��" SortExpression="Quantity"/>
            </Columns>
        </sk:myGridView>
        <asp:SqlDataSource ID="SqlDataSource3" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="sp_selectAvailableItemsByWareHouseID" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter Name="WareHouseID" QueryStringField="id" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="ItemID"
            DataSourceID="SqlDataSource3" Width=100% AllowPaging="True" AllowSorting="True" 
            Visible="false" OnRowDataBound="GridView2_RowDataBound" OnSelectedIndexChanged="GridView2_SelectedIndexChanged" OnDataBound="GridView2_DataBound">
            <Columns>
                <asp:CommandField ShowSelectButton="True" SelectText="���" />
                <asp:BoundField DataField="ItemID" HeaderText="���ʱ��" SortExpression="ItemID"></asp:BoundField>
                <asp:BoundField DataField="Name" HeaderText="��������" SortExpression="Name"></asp:BoundField>
                <asp:BoundField DataField="Specification" HeaderText="����ͺ�" SortExpression="Specification"></asp:BoundField>
                <asp:BoundField DataField="Unit" HeaderText="������λ" SortExpression="Unit"></asp:BoundField>
                <asp:BoundField DataField="StandardPrice" HeaderText="����" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" />
            </Columns>
        </sk:myGridView>
        </div>
    </form>
</body>
</html>
