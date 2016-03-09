<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="check.aspx.cs" Inherits="inventory_check" Title="Untitled Page" %>
<%@ Register Assembly="obout_Calendar_Pro_Net" Namespace="OboutInc.Calendar" TagPrefix="obout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <asp:RadioButton ID="radioBrowser" runat="server" autopostback="true" 
      GroupName="SearchType" 
      Text="盘点录入" 
      OnCheckedChanged="radioButton_CheckedChanged" Checked=true />
    <asp:RadioButton ID="radioInsert" runat="server" autopostback="true" 
      GroupName="SearchType" 
      Text="盘点查询" 
      OnCheckedChanged="radioButton_CheckedChanged" />
    <asp:Label ID="Message" runat="server" Text="" ForeColor=red></asp:Label>
    <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex=0>
        <asp:View ID="View1" runat="server">
            <asp:HiddenField ID="hidPriceAtlast" runat="server" Value=0 />
            <asp:HiddenField ID="hidWareHouseID" runat="server" Value=0 />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                InsertCommand="sp_insertCheck" InsertCommandType=StoredProcedure >
                <InsertParameters>
                    <asp:Parameter Name="InventoryCheckID" Type="Int32" />
                    <asp:Parameter Name="WareHouseID" Type="Int32" />
                    <asp:Parameter Name="CheckDate" Type="DateTime" />
                    <asp:Parameter Name="UserName" Type="String" />
                    <asp:Parameter Name="Description" Type="String" />
                    <asp:Parameter Name="ItemsIDList" Type="String" />
                    <asp:Parameter Name="InventoryList" Type="String" />
                    <asp:Parameter Name="QuantityList" Type="String" />
                    <asp:Parameter Name="ReasonList" Type="String" />
                </InsertParameters>
            </asp:SqlDataSource>
            <asp:FormView ID="FormView1" runat="server" AllowPaging="True" DataKeyNames="CheckID"
                DataSourceID="SqlDataSource1" DefaultMode="Insert" Width=95% HorizontalAlign=Center OnItemInserting="FormView1_ItemInserting" OnItemInserted="FormView1_ItemInserted">
                <InsertItemTemplate>
                    <table width=100%>
                    <thead><tr><td colspan=6 class="ticketTitle">库存盘点单</td></tr></thead>
                    <tr><td align=left>盘 点 人:</td>
                        <td><%#Server.HtmlEncode(this.User.Identity.Name)%></td>
                        <td align=left>盘点单位:</td>
                        <td><%# Application["Organ"] %></td>
                        <td>盘点单号:</td>
                        <td>系统自动编号</td>
                    </tr>
                    <tr><td align=left>盘点日期:</td>
                        <td><asp:TextBox ID="CheckDateTextBox" runat="server" Text='<%#DateTime.Now.ToShortDateString()%>'>
                        </asp:TextBox>
                        <obout:calendar id="Calendar1" runat="server" dateformat="yyyy-mm-dd" datepickerbuttontext='<img src="../images/calendar.gif"/>'
                            datepickermode="True" namesdays="日, 一, 二, 三, 四, 五, 六"  ShowYearSelector="true" namesmonths="一月, 二月, 三月, 四月, 五月, 六月, 七月, 八月, 九月, 十月, 十一月, 十二月"
                            scriptpath="../JScripts/calendarscript" stylefolder="../calendarStyle/default"></obout:calendar>
                        </td>
                        <td align=left>盘点仓库:</td>
                        <td>
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
                        <td align=left>备 &nbsp; &nbsp; 注:</td>
                        <td colspan=1><asp:TextBox ID="DescriptionTextBox" runat="server" Text='<%# Bind("Description") %>'>
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
                        <td><asp:Button ID="btnAuto" runat="server" Text="读入该库所有物资" OnClientClick="JavaScript: return confirm('您确认所选仓库正确吗？');" OnClick="btnAuto_Click" />
                        </td>
                    </tr>
                    <tr valign=top runat=server id="trList"><td colspan=6>
                    <div class="divGridView">
                        <sk:myGridView ID="GridView1" runat="server" AllowPaging="True" AllowPagingToggle="false" AutoGenerateColumns="False"
                            Width=100% DataKeyNames="CheckItemsID" ShowFooter=true AllowSorting="False"
                            OnPageIndexChanging="GridView1_PageIndexChanging" OnRowDeleting="GridView1_RowDeleting" 
                            OnRowEditing="GridView1_RowEditing" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnRowUpdating="GridView1_RowUpdating" OnRowDataBound="GridView1_RowDataBound">
                            <Columns>
                                <asp:TemplateField HeaderText="序号">
                                    <ItemTemplate>
                                        <%# (((GridViewRow)Container).DataItemIndex + 1) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资编号" SortExpression="CheckItemsID">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCheckItemsID" runat="server" Text='<%# Eval("CheckItemsID")%>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="物资名称" SortExpression="CheckItemsName">
                                    <ItemTemplate>
                                        <%# Eval("CheckItemsName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="规格型号" SortExpression="CheckItemsSpecification">
                                    <ItemTemplate>
                                        <%# Eval("CheckItemsSpecification")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="单位" SortExpression="CheckItemsUnit">
                                    <ItemTemplate>
                                        <%# Eval("CheckItemsUnit")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="标准单价" SortExpression="CheckItemsStandardPrice">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}",Eval("CheckItemsStandardPrice"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="账面数量" SortExpression="CheckItemsInventory">
                                    <ItemTemplate>
                                        <%# Eval("CheckItemsInventory")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="实际数量" SortExpression="CheckQuantity">
                                    <ItemTemplate>
                                        <%# Eval("CheckQuantity") %>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtInventory" runat="server" Text='<%# Eval("CheckItemsInventory")%>' Visible=false></asp:TextBox>
                                        <asp:TextBox ID="txtCheckQuantity" runat="server" Width=40 Text='<%# Bind("CheckQuantity") %>'></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtCheckQuantity"
                                            ErrorMessage="请输入实际数量！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCheckQuantity"
                                            Display="Dynamic" ErrorMessage="请输入数字" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="盈亏数量" SortExpression="CheckItemsExtra" ControlStyle-Width="40">
                                    <ItemTemplate>
                                        <%# Eval("CheckItemsExtra")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="盈亏金额" SortExpression="CheckItemsExtraMoney">
                                    <ItemTemplate>
                                        <%# String.Format("{0:C}",Eval("CheckItemsExtraMoney"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="盈亏原因" SortExpression="CheckItemsReason">
                                    <EditItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("CheckItemsReason") %>' Visible="False"></asp:Label>
                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                            SelectCommand="sp_getCheckItemsReason" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="Label1" Name="InventoryReasonID" PropertyName="Text"
                                                    Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:DropDownList ID="drpCheckItemsReason" runat="server" DataSourceID="SqlDataSource2"
                                            DataTextField="Column2" DataValueField="Column1">
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("CheckItemsReason") %>' Visible="False"></asp:Label>
                                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                            SelectCommand="sp_getCheckItemsReason" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="Label1" Name="InventoryReasonID" PropertyName="Text"
                                                    Type="Int32" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <asp:DropDownList ID="drpCheckItemsReason" runat="server" DataSourceID="SqlDataSource2"
                                            DataTextField="Column2" DataValueField="Column1" Enabled=false>
                                        </asp:DropDownList>
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
                        <sk:myGridView ID="GridView2" runat="server" AutoGenerateColumns="False" AllowPagingToggle="false" DataKeyNames="ItemID"
                            Width=100% OnRowDataBound="GridView2_RowDataBound" OnSelectedIndexChanged="GridView2_SelectedIndexChanged" 
                            OnPageIndexChanging="GridView2_PageIndexChanging" AllowPaging="False" AllowSorting="False">
                        <Columns>
                            <asp:CommandField ShowSelectButton="True" SelectText="盘点" />
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
                        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Enabled="false"
                            Text="保存">
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
        <div align=center>
            <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                SelectCommand="SELECT [InventoryCheckMain].InventoryCheckID, [WareHouses].Description As WareHouseName, 
                    [InventoryCheckMain].CheckDate, [InventoryCheckMain].UserName, [InventoryCheckMain].Description,
                    [InventoryCheckMain].ReviewerName,[InventoryCheckMain].IsReviewed FROM [InventoryCheckMain]
                    Join [WareHouses] On ([InventoryCheckMain].WareHouseID=[WareHouses].WareHouseID) Order By InventoryCheckID Desc "
                UpdateCommand="Update InventoryCheckMain Set IsReviewed=1, ReviewerName=@ReviewerName Where InventoryCheckID=@InventoryCheckID"
                DeleteCommand="sp_deleteInventoryCheck" DeleteCommandType="StoredProcedure">
                <UpdateParameters>
                    <asp:Parameter Name="InventoryCheckID" Type="Int32" />
                    <asp:Parameter Name="ReviewerName" Type="String" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:Parameter Name="InventoryCheckID" Type="Int32" />
                </DeleteParameters>
            </asp:SqlDataSource>
            盘点历史列表
            <sk:myGridView ID="GridView3" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" DataKeyNames="InventoryCheckID" 
                DataSourceID="SqlDataSource4" Width="98%"  OnRowUpdating="GridView3_RowUpdating" 
                OnRowDeleted="GridView3_RowDeleted" OnRowDataBound="GridView3_RowDataBound" OnRowUpdated="GridView3_RowUpdated">
                <Columns>
                    <asp:CommandField SelectText="详细盘点" ShowSelectButton="True" />
                    <asp:BoundField DataField="InventoryCheckID" HeaderText="盘点单编号" InsertVisible="False" ReadOnly="True"
                        SortExpression="InventoryCheckID" />
                    <asp:BoundField DataField="WareHouseName" HeaderText="盘点仓库" SortExpression="WareHouseName" />
                    <asp:TemplateField HeaderText="盘点日期" SortExpression="CheckDate">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# ((DateTime)Eval("CheckDate")).ToShortDateString() %>' width="80px"></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UserName" HeaderText="盘点人" SortExpression="UserName" />
                    <asp:TemplateField HeaderText="备注" SortExpression="Description">
                        <ItemTemplate>
                            <div style="width:100px;overflow: hidden; text-overflow:ellipsis;word-break:keep-all" title=<%# Eval("Description")%>>
                            <%# Eval("Description")%>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="ReviewerName" HeaderText="审核人" SortExpression="ReviewerName" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnReview" Runat="server" Visible=false CommandName="Update" OnClientClick="return confirm('审核之后将不能再编辑，确定？');">
                            审核</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" Runat="server" Visible=false CommandName="Delete" OnClientClick="return confirm('确定删除该发料单？');">
                            删除</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </sk:myGridView>
            <asp:SqlDataSource ID="SqlDataSource5" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                SelectCommand="SELECT [Items].ItemID, [Items].Name, [Items].Specification, [Items].Unit, [Items].StandardPrice, InventoryQuantity, RealQuantity ,
                                    (RealQuantity-InventoryQuantity) as CheckItemsExtra, (RealQuantity-InventoryQuantity)*StandardPrice as CheckItemsExtraMoney,
                                    InventoryReasonID FROM [InventoryCheckDetail] 
                                    Join [Items] ON ([InventoryCheckDetail].ItemID = [Items].ItemID ) 
                                    WHERE ([InventoryCheckDetail].[InventoryCheckID] = @InventoryCheckID) 
                                    Order By InventoryCheckDetailID Desc"
                UpdateCommand="sp_updateInventoryCheckDetail" UpdateCommandType="StoredProcedure" 
                DeleteCommand="sp_deleteInventoryCheckDetail" DeleteCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="GridView3" Name="InventoryCheckID" PropertyName="SelectedValue"
                        Type="Int32" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:ControlParameter ControlID="GridView3" Name="InventoryCheckID" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:Parameter Name="ItemID" Type="string" />
                    <asp:Parameter Name="RealQuantity" Type="decimal" />
                    <asp:Parameter Name="InventoryReasonID" Type="int32" />
                </UpdateParameters>
                <DeleteParameters>
                    <asp:ControlParameter ControlID="GridView3" Name="InventoryCheckID" PropertyName="SelectedValue"
                        Type="Int32" />
                    <asp:Parameter Name="ItemID" Type="string" />
                </DeleteParameters>
            </asp:SqlDataSource>
            详细盘点记录
            <sk:myGridView ID="GridView4" runat="server" AutoGenerateColumns="False" AllowPaging=true Width="98%"
                DataKeyNames="ItemID" RowStyle-HorizontalAlign="Left" DataSourceID="SqlDataSource5"
                OnRowDataBound="GridView4_RowDataBound" ShowFooter=true OnDataBound="GridView4_DataBound" OnRowUpdating="GridView4_RowUpdating">
                <Columns>
                    <asp:TemplateField HeaderText="物资编号" SortExpression="ItemID" FooterStyle-HorizontalAlign="left">
                        <ItemTemplate>
                            <%# Eval("ItemID")%>
                        </ItemTemplate>
                        <FooterTemplate>
                            <asp:DropDownList ID="drpItem" runat="server" DataTextField="ItemID" DataValueField="ItemID"
                                onkeyup="dropKeyUp()" onkeypress="catch_press(this);" Visible="false">
                            </asp:DropDownList>
                            <asp:LinkButton ID="LinkButtonEditAdd" runat="server" Visible="false" 
                                Text="快速添加" OnClick="LinkButtonEditAdd_Click">
                            </asp:LinkButton>
                        </FooterTemplate>
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
                        <EditItemTemplate>
                            <asp:TextBox ID="txtQuantity" runat="server" Width="60px" Text='<%# Bind("RealQuantity") %>'></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtQuantity"
                                ErrorMessage="请输入数量！" ValidationGroup="QuantityEditValid" Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtQuantity"
                                Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityEditValid"></asp:RegularExpressionValidator>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏数量" SortExpression="CheckItemsExtra">
                        <ItemTemplate>
                            <%# Eval("CheckItemsExtra")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏金额" SortExpression="CheckItemsExtraMoney">
                        <ItemTemplate>
                           <%# String.Format("{0:C}",Eval("CheckItemsExtraMoney"))%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="盈亏原因" SortExpression="CheckItemsReason">
                        <EditItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventoryReasonID") %>' Visible="False"></asp:Label>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="sp_getCheckItemsReason" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="Label1" Name="InventoryReasonID" PropertyName="Text"
                                        Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="drpCheckItemsReason" runat="server" DataSourceID="SqlDataSource2"
                                DataTextField="Column2" DataValueField="Column1">
                            </asp:DropDownList>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventoryReasonID") %>' Visible="False"></asp:Label>
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                                SelectCommand="sp_getCheckItemsReason" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="Label1" Name="InventoryReasonID" PropertyName="Text"
                                        Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:DropDownList ID="drpCheckItemsReason" runat="server" DataSourceID="SqlDataSource2"
                                DataTextField="Column2" DataValueField="Column1" Enabled=false>
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField CancelText="取消" 
                        DeleteText="删除" EditText="编辑" InsertText="插入" NewText="新增" 
                        SelectText="选取" UpdateText="确认" ValidationGroup="QuantityEditValid" />
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDeleteOne" Runat="server" 
                                OnClientClick="return confirm('删除该记录将把系统库存恢复为盘点前库存，确定？');"
                                CommandName="Delete">删除</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </sk:myGridView>
        </div>
        </asp:View>
    </asp:MultiView>
</asp:Content>

