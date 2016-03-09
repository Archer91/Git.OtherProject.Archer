<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Dispatch.aspx.cs" Inherits="outbound_Dispatch" Title="支出小票" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <asp:RadioButton ID="radioBrowser" runat="server" autopostback="true" 
      GroupName="SearchType" Text="支出发料" OnCheckedChanged="radioButton_CheckedChanged" Checked='true' />
    <asp:RadioButton ID="radioInsert" runat="server" autopostback="true" 
      GroupName="SearchType" Text="发料查询" OnCheckedChanged="radioButton_CheckedChanged" />
    <asp:Label ID="Message" runat="server" Text="" ForeColor=red></asp:Label>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex=0>
        <asp:View ID="View1" runat="server">
            <asp:HiddenField ID="hidWareHouseID" runat="server" Value='0' />
            <asp:HiddenField ID="hidAddItemID" runat="server" Value='0' />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                InsertCommand="sp_insertDispatch" InsertCommandType='StoredProcedure' OnInserted="SqlDataSource1_Inserted">
                <InsertParameters>
                    <asp:Parameter Name="DeliveryID" Type="Int32" Direction="Output"/>
                    <asp:Parameter Name="ProjectCategoryID" Type="Int32" />
                    <asp:Parameter Name="DepartmentID" Type="Int32" />
                    <asp:Parameter Name="WareHouseID" Type="Int32" />
                    <asp:Parameter Name="DeliveryDate" Type="DateTime" />
                    <asp:Parameter Name="UserName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="ReceiverName" Type="String" />
                    <asp:Parameter Name="IsAccepted" Type="Boolean" DefaultValue="false" />
                    <asp:Parameter Name="IsReviewed" Type="boolean" DefaultValue="false" />
                    <asp:Parameter Name="ReviewerID" Type="string" DefaultValue="" />
                    <asp:Parameter Name="ItemsIDList" Type="String" />
                    <asp:Parameter Name="QuantityList" Type="String" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" AllowPaging="True" DataKeyNames="DeliveryID" DataSourceID="SqlDataSource1" 
                DefaultMode="Insert" Width='98%' HorizontalAlign=Center OnItemInserting="FormView1_ItemInserting"
                OnItemInserted="FormView1_ItemInserted">
                <InsertItemTemplate>
                    <table width='100%'>
                    <thead><tr><td colspan=6 class="ticketTitle">支出发料单</td></tr></thead>
                    <tr>
                        <td align=left>管 库 员:</td>
                        <td><%#Server.HtmlEncode(this.User.Identity.Name)%></td>
                        <td>单 &nbsp; &nbsp; 位:</td>
                        <td><%# Application["Organ"]%></td>
                        <td>发料单号:</td>
                        <td>系统自动编号</td>
                    </tr>
                    <tr><td align=left>发料日期:</td>
                        <td><asp:TextBox ID="DeliveryDateTextBox" runat="server" Text='<%#DateTime.Now.ToShortDateString()%>'>
                        </asp:TextBox>
                            <obout:calendar id="Calendar1" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
                                datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
                                scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>
                        </td>
                        <td align=left>发料仓库:</td>
                        <td align=left colspan=3>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="sp_getGrantedWareHouses" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="UserName" Type="String" />
                                </SelectParameters>    
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                                DataTextField="Description" DataValueField="WareHouseID"
                                OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged" OnDataBound="DropDownList1_DataBound">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td align=left>领料部门:</td>
                        <td><asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="Select [DepartmentID], REPLICATE ('|- ', [Level]) + [Name] AS DepartName, [Label] FROM dbo.GetDepartmentTreeInfo() order by [Label]"></asp:SqlDataSource>
                            <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource3" AutoPostBack="true"
                                DataTextField="DepartName" DataValueField="DepartmentID">
                            </asp:DropDownList></td>                    
                        <td align=left>领 料 人:</td>
                        <td><asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="Select UserName From Accounts_DepartmentUsers Where DepartmentID=@DepartmentID">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="DropDownList2" PropertyName="SelectedValue" Name="DepartmentID" Type="Int32" />
                                </SelectParameters>    
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="DrpUser" runat="server" DataSourceID="SqlDataSource4" DataTextField="UserName" DataValueField="UserName">
                            </asp:DropDownList>
                        </td>
                        <td align=left>生产项目:</td>
                        <td><asp:SqlDataSource ID="SqlProjectCategory" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="Select [ProjectCategoryID], REPLICATE ('|- ', [Level]) + [Name] AS ProjectName, [Label] FROM dbo.GetProjectTree() order by [Label]">
                            </asp:SqlDataSource>                            
                            <asp:DropDownList ID="DrpProjectCategory" runat="server" DataSourceID="SqlProjectCategory"
                                DataTextField="ProjectName" DataValueField="ProjectCategoryID" AutoPostBack="false">
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td align=left>备 &nbsp; &nbsp; 注:</td>
                        <td align=left colspan=5><asp:TextBox ID="DescriptionTextBox" runat="server" Width=90% Text='<%# Bind("Description") %>'>
                        </asp:TextBox></td>                    
                    </tr>
                    <tr><td colspan=2>
                        <asp:RadioButton ID="radioBrowserDetails" runat="server" autopostback="true" 
                          GroupName="SearchType" 
                          Text="浏览" 
                          OnCheckedChanged="radioButtonDetails_CheckedChanged" Checked=true />
                        <asp:RadioButton ID="radioInsertDetails" runat="server" autopostback="true" 
                          GroupName="SearchType" 
                          Text="新增"
                          OnCheckedChanged="radioButtonDetails_CheckedChanged" />
                    </td>
                    <td align="left">
                    <asp:DropDownList ID="drpFilterOption" runat="server">
                        <asp:ListItem Text="物资编号" Value="ItemID" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="物资名称" Value="Name"></asp:ListItem>
                        <asp:ListItem Text="规格型号" Value="Specification"></asp:ListItem>
                    </asp:DropDownList>
                    </td>
                    <td>
                        <asp:TextBox ID="ItemIDTextBox" runat="server" Width="100px" Enabled="false" onkeyup="dropKeyUp()" />
                        <asp:LinkButton ID="LinkButtonSearch" runat="server" Text="查找" OnClick="LinkButtonSearch_Click" Enabled="false">
                        </asp:LinkButton>
                    </td>
                    <td colspan=2>
                    </td>
                    </tr>
                    <tr valign=top runat=server id="trList"><td colspan=6>
                    <div class="divGridView">
                        <sk:myGridView ID="GridView1" runat="server" AllowPagingToggle="false" AllowPaging="false" AutoGenerateColumns="False"
                            Width=100% DataKeyNames="DeliveryItemsID" ShowFooter=true AllowSorting="False"
                            OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDeleting="GridView1_RowDeleting" 
                            OnRowEditing="GridView1_RowEditing" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnRowUpdating="GridView1_RowUpdating" OnRowDataBound="GridView1_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="序号">
                                    <ItemTemplate>
                                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资编号" SortExpression="DeliveryItemsID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblDeliveryItemsID" runat="server" Text='<%# Eval("DeliveryItemsID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资名称" SortExpression="DeliveryItemsName">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryItemsName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="规格型号" SortExpression="DeliveryItemsSpecification">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryItemsSpecification")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="计量单位" SortExpression="DeliveryItemsUnit">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryItemsUnit")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="标准单价" SortExpression="DeliveryItemsStandardPrice">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}",Eval("DeliveryItemsStandardPrice"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="原有库存" SortExpression="DeliveryItemsInventory">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryItemsInventory")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="实发数量" SortExpression="DeliveryQuantity">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryQuantity") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtDeliveryItemsQuantity" runat="server" Width=40 Text='<%# Bind("DeliveryQuantity") %>'></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDeliveryItemsQuantity"
                                            ErrorMessage="请输入数量！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtDeliveryItemsQuantity"
                                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                                        <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="超过库存！" 
                                            ValueToCompare='<%# Eval("DeliveryItemsInventory")%>' ControlToValidate="txtDeliveryItemsQuantity" Operator="LessThanEqual" 
                                            Type=Double ValidationGroup="QuantityValid" Display="Dynamic"></asp:CompareValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="实发金额" SortExpression="DeliveryItemsMoney">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}",Eval("DeliveryItemsMoney"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="剩余库存" SortExpression="DeliveryItemsLeftInventory">
                                    <ItemTemplate>
                                        <%# Eval("DeliveryItemsLeftInventory")%>
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
                    </td></tr>
                    <tr valign=top runat=server id="TrNew" visible=false><td colspan=6>
                    <div class="divGridView">
                        <sk:myGridView ID="GridView2" runat="server" AllowPagingToggle="false" AutoGenerateColumns="False" DataKeyNames="ItemID"
                            Width=100% OnRowDataBound="GridView2_RowDataBound" OnSelectedIndexChanged="GridView2_SelectedIndexChanged" 
                            OnPageIndexChanging="GridView2_PageIndexChanging" AllowPaging="False" AllowSorting="False">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" SelectText="发料" />
                            <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID"></asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name"></asp:BoundField>
                            <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification"></asp:BoundField>
                            <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit"></asp:BoundField>
                            <asp:BoundField DataField="StandardPrice" HeaderText="单价" SortExpression="StandardPrice"></asp:BoundField>
                            <asp:BoundField DataField="Quantity" HeaderText="现有库存" SortExpression="Quantity"></asp:BoundField>
                        </Columns>
                        </sk:myGridView>
                    </div>
                    </td>
                    </tr>
                    <tr><td colspan=3 align=right>              
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                            Text="保存" Enabled=false>
                        </asp:LinkButton>
                        </td>
                        <td></td>
                        <td colspan=2 align=left>
                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" Text="取消" OnClick="InsertCancelButton_Click">
                        </asp:LinkButton>
                        </td></tr>
                    </table>
                </InsertItemTemplate>
            </asp:FormView>
        </asp:View>
        <asp:View ID="View2" runat="server">
            <iframe name="content" id="content" src=dispatchHisMain.aspx width=100% 
				    height=280pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
            <iframe name="detail" id="detail" src=dispatchHisDetail.aspx width=100% 
				    height=250pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </asp:View>
    </asp:MultiView>
</asp:Content>