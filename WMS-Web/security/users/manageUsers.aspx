<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="manageUsers.aspx.cs" Inherits="Security_users_manageUsers" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
    <style>
        div.divGridView
        {
            width: 500px; 
            height: 300px;
            overflow: auto;
        }
        th, th.locked	{
	        position:relative;
	        top: expression(parentNode.parentNode.parentNode.parentNode.parentNode.scrollTop-2); /* IE5+ only */
	        z-index: 20;
        }    
    </style>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
    <%-- Cause the textbox to submit the page on enter, raising server side onclick--%>
    <input type="text" style="visibility:hidden;display:none;"/>
    <table cellspacing="0" cellpadding="0" class="lrbBorders" width="750">
        <tr>
            <td class="callOutStyle"><asp:literal ID="Literal1" runat="server" text="<%$ Resources:SearchForUsers %>"/></td>
        </tr>
        <tr >
            <td class="bodyTextLowTopPadding">
                <asp:Label ID="Label1" runat="server" AssociatedControlID="SearchByDropDown" Text="<%$ Resources:SearchBy %>"/>
                <asp:dropDownList runat="server" id="SearchByDropDown">
                <asp:listItem runat="server" id="Item1" text="<%$ Resources:Username %>" />
                </asp:dropdownlist>
                &nbsp;&nbsp;<asp:Label ID="Label2" runat="server" AssociatedControlID="TextBox1" Text="<%$ Resources:For %>"/>
                <asp:textbox runat="server" id="TextBox1"/>
                <asp:button ID="Button1" runat="server" text="<%$ Resources:SearchFor %>" onclick="SearchForUsers"/>
                <br/>
                <asp:Label runat="server" id="AlphabetInfo" Text="<%$ Resources:GlobalResources,AlphabetInfo %>"/><br/>
                <asp:repeater runat="server" id="AlphabetRepeater" onitemcommand="RetrieveLetter">
                <itemtemplate>
                <asp:linkbutton runat="server" id="LinkButton1" commandname="Display" commandargument="<%#Container.DataItem%>" text="<%#Container.DataItem%>"/>
                &nbsp;
                </itemtemplate>
                </asp:repeater>
            </td>
    </table>
    <br/>

    <table cellspacing="0" cellpadding="0" border="0" id="hook" width="750">
        <tbody>
        <tr align="left" valign="top">
            <td width="500px" height="100%" class="lbBorders">
            <div class="divGridView">
                <sk:myGridView runat="server" id="DataGrid" AllowPagingToggle="false" AllowPaging="false" width="100%" autogeneratecolumns="False" onpageindexchanging="IndexChanged" UseAccessibleHeader="true">
                <columns>               
                            
                <asp:templatefield headertext="<%$ Resources:Active %>">
                <headerstyle horizontalalign="center"/>
                <itemstyle horizontalalign="center"/>
                <itemtemplate>
                <asp:checkBox runat="server" id="CheckBox1" oncheckedchanged="EnabledChanged" autopostback="true" checked='<%#DataBinder.Eval(Container.DataItem, "IsApproved")%>'/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server" headertext="<%$ Resources:UserNo %>">
                <itemtemplate>
                <asp:label runat="server" id="UserNoLink" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "Email")%>'/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server" headertext="<%$ Resources:Username %>">
                <itemtemplate>
                <asp:label runat="server" id="UserNameLink" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "UserName")%>'/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server" headertext="是否在线">
                <itemtemplate>
                <asp:label runat="server" id="IsOnlineLink" forecolor='black' text='<%#((bool)DataBinder.Eval(Container.DataItem, "IsOnline"))?"是":"否"%>'/>
                </itemtemplate>
                </asp:templatefield>
                
                <asp:templatefield runat="server" headertext="所在部门">
                <itemtemplate>
                <asp:label runat="server" id="lblDepartment" forecolor='black' text='<%#DataBinder.Eval(Container.DataItem, "Comment")%>'/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server">
                <itemtemplate>
                <asp:linkButton runat="server" id="LinkButton1" text="<%$ Resources:EditUser %>" commandname="EditUser" toolTip='<%# GetToolTip("EditUser",DataBinder.Eval(Container.DataItem, "UserName").ToString()) %>' commandargument='<%#DataBinder.Eval(Container.DataItem, "UserName")%>' oncommand="LinkButtonClick"/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server">
                <itemtemplate>
                <asp:linkButton runat="server" id="linkButton2" text="<%$ Resources:DeleteUser%>" commandname="DeleteUser" toolTip='<%# GetToolTip("DeleteUser",DataBinder.Eval(Container.DataItem, "UserName").ToString()) %>' commandargument='<%#DataBinder.Eval(Container.DataItem, "UserName")%>' oncommand="LinkButtonClick"/>
                </itemtemplate>
                </asp:templatefield>

                <asp:templatefield runat="server">
                <itemtemplate>
                <asp:linkbutton ID="Linkbutton3" runat="server" commandname="Select" toolTip='<%# GetToolTip("EditRoles",DataBinder.Eval(Container.DataItem, "UserName").ToString()) %>' onclick="ButtonClick" text="<%$ Resources:EditRoles %>" commandargument='<%# DataBinder.Eval(Container.DataItem, "UserName") %>'/>
                </itemtemplate>
                </asp:templatefield>

                </columns>
                </sk:myGridView>
            </div>  
                
                <asp:label runat="server" id="noUsers" CssClass="bodyTextNoPadding" enableViewState="false" visible="false" text="<%$ Resources:NoUsersCreated %>"/>
                <asp:label runat="server" id="notFoundUsers" CssClass="bodyTextNoPadding" enableViewState="false" visible="false" text="<%$ Resources:NotFoundUsers %>"/>
                
            </td>
            <td height="100%">
                <asp:placeholder runat="server" id="RolePlaceHolder">
                    <table border="0px" cellpadding="5" cellspacing="0" height="100%" width="100%">
                        <tr class="callOutStyle">
                            <td align="center"><asp:literal ID="Literal2" runat="server" text="<%$ Resources:Roles %>"/></td>
                        </tr>
                        <tr class="userDetailsWithFontSize" valign="top">
                            <td class="lrbBorders" height="100%" >
                                <asp:multiView runat="server" id="multiView1" activeviewindex="0">
                                <asp:view runat="server" id="view1">
                                </asp:view>
                                <asp:view runat="server" id="view2">
                                <asp:label runat="server" id="AddToRole" text="<%$ Resources:AddToRoles %>"/><br/>
                                <asp:repeater runat="server" id="CheckBoxRepeater">
                                <itemtemplate>
                                <asp:checkBox runat="server" id="CheckBox1" autopostback="true" oncheckedchanged="RoleMembershipChanged" text='<%# Container.DataItem.ToString()%>' checked='<%# Roles.IsUserInRole(CurrentUser, Container.DataItem.ToString()) %>'/>
                                <br/>
                                </itemtemplate>
                                </asp:repeater>
                                </asp:view>
                                </asp:multiView>
                            </td>
                        </tr>
                    </table>
                </asp:placeholder>
            </td>
        </tr>
        </tbody>
    </table>
    <asp:linkButton runat="server" id="LinkButton3" text="<%$ Resources:CreateNewUser %>" onclick="RedirectToAddUser"/>

    <table runat="server" id="confirmation" height="100%" width="100%" Visible="false">
        <tr height="70%">
            <td width="60%">
                <table cellspacing="0" height="100%" width="100%" cellpadding="4" rules="none"
                       bordercolor="#CCDDEF" border="1" style="border-color:#CCDDEF;border-style:None;border-collapse:collapse;">
                    <tr class="callOutStyle">
                        <td style="padding-left:10;padding-right:10;" colspan="3">
                            <asp:literal ID="Literal3" runat="server" text="<%$ Resources:ManageUsers %>" />
                        </td>
                    </tr>
                    <tr class="bodyText" height="100%" valign="top">
                        <td style="padding-left:10;padding-right:10;" colspan="3">
                            <asp:literal runat="server" id="UserID" visible="false"/>
                            <asp:literal runat="server" id="AreYouSure" text="<%$ Resources:AreYouSure %>" />
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
    <asp:button ValidationGroup="none" text="<%$ Resources:Back %>" id="doneButton" onclick="ReturnToPreviousPage" runat="server"/>
    </form>
</body>
</html>
