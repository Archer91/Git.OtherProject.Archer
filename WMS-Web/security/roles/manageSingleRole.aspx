<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="manageSingleRole.aspx.cs" Inherits="Security_roles_manageSingleRole" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
        <input type="text" style="visibility:hidden;display:none;"/>
        <table width="100%">
            <tbody>
            <tr>
                <td>
                    <span class="bodyTextNoPadding">
                    <asp:literal ID="Literal2" runat="server" text="<%$ Resources:Role %>" />
                    <asp:label id="roleName" runat="server" font-bold="true">
                    </asp:label>
                    </span>
                </td>
            </tr>
            <tr>
                <td>
                    <table>
                        <tbody>
                        <tr valign="top">
                            <td>
                                <table cellspacing="0" cellpadding="5" class="lrbBorders" width="750"/>

                                <tbody>
                        <tr>
                            <td class="callOutStyle">
                                 <asp:literal ID="Literal3" runat="server" text="<%$ Resources:SearchForUsers %>" />
                            </td>
                        </tr>
                        <tr >
                            <td class="bodyTextNoPadding">
                                <asp:literal ID="Literal4" runat="server" text="<%$ Resources:SearchBy %>" />
                                <asp:dropdownlist id="dropDown1" runat="server">
                                <asp:listitem runat="server" id="listItem1" text="<%$ Resources:Username %>"/>
                                </asp:dropdownlist>
                                &nbsp;<asp:literal ID="Literal5" runat="server" text="<%$ Resources:For %>"/>
                                <asp:textbox runat="server" id="textBox1" width="11em"/>
                                &nbsp;
                                <asp:button runat="server" id="button2" onclick="SearchForUsers" text="<%$ Resources:FindUser %>"/>
                                <br />
                               <asp:Label runat="server" id="alphabetInfo" Text="<%$ Resources:GlobalResources,AlphabetInfo %>"/><br/>
                                <asp:repeater runat="server" id="repeater" onitemcommand="RetrieveLetter">
                                <itemtemplate>
                                <asp:linkbutton runat="server" id="linkButton1" text="<%#Container.DataItem%>" commandname="Display" commandargument="<%#Container.DataItem%>" />
                                &nbsp;
                                </itemtemplate>
                                </asp:repeater>
                            </td>
                        </tr>
            </tbody>
                    </table>
                    <br />
                    <table id="containerTable" runat="server" border="0" cellspacing="0" cellpadding="0"  class="itemDetailsContainer" width="750" >
                        <tbody>
                        <tr align="left" valign="top">
                            <td width="62%" height="100%" class="lrbBorders">
                                <sk:myGridView runat="server" id="dataGrid" allowpaging="true" autogeneratecolumns="False" onitemdatabound="ItemDataBound" onpageindexchanging="IndexChanged" pagesize="7" width="100%" UseAccessibleHeader="true">
                                <columns>

                                <asp:templatefield runat="server" headertext="<%$ Resources:Username %>">
                                <itemtemplate>
                                <asp:label runat="server" id="userNameLink" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "UserName")%>'/>
                                </itemtemplate>
                                </asp:templatefield>

                                <asp:templatefield runat="server" headertext="<%$ Resources:UserInRole %>" >
                                <headerstyle horizontalalign="center" />
                                <itemstyle horizontalalign="center" />
                                <itemtemplate>
                                <asp:checkbox ID="Checkbox1" runat="server" oncheckedchanged="EnabledChanged" autopostback="true" checked='<%# Roles.IsUserInRole(DataBinder.Eval(Container.DataItem, "UserName").ToString(), (string)CurrentRole)%>' />
                                </itemtemplate>
                                </asp:templatefield>

                                </columns>
                                </sk:myGridView>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                    <asp:label runat="server" id="notFoundUsers" class="bodyTextNoPadding" enableViewState="false" visible="false" text="<%$ Resources:NotFoundUsers %>"/>
                </td>
            </tr>
            </tbody>
        </table>
        <br /><br />
        <asp:button ValidationGroup="none" text="<%$ Resources:Back%>" id="doneButton" onClick="ReturnToPreviousPage" runat=server/>
    </form>
</body>
</html>
