<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="department.aspx.cs" Inherits="setting_department" Title="²¿ÃÅ×Öµä" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
<table>
<tr><td width=20%>
<iframe name="tree" id="tree" src=departmentTree.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
</td>
<td><iframe name="content" id="content" src=departmentMain.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe></td>
</tr>
</table>
</asp:Content>

