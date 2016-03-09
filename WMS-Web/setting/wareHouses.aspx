<%@ Register Assembly="skcontrols"   TagPrefix="sk" Namespace="skcontrols"%>
<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="wareHouses.aspx.cs" Inherits="setting_wareHouses" Title="²Ö¿â×Öµä" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentMain" Runat="Server">
    <table width=100%>
    <tr valign=top>
        <td width=20%>
            <iframe name="tree" id="tree" src=wareHousesTree.aspx width=100% height=400pt frameborder=0 marginheight="0" marginwidth="0" ></iframe>
        </td>
        <td><iframe name="content" id="content" src=wareHousesMain.aspx width=100% height=400pt frameborder=0 marginheight="0" marginwidth="0" ></iframe></td>
    </tr>
    </table>
</asp:Content>