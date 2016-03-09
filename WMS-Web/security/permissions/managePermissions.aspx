<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="managePermissions.aspx.cs" Inherits="Security_permissions_managePermissions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
    <script type="text/javascript">
    function CheckAll()
    {
        var oCurrentElement
        for (i=0;i<document.getElementsByTagName("input").length;i++)
	    {
            oCurrentElement = document.getElementsByTagName("input").item(i);
		    if (oCurrentElement.type=="checkbox" && oCurrentElement != event.srcElement)
			    oCurrentElement.checked = event.srcElement.checked;
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
                            <td><asp:literal ID="Literal2" runat="server" text=""/></td>
                        </tr>
                        <tr align="Left">
                            <td valign="top" width="200px" align="Left">
                                <asp:panel runat="server" id="panel1" scrollbars="auto" height="500px" width="200px">
                                    <asp:TreeView  
                                        ID="tv"
                                        ExpandDepth="2"
                                        runat="server" ShowLines=true
                                        OnTreeNodePopulate="TreeView1_TreeNodePopulate" onSelectedNodeChanged="TreeNodeSelected" ImageSet="XPFileExplorer">
                                     </asp:TreeView>	
                                </asp:panel>
                            </td>
                            <td valign="top">
                                <sk:myGridView runat="server" id="dataGrid" autogeneratecolumns="False" width="100%" ShowFooter=true>
                                    <columns>
                                        <asp:templatefield headertext="角色">
                                            <itemtemplate>
                                                <asp:label runat="server" id="lblName" text='<%# Eval("RoleName") %>'/>
                                            </itemtemplate>
                                            <FooterTemplate>
                                                <asp:button text="确定" id="yesButton" runat=server OnClick="yesButton_Click"/>
                                            </FooterTemplate>
                                        </asp:templatefield>

                                        <asp:templatefield headertext="是否具有权限">
                                            <itemtemplate>
                                                <asp:checkBox runat="server" id="chkRight" checked=<%#Convert.ToBoolean(Eval("IsRoleInPermission"))%>/>
                                            </itemtemplate>
                                            <FooterTemplate>
                                                <asp:checkBox runat="server" id="chkAll" onClick="CheckAll();" Text="选中所有"/>
                                            </FooterTemplate>
                                        </asp:templatefield>
                                    </columns>
                                </sk:myGridView>
                            </td>
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
