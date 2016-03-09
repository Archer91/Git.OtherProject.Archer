<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" Async="true" CodeFile="wareHousesMain.aspx.cs" Inherits="setting_wareHousesMain" EnableViewState="false" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>

    <script>
        function moveoption(fromlist, tolist, isInsert)
        {
            var i;
            for(i = fromlist.options.length - 1; i >= 0; i--)
            {
                    if(fromlist.options[i].selected == true)
                    {
                        if(fromlist.options[i].value.length==4)
                        {
                            if (isInsert)
                                document.getElementById("hidInsertID").value += fromlist.options[i].value + ",";
                            else
                                document.getElementById("hidDeleteID").value += fromlist.options[i].value + ",";                                
                            tolist.appendChild(fromlist.options[i].cloneNode(true));
                            fromlist.remove(i);
                        }
                        else
                        {
                            alert("请选择最底层种类！");
                        }
                    }
            }
        }
        
        function sortMe(oSel)
        {
            var ln = oSel.options.length;
            var arr = new Array(); // 这是关键部分
            var arrText = new Array(); 
            // 将select中的所有option的value值将保存在Array中
            for (var i = 0; i < ln; i++)
            {
              // 如果需要对option中的文本排序，可以改为arr[i] = oSel.options[i].text;
              arr[i] = oSel.options[i].value; 
              //arrText[i] = oSel.options[i].text;
            }
            arr.sort(); // 开始排序
            //arrText.sort();
            // 清空Select中全部Option
            for (i=ln-1;i>=0;i--)
            {
              //oSel.options[ln] = null;
              oSel.remove(i);
            }
            // 将排序后的数组重新添加到Select中
            for (i = 0; i < arr.length; i++)
            {
              oSel.add (new Option(arr[i], arr[i]));
            }
        }
        
        function getInsertIDList(oList)
        {
            var i;
            var strIDList="";
            for(i = oList.options.length - 1; i >= 0; i--)
            {
                strIDList += oList.options[i].value + ",";
            }
            document.getElementById("hidLeftID").value = strIDList;
            return true;
        }
    </script>
</head>
<body oncontextmenu="event.returnValue=false">
<form id="form1" runat="server">
<asp:HiddenField ID="hidLeftID" runat="server" />
<asp:HiddenField ID="hidInsertID" runat="server" />
<asp:HiddenField ID="hidDeleteID" runat="server" />
<asp:SqlDataSource ID="SqlWareHousesDetails" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
    InsertCommand="sp_insertWareHouse" InsertCommandType="StoredProcedure"
    SelectCommand="SELECT * FROM [WareHouses] Where WareHouseID=@WareHouseID"
    UpdateCommand="sp_updateWareHouse" UpdateCommandType="StoredProcedure">
    <SelectParameters>
        <asp:QueryStringParameter QueryStringField="id" Name="WareHouseID"/>
    </SelectParameters>
    <UpdateParameters>
        <asp:Parameter Name="WareHouseID" Type="Int32" />
        <asp:Parameter Name="WareHouseCode" Type="String" />
        <asp:Parameter Name="Description" Type="String" />
        <asp:Parameter Name="ParentWareHouseID" Type="Int32" />
        <asp:Parameter Name="IsActive" Type="Boolean" />
        <asp:Parameter Name="UserName" Type="String" />
        <asp:Parameter Name="IsExceptionAllowed" Type="Boolean" />
        <asp:Parameter Name="Quota" Type="Decimal" />
        <asp:Parameter Name="InsertIDList" Type="String" />
        <asp:Parameter Name="DeleteIDList" Type="String" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter Name="WareHouseCode" Type="String" />
        <asp:Parameter Name="Description" Type="String" />
        <asp:Parameter Name="ParentWareHouseID" Type="Int32" />
        <asp:Parameter Name="IsActive" Type="Boolean" />
        <asp:Parameter Name="UserName" Type="String" />
        <asp:Parameter Name="IsExceptionAllowed" Type="Boolean" />
        <asp:Parameter Name="Quota" Type="Decimal" />
        <asp:Parameter Name="InsertIDList" Type="String" />
        <asp:Parameter Name="WareHouseID" Type="Int32" />
    </InsertParameters>
