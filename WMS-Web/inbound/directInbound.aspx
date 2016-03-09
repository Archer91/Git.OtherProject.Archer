<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="directInbound.aspx.cs" Inherits="inbound_directInbound" Title="Untitled Page" %>
<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <asp:RadioButton ID="radioInsert" runat="server" Text="入库登记" AutoPostBack="True"
        GroupName="SearchType" OnCheckedChanged="radioButton_CheckedChanged" Checked="True" />
    <asp:RadioButton ID="radioBrowser" runat="server" Text="入库查询" AutoPostBack="true"
        GroupName="SearchType" OnCheckedChanged="radioButton_CheckedChanged" />
    <asp:Label ID="Message" runat="server" ForeColor="red" Text=""></asp:Label><br />
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
        <asp:View ID="View1" runat="server">
            <asp:HiddenField ID="hidAddItemID" runat="server" Value='0' />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                InsertCommand="sp_insertReceipt" InsertCommandType="StoredProcedure">
                <InsertParameters>
                    <asp:Parameter Name="ReceiptID" Type="Int32" />
                    <asp:Parameter Name="ReceivingCode" Type="String" />
                    <asp:Parameter Name="ContractID" Type="String" />
                    <asp:Parameter Name="ArriveDate" Type="DateTime" />
                    <asp:Parameter Name="ReceiverID" Type="String" />
                    <asp:Parameter Name="CheckerID" Type="String" />
                    <asp:Parameter Name="SupplierID" Type="Int32" />
                    <asp:Parameter Name="WareHouseID" Type="Int32" />
                    <asp:Parameter Name="IsReviewed" Type="Boolean" DefaultValue="false" />
                    <asp:Parameter Name="ReviewerID" Type="String" DefaultValue="" />
                    <asp:Parameter Name="Freight" Type="Decimal" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="ItemsIDList" Type="String" />
                    <asp:Parameter Name="PriceList" Type="string" />
                    <asp:Parameter Name="QuantityList" Type="String" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" AllowPaging="True" DataKeyNames="ReceiptID"
                DataSourceID="SqlDataSource1" DefaultMode="Insert" Width="98%" HorizontalAlign="Center" OnItemInserting="FormView1_ItemInserting" OnItemInserted="FormView1_ItemInserted">
                <InsertItemTemplate>
                    <table width='100%'>
                    <thead><tr><td colspan='6' class="ticketTitle">直接入库单</td></tr></thead>
                    <tr><td align='left'>收 料 员:</td>
                        <td><%#Server.HtmlEncode(this.User.Identity.Name)%></td>
                        <td align='left' >收料单位:</td>
                        <td ><%# Application["Organ"] %></td>
                        <td align='left'>入库单号:</td>
                        <td>系统自动编号</td>
                    </tr>
                    <tr><td align='left' >料 单 号:</td>
                        <td><asp:TextBox ID="ReceivingCodeTextBox" runat="server" ></asp:TextBox></td>
                        <td align="left" >发货单位:</td>
                        <td colspan='3'>
                            <asp:SqlDataSource ID="SqlSupplier" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="SELECT SupplierID, Spell+':'+Name As Name FROM [Supplier] Where PID is not null order by Name">
                            </asp:SqlDataSource>                            
                            <asp:DropDownList ID="DrpSupplier" runat="server" DataSourceID="SqlSupplier"
                                DataTextField="Name" DataValueField="SupplierID">
                            </asp:DropDownList></td>
                    </tr>
                    <tr><td align="left">入库日期:</td>
                        <td><asp:TextBox ID="ReceiptDateTextBox" runat="server" Text='<%#DateTime.Now.ToShortDateString()%>'>
                        </asp:TextBox>
                            <obout:calendar id="CalendarReceiptDate" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
                                datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
                                scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>
                        </td>
                        <td align="left" >仓 &nbsp; &nbsp; 库:</td>
                        <td><asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="sp_getGrantedWareHouses" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:Parameter Name="UserName" Type="String" />
                                </SelectParameters>    
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource2"
                                DataTextField="Description" DataValueField="WareHouseID">
                            </asp:DropDownList></td>
                        <td align="left" >运 杂 费:</td>
                        <td ><asp:TextBox ID="FreightTextBox" runat="server" Text="0">
                        </asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegValid" runat="server" ControlToValidate="FreightTextBox"
                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="MainValid"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr><td align="left" >检 验 员:</td>
                        <td ><asp:DropDownList ID="DropChecker" runat="server" DataTextField="UserName" DataValueField="UserName" Width="63%">
                            </asp:DropDownList></td>
                        <td align='left' >合 同 号:</td>
                        <td >                           
                             <asp:TextBox ID="ContractIDTextBox" runat="server" Text='<%# Bind("ContractID") %>'>
                             </asp:TextBox></td>
                        <td align='left'>备 &nbsp; &nbsp; 注:</td>
                        <td ><asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>'>
                        </asp:TextBox></td>
                    </tr>
                    <tr><td colspan=2 >
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
                            </asp:LinkButton></td>   
                        <td colspan=2>
                            <asp:Button ID="btnAuto" runat="server" Text="按采购计划入库" OnClientClick="JavaScript: return confirm('您确认所选接货单、仓库正确吗？');" OnClick="btnAuto_Click" />
                        </td>                         
                    </tr> 
                    <tr valign=top runat=server id="trList"><td colspan=6>
                    <div class="divGridView">
                        <sk:myGridView ID="GridView1" runat="server" AllowPagingToggle="false" AllowPaging="false" AutoGenerateColumns="False"
                            Width=100% DataKeyNames="ReceiptItemsID" ShowFooter=true AllowSorting="False"
                            OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDeleting="GridView1_RowDeleting" 
                            OnRowEditing="GridView1_RowEditing" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnRowUpdating="GridView1_RowUpdating" OnRowDataBound="GridView1_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="序号">
                                    <ItemTemplate>
                                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资编号" SortExpression="ReceiptItemsID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblReceiptItemsID" runat="server" Text='<%# Eval("ReceiptItemsID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资名称" SortExpression="ReceiptItemsName">
                                    <ItemTemplate>
                                        <%# Eval("ReceiptItemsName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="规格型号" SortExpression="ReceiptItemsSpecification">
                                    <ItemTemplate>
                                        <%# Eval("ReceiptItemsSpecification")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="计量单位" SortExpression="ReceiptItemsUnit">
                                    <ItemTemplate>
                                        <%# Eval("ReceiptItemsUnit")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="标准单价" SortExpression="ReceiptItemsStandardPrice">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}", Eval("ReceiptItemsStandardPrice"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="预期数量" SortExpression="ReceiptItemsExpectedQuantity">
                                    <ItemTemplate>
                                        <%# Eval("ReceiptItemsExpectedQuantity")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="实际单价" SortExpression="ReceiptItemsPrice">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}", Eval("ReceiptItemsPrice"))%>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtReceiptItemsPrice" runat="server" Width="50" Text='<%# Bind("ReceiptItemsPrice") %>'></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtReceiptItemsPrice"
                                            ErrorMessage="请输入实际单价！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtReceiptItemsPrice"
                                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="实收数量" SortExpression="ReceiptItemsQuantity">
                                    <ItemTemplate>
                                        <%# Eval("ReceiptItemsQuantity")%>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtReceiptItemsQuantity" runat="server" Width=40 Text='<%# Bind("ReceiptItemsQuantity") %>'></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtReceiptItemsQuantity"
                                            ErrorMessage="请输入实收数量！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtReceiptItemsQuantity"
                                            Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                                    </EditItemTemplate>
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
                            Width=100% OnSelectedIndexChanged="GridView2_SelectedIndexChanged" 
                            OnPageIndexChanging="GridView2_PageIndexChanging" AllowPaging="True" AllowSorting="False">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" SelectText="入库" />
                            <asp:BoundField DataField="ItemID" HeaderText="物资编号" SortExpression="ItemID"></asp:BoundField>
                            <asp:BoundField DataField="Name" HeaderText="物资名称" SortExpression="Name"></asp:BoundField>
                            <asp:BoundField DataField="Specification" HeaderText="规格型号" SortExpression="Specification"></asp:BoundField>
                            <asp:BoundField DataField="Unit" HeaderText="计量单位" SortExpression="Unit"></asp:BoundField>
                            <asp:BoundField DataField="StandardPrice" HeaderText="标准单价" SortExpression="StandardPrice"></asp:BoundField>
                            <asp:BoundField DataField="Quantity" HeaderText="预期数量" SortExpression="Quantity"></asp:BoundField>
                        </Columns>
                        </sk:myGridView>
                    </div>
                    </td>
                    </tr>   
                    <tr><td colspan=3 align=right>              
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert"
                            Text="保存" Enabled="false">
                        </asp:LinkButton>
                        </td>
                        <td></td>
                        <td colspan=2 align=left>
                        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
                            Text="取消" OnClick="InsertCancelButton_Click">
                        </asp:LinkButton>
                        </td></tr>
                    </table>
                </InsertItemTemplate>
            </asp:FormView>
        </asp:View>
        <asp:View ID="View2" runat="server">
            <iframe name="content" id="content" src=inboundHisMain.aspx width=100% height=280pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
            <iframe name="detail" id="detail" src=inboundHisDetail.aspx width=100% height=250pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </asp:View>
    </asp:MultiView> 
</asp:Content>

