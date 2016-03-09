<%@ Page Language="C#" AutoEventWireup="true" CodeFile="dispatchHisMain.aspx.cs" Inherits="outbound_dispatchHisMain" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
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
            window.parent.detail.location.href="dispatchHisDetail.aspx?id="+intDeliveryID;
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
            SelectCommand="SELECT [DeliveryMain].DeliveryID, [ProjectCategories].Name As ProjectCategoryName,[Accounts_Department].DepartName, 
                [WareHouses].Description As WareHouseName, [DeliveryMain].DeliveryDate, [DeliveryMain].UserName, [DeliveryMain].Description, 
                [DeliveryMain].ReceiverName,[DeliveryMain].IsAccepted,[DeliveryMain].IsReviewed,[DeliveryMain].ReviewerID
                FROM [DeliveryMain] 
                Join [Accounts_Department] On ([DeliveryMain].DepartmentID=[Accounts_Department].DepartmentID) 
                Join [WareHouses] On ([DeliveryMain].WareHouseID=[WareHouses].WareHouseID) 
                Join [ProjectCategories] On ([DeliveryMain].ProjectCategoryID=[ProjectCategories].ProjectCategoryID)
                Where DeliveryDate Between @BeginDate And @EndDate
                ORDER BY [DeliveryMain].DeliveryID DESC"
            UpdateCommand="UPDATE DeliveryMain SET IsReviewed=1,ReviewerID=@ReviewerID WHERE DeliveryID=@DeliveryID"
            DeleteCommand="sp_deleteDelivery" DeleteCommandType="StoredProcedure"
            FilterExpression="WareHouseName='{0}'">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="DeliveryID" Type="Int32" />
                <asp:Parameter Name="ReviewerID" Type="string" />
            </UpdateParameters>
            <DeleteParameters>
                <asp:Parameter Name="DeliveryID" Type="Int32" />
            </DeleteParameters>
            <FilterParameters>
                <asp:Parameter Name="WareHouseName" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <div class="divGridView100">
            <sk:myGridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="DeliveryID" RowStyle-HorizontalAlign="Left"
                DataSourceID="SqlDataSource4" Width=98% OnRowDataBound="GridView3_RowDataBound" 
                OnRowDeleted="GridView3_RowDeleted" OnRowUpdating="GridView3_RowUpdating" OnRowUpdated="GridView3_RowUpdated">
                <Columns>
                    <asp:TemplateField SortExpression="DeliveryID">
                        <ItemTemplate>
                            <div style="color:#265CC0;cursor:hand;width:50px" onclick='readDetail(<%# Eval("DeliveryID") %>)'>
                            <%# Eval("DeliveryID") %>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <img style="cursor:hand;" src="../images/print.gif" alt="打印" onclick="window.open('print.aspx?id=<%# Eval("DeliveryID") %>','_blank','fullscreen=0,menubar=no,location=no,scrollbars=auto,resizable=yes,status=yes')"/>
                        </ItemTemplate>
                    </asp:TemplateField>                    
                    <asp:BoundField DataField="WareHouseName" HeaderText="发料仓库" SortExpression="WareHouseName" />
                    <asp:BoundField DataField="DepartName" HeaderText="领料部门" SortExpression="DepartName" />
                    <asp:BoundField DataField="ProjectCategoryName" HeaderText="生产项目" SortExpression="ProjectCategoryName" />
                    <asp:BoundField DataField="UserName" HeaderText="管库员" SortExpression="UserName" />
                    <asp:CheckBoxField DataField="IsAccepted" HeaderText="已确认" SortExpression="IsAccepted"/>
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
                            <asp:LinkButton ID="btnUpdate" Runat="server" OnClientClick="return confirm('确定该发料单已通过审核？');"
                                CommandName="Update" Visible=false>审核</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" Runat="server" Visible=false CommandName="Delete" OnClientClick="return confirm('确定删除该发料单？');">
                            删除</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnModify" Runat="server" Visible=false
                            OnClientClick="return confirm('确定撤销审核该发料单？');" OnClick="btnModify_Click">
                            撤销审核</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <RowStyle HorizontalAlign="Left" />
            </sk:myGridView>
        </div>
    </form>
</body>
</html>
