<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="checkError.aspx.cs" Inherits="report_checkError" Title="Untitled Page" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
<table width=100%>
    <tr>
    <td width=100% height="20" background="../images/headerbg.gif">盘点误差率分析</td>
    </tr>
    <tr>
    <td width=100%>
        <br />
        从<asp:TextBox ID="BeginDateTextBox" runat="server" Width="100px">
        </asp:TextBox>
        <obout:calendar id="Calendar1" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
            datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
            scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>
        到<asp:TextBox ID="EndDateTextBox" runat="server" Width="100px">
        </asp:TextBox>
        <obout:calendar id="Calendar2" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
            datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
            scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>

        选择仓库:
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT 0 AS WareHouseID,'所有仓库' AS Description, 'NULL->0' AS Label Union SELECT [WareHouseID], REPLICATE ('|- ', [Level]) + [Description] AS Description, Label FROM dbo.GetWareHouseTreeInfo() order by [Label]"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1"
            DataTextField="Description" DataValueField="WareHouseID">
        </asp:DropDownList>
        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="刷新" OnClick="btnRefresh_Click" />
        <br />
    </td>
    </tr>
    <tr>
    <td width=100%>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="sp_getCheckError" SelectCommandType=StoredProcedure
            FilterExpression="WareHouseName in ({0})">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
                <asp:Parameter Name="topCount" DefaultValue=0 Type=int32 />
            </SelectParameters>
            <FilterParameters>
                <asp:Parameter Name="WareHouseName" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView1" runat="server"
            AutoGenerateColumns="False" DataKeyNames="InventoryCheckID" ShowFooter=True AllowSorting="True" AllowPaging="true"
            DataSourceID="SqlDataSource2" Width="100%" OnRowDataBound="GridView1_RowDataBound" AllowMultiColumnSorting="False">
            <Columns>
                <asp:TemplateField ShowHeader="False">
                    <itemtemplate>
                    <asp:LinkButton runat="server" Text="详细盘点" CommandName="Select" CausesValidation="False" id="LinkButton1"></asp:LinkButton>
                    </itemtemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="InventoryCheckID" HeaderText="盘点单号" SortExpression="InventoryCheckID" ReadOnly="True" />
                <asp:BoundField DataField="WareHouseName" HeaderText="仓库" SortExpression="WareHouseName" ReadOnly="True" />
                <asp:BoundField DataField="CheckDate" HeaderText="盘点日期" SortExpression="CheckDate" ReadOnly="True" HtmlEncode= False DataFormatString="{0:D}" />
                <asp:BoundField DataField="TotalQuantity" HeaderText="盘点件数" SortExpression="TotalQuantity" ReadOnly="True" >
                    <itemstyle horizontalalign="Right" />
                </asp:BoundField>
                <asp:BoundField DataField="ErrorQuantity" HeaderText="误差件数" SortExpression="ErrorQuantity" ReadOnly="True" >
                    <itemstyle horizontalalign="Right" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="误差率" SortExpression="ErrorRate">
                    <itemstyle horizontalalign="Right" />
                    <ItemTemplate>
                        <%# String.Format("{0:F2}%", Convert.ToDecimal(Eval("ErrorRate")) * 100)%>
                    
</ItemTemplate>
                    <footerstyle horizontalalign="Right" />
                </asp:TemplateField>
            </Columns>
        </sk:myGridView>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                SelectCommand="SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, InventoryQuantity, RealQuantity ,
                                    InventoryReasonID FROM [InventoryCheckDetail] 
                                    Join [Items] ON ([InventoryCheckDetail].ItemID = [Items].ItemID ) 
                                    WHERE ([InventoryCheckDetail].[InventoryCheckID] = @InventoryCheckID) 
                                    Order By InventoryCheckDetailID Desc">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView1" Name="InventoryCheckID" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>
            详细盘点记录
            <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging=true Width=100%
                DataKeyNames="ItemID" RowStyle-HorizontalAlign="Left" DataSourceID="SqlDataSource5"
                OnRowDataBound="GridView4_RowDataBound" ShowFooter=true>
                <Columns>
                    <asp:TemplateField HeaderText="物资编号" SortExpression="ItemID" FooterStyle-HorizontalAlign="left">
                        <ItemTemplate>
                            <%# Eval("ItemID")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name" ReadOnly="true" />
                    <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" ReadOnly="true" />
                    <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" ReadOnly="true" />
                    <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                    <asp:BoundField DataField="InventoryQuantity" HeaderText="账面数量" SortExpression="InventoryQuantity" ReadOnly="true" />
                    <asp:TemplateField HeaderText="实际数量" SortExpression="RealQuantity">
                        <ItemTemplate>
                            <%# Eval("RealQuantity")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏数量" SortExpression="CheckItemsExtra">
                        <ItemTemplate>
                            <%# Convert.ToDecimal(Eval("RealQuantity")) - Convert.ToDecimal(Eval("InventoryQuantity"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏金额" SortExpression="CheckItemsExtraMoney">
                        <ItemTemplate>
                           <%# String.Format("{0:C}", (Convert.ToDecimal(Eval("RealQuantity")) - Convert.ToDecimal(Eval("InventoryQuantity"))) * Convert.ToDecimal(Eval("StandardPrice")))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏原因" SortExpression="CheckItemsReason">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventoryReasonID") %>' Visible="False"></asp:Label>
                            <asp:SqlDataSource ID="sqlReason" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="sp_getCheckItemsReason" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="Label1" Name="InventoryReasonID" PropertyName="Text"
                                        Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="drpCheckItemsReason" runat="server" DataSourceID="sqlReason"
                                DataTextField="Column2" DataValueField="Column1" Enabled=false>
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </sk:myGridView>
    </td>
    </tr>
</table>
</asp:Content>

