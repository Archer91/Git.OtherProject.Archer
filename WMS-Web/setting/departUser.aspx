<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="departUser.aspx.cs" Inherits="setting_departUser" %>

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
                        if (isInsert)
                            document.getElementById("hidInsertID").value += fromlist.options[i].value + ",";
                        else
                            document.getElementById("hidDeleteID").value += fromlist.options[i].value + ",";                                
                        tolist.appendChild(fromlist.options[i].cloneNode(true));
                        fromlist.remove(i);
                    }
            }
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:HiddenField ID="hidInsertID" runat="server" />
        <asp:HiddenField ID="hidDeleteID" runat="server" />
        <table Width="98%" align="center">
        <tr><td colspan=3 class="ticketTitle"><asp:Literal runat="server" ID="ltrTitle"></asp:Literal></td></tr>
        <tr>
        <td>尚未属任何班组的人员：</td>
        <td></td>
        <td>本班组人员：</td>
        </tr>
        <tr>
            <td width=40%>
                <asp:ListBox ID="ListSparesCatogries" runat="server" Width=100% Rows=20 
                    DataTextField="UserName" DataValueField="UserName" 
                    SelectionMode="Multiple" AutoPostBack="false" onDblclick="moveoption(ListSparesCatogries, ListWareHouseSparesCatogries, true);"></asp:ListBox>
            </td>
            <td width=20% align=center valign=middle>
                <input type=button value="添加>>" OnClick="moveoption(ListSparesCatogries, ListWareHouseSparesCatogries, true);" />
                <br /><br /><br />
                <input type=button value="<<删除" onclick="moveoption(ListWareHouseSparesCatogries, ListSparesCatogries, false);"/>
            </td>
            <td>
                <asp:ListBox ID="ListWareHouseSparesCatogries" runat="server" Width=100% Rows=20 
                    DataTextField="UserName" 
                    DataValueField="UserName" SelectionMode="Multiple" AutoPostBack="false"
                    onDblclick="moveoption(ListWareHouseSparesCatogries, ListSparesCatogries, false);">
                </asp:ListBox>
            </td>
        </tr>
        <tr><td colspan=3 height="10px"></td></tr>
        <tr><td align=right>              
        <asp:LinkButton ID="InsertButton" runat="server" Text="保存" OnClick="InsertButton_Click">
        </asp:LinkButton>
        </td>
        <td></td>
        <td align=left>
        <asp:LinkButton ID="InsertCancelButton" runat="server" Text="取消" OnClick="InsertCancelButton_Click">
        </asp:LinkButton>
        </td></tr>
        </table>

    </form>
</body>
</html>
