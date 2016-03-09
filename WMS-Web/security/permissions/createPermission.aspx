<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="createPermission.aspx.cs" Inherits="Security_permissions_createPermission" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <table width="80%">
            <tr>
                <td width="80%">
                    <table cellspacing="0" width="100%" cellpadding="4" rules="all" bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                        <tr class="callOutStyle">
                            <td colspan="2"><asp:literal ID="Literal1" runat="server" text="<%$ Resources:AddNewAccess %>" /></td>
                        </tr>

                        <tr>
                            <td class="bodyTextNoPadding" width="200px" >
                                <b><asp:literal ID="Literal2" runat="server" text="<%$ Resources:SelectDirForRule %>"/></b>
                                <asp:panel runat="server" id="panel1" scrollbars="auto" height="400px" width="200px">
                                    <asp:TreeView  
                                        ID="tv"
                                        ExpandDepth="2" 
                                        runat="server" ShowLines=true
                                        OnTreeNodePopulate="TreeView1_TreeNodePopulate" onSelectedNodeChanged="TreeNodeSelected" ImageSet="XPFileExplorer">
                                     </asp:TreeView>	
                                </asp:panel>
                            </td>
                            <td height="100%" valign="top">
                                <table border="0" cellpadding="0" cellspacing="0" class="bodyTextNoPadding" height="100%" width="100%" align="center">
                                    <tr>
                                        <td width="50%"><b><asp:literal ID="Literal3" runat="server" text="<%$ Resources:RuleAppliesTo %>"/></b></td>
                                        <td><b><asp:literal ID="Literal4" runat="server" text="<%$ Resources:Permission %>"/></b></td>
                                    </tr>
                                    <tr>
                                        <td width="62%">
                                            <asp:radiobutton runat="server" id="roleRadio" checked="true" groupname="rolesUsers" />
                                            <asp:label ID="Label1" runat="server" associatedcontrolid="roleRadio"><asp:literal ID="Literal5" runat="server" text="<%$ Resources:Role %>"/></asp:label>
                                            <asp:dropdownlist runat="server" id="roles"/>
                                            </td>
                                        <td>
                                            <asp:radiobutton runat="server" id="grantRadio" groupname="grantDeny" />
                                            <asp:label ID="Label2" runat="server" associatedcontrolid="grantRadio"><asp:literal ID="Literal6" runat="server" text="<%$ Resources:Allow %>"/></asp:label></td>
                                    </tr>
                                    <tr>
                                        <td width="62%">
                                            <asp:radiobutton runat="server" id="allUsersRadio" groupname="rolesUsers" />
                                            <asp:label ID="Label5" runat="server" associatedcontrolid="allUsersRadio"><asp:literal ID="Literal10" runat="server" text="<%$ Resources:AllUsers %>"/></asp:label></td>

                                        <td>
                                            <asp:radioButton runat="server" id="denyRadio" checked="true" groupName="grantDeny"/>
                                            <asp:label ID="Label4" runat="server" associatedcontrolid="denyRadio"><asp:literal ID="Literal9" runat="server" text="<%$ Resources:Deny %>"/></asp:label>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:customvalidator runat="server" id="placeholderValidator" enableclientscript="false" errormessage="Invalid input" display="dynamic"/>
        <br /><br />
        <asp:button ValidationGroup="none" runat="server" id="button1" text="<%$ Resources:OK %>" onclick="UpdateAndReturnToPreviousPage" width="110"/>
        <asp:button runat="server" id="button2" text="<%$ Resources:Cancel %>" onclick="ReturnToPreviousPage" width="110"/>
    </form>
</body>
</html>
