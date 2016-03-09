<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="project.aspx.cs" Inherits="setting_project" Title="生产项目" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
<table>
<tr><td width=20%>
<iframe name="tree" id="tree" src=projectTree.aspx width=100% height=470pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
</td>
<td><iframe name="content" id="content" src=projectMain.aspx width=100% height=470pt frameborder=0 marginheight="0" marginwidth="0" ></iframe></td>
</tr>
</table>
</asp:Content>

