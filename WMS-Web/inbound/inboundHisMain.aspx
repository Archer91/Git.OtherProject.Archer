<%@ Page Language="C#" AutoEventWireup="true" CodeFile="inboundHisMain.aspx.cs" Inherits="inbound_inboundHisMain" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
    <script type="text/javascript" src="../JScripts/enterKey.js"></script>
    <link href="../JScripts/lock.css" rel="stylesheet" type="text/css" />
    <script type="text/javascript">

        function readDetail(intDeliveryID)
        {
            var oCurrentElement = event.srcElement;
            var table = document.getElementById("GridView3");
            var rows = table.getElementsByTagName("tr");
            for (var i=0;i<rows.length;i++)
            {
                rows[i].style.color = "#000000";
            }
            oCurrentElement.parentNode.parentNode.style.color="red";
            window.parent.detail.location.href="inboundHisDetail.aspx?id="+intDeliveryID;
        }
    </script>
</head>
<body onkeydown="KeyDown()" oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        从<asp:TextBox ID="BeginDateTextBox" runat="server" Width="100px">
        </asp:TextBox>
        <obout:calendar id="Calendar2" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
            datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
            scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>
        到<asp:TextBox ID="EndDateTextBox" runat="server" Width="100px">
        </asp:TextBox>
        <obout:calendar id="Calendar3" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
            datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
            scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>

        &nbsp;&nbsp;
        选择仓库:
        <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT 0 AS WareHouseID,'所有仓库' AS Description, 'NULL->0' AS Label Union SELECT [WareHouseID], REPLICATE ('|- ', [Level]) + [Description] AS Description, Label FROM dbo.GetWareHouseTreeInfo() order by [Label]"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource6"
            DataTextField="Description" DataValueField="WareHouseID">
        </asp:DropDownList>
        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="刷新" OnClick="btnRefresh_Click" />
        <br />
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT [ReceiptMain].ReceiptID, [ReceiptMain].ReceivingCode, [ReceiptMain].ContractID, [ReceiptMain].ArriveDate, 
                [ReceiptMain].ReceiverID, [ReceiptMain].CheckerID, [WareHouses].Description As WareHouseName, [Supplier].Name AS SupplierName,
                [ReceiptMain].Freight, [ReceiptMain].IsReviewed, [ReceiptMain].ReviewerID,
                [ReceiptMain].Description FROM [ReceiptMain] 
                JOIN [WareHouses] ON ([ReceiptMain].WareHouseID = [WareHouses].WareHouseID) 
                JOIN [Supplier] ON ([ReceiptMain].SupplierID = [Supplier].SupplierID)
                Where ArriveDate Between @BeginDate And @EndDate
                ORDER BY ReceiptID DESC"
            UpdateCommand="Update ReceiptMain Set IsReviewed=1,ReviewerID=@ReviewerID Where ReceiptID=@ReceiptID"
            DeleteCommand="sp_deleteReceipt" DeleteCommandType="StoredProcedure"
            FilterExpression="WareHouseName='{0}'">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="ReceiptID" Type="Int32" />
                <asp:Parameter Name="ReviewerID" Type="String" />
            </UpdateParameters>
            <FilterParameters>
                <asp:Parameter Name="WareHouseName" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <div class="divGridView100">
        <sk:myGridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False"
            DataKeyNames="ReceiptID" DataSourceID="SqlDataSource4" Width="98%" 
            OnRowDataBound="GridView3_RowDataBound" OnRowUpdating="GridView3_RowUpdating" 
            OnRowUpdated="GridView3_RowUpdated" OnRowDeleted="GridView3_RowDeleted">
            <Columns>
                <asp:TemplateField SortExpression="ReceiptID">
                    <ItemTemplate>
                        <div style="color:#265CC0;cursor:hand;width=50px" onclick='readDetail(<%# Eval("ReceiptID") %>)'>
                        <%# Eval("ReceiptID")%>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="WareHouseName" HeaderText="仓库" SortExpression="WareHouseName" />
                <asp:BoundField DataField="SupplierName" HeaderText="供货商" SortExpression="SupplierName" />
                <asp:BoundField DataField="ReceivingCode" HeaderText="料单号" InsertVisible="False" ReadOnly="True" SortExpression="ReceivingCode" />
                <asp:BoundField DataField="ContractID" HeaderText="合同号" InsertVisible="False" ReadOnly="True" SortExpression="ContractID" />                    
                <asp:TemplateField HeaderText="入库日期" SortExpression="ArriveDate">
                    <ItemTemplate>
                        <asp:Label ID="lblArriveDate" runat="server" Text='<%# ((DateTime)Eval("ArriveDate")).ToShortDateString() %>' width="80px"></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ReceiverID" HeaderText="管库员" SortExpression="ReceiverID" />
                <asp:BoundField DataField="CheckerID" HeaderText="检验员" SortExpression="CheckerID" />
                <asp:TemplateField HeaderText="运杂费"  SortExpression="Freight">
                    <ItemTemplate>
                        <%# String.Format("{0:C}", Eval("Freight")) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:CheckBoxField DataField="IsReviewed" HeaderText="已审核" SortExpression="IsReviewed" />
                <asp:BoundField DataField="ReviewerID" HeaderText="审核员" SortExpression="ReviewerID" />
                <asp:TemplateField HeaderText="备注" SortExpression="Description">
                    <ItemTemplate>
                        <div style="width:100px;overflow: hidden; text-overflow:ellipsis;word-break:keep-all" title=<%# Eval("Description")%>>
                        <%# Eval("Description")%>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnUpdate" Runat="server" 
                            OnClientClick="return confirm('确定该入库单已通过审核？');"
                            CommandName="Update" Visible=false>审核</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:LinkButton ID="btnDelete" Runat="server" Visible=false CommandName="Delete" 
                        OnClientClick="return confirm('确定删除该入库单？');">
                        删除</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </sk:myGridView>
        </div>
    </form>
</body>
</html>
