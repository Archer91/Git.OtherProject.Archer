<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="manageAllRoles.aspx.cs" Inherits="Security_roles_manageAllRoles" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <table cellspacing="0" cellpadding="5" class="lrbBorders" width="580">
            <tr>
                <td class="callOutStyle"><asp:literal ID="Literal1" runat="server" text="<%$ Resources:CreateNewRole %>" /></td>
            </tr>
            <tr >
                <td class="bodyTextNoPadding">
                       <asp:Label ID="Label1" runat="server" AssociatedControlID="textBox1" Text="<%$ Resources:NewRoleName %>"/>
                       <asp:textBox runat=server id="textBox1" maxlength="256"/>
                       <asp:button runat=server id="button1" text="<%$ Resources:AddRole %>" onClick="AddRole"/><br/>
            <asp:label runat="server" id="errorMessage" enableViewState="false" forecolor="Red" visible="false"/>

                </td>
            </tr>
        </table>

        <%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
        <input type="text" style="visibility:hidden"/>
        <br/>
        <table cellspacing="0" cellpadding="0" border="0"  width="580">
            <tbody>
            <tr valign="top">
                <td height="100%" class="lrbBorders">
                    <sk:myGridView runat="server" id="dataGrid" allowpaging="true" autogeneratecolumns="False" OnPageIndexChanging="IndexChanged" width="100%" UseAccessibleHeader="true">
                        <columns >
                            <asp:templateField runat="server" headerText="<%$ Resources:RoleName %>" >
                                <itemTemplate>
                                    <%# Container.DataItem %>
                                </itemTemplate>
                            </asp:templateField>

                            <asp:templateField runat="server" headerText="<%$ Resources:AddRemove %>" >
                                <itemTemplate>
                                    <asp:linkButton runat="server" id="linkButton1" text="<%$ Resources:Manage %>" commandName="ManageRole" toolTip='<%# GetToolTip("Manage",Container.DataItem.ToString()) %>' commandArgument='<%#Container.DataItem%>' onCommand='LinkButtonClick'/>
                                </itemTemplate>
                            </asp:templateField>

                            <asp:templateField runat="server" >
                                <itemStyle horizontalAlign="center"/>
                                <itemTemplate>
                                    <asp:linkButton runat="server" id="linkButton2" text="<%$ Resources:Delete %>" commandName="DeleteRole" toolTip='<%# GetToolTip("Delete",Container.DataItem.ToString()) %>' commandArgument='<%#Container.DataItem%>' onCommand='LinkButtonClick'/>
                                </itemTemplate>
                            </asp:templateField>
                        </columns>
                    </sk:myGridView>
                </td>
            </tr>
            </tbody>
        </table>
        
        <table runat="server" id="confirmation" height="100%" width="100%" Visible="false">
            <tr height="70%">
                <td width="60%">
                    <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                           bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                        <tr class="callOutStyle">
                            <td style="padding-left:10;padding-right:10;" colspan="3">
                                <asp:literal ID="Literal3" runat="server" text="<%$ Resources:UserManagement %>" />
                            </td>
                        </tr>
                        <tr class="bodyText" height="100%" valign="top">
                            <td style="padding-left:10;padding-right:10;" colspan="3">
                                <asp:literal ID="Literal2" runat="server" text="<%$ Resources:AreYouSure %>"/> "<asp:Label runat=server id="RoleName" Font-Bold="true"/>"?
                            </td>
                        </tr>
                        <tr class="userDetailsWithFontSize" valign="top" height="5%">
                            <td style="padding-left:10;padding-right:10;" align="Left">
                            
                            </td>
                            <td style="padding-left:10;padding-right:10;" align="Right">
                                <asp:Button ID="Button2" runat="server" OnClick="Yes_Click" Text="<%$ Resources:Yes %>" width="100"/>
                            </td>
                            <td style="padding-left:10;padding-right:10;" align="Left" width="1%">
                                <asp:Button ID="Button3" runat="server" OnClick="No_Click" Text="<%$ Resources:No %>" width="100"/>
                            </td>
                        </tr>
                    </table>
                </td>
                <td/>
            </tr>
            <tr><td colspan="2"/></tr>
        </table>
        <br /><br />
        <asp:button ValidationGroup="none" text="<%$ Resources:Back%>" id="doneButton" onClick="ReturnToPreviousPage" runat=server/>

    </form>
</body>
</html>
