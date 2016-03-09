<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="costAnalyst.aspx.cs" Inherits="report_costAnalyst" Title="Untitled Page" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
<table width=100%>
    <tr>
    <td width=100% height="20" background="../images/headerbg.gif">采购成本/料差分析（以入库单为依据）</td>
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

        选择供应单位:
        <asp:SqlDataSource ID="sqlSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="SELECT 0 AS SupplierID,'所有单位' AS Name Union SELECT [SupplierID],Name FROM Supplier"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="sqlSupplier"
            DataTextField="Name" DataValueField="SupplierID">
        </asp:DropDownList>
        &nbsp;&nbsp;<asp:Button ID="btnRefresh" runat="server" Text="刷新" OnClick="btnRefresh_Click" />
        <br />
    </td>
    </tr>
    <tr>
    <td width=100%>
        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="sp_getCostDiff" SelectCommandType=StoredProcedure
            FilterExpression="SupplierName in ({0})">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
                <asp:Parameter Name="topCount" DefaultValue=0 Type=int32 />
            </SelectParameters>
            <FilterParameters>
                <asp:Parameter Name="SupplierName" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView1" runat="server" AllowPaging="true"
            AutoGenerateColumns="False" DataKeyNames="ItemID" ShowFooter=true AllowSorting="true"
            DataSourceID="SqlDataSource2" Width="100%">
            <Columns>
                <asp:TemplateField ShowHeader="False">
                    <itemtemplate>
                    <asp:LinkButton runat="server" Text="详细采购" CommandName="Select" CausesValidation="False" id="LinkButton1"></asp:LinkButton>
                    </itemtemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="序号">
                    <ItemTemplate>
                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID" ReadOnly="true" />
                <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name" ReadOnly="true" />
                <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" ReadOnly="true" />
                <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" ReadOnly="true" />
                <asp:BoundField DataField="SupplierName" HeaderText="供应单位" SortExpression="SupplierName" ReadOnly="true" />
                <asp:BoundField DataField="InboundQuantity" HeaderText="购入数量" SortExpression="InboundQuantity" ItemStyle-HorizontalAlign=Right ReadOnly="true" />
                <asp:BoundField DataField="InboundPrice" HeaderText="平均购入单价" SortExpression="InboundPrice" ItemStyle-HorizontalAlign=Right HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" ItemStyle-HorizontalAlign=Right HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                <asp:BoundField DataField="CostDiff" HeaderText="单价料差" SortExpression="CostDiff" ItemStyle-HorizontalAlign=Right HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                <asp:TemplateField HeaderText="料差率" FooterStyle-HorizontalAlign="Right" ItemStyle-HorizontalAlign=Right SortExpression="CostDiffRate">
                    <ItemTemplate>
                        <%# Convert.IsDBNull(Eval("CostDiffRate")) ? null : String.Format("{0:F2}%", Convert.ToDecimal(Eval("CostDiffRate")) * 100)%>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </sk:myGridView>
        <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="Select ReceiptMain.ArriveDate, ReceiptDetail.Quantity, ReceiptDetail.Price, Items.StandardPrice,
                    Supplier.Name as SupplierName, (Price-StandardPrice) as CostDiff From ReceiptDetail
                    Join ReceiptMain On (ReceiptDetail.ReceiptID=ReceiptMain.ReceiptID)
                    Join Supplier On (ReceiptMain.SupplierID=Supplier.SupplierID)
                    Join Items On (Items.ItemID=ReceiptDetail.ItemID)
                    Where ReceiptDetail.ItemID=@ItemID And ReceiptMain.ArriveDate Between @BeginDate And @EndDate"
            FilterExpression="SupplierName in ({0})">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
                <asp:ControlParameter ControlID="GridView1" Name="ItemID" PropertyName="SelectedValue"
                    Type="String" />
            </SelectParameters>
            <FilterParameters>
                <asp:Parameter Name="SupplierName" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        详细采购入库记录
        <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging=true Width=100%
            RowStyle-HorizontalAlign="Right" DataSourceID="SqlDataSource5" ShowFooter=true>
            <Columns>
                <asp:TemplateField HeaderText="序号">
                    <ItemTemplate>
                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="入库日期" SortExpression="ArriveDate">
                    <ItemTemplate>
                        <%# ((DateTime)Eval("ArriveDate")).ToShortDateString()%>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="Quantity" HeaderText="入库数量" SortExpression="Quantity" ReadOnly="true" />
                <asp:BoundField DataField="Price" HeaderText="购入单价" SortExpression="Price" HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice" HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
                <asp:BoundField DataField="CostDiff" HeaderText="单价料差" SortExpression="CostDiff" ItemStyle-HorizontalAlign=Right HtmlEncode= false DataFormatString="{0:C}" ReadOnly="true" />
            </Columns>
        </sk:myGridView>
    </td>
    </tr>
</table>
</asp:Content>