</asp:SqlDataSource>
<asp:FormView ID="FormViewWareHouses" runat="server" AllowPaging="True" DataKeyNames="WareHouseID"
    DataSourceID="SqlWareHousesDetails" Width="100%" DefaultMode="Insert" OnItemInserting="FormViewWareHouses_ItemInserting" OnItemInserted="FormViewWareHouses_ItemInserted" OnItemDeleted="FormViewWareHouses_ItemDeleted" OnItemUpdated="FormViewWareHouses_ItemUpdated" OnItemUpdating="FormViewWareHouses_ItemUpdating">
    <EditItemTemplate>
        <table width=100%><tr>
            <td align=left width=20%>仓库编号:</td>
            <td width=20%>
                <asp:TextBox ID="txtWareHouseCode" runat="server" Text=<%# Bind("WareHouseCode")%>></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtWareHouseCode"
                    ErrorMessage="请输入编号！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                
            </td>
            <td width=30%>名称:</td>
            <td><asp:TextBox ID="txtDescription" runat="server" Text=<%# Bind("Description")%>></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDescription"
                    ErrorMessage="请输入名称！" ValidationGroup="QuantityValid" Display="Dynamic"></asp:RequiredFieldValidator>                            
            </td>
        </tr>
        <tr>
            <td align=left>上级仓库:</td>
            <td>
                <asp:Label ID="Label1" runat="server" Text='<%# Bind("ParentWareHouseID") %>' Visible="False"></asp:Label>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                    SelectCommand="Select 0 as WareHouseID, '无' As Description Union SELECT WareHouseID,WareHouseCode+','+Description As Description FROM WareHouses">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="Label1" Name="ParentWareHouseID" PropertyName="Text"
                            Type="Int32" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource3"
                    DataTextField="Description" DataValueField="WareHouseID" SelectedValue='<%# Bind("ParentWareHouseID") %>'>
                </asp:DropDownList>
            </td>
            <td>是否允许存放物资？:</td>
            <td>
                <asp:CheckBox ID="Checkbox1" runat="server" Checked=<%# Bind("IsActive")%>/>
            </td>
        </tr>
        <tr>
            <td align=left>主要管库员:</td>
            <td><asp:TextBox ID="TextBox1" runat="server" Text=<%# Bind("UserName")%>></asp:TextBox></td>
            <td>是否允许例外存放其他物资？:</td>
            <td><asp:CheckBox ID="Checkbox2" runat="server" Checked=<%# Bind("IsExceptionAllowed")%>/></td>
        </tr>
        <tr>
            <td align=left>定额:</td>
            <td>
                <asp:TextBox ID="txtQuota" runat="server" Text='<%# Bind("Quota") %>'></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtQuota"
                    Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
            </td>
            <td>       
            </td>
        </tr>
        </table>
        <table width=100%>
        <tr>
        <td>物资分类：</td>
        <td></td>
        <td>本库可存放物资：</td>
        </tr>
        <tr>
            <td width=40%>
                <asp:SqlDataSource ID="SqlSparesCatogries" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                    SelectCommand="SELECT ItemCategoryID,([ItemCategoryID]+','+[Description]) As CategoriesName FROM [ItemCategories] Where ItemCategoryID NOT in (Select ItemCategoryID From [WareHouseItemCatogries] Where WareHouseID = @WareHouseID)">
                    <SelectParameters>
                        <asp:QueryStringParameter QueryStringField="id" Name="WareHouseID"/>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:ListBox ID="ListSparesCatogries" runat="server" Width=100% Rows=10 
                    DataSourceID="SqlSparesCatogries" DataTextField="CategoriesName" DataValueField="ItemCategoryID" 
                    SelectionMode="Multiple" AutoPostBack="false" onDblclick="moveoption(FormViewWareHouses_ListSparesCatogries, FormViewWareHouses_ListWareHouseItemCatogries, true);"></asp:ListBox>
            </td>
            <td width=10% align=center valign=middle>
                <input type=button value="添加>>" OnClick="moveoption(FormViewWareHouses_ListSparesCatogries, FormViewWareHouses_ListWareHouseItemCatogries, true);" />
                <br /><br /><br />
                <input type=button value="<<删除" onclick="moveoption(FormViewWareHouses_ListWareHouseItemCatogries, FormViewWareHouses_ListSparesCatogries, false);"/>
            </td>
            <td>
                <asp:SqlDataSource ID="SqlWareHouseItemCatogries" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                    SelectCommand="SELECT ItemCategoryID,([ItemCategoryID]+','+[Description]) As CategoriesName FROM [ItemCategories] Where ItemCategoryID in (Select ItemCategoryID From [WareHouseItemCatogries] Where WareHouseID = @WareHouseID)">
                    <SelectParameters>
                        <asp:QueryStringParameter QueryStringField="id" Name="WareHouseID"/>
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:ListBox ID="ListWareHouseItemCatogries" runat="server" Width="98%" Rows=10 
                    DataSourceID="SqlWareHouseItemCatogries" DataTextField="CategoriesName" 
                    DataValueField="ItemCategoryID" SelectionMode="Multiple" AutoPostBack="false"
                    onDblclick="moveoption(FormViewWareHouses_ListWareHouseItemCatogries, FormViewWareHouses_ListSparesCatogries, false);">
                </asp:ListBox>
            </td>
        </tr>
        <tr><td align=right>              
        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" ValidationGroup="QuantityValid" CommandName="Update"
            Text="保存更改">
        </asp:LinkButton>
        </td>
        <td></td>
        <td align=left>
        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
            Text="取消">
        </asp:LinkButton>
        </td></tr>
        </table>
    </EditItemTemplate>
    <InsertItemTemplate>
        <table width=100%><tr>
            <td align=left width=20%>仓库编号:</td>
            <td width=20%>
                <asp:TextBox ID="txtWareHouseCode" runat="server" Text=<%# Bind("WareHouseCode")%>></asp:TextBox></td>
            <td width=30%>名称:</td>
            <td><asp:TextBox ID="txtDescription" runat="server" Text=<%# Bind("Description")%>></asp:TextBox></td>
        </tr>
        <tr>
            <td align=left>上级仓库:</td>
            <td>
                <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                    SelectCommand="SELECT * FROM [ViewWareHouses]">
                </asp:SqlDataSource>
                <asp:DropDownList ID="drpParentWareHouseID" runat="server" DataSourceID="SqlDataSource3"
                    DataTextField="Description" DataValueField="WareHouseID">
                </asp:DropDownList>
            </td>
            <td>是否允许存放物资？:</td>
            <td>
                <asp:CheckBox ID="Checkbox1" runat="server" Checked="true"/>
            </td>
        </tr>
        <tr>
            <td align=left>主要管库员:</td>
            <td><asp:TextBox ID="TextBox1" runat="server" Text=<%# Bind("UserName")%>></asp:TextBox></td>
            <td>是否允许例外存放其他物资？:</td>
            <td><asp:CheckBox ID="Checkbox2" runat="server" Checked="true"/></td>
        </tr>
        <tr>
            <td align=left>定额:</td>
            <td>
                <asp:TextBox ID="txtQuota" runat="server" Text='<%# Bind("Quota") %>'></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtQuota"
                    Display="Dynamic" ErrorMessage="请输入数字！" ValidationExpression="^\-?[0-9]*\.?[0-9]*$" ValidationGroup="QuantityValid"></asp:RegularExpressionValidator>
            </td>
        </tr>
        </table>
        <table width=100%>
        <tr>
        <td>物资分类：</td>
        <td></td>
        <td>本库可存放物资：</td>
        </tr>
        <tr>
            <td width=40%>
                <asp:SqlDataSource ID="SqlSparesCatogries" runat="server" ConnectionString="<%$ ConnectionStrings:MySqlProviderConnection %>"
                    SelectCommand="SELECT ItemCategoryID,([ItemCategoryID]+','+[Description]) As CategoriesName FROM [ItemCategories]">
                </asp:SqlDataSource>
                <asp:ListBox ID="ListSparesCatogries" runat="server" Width=100% Rows=10 
                    DataSourceID="SqlSparesCatogries" DataTextField="CategoriesName" DataValueField="ItemCategoryID" 
                    SelectionMode="Multiple" AutoPostBack="false" onDblclick="moveoption(FormViewWareHouses_ListSparesCatogries, FormViewWareHouses_ListWareHouseItemCatogries, true);"></asp:ListBox>
            </td>
            <td width=10% align=center valign=middle>
                <input type=button value="添加>>" OnClick="moveoption(FormViewWareHouses_ListSparesCatogries, FormViewWareHouses_ListWareHouseItemCatogries, true);" />
                <br /><br /><br />
                <input type=button value="<<删除" onclick="moveoption(FormViewWareHouses_ListWareHouseItemCatogries, FormViewWareHouses_ListSparesCatogries, false);"/>
            </td>
            <td>
                <asp:ListBox ID="ListWareHouseItemCatogries" runat="server" Width="98%" Rows=10 
                    SelectionMode="Multiple" AutoPostBack="false"
                    onDblclick="moveoption(FormViewWareHouses_ListWareHouseItemCatogries, FormViewWareHouses_ListSparesCatogries, false);">
                </asp:ListBox>
            </td>
        </tr>
        <tr><td align=right>              
        <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" ValidationGroup="QuantityValid" CommandName="Insert"
            Text="保存" OnClientClick="return getInsertIDList(FormViewWareHouses_ListWareHouseItemCatogries);">
        </asp:LinkButton>
        </td>
        <td></td>
        <td align=left>
        <asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel"
            Text="取消">
        </asp:LinkButton>
        </td></tr>
        </table>
    </InsertItemTemplate>
</asp:FormView>
</form>
</body>
</html>
