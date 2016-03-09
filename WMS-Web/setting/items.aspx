<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="items.aspx.cs" Inherits="setting_items" Title="物资字典、物资分类、物资管理权限" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <table width=100%>
    <tr valign=top>
        <td width=25%>
            <iframe name="tree" src=itemsTree.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td>
        <td>
            <iframe name="content" src=itemsMain.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td>
    </tr>
    </table>
</asp:Content>