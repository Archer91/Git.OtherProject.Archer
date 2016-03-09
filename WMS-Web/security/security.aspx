<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="security.aspx.cs" Inherits="Security_security"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
    <table id="hook" height="100%" width="100%">
        <tr>
            <td width="600" valign="top" style="height: 171px">
                <table width="100%">
                    <tr>
                        <td class="bodyTextNoPadding" colspan="3">
                            <asp:literal ID="Literal1" runat="server" text="<%$ Resources: Explanation %>"/>
                            <br/><br/>
                            <asp:literal ID="Literal2" runat="server" text="<%$ Resources: ClickLinksInstruction %>"/>
                        </td>
                    </tr>
                    <tr>
                        <td width="33%" height="100%">
                            <table height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#ccddef" border="1">
                                <tr class="callOutStyle">
                                    <td><asp:literal ID="Literal3" runat="server" text="<%$ Resources: Users %>"/></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td>
                                        <asp:literal ID="Literal4" runat="server" text="<%$ Resources: ExistingUsers %>"/> <asp:label runat="server" id="userCount" font-bold="true" text="0"/><br/>
                                        <asp:hyperlink runat="server" id="waLink3" navigateUrl="~/security/users/addUser.aspx" text="<%$ Resources:CreateUser %>"/><br/>
                                        <asp:hyperlink runat="server" id="waLink4" navigateUrl="~/security/users/manageUsers.aspx" text="<%$ Resources:ManageUsers %>"/><br/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="33%" height="100%" valign="top">
                            <table height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#ccddef" border="1">
                                <tr class="callOutStyle">
                                    <td><asp:Literal ID="Literal6" runat="server" Text="<% $ Resources: Roles%>" /></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td style="height: 100%">
                                        <asp:label runat="server" id="roleMessage" text="<%$ Resources: ExistingRoles%>"/>
                                        <asp:label runat="server" id="roleCount" font-bold="true" text="0"/>
                                        <br/>
                                        <asp:hyperlink runat="server" id="waLink5" navigateUrl="~/security/roles/manageAllRoles.aspx" text="<%$ Resources:CreateOrManageRoles %>"/><br/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="33%" height="100%" valign="top">
                            <table height="100%" width="100%" cellpadding="4" rules="all" bordercolor="#ccddef" border="1">
                                <tr class="callOutStyle">
                                    <td><asp:Literal ID="Literal7" runat="server" Text="<% $ Resources: AccessRules%>" /></td>
                                </tr>
                                <tr class="bodyText" height="100%" valign="top">
                                    <td>
                                        <asp:hyperlink runat="server" id="waLink8" navigateUrl="~/security/permissions/managePermissions.aspx" text="<%$ Resources:ManageAccessRules %>"/><br/>
                                        <asp:hyperlink runat="server" id="waLink9" navigateUrl="~/security/permissions/manageWareHouses.aspx" text="<%$ Resources:ManageWareHouseAccessRules %>"/><br/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>

