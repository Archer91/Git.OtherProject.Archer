<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="supplier.aspx.cs" Inherits="setting_supplier" Title="ÍùÀ´µ¥Î»×Öµä" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <table width=100%>
    <tr valign=top>
        <td width=30%>
            <iframe name="tree" id="tree" src=supplierTree.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td>
        <td><iframe name="content" id="content" src=supplierMain.aspx width=100% height=500pt frameborder=0 marginheight="0" marginwidth="0" ></iframe></td>
    </tr>
    </table>        
</asp:Content>

