<%@ Page Language="C#" AutoEventWireup="true" CodeFile="turnOverMain.aspx.cs" Inherits="report_turnOverMain" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
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
    <td width=100% height="20" background="../images/headerbg.gif">库存周转率</td>
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
            SelectCommand="SELECT [WareHouseID], REPLICATE ('|- ', [Level]) + [Description] AS Description, Label FROM dbo.GetWareHouseTreeInfo() order by [Label]"></asp:SqlDataSource>
        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1"
            DataTextField="Description" DataValueField="WareHouseID">
        </asp:DropDownList>
        物资编号:
        <asp:TextBox ID="ItemIDTextBox" runat="server" Text='<%#DateTime.Now.ToShortDateString()%>' Width="100px"/>
        <asp:ImageButton ID="imgSearch" runat="server" ImageUrl="~/images/search_y.gif" AlternateText="查询" OnClick="imgSearch_Click" />
        <br />(可以只输入物资编号的前几位进行模糊查询)
    </td>
    </tr>
    <tr>
    <td width=100%>
        <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
            SelectCommand="sp_getTurnOver" SelectCommandType=StoredProcedure
            FilterExpression="ItemID like '{0}'">
            <SelectParameters>
                <asp:Parameter Name="BeginDate" Type="DateTime" />
                <asp:Parameter Name="EndDate" Type="DateTime" />
                <asp:ControlParameter Name="WareHouseID" ControlID="DropDownList1" PropertyName="SelectedValue" Type="Int32"/>
                <asp:Parameter Name="topCount" DefaultValue=0 Type=int32 />
            </SelectParameters>
            <FilterParameters>
                <asp:Parameter Name="ItemID" Type="String"/>
            </FilterParameters>
        </asp:SqlDataSource>
        <sk:myGridView ID="GridView4" runat="server" AllowSorting=true AllowPaging="true"
            AutoGenerateColumns="False" DataKeyNames="ItemID" ShowFooter=true
            DataSourceID="SqlDataSource4" Width="100%">
            <Columns>
                <asp:TemplateField HeaderText="序号">
                    <ItemTemplate>
                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID" ReadOnly="true" />
                <asp:BoundField DataField="WareHouseName" HeaderText="仓库" SortExpression="WareHouseName" ReadOnly="true" />
                <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name" ReadOnly="true" />
                <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification" ReadOnly="true" />
                <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit" ReadOnly="true" />
                <asp:BoundField DataField="TurnOver" HeaderText="库存周转率" SortExpression="TurnOver" HtmlEncode= false DataFormatString="{0:F5}"  ReadOnly="true" />
            </Columns>
        </sk:myGridView>
    </td>
    </tr>
</table>
    </form>
</body>
</html>
