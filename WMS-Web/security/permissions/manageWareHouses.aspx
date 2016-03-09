<%@ Page Language="C#" AutoEventWireup="true" CodeFile="manageWareHouses.aspx.cs" Inherits="Security_permissions_manageWareHouses" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>无标题页</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
    <script>
        function getUserWareHouse(oList)
        {
            var i;
            for(i = oList.options.length - 1; i >= 0; i--)
            {
                if(oList.options[i].selected == true)
                {
                    window.content.location.href="wareHousesTree.aspx?id=" + escape(oList.options[i].value);
                }
            }
        }
    </script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <table width="100%">
            <tr>
                <td width="80%">
                    <table cellspacing="0" width="100%" cellpadding="4" rules="none" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                        <tr class="callOutStyle">
                            <td><asp:literal ID="Literal1" runat="server" text="管理访问规则"/></td>
                            <td align="left" valign="top" width="400px"></td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr align="Left">
                            <td valign="top" width="200px" align="Left">
                                用户
                            </td>
                            <td>
                                仓库权限
                            </td>
                            <td></td>
                        </tr>
                        <tr align="Left">
                            <td valign="top" width="200px" align="Left">
                                <asp:ListBox ID="ListUsers" runat="server" Width="100%" Rows=20 onClick="getUserWareHouse(this);"
                                    DataTextField="UserName" DataValueField="UserName" AutoPostBack="false"></asp:ListBox>
                            </td>
                            <td align="left" valign="top" width="400px">
                                <iframe name="content" id="content" src=wareHousesTree.aspx width=100% height=325px frameborder=0 marginheight="0" marginwidth="0" ></iframe>
                            </td>
                            <td></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <br /><br />
        <asp:button ValidationGroup="none" text="返回" id="doneButton" onClick="ReturnToPreviousPage" runat=server/>
    </form> 
</body>
</html>
