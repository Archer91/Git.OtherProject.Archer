<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="dispatchConfirm.aspx.cs" Inherits="outbound_dispatchConfirm" Title="Untitled Page" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
<table width=100%>
    <tr>
    <td width=100% height="20" background="../images/headerbg.gif">发料历史列表</td>
    </tr>
    <tr>
    <td width=100%>
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

        选择仓库:
        <asp:SqlDataSource ID="SqlDataSource6" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT 0 AS WareHouseID,'所有仓库' AS Description, 'NULL->0' AS Label Union SELECT [WareHouseID], REPLICATE ('|- ', [Level]) + [Description] AS Description, Label FROM dbo.GetWareHouseTreeInfo() order by [Label]"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource6"
            DataTextField="Description" DataValueField="WareHouseID">
        </asp:DropDownList>
        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="刷新" OnClick="btnRefresh_Click" />
        <br />
    </td>
    </tr>
    <tr>
    <td width=100%>
    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
        SelectCommand="SELECT [DeliveryMain].DeliveryID, [ProjectCategories].Name As ProjectCategoryName,[Accounts_Department].DepartName, 
            [WareHouses].Description As WareHouseName, [DeliveryMain].DeliveryDate, [DeliveryMain].UserName, [DeliveryMain].Description, 
            [DeliveryMain].ReceiverName, [DeliveryMain].IsAccepted FROM [DeliveryMain] 
            Join [Accounts_Department] On ([DeliveryMain].DepartmentID=[Accounts_Department].DepartmentID) 
            Join [WareHouses] On ([DeliveryMain].WareHouseID=[WareHouses].WareHouseID) 
            Join [ProjectCategories] On ([DeliveryMain].ProjectCategoryID=[ProjectCategories].ProjectCategoryID)
            Where [DeliveryMain].ReceiverName=@ReceiverName And DeliveryDate Between @BeginDate And @EndDate
            ORDER BY [DeliveryMain].DeliveryID DESC"
        UpdateCommand="Update DeliveryMain Set IsAccepted=1 Where DeliveryID=@DeliveryID"
        FilterExpression="WareHouseName='{0}'">
        <SelectParameters>
            <asp:Parameter Name="ReceiverName" DefaultValue="" Type="String" />
            <asp:Parameter Name="BeginDate" Type="DateTime" />
            <asp:Parameter Name="EndDate" Type="DateTime" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="DeliveryID" Type="Int32" />
        </UpdateParameters>
        <FilterParameters>
            <asp:Parameter Name="WareHouseName" Type="String"/>
        </FilterParameters>
    </asp:SqlDataSource>
    <sk:myGridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="DeliveryID" 
        DataSourceID="SqlDataSource4" Width=98% OnRowDataBound="GridView3_RowDataBound">

        <Columns>
            <asp:CommandField SelectText="详细发料" ShowSelectButton="True" />
            <asp:BoundField DataField="DeliveryID" HeaderText="发料单编号" InsertVisible="False" ReadOnly="True"
                SortExpression="DeliveryID" />
            <asp:BoundField DataField="ReceiverName" HeaderText="领料人" SortExpression="ReceiverName" />
            <asp:BoundField DataField="ProjectCategoryName" HeaderText="生产项目" SortExpression="ProjectCategoryName" />
            <asp:BoundField DataField="WareHouseName" HeaderText="发料仓库" SortExpression="WareHouseName" />
            <asp:BoundField DataField="DepartName" HeaderText="领料部门" SortExpression="DepartName" />
            <asp:TemplateField HeaderText="发料日期" SortExpression="DeliveryDate">
                <ItemTemplate>
                    <asp:Label ID="Label2" runat="server" Text='<%# ((DateTime)Eval("DeliveryDate")).ToShortDateString() %>' width="80px"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="UserName" HeaderText="发料人" SortExpression="UserName" />
            <asp:CheckBoxField DataField="IsAccepted" HeaderText="是否已确认" SortExpression="IsAccepted" />
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
                        OnClientClick="return confirm('确定已经领到所有物资？');"
                        CommandName="Update" Visible=false>领料确认</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </sk:myGridView>
    </td></tr>
    <tr><td width=100% height="20" background="../images/headerbg.gif">详细发料记录</td></tr>
    <tr><td>
    <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
        SelectCommand="SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, [DeliveryDetail].[Quantity] FROM [DeliveryDetail] Join [Items] ON ([DeliveryDetail].ItemID = [Items].ItemID ) WHERE ([DeliveryDetail].[DeliveryID] = @DeliveryID)">
        <SelectParameters>
            <asp:ControlParameter ControlID="GridView3" Name="DeliveryID" PropertyName="SelectedValue"
                Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging="False" Width=98%
        DataSourceID="SqlDataSource5" OnRowDataBound="GridView4_RowDataBound" ShowFooter=true>
        <Columns>
            <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID" />
            <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name" />
            <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" />
            <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" />
            <asp:BoundField DataField="Quantity" HeaderText="实发数量" SortExpression="Quantity" />
            <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" />
            <asp:TemplateField HeaderText="发料金额" SortExpression="TotalPrice">
                <ItemTemplate>
                    <%# String.Format("{0:C}", Convert.ToDecimal(Eval("Quantity")) * Convert.ToDecimal(Eval("StandardPrice")))%>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </sk:myGridView>
</td></tr></table>
</asp:Content>

