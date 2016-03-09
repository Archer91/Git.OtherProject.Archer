<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="editUser.aspx.cs" Inherits="Security_users_editUser" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <table cellspacing="0" cellpadding="0" border="0"  width="750">
            <tbody>
            <tr align="left" valign="top">
                <td width="62%" height="100%" class="lbBorders">

                    <table cellspacing="0" width="100%" cellpadding="0" border="0">
                        <tr class="callOutStyleLowLeftPadding">
                            <td colspan="4">
                                <asp:literal ID="Literal1" runat="server" text="<%$ Resources:User %>" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table class="bodyText" bordercolor="#CCDDEF">
                                    <tr>
                                        <td><asp:Label ID="Label1" runat="server" AssociatedControlID="UserID" Text="<%$ Resources:UserID %>"/></td>
                                        <td>
                                            <asp:textbox runat="server" id="UserID" maxlength="255" tabindex="101"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><asp:Label ID="Label2" runat="server" AssociatedControlID="Password"/>√‹¬Î:</td>
                                        <td>
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="createUser">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">√‹¬Î»∑»œ:</asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required."
                                                ValidationGroup="createUser">*</asp:RequiredFieldValidator>
                                        </td>
                                        <td colspan="3"><asp:checkbox runat="server" id="ActiveUser" text="<%$ Resources:ActiveUser %>" checked="true"/></td>
                                    </tr>
                                    <tr>
                                        <td ><asp:Label ID="Label3" runat="server" AssociatedControlID="Description" Text="<%$ Resources:Description %>"/></td>
                                        <td>
                                            <asp:textbox runat="server" id="Description" />
                                        </td>
                                       <td colSpan="3"><asp:button runat="server" id="SaveButton" onClick="SaveClick" text="<%$ Resources:Save %>" width="100"/>
                                        </td>
                                    </tr>
                                </table>

                            </td>
                        </tr>
                    </table>
                </td>
                <td width="32%" height="100%">
                    <table  border="1px" cellpadding="0" cellspacing="0" height="100%" width="100%">
                        <tbody>
                        <tr class="callOutStyleLowLeftPadding" height="1">
                            <td valign="top">
                                <asp:literal ID="Literal2" runat="server" text="<%$ Resources:Roles %>" />
                            </td>
                        </tr>
                        <tr valign="top">
                            <td  class="userDetailsWithFontSize" height="100%">
                                <asp:panel runat="server" id="Panel1" scrollbars="auto" valign="top">
                                <asp:label runat="server" id="SelectRolesLabel" text="<%$ Resources:SelectRoles%>"/>
                                <br/>
                                <asp:repeater runat="server" id="CheckBoxRepeater">
                                <itemtemplate>
                                <asp:checkbox runat="server" id="checkBox1" text='<%# Container.DataItem.ToString()%>' checked='<%# (CurrentUser == null) ? false : Roles.IsUserInRole(CurrentUser, Container.DataItem.ToString())%>'/>
                                <br/>
                                </itemtemplate>
                                </asp:repeater>
                                </asp:panel>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </td>
            </tr>
            </tbody>
        </table>
        <br/>
        <asp:validationsummary ID="Validationsummary1" runat="server" headertext="<%$ Resources:PleaseCorrect %>"/>
        <asp:requiredfieldvalidator ID="Requiredfieldvalidator1" runat="server" controltovalidate="UserID" enableclientscript="false" errormessage="<%$ Resources:UserIDRequired %>" display="none"/>
        <asp:customvalidator runat="server" id="PlaceholderValidator" controltovalidate="UserID" enableclientscript="false" errormessage="<%$ Resources:InvalidInput %>" onservervalidate="ServerCustomValidate" display="none"/>
        <table runat="server" id="confirmation" height="100%" width="100%" Visible="false">
            <tr height="70%">
                <td width="60%">
                    <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                           bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                        <tr class="callOutStyle">
                            <td style="padding-left:10;padding-right:10;" colspan="3">
                                <asp:literal ID="Literal4" runat="server" text="<%$ Resources:UserManagement %>" />
                            </td>
                        </tr>
                        <tr class="bodyText" height="100%" valign="top">
                            <td style="padding-left:10;padding-right:10;" colspan="3">
                                <asp:literal runat="server" id="DialogMessage" />
                            </td>
                        </tr>
                        <tr class="userDetailsWithFontSize" valign="top" height="5%">
                            <td style="padding-left:10;padding-right:10;" align="Left">
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/security/Security.aspx" Text="<%$ Resources:GoHome %>"/>
                            </td>
                            <td style="padding-left:10;padding-right:10;" align="Right">
                                <asp:Button runat="server" id="AddAnother" enableViewState="false" OnClick="AddAnother_Click" Text="<%$ Resources:AddAnother %>" width="100"/>
                            </td>
                            <td style="padding-left:10;padding-right:10;" align="Left" width="1%">
                                <asp:Button ID="Button1" runat="server" OnClick="OK_Click" Text="<%$ Resources:OK %>" width="75"/>
                            </td>
                        </tr>
                    </table>
                </td>
                <td/>
            </tr>
            <tr><td colspan="2"/></tr>
        </table>
        <br /><br />
        <asp:button ValidationGroup="none" text="∑µªÿ" id="DoneButton" onclick="ReturnToPreviousPage" runat="server"/>
    </form>
</body>
</html>
