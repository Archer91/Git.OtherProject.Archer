<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="addUser.aspx.cs" Inherits="Security_users_addUser" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
    <script type="text/javascript" src="../../JScripts/checkFrame.js"></script>
</head>
<body oncontextmenu="event.returnValue=false">
    <form id="form1" runat="server">
        <table width="750">
        <tr>
        <td width=50% height="100%" valign=top>
            <table width=100% border="1" cellspacing="0" cellpadding="0">
            <tr>
                <td class="callOutStyle" style="height: 19px"><asp:literal ID="Literal1" runat="server" text="创建用户"/></td>
            </tr>
            <tr >
                <td>
                    <asp:createUserWizard runat=server id=createUser displayCancelButton="True"
                        CssClass="bodyText" continueDestinationPageUrl="~/security/users/addUser.aspx"
                        emailLabelText="E-mail:" emailRegularExpression="\S+@\S+\.\S+"
                        OnCancelButtonClick="ReturnToPreviousPage" oncreateduser="CreatedUser" oncreatinguser="CreatingUser"
                        onSendingMail="SendingPasswordMail" CancelButtonText="取消" CompleteSuccessText="成功创建账号。" 
                        CreateUserButtonText="创建" RequireEmail="False" OnActiveStepChanged="createUser_ActiveStepChanged">
                        <WizardSteps>
                            <asp:CreateUserWizardStep runat="server">
                                <ContentTemplate>
                                    <table border="0">
                                        <tbody>
                                            <tr>
                                                <td align="center" colspan="2">
                                                    注册新帐号</td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">姓名:</asp:Label></td>
                                                <td>
                                                    <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                        ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="createUser">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">密码:</asp:Label></td>
                                                <td>
                                                    <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                        ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="createUser">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">密码确认:</asp:Label></td>
                                                <td>
                                                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                        ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required."
                                                        ValidationGroup="createUser">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td align="center" colspan="2">
                                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                                        ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="两次密码输入不同。"
                                                        ValidationGroup="createUser"></asp:CompareValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="2" style="color: red">
                                                    <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </ContentTemplate>
                            </asp:CreateUserWizardStep>
                            <asp:CompleteWizardStep runat="server">
                                <ContentTemplate>
                                    <table border="0" width="100%">
                                        <tr>
                                            <td align="center">
                                                完成</td>
                                        </tr>
                                        <tr>
                                            <td align="center"><asp:Label ID="lblSuccess" runat="server"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td align="center">
                                                <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue"
                                                    Text="继续" ValidationGroup="createUser" />
                                            </td>
                                        </tr>
                                    </table>
                                </ContentTemplate>
                            </asp:CompleteWizardStep>
                        </WizardSteps>
                    </asp:createUserWizard>
                </td>
            </tr>
            </table>

        </td>
        <td width=50% height="100%" valign=top>
                <table border="1" cellpadding="0" cellspacing="0" height="100%" width="100%">
                    <tr class="callOutStyleLowLeftPadding" height="1">
                        <td valign="top"><asp:literal ID="Literal2" runat="server" text="角色"/></td>
                    </tr>
                    <tr valign="top" height="100%">
                        <td  class="userDetailsWithFontSize" height="100%">
                            <asp:panel runat="server" id="panel1" scrollbars="auto" valign="top">
                            <asp:label runat="server" id="selectRolesLabel" text="选择角色"/>
                            <br/>
                            <asp:repeater runat="server" id="checkBoxRepeater">
                            <itemtemplate>
                            <asp:checkbox runat="server" id="checkBox1" text='<%# Container.DataItem.ToString()%>' />
                            <br/>
                            </itemtemplate>
                            </asp:repeater>
                            </asp:panel>
                        </td>
                    </tr>
                </table>    
        </td>
        </tr>
        </table>

        <asp:checkbox runat="server" id="activeUser" checked="true" text="激活用户"/>
        <br /><br />
        <asp:button ValidationGroup="none" text="返回" id="DoneButton" onclick="ReturnToPreviousPage" runat="server"/>
    </form>
</body>
</html>
