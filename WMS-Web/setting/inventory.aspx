<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%><%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inventory.aspx.cs" Inherits="setting_inventory" Title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <table width=100%>
    <tr valign=top>
        <td width=20%>
            <iframe name="tree" id="tree" src=inventoryTree.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td>
        <td>
        <table width="100%"><tr><td>
            <iframe name="detail" id="detail" src=inventoryDetail.aspx width=100% height=150pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td></tr>
        <tr><td><iframe name="content" id="content" src=inventoryMain.aspx width=100% height=350pt frameborder=0 marginheight="0" marginwidth="0" ></iframe></td></tr>
        </table>
        </td>
    </tr>
    </table>
</asp:Content>

