<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>欢迎使用仓储管理系统</title>
    <script language=javascript>
	function setFocus()
	{
	    var oInput = document.getElementById("Login1_UserNo");
	    var oInputPsw = document.getElementById("Login1_Password");
	    if (oInput.value=="")
	        oInput.focus();
	    else
	        oInputPsw.focus();
	}
	</script>
</head>

<body oncontextmenu="event.returnValue=false" leftMargin=0 topMargin=0 bgcolor="#4F95FF" onload="setFocus();">
    <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
	  <tr height=30><td></td></tr>
	  <tr><td align="center" valign="top">
	    <img src="images/WMS.gif" border="0" alt="欢迎使用仓储管理系统">
	  </td></tr>
	  <tr><td align="center" style="height: 30px">  
        <form id="frmLogin" runat="server">
            <asp:Login ID="Login1" runat="server" FailureText="登录失败，请重新尝试。" LoginButtonText="确定" PasswordLabelText="密码：" RememberMeText="记住密码" TitleText="" 
                UserNameLabelText="用户名：" Orientation="Horizontal" PasswordRequiredErrorMessage="请输入密码。" 
                UserNameRequiredErrorMessage="请输入用户名。" DisplayRememberMe="False" OnLoggedIn="Login1_LoggedIn">
                <LayoutTemplate>
                    <table border="0" cellpadding="1" cellspacing="0" style="border-collapse: collapse">
                        <tr>
                            <td style="height: 60px">
                                <table border="0" cellpadding="0">
                                    <tr>
                                        <td>
                                            <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">用户名：</asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="UserNo" runat="server"></asp:TextBox>
                                            <asp:TextBox ID="UserName" runat="server" Text="hehe" Visible="false"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                ErrorMessage="请输入用户名。" ToolTip="请输入用户名。" ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                        <td>
                                            <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">密码：</asp:Label></td>
                                        <td>
                                            <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                ErrorMessage="请输入密码。" ToolTip="请输入密码。" ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                        </td>
                                        <td>
                                            <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="确定" 
                                                ValidationGroup="Login1" OnClick="LoginButton_Click" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="6" style="color: red; height: 16px;">
                                            <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>
            </asp:Login> 
        </form>
	  </td></tr>
	</TABLE>
</body>
</html>
